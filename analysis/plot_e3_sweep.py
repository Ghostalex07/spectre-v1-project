#!/usr/bin/env python3
"""E3 barrido: sobrecoste relativo frente a W, predictibilidad y tamaño.

El análisis es emparejado por bloques: para cada variante y combinación se
resume cada bloque (mediana de sus repeticiones) y el IC bootstrap se calcula
remuestreando bloques completos, que contienen todas las variantes.

Lee solo CSV con la cabecera nueva (`work_per_iter`, `predictability_mode`,
`array_bytes`, `block_id`). Los CSV antiguos de E3 se ignoran aquí y siguen
funcionando con `plot_e3.py`.
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
    ROOT,
    block_statistics,
    e3_sweep_paths,
    fmt_num,
    is_e3_sweep_csv,
    median,
    paired_block_bootstrap,
    read_rows,
    require_matplotlib,
    to_float,
    to_int,
)

DERIVED_DIR = DATA_DIR / "derived"
REPORT_DIR = ROOT / "report"
OVERHEAD_CSV = DERIVED_DIR / "e3_sweep_overhead.csv"
OVERHEAD_MD = REPORT_DIR / "e3_sweep_overhead.md"
TABLE_FIELDS = [
    "machine_id",
    "work_per_iter",
    "predictability_mode",
    "out_of_range_fraction",
    "array_bytes",
    "variant",
    "n_blocks",
    "baseline_cycles",
    "variant_cycles",
    "overhead_pct",
    "ci_low",
    "ci_high",
    "slowdown",
]


def load_sweep(machine_id: str, session_id: str | None = None) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for path in e3_sweep_paths(machine_id, session_id=session_id):
        if not is_e3_sweep_csv(path):
            continue
        rows.extend(read_rows(path))
    return rows


def combo_key(row: dict[str, str]) -> tuple:
    return (
        row.get("machine_id", ""),
        to_int(row.get("work_per_iter")),
        row.get("predictability_mode", ""),
        to_int(row.get("array_bytes")),
    )


def overhead_table(rows, n_boot: int = 10_000, seed: int = 12345) -> list[dict]:
    """Tabla de sobrecoste por combinación, máquina y variante."""
    groups: dict[tuple, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        groups[combo_key(row)].append(row)

    table: list[dict] = []
    for key in sorted(groups):
        machine_id, work, mode, array_bytes = key
        combo_rows = groups[key]
        by_variant: dict[str, list[dict[str, str]]] = defaultdict(list)
        for row in combo_rows:
            by_variant[row.get("variant", "")].append(row)

        baseline_rows = by_variant.get("baseline", [])
        if not baseline_rows:
            continue
        baseline_blocks = block_statistics(baseline_rows)
        if not baseline_blocks:
            continue
        baseline_cycles = median(baseline_blocks.values())
        oor = median(to_float(row.get("out_of_range_fraction")) for row in combo_rows)

        for variant in sorted(by_variant):
            if variant == "baseline":
                continue
            variant_blocks = block_statistics(by_variant[variant])
            pct, low, high = paired_block_bootstrap(
                baseline_blocks, variant_blocks, n_boot=n_boot, seed=seed
            )
            variant_cycles = median(variant_blocks.values())
            slowdown = (
                variant_cycles / baseline_cycles if baseline_cycles else float("nan")
            )
            table.append(
                {
                    "machine_id": machine_id,
                    "work_per_iter": work,
                    "predictability_mode": mode,
                    "out_of_range_fraction": oor,
                    "array_bytes": array_bytes,
                    "variant": variant,
                    "n_blocks": len(set(baseline_blocks) & set(variant_blocks)),
                    "baseline_cycles": baseline_cycles,
                    "variant_cycles": variant_cycles,
                    "overhead_pct": pct,
                    "ci_low": low,
                    "ci_high": high,
                    "slowdown": slowdown,
                }
            )
    return table


def write_table(table: list[dict]) -> None:
    DERIVED_DIR.mkdir(parents=True, exist_ok=True)
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    with open(OVERHEAD_CSV, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=TABLE_FIELDS)
        writer.writeheader()
        for row in table:
            writer.writerow(
                {
                    field: (
                        f"{row[field]:.6f}"
                        if field
                        in {
                            "out_of_range_fraction",
                            "baseline_cycles",
                            "variant_cycles",
                            "overhead_pct",
                            "ci_low",
                            "ci_high",
                            "slowdown",
                        }
                        and not math.isnan(row[field])
                        else row[field]
                    )
                    for field in TABLE_FIELDS
                }
            )

    lines = [
        "# E3 barrido — sobrecoste por combinación",
        "",
        "Generado por `analysis/plot_e3_sweep.py` desde los CSV nuevos de E3. "
        "El IC95 remuestrea bloques completos (emparejado).",
        "",
        "| máquina | W | predictibilidad | fuera rango | array B | variante | "
        "bloques | base ciclos | var ciclos | sobrecoste % | IC95 | slowdown |",
        "|---|---:|---|---:|---:|---|---:|---:|---:|---:|---|---:|",
    ]
    for row in table:
        ci = (
            f"[{fmt_num(row['ci_low'])}, {fmt_num(row['ci_high'])}]"
            if not math.isnan(row["ci_low"])
            else "n/a"
        )
        lines.append(
            f"| `{row['machine_id']}` | {row['work_per_iter']} | "
            f"`{row['predictability_mode']}` | "
            f"{row['out_of_range_fraction']:.2f} | {row['array_bytes']} | "
            f"`{row['variant']}` | {row['n_blocks']} | "
            f"{fmt_num(row['baseline_cycles'])} | "
            f"{fmt_num(row['variant_cycles'])} | "
            f"{fmt_num(row['overhead_pct'])} | {ci} | "
            f"{fmt_num(row['slowdown'])} |"
        )
    OVERHEAD_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _lookup(table: list[dict], machine_id: str, mode: str, array_bytes: int):
    selected = [
        row
        for row in table
        if row["machine_id"] == machine_id
        and row["predictability_mode"] == mode
        and row["array_bytes"] == array_bytes
    ]
    return selected


def make_figures(
    table: list[dict],
    machines: list[str],
    overlay_predictability: str,
    overlay_array_bytes: int | None,
) -> None:
    plt = require_matplotlib()
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)

    for machine_id in machines:
        machine_rows = [row for row in table if row["machine_id"] == machine_id]
        if not machine_rows:
            continue
        modes = sorted({row["predictability_mode"] for row in machine_rows})
        arrays = sorted({row["array_bytes"] for row in machine_rows})
        variants = sorted({row["variant"] for row in machine_rows})
        fig, axes = plt.subplots(
            len(modes),
            len(arrays),
            figsize=(4.2 * len(arrays), 3.0 * len(modes)),
            squeeze=False,
        )
        colors = {"lfence": "#f58518", "mask": "#54a24b"}
        for i, mode in enumerate(modes):
            for j, array_bytes in enumerate(arrays):
                ax = axes[i][j]
                for variant in variants:
                    selected = [
                        row
                        for row in machine_rows
                        if row["predictability_mode"] == mode
                        and row["array_bytes"] == array_bytes
                        and row["variant"] == variant
                    ]
                    selected.sort(key=lambda row: row["work_per_iter"])
                    if not selected:
                        continue
                    xs = [row["work_per_iter"] for row in selected]
                    ys = [row["overhead_pct"] for row in selected]
                    lows = [row["ci_low"] for row in selected]
                    highs = [row["ci_high"] for row in selected]
                    color = colors.get(variant)
                    ax.plot(xs, ys, marker="o", label=variant, color=color)
                    finite = [
                        (x, low, high)
                        for x, low, high in zip(xs, lows, highs)
                        if not math.isnan(low) and not math.isnan(high)
                    ]
                    if finite:
                        ax.fill_between(
                            [item[0] for item in finite],
                            [item[1] for item in finite],
                            [item[2] for item in finite],
                            color=color,
                            alpha=0.15,
                        )
                ax.set_title(f"{mode} · {array_bytes} B")
                ax.set_xlabel("W (trabajo dependiente)")
                ax.set_ylabel("sobrecoste vs baseline (%)")
                ax.grid(alpha=0.25)
                ax.legend(fontsize=8)
        fig.suptitle(f"E3 barrido — sobrecoste frente a W ({machine_id})")
        fig.tight_layout()
        out = FIGURES_DIR / f"e3_sweep_{machine_id}_overhead_vs_work.png"
        fig.savefig(out, dpi=150)
        plt.close(fig)
        print(f"figura: {out}")

    # Superposición multi-máquina: una línea por máquina y variante.
    variant_list = sorted({row["variant"] for row in table})
    fig, axes = plt.subplots(
        1, len(variant_list), figsize=(4.5 * len(variant_list), 3.6), squeeze=False
    )
    for j, variant in enumerate(variant_list):
        ax = axes[0][j]
        for machine_id in machines:
            rows = _lookup(
                table, machine_id, overlay_predictability, overlay_array_bytes
            )
            rows = [row for row in rows if row["variant"] == variant]
            rows.sort(key=lambda row: row["work_per_iter"])
            if not rows:
                continue
            xs = [row["work_per_iter"] for row in rows]
            ys = [row["overhead_pct"] for row in rows]
            ax.plot(xs, ys, marker="o", label=machine_id)
        ax.set_title(variant)
        ax.set_xlabel("W (trabajo dependiente)")
        ax.set_ylabel("sobrecoste vs baseline (%)")
        ax.grid(alpha=0.25)
        ax.legend(fontsize=7)
    fig.suptitle(
        f"E3 barrido — {overlay_predictability}, array {overlay_array_bytes} B"
    )
    fig.tight_layout()
    out = FIGURES_DIR / "e3_sweep_overlay.png"
    fig.savefig(out, dpi=150)
    plt.close(fig)
    print(f"figura: {out}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--machine-id",
        action="append",
        required=True,
        help="Identificador; se puede repetir para superponer máquinas",
    )
    parser.add_argument("--session-id", default=None)
    parser.add_argument("--n-boot", type=int, default=10_000)
    parser.add_argument("--seed", type=int, default=12345)
    parser.add_argument(
        "--overlay-predictability",
        default="inrange",
        help="Modo para la figura multi-máquina (defecto inrange)",
    )
    parser.add_argument(
        "--overlay-array-bytes",
        type=int,
        default=None,
        help="Tamaño para la figura multi-máquina (defecto el mayor medido)",
    )
    parser.add_argument("--no-figures", action="store_true")
    args = parser.parse_args()

    rows: list[dict[str, str]] = []
    for machine_id in args.machine_id:
        machine_rows = load_sweep(machine_id, session_id=args.session_id)
        if not machine_rows:
            print(f"aviso: sin CSV de barrido E3 para {machine_id}")
        rows.extend(machine_rows)
    if not rows:
        raise SystemExit(
            "No hay CSV de barrido E3. Ejecuta scripts/run_e3.sh <machine_id> sweep."
        )

    table = overhead_table(rows, n_boot=args.n_boot, seed=args.seed)
    if not table:
        raise SystemExit("Los CSV no contienen baseline y una variante comparable.")
    write_table(table)
    print(f"tabla: {OVERHEAD_CSV}")
    print(f"tabla: {OVERHEAD_MD}")

    if not args.no_figures:
        array_bytes = args.overlay_array_bytes
        if array_bytes is None:
            array_bytes = max(row["array_bytes"] for row in table)
        make_figures(table, args.machine_id, args.overlay_predictability, array_bytes)


if __name__ == "__main__":
    main()
