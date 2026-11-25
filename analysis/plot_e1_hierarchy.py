#!/usr/bin/env python3
"""E1 jerárquico: latencia de pointer chasing frente al working set.

Genera una figura `ciclos/carga` vs tamaño (eje X logarítmico) con mediana y
bandas p5-p95 e IQR, líneas verticales de L1d/L2/L3 tomadas de la ficha de
entorno, y una tabla de mesetas (CSV + Markdown) con IC bootstrap.

Criterio de meseta: para una caché de capacidad C se toman los tamaños en
[0,25·C, 0,75·C]. Para memoria se toma todo tamaño >= 2·L3 (o el mayor tamaño
medido si no hay ficha de L3). El criterio está documentado en
`docs/metrics.md`.
"""

from __future__ import annotations

import argparse
import csv
import math
import re
from pathlib import Path

from common import (
    DATA_DIR,
    FIGURES_DIR,
    HIERARCHY_COLUMNS,
    bootstrap_ci,
    csv_header,
    e1_hierarchy_paths,
    find_data_file,
    median,
    median_ci,
    p5,
    p95,
    percentile,
    read_rows,
    require_matplotlib,
    to_float,
    to_int,
)

LEVELS = ("L1d", "L2", "L3")
_CACHE_RE = re.compile(
    r"^L(\d)([di]?)\s+cache:\s+([0-9]+(?:\.[0-9]+)?)\s*(KiB|MiB|GiB)"
    r"(?:\s*\((\d+)\s+instances?\))?",
    re.IGNORECASE,
)
_UNITS = {"kib": 1024, "mib": 1024**2, "gib": 1024**3}


def parse_cache_env(path: str | Path) -> dict[str, int]:
    """Extrae capacidades de L1d/L2/L3 de un `env_*.txt`.

    lscpu da el total de las instancias para L1/L2; para un hilo se usa la
    capacidad por instancia. L3 se deja como total (normalmente compartida).
    """
    cache: dict[str, int] = {}
    try:
        lines = Path(path).read_text(encoding="utf-8", errors="replace").splitlines()
    except OSError:
        return cache
    for line in lines:
        match = _CACHE_RE.match(line.strip())
        if not match:
            continue
        level = int(match.group(1))
        kind = (match.group(2) or "").lower()
        if level == 1 and kind != "d":
            continue
        value = float(match.group(3)) * _UNITS[match.group(4).lower()]
        instances = int(match.group(5) or 1)
        name = "L1d" if level == 1 else f"L{level}"
        if level in (1, 2) and instances > 0:
            value /= instances
        cache[name] = int(round(value))
    return cache


def _env_for(machine_id: str, data_dir: Path, session_id: str | None) -> Path | None:
    return find_data_file(
        machine_id, f"env_{machine_id}.txt", data_dir=data_dir, session_id=session_id
    )


def load_hierarchy(path: str | Path) -> list[dict[str, str]]:
    """Lee y valida un CSV nuevo. Un E1 antiguo no se mezcla."""
    header = csv_header(path)
    missing = [column for column in HIERARCHY_COLUMNS if column not in header]
    if missing:
        raise ValueError(
            f"{path} no es un CSV de E1 jerárquico; faltan columnas: "
            + ", ".join(missing)
        )
    return read_rows(path)


def pick_hierarchy_path(
    machine_id: str, data_dir: Path, session_id: str | None
) -> Path | None:
    paths = e1_hierarchy_paths(machine_id, data_dir=data_dir, session_id=session_id)
    if not paths:
        return None
    return max(paths, key=lambda path: path.stat().st_mtime)


def group_by_size(rows: list[dict[str, str]]) -> dict[int, list[float]]:
    groups: dict[int, list[float]] = {}
    for row in rows:
        size = to_int(row.get("working_set_bytes"), 0)
        value = to_float(row.get("cycles_per_load"))
        if size <= 0 or math.isnan(value):
            continue
        groups.setdefault(size, []).append(value)
    return groups


def size_summary(values: list[float]) -> dict[str, float]:
    low, high = median_ci(values, n_boot=2000)
    return {
        "median": median(values),
        "p5": p5(values),
        "p95": p95(values),
        "q1": percentile(values, 25),
        "q3": percentile(values, 75),
        "low": low,
        "high": high,
    }


def plateau_windows(
    cache: dict[str, int], max_size: int
) -> dict[str, tuple[float, float]]:
    windows: dict[str, tuple[float, float]] = {}
    for level in LEVELS:
        capacity = cache.get(level)
        if capacity:
            windows[level] = (0.25 * capacity, 0.75 * capacity)
    l3 = cache.get("L3")
    if l3:
        windows["memoria"] = (2.0 * l3, float("inf"))
    else:
        windows["memoria"] = (float(max_size), float(max_size))
    return windows


def select_window(
    rows: list[dict[str, str]], low: float, high: float
) -> list[dict[str, str]]:
    selected = []
    for row in rows:
        size = to_int(row.get("working_set_bytes"), 0)
        if size > 0 and low <= size <= high:
            selected.append(row)
    return selected


def summarize_plateau(
    rows: list[dict[str, str]],
    level: str,
    capacity: int | None,
    low: float,
    high: float,
    n_boot: int,
    seed: int,
) -> dict:
    selected = select_window(rows, low, high)
    values = [to_float(row.get("cycles_per_load")) for row in selected]
    values = [value for value in values if not math.isnan(value)]
    sizes = sorted({to_int(row.get("working_set_bytes"), 0) for row in selected})
    result = {
        "level": level,
        "capacity_bytes": capacity if capacity else "",
        "range_low_bytes": int(low) if math.isfinite(low) else "",
        "range_high_bytes": int(high) if math.isfinite(high) else "",
        "n_points": len(sizes),
        "n_samples": len(values),
        "cycles_per_load": median(values) if values else "",
        "ci_low": "",
        "ci_high": "",
        "status": "ok" if values else "sin-muestras",
    }
    if values:
        low_ci, high_ci = bootstrap_ci(
            values, statistic=median, n_boot=n_boot, seed=seed
        )
        result["ci_low"] = low_ci
        result["ci_high"] = high_ci
    if not rows:
        result["status"] = "sin-datos"
    return result


def build_plateaus(
    machine_id: str,
    rows: list[dict[str, str]],
    cache: dict[str, int],
    n_boot: int,
    seed: int,
) -> list[dict]:
    session_id = rows[0].get("session_id", "") if rows else ""
    max_size = max(group_by_size(rows), default=0)
    windows = plateau_windows(cache, max_size)
    blocks = []
    for level in ("L1d", "L2", "L3", "memoria"):
        if level not in windows:
            blocks.append(
                {
                    "machine_id": machine_id,
                    "session_id": session_id,
                    "level": level,
                    "capacity_bytes": "",
                    "range_low_bytes": "",
                    "range_high_bytes": "",
                    "n_points": 0,
                    "n_samples": 0,
                    "cycles_per_load": "",
                    "ci_low": "",
                    "ci_high": "",
                    "status": "sin-ficha",
                }
            )
            continue
        low, high = windows[level]
        summary = summarize_plateau(
            rows, level, cache.get(level), low, high, n_boot, seed
        )
        summary.update({"machine_id": machine_id, "session_id": session_id})
        if not cache and level != "memoria":
            summary["status"] = "sin-ficha"
        blocks.append(summary)
    return blocks


def write_plateau_csv(blocks: list[dict], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "machine_id",
        "session_id",
        "level",
        "capacity_bytes",
        "range_low_bytes",
        "range_high_bytes",
        "n_points",
        "n_samples",
        "cycles_per_load",
        "ci_low",
        "ci_high",
        "status",
    ]
    with open(path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        for block in blocks:
            row = {}
            for field in fields:
                value = block.get(field, "")
                if isinstance(value, float):
                    value = f"{value:.6f}"
                row[field] = value
            writer.writerow(row)


def _fmt_bytes(value: int | float | str) -> str:
    if value == "" or value is None:
        return "—"
    value = float(value)
    for unit, scale in (("GiB", 1024**3), ("MiB", 1024**2), ("KiB", 1024)):
        if value >= scale:
            return f"{value / scale:.2f} {unit}"
    return f"{value:.0f} B"


def _fmt_num(value: float | str) -> str:
    return "PENDIENTE" if value == "" else f"{float(value):.3f}"


def _range_text(block: dict) -> str:
    low = block.get("range_low_bytes", "")
    high = block.get("range_high_bytes", "")
    if low == "":
        return "—"
    if high == "":
        return f">= {_fmt_bytes(low)}"
    return f"{_fmt_bytes(low)}–{_fmt_bytes(high)}"


def write_plateau_markdown(blocks: list[dict], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# Mesetas de E1 jerárquico",
        "",
        "Criterio: para L1d/L2/L3 se usan los tamaños en [25 %, 75 %] de la",
        "capacidad de cada nivel. Para memoria se usa todo tamaño >= 2·L3 (o el",
        "mayor medido si no hay ficha de L3). Las capacidades se toman de",
        "`env_<machine_id>.txt`; L1d/L2 se dividen por instancia.",
        "",
        "| machine_id | nivel | capacidad | rango usado | puntos | muestras | ciclos/carga | IC95 | estado |",
        "|---|---|---:|---|---:|---:|---:|---|---|",
    ]
    for block in blocks:
        status = block.get("status", "")
        value = (
            "PENDIENTE"
            if status in ("sin-ficha", "sin-datos")
            else _fmt_num(block.get("cycles_per_load", ""))
        )
        ci = (
            "PENDIENTE"
            if block.get("ci_low", "") == ""
            else f"[{float(block['ci_low']):.3f}, {float(block['ci_high']):.3f}]"
        )
        lines.append(
            "| `{machine}` | {level} | {capacity} | {range} | {points} | "
            "{samples} | {value} | {ci} | {status} |".format(
                machine=block.get("machine_id", ""),
                level=block.get("level", ""),
                capacity=_fmt_bytes(block.get("capacity_bytes", "")),
                range=_range_text(block),
                points=block.get("n_points", 0),
                samples=block.get("n_samples", 0),
                value=value,
                ci=ci,
                status=status,
            )
        )
    lines.extend(
        [
            "",
            "Un estado `sin-ficha` indica que falta la ficha de entorno;",
            "`sin-muestras` indica que el barrido no tiene puntos en la ventana.",
            "No se rellenan cifras que los datos no contienen.",
            "",
        ]
    )
    path.write_text("\n".join(lines), encoding="utf-8")


def plot_series(series: list[dict], out: Path) -> None:
    plt = require_matplotlib()
    from matplotlib.ticker import FuncFormatter, LogLocator

    fig, ax = plt.subplots(figsize=(9.5, 5.2))
    cache_lines: dict[int, set[str]] = {}
    for index, item in enumerate(series):
        groups = group_by_size(item["rows"])
        if not groups:
            continue
        sizes = sorted(groups)
        summaries = [size_summary(groups[size]) for size in sizes]
        medians = [summary["median"] for summary in summaries]
        color = f"C{index % 10}"
        ax.plot(
            sizes,
            medians,
            marker="o",
            markersize=3,
            linewidth=1.6,
            color=color,
            label=item["machine_id"],
        )
        ax.fill_between(
            sizes,
            [summary["p5"] for summary in summaries],
            [summary["p95"] for summary in summaries],
            color=color,
            alpha=0.12,
            linewidth=0,
        )
        ax.fill_between(
            sizes,
            [summary["q1"] for summary in summaries],
            [summary["q3"] for summary in summaries],
            color=color,
            alpha=0.22,
            linewidth=0,
        )
        for level, capacity in item["cache"].items():
            cache_lines.setdefault(capacity, set()).add(level)

    for capacity in sorted(cache_lines):
        levels = "/".join(sorted(cache_lines[capacity]))
        ax.axvline(
            capacity,
            color="0.35",
            linestyle="--",
            linewidth=1.0,
            alpha=0.6,
            label=f"{levels} = {_fmt_bytes(capacity)}",
        )

    ax.set_xscale("log", base=2)
    ax.set_xlabel("working set (bytes)")
    ax.set_ylabel("ciclos por carga")
    ax.set_title("E1 jerárquico — latencia de pointer chasing")
    ax.xaxis.set_major_locator(LogLocator(base=2))
    ax.xaxis.set_major_formatter(FuncFormatter(lambda value, _: _fmt_bytes(value)))
    ax.grid(alpha=0.25, which="both")
    ax.legend(fontsize="small")
    fig.tight_layout()
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out, dpi=160)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--machine-id",
        action="append",
        required=True,
        help="Se puede repetir para superponer varias máquinas",
    )
    parser.add_argument("--session-id", default="")
    parser.add_argument("--data-dir", default=str(DATA_DIR))
    parser.add_argument("--out", default="")
    parser.add_argument("--table-csv", default="")
    parser.add_argument("--table-md", default="")
    parser.add_argument("--n-boot", type=int, default=5000)
    parser.add_argument("--seed", type=int, default=12345)
    args = parser.parse_args()

    data_dir = Path(args.data_dir)
    series = []
    for machine_id in args.machine_id:
        path = pick_hierarchy_path(machine_id, data_dir, args.session_id or None)
        if path is None:
            print(
                f"aviso: no hay E1 jerárquico para {machine_id} "
                f"en {data_dir / machine_id}"
            )
            continue
        try:
            rows = load_hierarchy(path)
        except ValueError as exc:
            print(f"aviso: {exc}; se omite {machine_id}")
            continue
        env_path = _env_for(machine_id, data_dir, args.session_id or None)
        cache = parse_cache_env(env_path) if env_path else {}
        if not cache:
            print(
                f"aviso: sin ficha de caché para {machine_id}; no habrá líneas L1/L2/L3"
            )
        series.append(
            {
                "machine_id": machine_id,
                "path": path,
                "rows": rows,
                "cache": cache,
            }
        )

    if not series:
        raise SystemExit(
            "No hay datos de E1 jerárquico. Ejecuta scripts/run_e1_hierarchy.sh."
        )

    blocks: list[dict] = []
    for item in series:
        machine_blocks = build_plateaus(
            item["machine_id"],
            item["rows"],
            item["cache"],
            args.n_boot,
            args.seed,
        )
        blocks.extend(machine_blocks)
        print(f"CSV: {item['path']}")
        for block in machine_blocks:
            value = block.get("cycles_per_load", "")
            shown = "PENDIENTE" if value == "" else f"{float(value):.2f}"
            print(f"  {block['level']:7s} {shown:>10s}  ({block['status']})")

    if args.out:
        out = Path(args.out)
    elif len(series) == 1:
        out = FIGURES_DIR / f"e1_hierarchy_{series[0]['machine_id']}.png"
    else:
        out = FIGURES_DIR / "e1_hierarchy.png"
    plot_series(series, out)
    print(f"figura: {out}")

    table_csv = (
        Path(args.table_csv)
        if args.table_csv
        else (DATA_DIR / "derived" / "e1_hierarchy_plateaus.csv")
    )
    table_md = (
        Path(args.table_md)
        if args.table_md
        else (
            Path(__file__).resolve().parent.parent
            / "report"
            / "e1_hierarchy_plateaus.md"
        )
    )
    write_plateau_csv(blocks, table_csv)
    write_plateau_markdown(blocks, table_md)
    print(f"tabla CSV: {table_csv}")
    print(f"tabla Markdown: {table_md}")


if __name__ == "__main__":
    main()
