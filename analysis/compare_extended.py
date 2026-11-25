#!/usr/bin/env python3
"""Comparativa extendida: mesetas E1 y sobrecoste del barrido E3."""

from __future__ import annotations

import argparse
import csv
import math
import re
import statistics
from collections import defaultdict
from pathlib import Path

from common import (
    DATA_DIR,
    FIGURES_DIR,
    bootstrap_ci,
    e1_hierarchy_paths,
    e3_sweep_paths,
    median,
    read_rows,
)
from plot_e1_hierarchy import _env_for, build_plateaus, load_hierarchy, parse_cache_env
from plot_e3_sweep import load_sweep, overhead_table


def env_frequency_mhz(path: Path | None) -> float:
    """Frecuencia aproximada registrada en la ficha de entorno."""
    if path is None:
        return float("nan")
    try:
        text = Path(path).read_text(encoding="utf-8")
    except OSError:
        return float("nan")

    match = re.search(r"^cpu MHz\s*:\s*([0-9.,]+)", text, re.MULTILINE)
    if match:
        return float(match.group(1).replace(",", "."))

    values = [
        float(value) / 1000.0 for value in re.findall(r"cur_freq_khz=(\d+)", text)
    ]
    if values:
        return float(statistics.median(values))
    return float("nan")


def should_aggregate(
    frequencies: list[float], min_sessions: int = 3, max_spread: float = 0.10
) -> tuple[bool, str]:
    """Decide si se pueden agregar sesiones sin mezclar condiciones distintas."""
    valid = [value for value in frequencies if not math.isnan(value) and value > 0]
    if len(valid) < min_sessions:
        return False, f"menos de {min_sessions} sesiones con frecuencia válida"
    spread = (max(valid) - min(valid)) / max(valid)
    if spread > max_spread:
        return (
            False,
            f"frecuencia entre sesiones difiere más del {max_spread * 100:.0f} % "
            f"({min(valid):.0f}–{max(valid):.0f} MHz)",
        )
    return True, ""


def machine_ids(data_dir: Path = DATA_DIR) -> list[str]:
    """Máquinas con cualquier CSV de E1 o E3, en raíz o sesiones."""
    found: set[str] = set()
    if not data_dir.is_dir():
        return []
    for directory in data_dir.iterdir():
        if not directory.is_dir() or directory.name in {"derived", "simulation"}:
            continue
        if any(
            path.name.startswith(("e1_", "e3_")) and path.suffix == ".csv"
            for path in directory.rglob("*.csv")
        ):
            found.add(directory.name)
    return sorted(found)


def _write_csv(path: Path, rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0]) if rows else []
    with open(path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def _write_md(path: Path, rows: list[dict], columns: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "| " + " | ".join(columns) + " |",
        "|" + "|".join("---" for _ in columns) + "|",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(row.get(col, "")) for col in columns) + " |")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def collect_plateaus(machine_id: str, data_dir: Path = DATA_DIR) -> list[dict]:
    """Mesetas por sesión y, solo si procede, una fila agregada."""
    by_level: dict[str, list[dict]] = defaultdict(list)

    for path in e1_hierarchy_paths(machine_id, data_dir=data_dir):
        session_id = path.parent.name if path.parent != data_dir / machine_id else None
        env_path = _env_for(machine_id, data_dir, session_id)
        cache = parse_cache_env(env_path) if env_path else {}
        frequency = env_frequency_mhz(env_path)
        rows = load_hierarchy(path)
        for plateau in build_plateaus(
            machine_id, rows, cache, n_boot=2_000, seed=12345
        ):
            item = dict(plateau)
            item["machine_id"] = machine_id
            item["session_id"] = session_id or "root"
            item["sessions"] = 1
            item["freq_mhz"] = "" if math.isnan(frequency) else f"{frequency:.1f}"
            item["note"] = ""
            by_level[item["level"]].append(item)

    result: list[dict] = []
    for level in ("L1d", "L2", "L3", "memoria"):
        items = by_level.get(level, [])
        if not items:
            continue

        frequencies = [
            float(item["freq_mhz"]) for item in items if item.get("freq_mhz")
        ]
        aggregate, reason = should_aggregate(frequencies)
        for item in items:
            item["status"] = item.get("status", "ok")
            item["note"] = "" if aggregate else reason
        result.extend(items)

        if not aggregate:
            continue

        values = [
            item["cycles_per_load"]
            for item in items
            if item.get("status") == "ok"
            and isinstance(item.get("cycles_per_load"), (int, float))
        ]
        if not values:
            continue
        low, high = bootstrap_ci(values, n_boot=2_000, seed=12345)
        result.append(
            {
                "machine_id": machine_id,
                "session_id": "(agregado)",
                "level": level,
                "sessions": len(items),
                "freq_mhz": "",
                "cycles_per_load": median(values),
                "ci_low": low,
                "ci_high": high,
                "status": "agregado",
                "note": "",
            }
        )
    return result


def collect_sweep(machine_id: str, data_dir: Path = DATA_DIR) -> list[dict]:
    rows: list[dict] = []
    for path in e3_sweep_paths(machine_id, data_dir=data_dir):
        rows.extend(load_sweep(machine_id, path=path))
    return overhead_table(rows, n_boot=2_000, seed=12345) if rows else []


def build_extended_outputs(
    data_dir: Path = DATA_DIR, figures_dir: Path = FIGURES_DIR
) -> None:
    machines = machine_ids(data_dir)
    plateaus: list[dict] = []
    sweep: list[dict] = []
    for machine in machines:
        plateaus.extend(collect_plateaus(machine, data_dir))
        sweep.extend(collect_sweep(machine, data_dir))

    derived = data_dir / "derived"
    if plateaus:
        _write_csv(derived / "e1_plateaus.csv", plateaus)
        _write_md(
            derived / "e1_plateaus.md",
            plateaus,
            [
                "machine_id",
                "session_id",
                "level",
                "sessions",
                "freq_mhz",
                "cycles_per_load",
                "ci_low",
                "ci_high",
                "status",
                "note",
            ],
        )
    if sweep:
        _write_csv(derived / "e3_sweep_summary.csv", sweep)
        _write_md(
            derived / "e3_sweep_summary.md",
            sweep,
            [
                "machine_id",
                "work_per_iter",
                "predictability_mode",
                "array_bytes",
                "variant",
                "n_blocks",
                "overhead_pct",
                "ci_low",
                "ci_high",
            ],
        )
    print(
        f"máquinas: {len(machines)}; mesetas: {len(plateaus)}; barrido E3: {len(sweep)}"
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", default=str(DATA_DIR))
    parser.add_argument("--figures-dir", default=str(FIGURES_DIR))
    args = parser.parse_args()
    build_extended_outputs(Path(args.data_dir), Path(args.figures_dir))


if __name__ == "__main__":
    main()
