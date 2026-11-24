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
        # `choices` remuestrea con reemplazo en C; equivalente al bucle
        # `values[rng.randrange(n)]`, pero mucho más rápido con n grande.
        sample = rng.choices(values, k=n)
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


def candidate_data_dirs(machine_id: str, data_dir: str | Path = DATA_DIR) -> list[Path]:
    """Directorios de una máquina: la raíz antigua y sus sesiones."""
    root = Path(data_dir) / machine_id
    if not root.is_dir():
        return []
    dirs = [root]
    dirs.extend(child for child in sorted(root.iterdir()) if child.is_dir())
    return dirs


def find_data_file(
    machine_id: str,
    filename: str,
    data_dir: str | Path = DATA_DIR,
    session_id: str | None = None,
) -> Path | None:
    """Busca un CSV en la raíz o, si no, en la sesión más reciente.

    Mantiene la compatibilidad con `data/<machine_id>/` y añade
    `data/<machine_id>/<session_id>/`. Si se indica `session_id`, solo mira
    esa sesión.
    """
    root = Path(data_dir) / machine_id
    if session_id:
        dirs = [root / session_id]
    else:
        dirs = candidate_data_dirs(machine_id, data_dir)
    candidates = [directory / filename for directory in dirs]
    existing = [path for path in candidates if path.is_file()]
    if not existing:
        return None
    return max(existing, key=lambda path: path.stat().st_mtime)


def find_e1_path(
    machine_id: str,
    data_dir: str | Path = DATA_DIR,
    session_id: str | None = None,
) -> Path:
    path = find_data_file(
        machine_id, f"e1_{machine_id}.csv", data_dir=data_dir, session_id=session_id
    )
    if path is None:
        raise SystemExit(
            f"No hay E1 para {machine_id} en {Path(data_dir) / machine_id}. "
            "Ejecuta primero scripts/run_e1.sh o revisa --session-id."
        )
    return path


def machine_csv_paths(
    machine_id: str,
    filename: str,
    data_dir: str | Path = DATA_DIR,
    session_id: str | None = None,
) -> list[Path]:
    """Todas las apariciones de un CSV en la raíz y/o en las sesiones."""
    root = Path(data_dir) / machine_id
    if session_id:
        dirs = [root / session_id]
    else:
        dirs = candidate_data_dirs(machine_id, data_dir)
    paths = [directory / filename for directory in dirs]
    return sorted(path for path in paths if path.is_file())


def e1_hierarchy_paths(
    machine_id: str,
    data_dir: str | Path = DATA_DIR,
    session_id: str | None = None,
) -> list[Path]:
    return machine_csv_paths(
        machine_id,
        f"e1_hierarchy_{machine_id}.csv",
        data_dir=data_dir,
        session_id=session_id,
    )


def e1_timer_paths(
    machine_id: str,
    data_dir: str | Path = DATA_DIR,
    session_id: str | None = None,
) -> list[Path]:
    return machine_csv_paths(
        machine_id,
        f"e1_timer_{machine_id}.csv",
        data_dir=data_dir,
        session_id=session_id,
    )


def csv_header(path: str | Path) -> list[str]:
    with open(path, newline="", encoding="utf-8") as handle:
        reader = csv.reader(handle)
        return next(reader, [])


HIERARCHY_COLUMNS = (
    "machine_id",
    "session_id",
    "timestamp",
    "working_set_bytes",
    "node_size_bytes",
    "hops",
    "repetition",
    "total_cycles",
    "cycles_per_load",
    "seed",
    "cpu_pinned",
    "hugepage",
)
TIMER_COLUMNS = (
    "machine_id",
    "session_id",
    "timestamp",
    "repetition",
    "sample",
    "cpu_pinned",
    "cycles",
)


def is_hierarchy_csv(path: str | Path) -> bool:
    header = csv_header(path)
    return all(column in header for column in HIERARCHY_COLUMNS)


def is_timer_csv(path: str | Path) -> bool:
    header = csv_header(path)
    return all(column in header for column in TIMER_COLUMNS)


E3_SWEEP_COLUMNS = (
    "machine_id",
    "session_id",
    "timestamp",
    "variant",
    "work_per_iter",
    "predictability_mode",
    "out_of_range_fraction",
    "array_bytes",
    "iterations",
    "repetition",
    "block_id",
    "total_cycles",
    "cycles_per_iter",
    "seed",
    "cpu_pinned",
)
E3_LEGACY_COLUMNS = (
    "machine_id",
    "cpu",
    "family",
    "model",
    "stepping",
    "microcode",
    "kernel",
    "gcc",
    "flags",
    "variant",
    "iterations",
    "run",
    "cycles_per_iteration",
    "total_cycles",
)


def is_e3_sweep_csv(path: str | Path) -> bool:
    """True si el CSV es del barrido E3 nuevo (cabecera con work_per_iter)."""
    header = csv_header(path)
    return all(column in header for column in E3_SWEEP_COLUMNS)


def is_e3_legacy_csv(path: str | Path) -> bool:
    """True si el CSV es del E3 antiguo de una sola configuración."""
    header = csv_header(path)
    return all(column in header for column in E3_LEGACY_COLUMNS)


def e3_sweep_paths(
    machine_id: str,
    data_dir: str | Path = DATA_DIR,
    session_id: str | None = None,
) -> list[Path]:
    """CSV de barrido E3 en la raíz o en las sesiones de la máquina."""
    root = Path(data_dir) / machine_id
    if session_id:
        dirs = [root / session_id]
    else:
        dirs = candidate_data_dirs(machine_id, data_dir)
    paths: list[Path] = []
    for directory in dirs:
        paths.extend(directory.glob(f"e3_sweep_{machine_id}_*.csv"))
    return sorted(paths)


def block_statistics(
    rows: Iterable[dict[str, str]],
    value_key: str = "cycles_per_iter",
    block_key: str = "block_id",
    statistic=statistics.median,
) -> dict[int, float]:
    """Resume cada bloque completo a un estadístico (mediana por defecto)."""
    grouped: dict[int, list[float]] = {}
    for row in rows:
        block = to_int(row.get(block_key), default=-1)
        value = to_float(row.get(value_key))
        if block < 0 or math.isnan(value):
            continue
        grouped.setdefault(block, []).append(value)
    return {block: statistic(values) for block, values in grouped.items()}


def paired_block_bootstrap(
    baseline_by_block: dict[int, float],
    variant_by_block: dict[int, float],
    n_boot: int = 10_000,
    seed: int = 12345,
    alpha: float = 0.05,
) -> tuple[float, float, float]:
    """Sobrecoste relativo con IC bootstrap remuestreando bloques completos.

    Solo se usan los bloques presentes en las dos variantes, de modo que el
    remuestreo sea emparejado. El estadístico de cada bloque ya está resumido
    (por ejemplo, mediana de sus repeticiones). Devuelve
    ``(overhead_pct, ci_low, ci_high)``.
    """
    blocks = sorted(set(baseline_by_block) & set(variant_by_block))
    if not blocks:
        return float("nan"), float("nan"), float("nan")

    def relative(sample_blocks: list[int]) -> float:
        base = statistics.median(baseline_by_block[b] for b in sample_blocks)
        var = statistics.median(variant_by_block[b] for b in sample_blocks)
        if base == 0 or math.isnan(base) or math.isnan(var):
            return float("nan")
        return 100.0 * (var - base) / base

    point = relative(blocks)
    rng = random.Random(seed)
    samples = []
    for _ in range(n_boot):
        sample = [blocks[rng.randrange(len(blocks))] for _ in blocks]
        value = relative(sample)
        if not math.isnan(value):
            samples.append(value)
    if not samples:
        return point, float("nan"), float("nan")
    samples.sort()
    lower = samples[int((alpha / 2) * len(samples))]
    upper = samples[int((1 - alpha / 2) * len(samples)) - 1]
    return point, lower, upper


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


def iqr(values: Iterable[float]) -> float:
    """Rango intercuartílico (Q3 - Q1)."""
    values = list(values)
    if not values:
        return float("nan")
    return percentile(values, 75) - percentile(values, 25)


def median_ratio_ci(
    numerator: Iterable[float],
    denominator: Iterable[float],
    n_boot: int = 10_000,
    seed: int = 12345,
    alpha: float = 0.05,
) -> tuple[float, float, float]:
    """IC bootstrap del cociente de medianas de dos muestras independientes."""
    num = list(numerator)
    den = list(denominator)
    if not num or not den:
        return float("nan"), float("nan"), float("nan")
    observed = statistics.median(num) / statistics.median(den)
    rng = random.Random(seed)
    stats = []
    for _ in range(n_boot):
        sample_num = [num[rng.randrange(len(num))] for _ in range(len(num))]
        sample_den = [den[rng.randrange(len(den))] for _ in range(len(den))]
        stats.append(statistics.median(sample_num) / statistics.median(sample_den))
    stats.sort()
    low = stats[int((alpha / 2) * n_boot)]
    high = stats[int((1 - alpha / 2) * n_boot) - 1]
    return observed, low, high
