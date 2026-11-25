#!/usr/bin/env python3
"""Comparación multi-máquina de E1 y E3 (E2 solo como anexo opcional).

Recorre `data/<machine_id>/`, agrega los CSV de cada equipo y genera:

- una tabla por pantalla con E1 y sobrecoste E3;
- `data/derived/compare_machines.csv` con los valores agregados;
- `figures/compare_overhead.png` y, con `--with-e2`, las figuras de E2;
- la comparativa extendida de mesetas E1 y barrido E3 mediante
  `analysis/compare_extended.py`.

No inventa datos: si una máquina no tiene una variante, la omite.
"""

from __future__ import annotations

import argparse
import csv
import math
from collections import defaultdict
from pathlib import Path

from common import (
    DATA_DIR,
    FIGURES_DIR,
    find_e1_path,
    fmt_num,
    fmt_pct,
    median,
    median_ci,
    p5,
    p95,
    percentile,
    read_rows,
    require_matplotlib,
    to_float,
    to_int,
    wilson_ci,
)

VARIANTS = ("baseline", "lfence", "mask")
DEFAULT_MARGIN_MIN = 5


def discover_machines(
    data_dir: str | Path = DATA_DIR, include_legacy: bool = False
) -> list[str]:
    """Máquinas con un E1 válido, ordenadas por nombre.

    Un E1 puede estar en la raíz antigua o en una subcarpeta de sesión. Las
    máquinas cuyo nombre termina en `_final` son campañas legacy y se omiten
    salvo que se pida explícitamente incluirlas.
    """
    root = Path(data_dir)
    if not root.is_dir():
        raise SystemExit(f"No existe el directorio de datos: {root}")
    machines = []
    for directory in sorted(root.iterdir()):
        if not directory.is_dir():
            continue
        name = directory.name
        if name.endswith("_final") and not include_legacy:
            continue
        has_root = (directory / f"e1_{name}.csv").is_file()
        has_session = any(directory.glob(f"*/e1_{name}.csv"))
        if has_root or has_session:
            machines.append(name)
    return machines


def suggest_threshold(hit: list[float], miss: list[float]) -> int:
    """Mismo criterio que plot_e1.py: valle entre los dos modos."""
    if hit and miss:
        hit_high = percentile(hit, 95)
        miss_low = percentile(miss, 5)
        if miss_low > hit_high:
            return int(round((hit_high + miss_low) / 2))
        return int(round((median(hit) + median(miss)) / 2))
    if hit:
        return int(round(p95(hit)))
    if miss:
        return int(round(p5(miss)))
    return 0


def load_e1(directory: Path, machine_id: str, path: Path | None = None) -> dict:
    if path is None:
        path = directory / f"e1_{machine_id}.csv"
    rows = read_rows(path)
    hit = [to_float(row.get("cycles")) for row in rows if row.get("mode") == "hit"]
    miss = [to_float(row.get("cycles")) for row in rows if row.get("mode") == "miss"]
    hit = [value for value in hit if not math.isnan(value)]
    miss = [value for value in miss if not math.isnan(value)]
    if not hit and not miss:
        raise SystemExit(f"No hay muestras hit/miss en {path}")

    first = rows[0] if rows else {}
    hit_low, hit_high = median_ci(hit)
    miss_low, miss_high = median_ci(miss)
    return {
        "path": str(path),
        "cpu": first.get("cpu", machine_id),
        "family": first.get("family", ""),
        "model": first.get("model", ""),
        "stepping": first.get("stepping", ""),
        "microcode": first.get("microcode", ""),
        "kernel": first.get("kernel", ""),
        "gcc": first.get("gcc", ""),
        "flags": first.get("flags", ""),
        "hit_n": len(hit),
        "hit_median": median(hit),
        "hit_median_low": hit_low,
        "hit_median_high": hit_high,
        "hit_p5": p5(hit),
        "hit_p95": p95(hit),
        "miss_n": len(miss),
        "miss_median": median(miss),
        "miss_median_low": miss_low,
        "miss_median_high": miss_high,
        "miss_p5": p5(miss),
        "miss_p95": p95(miss),
        "suggested_threshold": suggest_threshold(hit, miss),
    }


def load_e2(
    directory: Path, machine_id: str, margin_min: int = DEFAULT_MARGIN_MIN
) -> dict:
    groups: dict[str, list[dict[str, str]]] = defaultdict(list)
    for path in sorted(directory.glob(f"e2_{machine_id}_*.csv")):
        if path.stem.endswith("_O0"):
            continue
        for row in read_rows(path):
            variant = row.get("variant", "")
            if variant in VARIANTS:
                groups[variant].append(row)

    summary = {}
    for variant in VARIANTS:
        rows = groups.get(variant, [])
        if not rows:
            continue
        total = len(rows)
        successes = sum(to_int(row.get("success")) for row in rows)
        low, high = wilson_ci(successes, total)
        margins = [
            to_int(row.get("score1")) - to_int(row.get("score2")) for row in rows
        ]
        unclear = sum(1 for margin in margins if margin < margin_min)
        summary[variant] = {
            "n": total,
            "total": total,
            "successes": successes,
            "rate": successes / total if total else float("nan"),
            "low": low,
            "high": high,
            "unclear_rate": unclear / total if total else float("nan"),
            "median_margin": median(margins),
        }
    return summary


def load_e3(directory: Path, machine_id: str) -> dict:
    by_variant: dict[str, list[float]] = defaultdict(list)
    for path in sorted(directory.glob(f"e3_{machine_id}_*.csv")):
        for row in read_rows(path):
            variant = row.get("variant", "")
            if variant in VARIANTS:
                by_variant[variant].append(to_float(row.get("cycles_per_iteration")))

    baseline = median(by_variant.get("baseline", []))
    summary = {}
    for variant in VARIANTS:
        values = [
            value for value in by_variant.get(variant, []) if not math.isnan(value)
        ]
        if not values:
            continue
        med = median(values)
        low, high = median_ci(values)
        absolute = med - baseline if baseline else float("nan")
        pct = 100 * absolute / baseline if baseline else float("nan")
        summary[variant] = {
            "n": len(values),
            "median": med,
            "median_low": low,
            "median_high": high,
            "p5": p5(values),
            "p95": p95(values),
            "abs": absolute,
            "pct": pct,
            "pct_low": 100 * (low - baseline) / baseline if baseline else float("nan"),
            "pct_high": 100 * (high - baseline) / baseline
            if baseline
            else float("nan"),
            "slowdown": med / baseline if baseline else float("nan"),
        }
    return summary


def summarize_machine(
    data_dir: str | Path, machine_id: str, margin_min: int = DEFAULT_MARGIN_MIN
) -> dict:
    directory = Path(data_dir) / machine_id
    if not directory.is_dir():
        raise SystemExit(f"No existe {directory}")
    return {
        "machine_id": machine_id,
        "e1": load_e1(directory, machine_id, find_e1_path(machine_id, data_dir)),
        "e2": load_e2(directory, machine_id, margin_min),
        "e3": load_e3(directory, machine_id),
    }


def _num(value: float, digits: int = 6) -> str:
    return "" if math.isnan(value) else f"{value:.{digits}f}"


def comparison_row(summary: dict) -> dict[str, str]:
    e1 = summary["e1"]
    e2 = summary["e2"]
    e3 = summary["e3"]

    def e2_rate(variant: str) -> str:
        item = e2.get(variant)
        return "" if not item else _num(item["rate"])

    def e2_field(variant: str, key: str) -> str:
        item = e2.get(variant)
        return "" if not item else _num(item[key])

    def e3_pct(variant: str) -> str:
        item = e3.get(variant)
        return "" if not item else _num(item["pct"])

    def e3_median(variant: str) -> str:
        item = e3.get(variant)
        return "" if not item else _num(item["median"])

    def e3_median_ci(variant: str, bound: str) -> str:
        item = e3.get(variant)
        key = f"median_{bound}"
        return "" if not item else _num(item[key])

    return {
        "machine_id": summary["machine_id"],
        "cpu": e1["cpu"],
        "family": e1["family"],
        "model": e1["model"],
        "stepping": e1["stepping"],
        "microcode": e1["microcode"],
        "kernel": e1["kernel"],
        "gcc": e1["gcc"],
        "threshold": str(e1["suggested_threshold"]),
        "hit_median": _num(e1["hit_median"]),
        "hit_median_low": _num(e1["hit_median_low"]),
        "hit_median_high": _num(e1["hit_median_high"]),
        "hit_p5": _num(e1["hit_p5"]),
        "hit_p95": _num(e1["hit_p95"]),
        "miss_median": _num(e1["miss_median"]),
        "miss_median_low": _num(e1["miss_median_low"]),
        "miss_median_high": _num(e1["miss_median_high"]),
        "miss_p5": _num(e1["miss_p5"]),
        "miss_p95": _num(e1["miss_p95"]),
        "e2_baseline_rate": e2_rate("baseline"),
        "e2_baseline_rate_low": e2_field("baseline", "low"),
        "e2_baseline_rate_high": e2_field("baseline", "high"),
        "e2_baseline_unclear_rate": e2_field("baseline", "unclear_rate"),
        "e2_baseline_median_margin": e2_field("baseline", "median_margin"),
        "e2_lfence_rate": e2_rate("lfence"),
        "e2_lfence_rate_low": e2_field("lfence", "low"),
        "e2_lfence_rate_high": e2_field("lfence", "high"),
        "e2_lfence_unclear_rate": e2_field("lfence", "unclear_rate"),
        "e2_lfence_median_margin": e2_field("lfence", "median_margin"),
        "e2_mask_rate": e2_rate("mask"),
        "e2_mask_rate_low": e2_field("mask", "low"),
        "e2_mask_rate_high": e2_field("mask", "high"),
        "e2_mask_unclear_rate": e2_field("mask", "unclear_rate"),
        "e2_mask_median_margin": e2_field("mask", "median_margin"),
        "e3_baseline_cycles": e3_median("baseline"),
        "e3_baseline_median_low": e3_median_ci("baseline", "low"),
        "e3_baseline_median_high": e3_median_ci("baseline", "high"),
        "e3_lfence_cycles": e3_median("lfence"),
        "e3_lfence_median_low": e3_median_ci("lfence", "low"),
        "e3_lfence_median_high": e3_median_ci("lfence", "high"),
        "e3_mask_cycles": e3_median("mask"),
        "e3_mask_median_low": e3_median_ci("mask", "low"),
        "e3_mask_median_high": e3_median_ci("mask", "high"),
        "e3_lfence_pct": e3_pct("lfence"),
        "e3_mask_pct": e3_pct("mask"),
    }


def write_table(summaries: list[dict], path: Path) -> None:
    if not summaries:
        return
    rows = [comparison_row(summary) for summary in summaries]
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def print_table(summaries: list[dict], with_e2: bool = False) -> None:
    if with_e2:
        header = (
            f"{'machine_id':24} {'CPU':32} {'E1_T':>5} "
            f"{'base':>8} {'lfence':>8} {'mask':>8} "
            f"{'E3 base':>9} {'lfence%':>9} {'mask%':>9}"
        )
    else:
        header = (
            f"{'machine_id':24} {'CPU':32} {'E1_T':>5} "
            f"{'E3 base':>9} {'lfence%':>9} {'mask%':>9}"
        )
    print(header)
    for summary in summaries:
        e1 = summary["e1"]
        e2 = summary["e2"]
        e3 = summary["e3"]

        def rate(variant: str) -> str:
            item = e2.get(variant)
            return "n/a" if not item else fmt_pct(item["rate"], 0)

        def pct(variant: str) -> str:
            item = e3.get(variant)
            return "n/a" if not item else f"{item['pct']:+.1f}%"

        prefix = (
            f"{summary['machine_id']:24} {e1['cpu'][:32]:32} "
            f"{e1['suggested_threshold']:5d} "
        )
        if with_e2:
            prefix += f"{rate('baseline'):>8} {rate('lfence'):>8} {rate('mask'):>8} "
        print(
            prefix
            + f"{fmt_num(e3.get('baseline', {}).get('median', float('nan')), 2):>9} "
            f"{pct('lfence'):>9} {pct('mask'):>9}"
        )


def plot_success(summaries: list[dict], out: Path) -> None:
    plt = require_matplotlib()
    machines = [summary["machine_id"] for summary in summaries]
    width = 0.26
    xs = list(range(len(machines)))
    colors = {"baseline": "#4c78a8", "lfence": "#f58518", "mask": "#54a24b"}

    fig, ax = plt.subplots(figsize=(max(8, 2.4 * len(machines)), 4.8))
    for offset, variant in zip((-width, 0.0, width), VARIANTS):
        rates = []
        errors_low = []
        errors_high = []
        present = []
        for summary in summaries:
            item = summary["e2"].get(variant)
            if not item:
                rates.append(float("nan"))
                errors_low.append(0)
                errors_high.append(0)
                present.append(False)
                continue
            rate = 100 * item["rate"]
            rates.append(rate)
            errors_low.append(100 * (item["rate"] - item["low"]))
            errors_high.append(100 * (item["high"] - item["rate"]))
            present.append(True)
        positions = [x + offset for x in xs]
        ax.bar(
            positions,
            rates,
            width=width,
            yerr=[errors_low, errors_high],
            capsize=3,
            label=variant,
            color=colors[variant],
        )
        for position, rate, ok in zip(positions, rates, present):
            if ok and not math.isnan(rate):
                ax.annotate(
                    f"{rate:.0f}%",
                    (position, rate),
                    textcoords="offset points",
                    xytext=(0, 4),
                    ha="center",
                    fontsize=7,
                )

    ax.set_xticks(xs)
    ax.set_xticklabels(machines, rotation=15, ha="right")
    ax.set_ylabel("recuperación correcta (%)")
    ax.set_ylim(-2, 108)
    ax.set_title("E2 — recuperación por máquina y variante")
    ax.legend()
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(out, dpi=160)
    print(f"figura: {out}")


def plot_overhead(summaries: list[dict], out: Path) -> None:
    plt = require_matplotlib()
    machines = [summary["machine_id"] for summary in summaries]
    width = 0.36
    xs = list(range(len(machines)))
    colors = {"lfence": "#f58518", "mask": "#54a24b"}

    fig, ax = plt.subplots(figsize=(max(8, 2.4 * len(machines)), 4.8))
    for offset, variant in zip((-width / 2, width / 2), ("lfence", "mask")):
        values = []
        errors_low = []
        errors_high = []
        for summary in summaries:
            item = summary["e3"].get(variant)
            if not item:
                values.append(float("nan"))
                errors_low.append(0.0)
                errors_high.append(0.0)
                continue
            values.append(item["pct"])
            errors_low.append(max(0.0, item["pct"] - item["pct_low"]))
            errors_high.append(max(0.0, item["pct_high"] - item["pct"]))
        positions = [x + offset for x in xs]
        ax.bar(
            positions,
            values,
            width=width,
            yerr=[errors_low, errors_high],
            capsize=3,
            label=variant,
            color=colors[variant],
        )
        for position, value in zip(positions, values):
            if not math.isnan(value):
                ax.annotate(
                    f"{value:+.0f}%",
                    (position, value),
                    textcoords="offset points",
                    xytext=(0, 4),
                    ha="center",
                    fontsize=7,
                )

    ax.axhline(0, color="black", linewidth=0.8)
    ax.set_xticks(xs)
    ax.set_xticklabels(machines, rotation=15, ha="right")
    ax.set_ylabel("sobrecoste frente a baseline (%)")
    ax.set_title("E3 — sobrecoste de LFENCE y máscara por máquina")
    ax.legend()
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    fig.savefig(out, dpi=160)
    print(f"figura: {out}")


def plot_scatter(summaries: list[dict], out: Path) -> None:
    plt = require_matplotlib()
    fig, ax = plt.subplots(figsize=(8, 5))
    markers = {"baseline": "o", "lfence": "s", "mask": "^"}
    colors = {"baseline": "#4c78a8", "lfence": "#f58518", "mask": "#54a24b"}

    for summary in summaries:
        machine = summary["machine_id"]
        for variant in VARIANTS:
            e2 = summary["e2"].get(variant)
            e3 = summary["e3"].get(variant)
            if not e2:
                continue
            x = 0.0 if variant == "baseline" else (e3["pct"] if e3 else float("nan"))
            if math.isnan(x):
                continue
            y = 100 * e2["rate"]
            low, high = 100 * e2["low"], 100 * e2["high"]
            xerr = None
            if e3:
                xerr = [
                    [max(0.0, x - e3["pct_low"])],
                    [max(0.0, e3["pct_high"] - x)],
                ]
            ax.scatter(
                [x],
                [y],
                marker=markers[variant],
                color=colors[variant],
                s=70,
                zorder=3,
            )
            ax.errorbar(
                [x],
                [y],
                xerr=xerr,
                yerr=[[max(0, y - low)], [max(0, high - y)]],
                fmt="none",
                capsize=3,
                color=colors[variant],
            )
            ax.annotate(
                f"{machine}:{variant}",
                (x, y),
                textcoords="offset points",
                xytext=(6, 4),
                fontsize=7,
            )

    ax.set_xlabel("sobrecoste frente a baseline (%)")
    ax.set_ylabel("recuperación correcta (%)")
    ax.set_ylim(-2, 105)
    ax.set_title("Eficacia frente a sobrecoste por máquina y variante")
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(out, dpi=160)
    print(f"figura: {out}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", default=str(DATA_DIR))
    parser.add_argument("--out-dir", default=str(FIGURES_DIR))
    parser.add_argument(
        "--table",
        default=str(DATA_DIR / "derived" / "compare_machines.csv"),
    )
    parser.add_argument(
        "--margin-min",
        type=int,
        default=DEFAULT_MARGIN_MIN,
        help="margen mínimo (score1-score2) para considerar claro un byte",
    )
    parser.add_argument(
        "--with-e2",
        action="store_true",
        help="incluye tablas/figuras de E2 (anexo opcional, no resultado principal)",
    )
    parser.add_argument(
        "--include-legacy",
        action="store_true",
        help="incluye campañas legacy cuyo machine_id termina en _final",
    )
    args = parser.parse_args()

    machines = discover_machines(args.data_dir, include_legacy=args.include_legacy)
    if not machines:
        raise SystemExit(f"No hay máquinas con E1 en {args.data_dir}")

    summaries = [
        summarize_machine(args.data_dir, machine, args.margin_min)
        for machine in machines
    ]
    print_table(summaries, args.with_e2)

    table_path = Path(args.table)
    write_table(summaries, table_path)
    print(f"tabla: {table_path}")

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    plot_overhead(summaries, out_dir / "compare_overhead.png")
    if args.with_e2:
        plot_success(summaries, out_dir / "compare_success.png")
        plot_scatter(summaries, out_dir / "compare_scatter.png")

    # Comparativa extendida: mesetas de E1 jerárquico y barrido de E3. Se
    # mantiene en un módulo aparte para no mezclar las tablas históricas con
    # los CSV de sesión nuevos.
    from compare_extended import build_extended_outputs

    build_extended_outputs(Path(args.data_dir), out_dir)


if __name__ == "__main__":
    main()
