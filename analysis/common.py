"""Utilidades comunes de análisis.

Solo usa la biblioteca estándar para leer y agregar los CSV. Matplotlib se
importa únicamente en los scripts que generan figuras.
"""

from __future__ import annotations

import csv
import math
import random
import statistics
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = ROOT / "data"
FIGURES_DIR = ROOT / "figures"


def read_rows(path: str | Path) -> list[dict[str, str]]:
    with open(path, newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def to_float(value: str | None, default: float = float("nan")) -> float:
    if value is None or value == "":
        return default
    try:
        return float(value)
    except ValueError:
        return default


def to_int(value: str | None, default: int = 0) -> int:
    if value is None or value == "":
        return default
    try:
        return int(float(value))
    except ValueError:
        return default


def group_by(
    rows: Iterable[dict[str, str]], key: str
) -> dict[str, list[dict[str, str]]]:
    groups: dict[str, list[dict[str, str]]] = {}
    for row in rows:
        groups.setdefault(row.get(key, ""), []).append(row)
    return groups


def median(values: Iterable[float]) -> float:
    values = list(values)
    return statistics.median(values) if values else float("nan")


def percentile(values: Iterable[float], pct: float) -> float:
    values = sorted(values)
    if not values:
        return float("nan")
    if len(values) == 1:
        return values[0]
    position = (len(values) - 1) * (pct / 100.0)
    lower = math.floor(position)
    upper = math.ceil(position)
    if lower == upper:
        return values[lower]
    weight = position - lower
    return values[lower] * (1 - weight) + values[upper] * weight


def p5(values: Iterable[float]) -> float:
    return percentile(values, 5)


def p95(values: Iterable[float]) -> float:
    return percentile(values, 95)


def wilson_ci(successes: int, total: int, z: float = 1.96) -> tuple[float, float]:
    """Intervalo de confianza de Wilson para una proporción."""
    if total <= 0:
        return float("nan"), float("nan")
    p = successes / total
    denominator = 1 + z * z / total
    centre = (p + z * z / (2 * total)) / denominator
    half = z * math.sqrt((p * (1 - p) + z * z / (4 * total)) / total) / denominator
    return max(0.0, centre - half), min(1.0, centre + half)


def bootstrap_ci(
    values: Iterable[float],
    statistic=statistics.median,
    n_boot: int = 10_000,
    seed: int = 12345,
    alpha: float = 0.05,
) -> tuple[float, float]:
    """Intervalo bootstrap por percentiles. Suficiente para medianas y p95."""
    values = list(values)
    if not values:
        return float("nan"), float("nan")
    rng = random.Random(seed)
    n = len(values)
    stats = []
    for _ in range(n_boot):
        sample = [values[rng.randrange(n)] for _ in range(n)]
        stats.append(statistic(sample))
    stats.sort()
    lower = stats[int((alpha / 2) * n_boot)]
    upper = stats[int((1 - alpha / 2) * n_boot) - 1]
    return lower, upper


def median_ci(
    values: Iterable[float],
    n_boot: int = 10_000,
    seed: int = 12345,
    alpha: float = 0.05,
) -> tuple[float, float]:
    """IC bootstrap de la mediana."""
    return bootstrap_ci(
        values,
        statistic=statistics.median,
        n_boot=n_boot,
        seed=seed,
        alpha=alpha,
    )


def percentile_ci(
    values: Iterable[float],
    pct: float,
    n_boot: int = 10_000,
    seed: int = 12345,
    alpha: float = 0.05,
) -> tuple[float, float]:
    """IC bootstrap de un percentil concreto."""
    values = list(values)
    return bootstrap_ci(
        values,
        statistic=lambda sample: percentile(sample, pct),
        n_boot=n_boot,
        seed=seed,
        alpha=alpha,
    )


def machine_dir(machine_id: str) -> Path:
    directory = DATA_DIR / machine_id
    if not directory.is_dir():
        raise SystemExit(
            f"No existe {directory}. Ejecuta primero los experimentos o revisa --machine-id."
        )
    return directory


def e1_path(machine_id: str) -> Path:
    return machine_dir(machine_id) / f"e1_{machine_id}.csv"


def e2_paths(machine_id: str, include_o0: bool = False) -> list[Path]:
    """CSV de E2 de la máquina.

    Por defecto excluye los controles `-O0`: mezclarlos con la campaña `-O2`
    falsea la tasa y el número de muestras. Se pueden incluir explícitamente
    para una comparación aparte.
    """
    paths = sorted(machine_dir(machine_id).glob(f"e2_{machine_id}_*.csv"))
    if not include_o0:
        paths = [p for p in paths if not p.stem.endswith("_O0")]
    return paths


def e3_paths(machine_id: str) -> list[Path]:
    return sorted(machine_dir(machine_id).glob(f"e3_{machine_id}_*.csv"))


def require_matplotlib():
    try:
        import matplotlib

        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except ImportError as exc:  # pragma: no cover - depende del entorno
        raise SystemExit(
            "Falta matplotlib. Instala las dependencias con:\n"
            "  python3 -m pip install -r analysis/requirements.txt"
        ) from exc
    return plt


def fmt_pct(value: float, digits: int = 1) -> str:
    return "n/a" if math.isnan(value) else f"{100 * value:.{digits}f}%"


def fmt_num(value: float, digits: int = 2) -> str:
    return "n/a" if math.isnan(value) else f"{value:.{digits}f}"
