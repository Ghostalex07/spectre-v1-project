#!/usr/bin/env python3
"""Valida que los CSV de una sesión tengan su ficha de entorno.

Los datos antiguos viven en `data/<machine_id>/` y solo generan un aviso.
Los datos nuevos viven en `data/<machine_id>/<session_id>/` y deben tener
`env_<machine_id>.txt` en la misma carpeta.
"""

from __future__ import annotations

import argparse
from pathlib import Path

from common import DATA_DIR

SKIP_DIRS = {"derived", "simulation"}
DATA_PREFIXES = ("e1_", "e3_")


def _machine_dirs(root: Path) -> list[Path]:
    return [
        path
        for path in sorted(root.iterdir())
        if path.is_dir() and path.name not in SKIP_DIRS
    ]


def _csvs(machine_dir: Path) -> list[Path]:
    return [
        path
        for path in sorted(machine_dir.rglob("*.csv"))
        if path.name.startswith(DATA_PREFIXES)
    ]


def validate(root: str | Path = DATA_DIR) -> tuple[list[str], list[str]]:
    """Devuelve (errores, avisos)."""
    root = Path(root)
    errors: list[str] = []
    warnings: list[str] = []
    if not root.is_dir():
        return [f"No existe el directorio de datos: {root}"], warnings

    for machine_dir in _machine_dirs(root):
        machine_id = machine_dir.name
        for csv_path in _csvs(machine_dir):
            env_path = csv_path.parent / f"env_{machine_id}.txt"
            if env_path.is_file():
                continue
            message = f"{csv_path}: falta {env_path.name} en la carpeta de la sesión"
            if csv_path.parent == machine_dir:
                warnings.append(message + " (dato antiguo; solo aviso)")
            else:
                errors.append(message)
    return errors, warnings


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", default=str(DATA_DIR))
    args = parser.parse_args()

    errors, warnings = validate(args.data_dir)
    for warning in warnings:
        print(f"AVISO: {warning}")
    for error in errors:
        print(f"ERROR: {error}")
    if errors:
        raise SystemExit(1)
    print(f"validación OK ({len(warnings)} avisos)")


if __name__ == "__main__":
    main()
