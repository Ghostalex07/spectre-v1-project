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
    """Decide si un conjunto de frecuencias es homogéneo y suficiente."""
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


def cluster_sessions(
    entries: list[tuple[str, float]], max_spread: float = 0.10
) -> list[list[tuple[str, float]]]:
    """Agrupa sesiones por frecuencia compatible con la mediana del grupo.

    Las sesiones se ordenan por frecuencia y se asignan al primer grupo cuya
    mediana esté a menos del ``max_spread``. Así una sesión a 2,4 GHz no impide
    agregar tres sesiones a ~4,2 GHz.
    """
    groups: list[list[tuple[str, float]]] = []
    for session_id, frequency in sorted(entries, key=lambda item: item[1]):
        if math.isnan(frequency) or frequency <= 0:
            groups.append([(session_id, frequency)])
            continue
        placed = False
        for group in groups:
            values = [
                value for _, value in group if not math.isnan(value) and value > 0
            ]
            if not values:
                continue
            center = statistics.median(values)
            if abs(frequency - center) / center <= max_spread:
                group.append((session_id, frequency))
                placed = True
                break
        if not placed:
            groups.append([(session_id, frequency)])
    return groups


def read_exclusions(path: Path | None = None) -> dict[str, str]:
    """Lee ``session_id | motivo`` desde `data/excluded_sessions.txt`."""
    if path is None:
        path = DATA_DIR / "excluded_sessions.txt"
    path = Path(path)
    if not path.is_file():
        return {}
    excluded: dict[str, str] = {}
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if "|" in line:
            session_id, reason = line.split("|", 1)
        elif "\t" in line:
            session_id, reason = line.split("\t", 1)
        else:
            session_id, reason = line, ""
        excluded[session_id.strip()] = reason.strip()
    return excluded


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


def collect_plateaus(
    machine_id: str,
    data_dir: Path = DATA_DIR,
    excluded: dict[str, str] | None = None,
) -> list[dict]:
    """Mesetas por sesión y agregados solo de grupos de frecuencia compatible."""
    if excluded is None:
        excluded = read_exclusions(data_dir / "excluded_sessions.txt")
    by_level: dict[str, list[dict]] = defaultdict(list)

    for path in e1_hierarchy_paths(machine_id, data_dir=data_dir):
        session_id = path.parent.name if path.parent != data_dir / machine_id else None
        sid = session_id or "root"
        env_path = _env_for(machine_id, data_dir, session_id)
        cache = parse_cache_env(env_path) if env_path else {}
        frequency = env_frequency_mhz(env_path)
        rows = load_hierarchy(path)
        for plateau in build_plateaus(
            machine_id, rows, cache, n_boot=2_000, seed=12345
        ):
            item = dict(plateau)
            item["machine_id"] = machine_id
            item["session_id"] = sid
            item["sessions"] = 1
            item["freq_mhz"] = "" if math.isnan(frequency) else f"{frequency:.1f}"
            item["note"] = ""
            by_level[item["level"]].append(item)

    result: list[dict] = []
    for level in ("L1d", "L2", "L3", "memoria"):
        items = by_level.get(level, [])
        if not items:
            continue

        entries = [
            (item["session_id"], float(item["freq_mhz"]))
            for item in items
            if item["session_id"] not in excluded
            and item.get("status") == "ok"
            and item.get("freq_mhz")
        ]
        groups = cluster_sessions(entries, max_spread=0.10)
        group_by_session = {
            session_id: group for group in groups for session_id, _ in group
        }
        aggregated_sessions: set[str] = set()
        aggregate_rows: list[dict] = []

        for group in groups:
            if len(group) < 3:
                continue
            by_session = {
                session_id: item
                for item in items
                for session_id in [item["session_id"]]
            }
            values = [
                by_session[session_id]["cycles_per_load"]
                for session_id, _ in group
                if session_id in by_session
                and isinstance(
                    by_session[session_id].get("cycles_per_load"), (int, float)
                )
            ]
            if len(values) < 3:
                continue
            low, high = bootstrap_ci(values, n_boot=2_000, seed=12345)
            session_ids = ",".join(session_id for session_id, _ in group)
            frequencies = [frequency for _, frequency in group]
            aggregate_rows.append(
                {
                    "machine_id": machine_id,
                    "session_id": "(agregado)",
                    "level": level,
                    "sessions": len(group),
                    "freq_mhz": f"{median(frequencies):.1f}",
                    "cycles_per_load": median(values),
                    "ci_low": low,
                    "ci_high": high,
                    "status": "agregado",
                    "note": f"sesiones: {session_ids}",
                }
            )
            aggregated_sessions.update(session_id for session_id, _ in group)

        for item in items:
            sid = item["session_id"]
            if sid in excluded:
                item["status"] = "excluida"
                item["note"] = f"excluida de resultados principales: {excluded[sid]}"
            elif sid in aggregated_sessions:
                item["note"] = "incluida en el agregado"
            elif item.get("freq_mhz"):
                group = group_by_session.get(sid, [])
                item["note"] = (
                    f"grupo de {len(group)} sesiones; no se agrega"
                    if group
                    else "sin grupo de frecuencia; no se agrega"
                )
            else:
                item["note"] = "sin frecuencia registrada; no se agrega"
            result.append(item)
        result.extend(aggregate_rows)
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
    excluded = read_exclusions(Path(data_dir) / "excluded_sessions.txt")
    plateaus: list[dict] = []
    sweep: list[dict] = []
    for machine in machines:
        plateaus.extend(collect_plateaus(machine, data_dir, excluded))
        sweep.extend(collect_sweep(machine, data_dir))

    derived = data_dir / "derived"
    report_dir = Path(data_dir).parent / "report"
    if plateaus:
        columns = [
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
        ]
        _write_csv(derived / "e1_plateaus.csv", plateaus)
        _write_md(derived / "e1_plateaus.md", plateaus, columns)
        _write_md(report_dir / "e1_plateaus.md", plateaus, columns)
    if sweep:
        _write_csv(derived / "e3_sweep_summary.csv", sweep)
        _write_md(
            derived / "e3_sweep_summary.md",
            sweep,
            [
                "machine_id",
                "session_id",
                "sessions",
                "scope",
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
