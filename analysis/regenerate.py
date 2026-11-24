#!/usr/bin/env python3
"""Regenera todas las figuras y tablas a partir de los datos crudos."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from common import (
    DATA_DIR,
    e1_hierarchy_paths,
    e1_path,
    e3_sweep_paths,
)

ANALYSIS = Path(__file__).resolve().parent
ROOT = ANALYSIS.parent


def run(*args: str) -> None:
    print("+", " ".join(args))
    subprocess.run(args, cwd=ROOT, check=True)


def discover_machines() -> list[str]:
    machines = []
    for directory in sorted(DATA_DIR.iterdir()):
        if not directory.is_dir() or directory.name in {"derived", "simulation"}:
            continue
        if list(directory.glob("e1_*.csv")) or list(directory.glob("*/e1_*.csv")):
            machines.append(directory.name)
    return machines


def main() -> None:
    python = sys.executable
    machines = discover_machines()
    if not machines:
        raise SystemExit("No hay máquinas con datos E1 en data/")

    for machine in machines:
        if e1_path(machine).is_file():
            run(python, str(ANALYSIS / "plot_e1.py"), "--machine-id", machine)
        if e1_hierarchy_paths(machine):
            run(python, str(ANALYSIS / "plot_e1_hierarchy.py"), "--machine-id", machine)
        if list((DATA_DIR / machine).glob("e3_*.csv")):
            run(python, str(ANALYSIS / "plot_e3.py"), "--machine-id", machine)
        if e3_sweep_paths(machine):
            run(python, str(ANALYSIS / "plot_e3_sweep.py"), "--machine-id", machine)

    run(python, str(ANALYSIS / "compare_machines.py"))
    run(python, str(ANALYSIS / "summarize_results.py"))
    run(python, str(ANALYSIS / "validate_data.py"))


if __name__ == "__main__":
    main()
