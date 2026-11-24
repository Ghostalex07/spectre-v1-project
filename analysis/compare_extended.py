#!/usr/bin/env python3
"""Comparativa extendida: mesetas E1 y sobrecoste del barrido E3."""

from __future__ import annotations

import argparse
import csv
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
    """Mesetas por nivel, agregando sesiones si existen."""
    by_level: dict[str, list[dict]] = defaultdict(list)
    for path in e1_hierarchy_paths(machine_id, data_dir=data_dir):
        session_id = path.parent.name if path.parent != data_dir / machine_id else None
        env_path = _env_for(machine_id, data_dir, session_id)
        cache = parse_cache_env(env_path) if env_path else {}
        rows = load_hierarchy(path)
        for plateau in build_plateaus(
            machine_id, rows, cache, n_boot=2_000, seed=12345
        ):
            plateau["session_id"] = session_id or "root"
            by_level[plateau["level"]].append(plateau)

    result = []
    for level, items in by_level.items():
        values = [item["cycles_per_load"] for item in items if item["status"] == "ok"]
        values = [value for value in values if value == value]
        if not values:
            result.append(
                {
                    "machine_id": machine_id,
                    "level": level,
                    "sessions": len(items),
                    "cycles_per_load": "",
                    "ci_low": "",
                    "ci_high": "",
                    "status": "sin-datos",
                }
            )
            continue
        low, high = bootstrap_ci(values, n_boot=2_000, seed=12345)
        result.append(
            {
                "machine_id": machine_id,
                "level": level,
                "sessions": len(items),
                "cycles_per_load": f"{median(values):.3f}",
                "ci_low": f"{low:.3f}",
                "ci_high": f"{high:.3f}",
                "status": "ok",
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
                "level",
                "sessions",
                "cycles_per_load",
                "ci_low",
                "ci_high",
                "status",
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
