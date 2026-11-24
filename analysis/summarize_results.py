#!/usr/bin/env python3
"""Genera un resumen Markdown de resultados a partir de compare_machines.csv."""

from __future__ import annotations

import argparse
import math
from pathlib import Path

from common import DATA_DIR, read_rows


def _num(row: dict[str, str], key: str, default: float = float("nan")) -> float:
    value = row.get(key, "")
    if value == "":
        return default
    try:
        return float(value)
    except ValueError:
        return default


def _fmt(value: float, digits: int = 2) -> str:
    return "n/a" if math.isnan(value) else f"{value:.{digits}f}"


def _pct(value: float, digits: int = 1) -> str:
    return "n/a" if math.isnan(value) else f"{100 * value:.{digits}f}%"


def _pct_points(value: float, digits: int = 1) -> str:
    return "n/a" if math.isnan(value) else f"{value:+.{digits}f}%"


def _ci(row: dict[str, str], centre: str, low: str, high: str, digits: int = 2) -> str:
    value = _num(row, centre)
    lower = _num(row, low)
    upper = _num(row, high)
    if math.isnan(value):
        return "n/a"
    if math.isnan(lower) or math.isnan(upper):
        return _fmt(value, digits)
    return f"{_fmt(value, digits)} [{_fmt(lower, digits)}, {_fmt(upper, digits)}]"


def _rate_ci(row: dict[str, str], variant: str) -> str:
    centre = f"e2_{variant}_rate"
    value = _num(row, centre)
    if math.isnan(value):
        return "n/a"
    return _ci(
        row,
        centre,
        f"e2_{variant}_rate_low",
        f"e2_{variant}_rate_high",
        digits=3,
    )


def _machine_label(row: dict[str, str]) -> str:
    return row.get("machine_id", "?")


def _cpu_label(row: dict[str, str]) -> str:
    return row.get("cpu", "?") or "?"


def render_summary(rows: list[dict[str, str]], title: str) -> str:
    lines = [
        f"# {title}",
        "",
        "> Documento generado por `analysis/summarize_results.py` a partir de",
        "> `data/derived/compare_machines.csv`. No se edita a mano: los números",
        "> salen de los CSV de la campaña.",
        "",
        "## Cobertura",
        "",
        f"- Entradas de máquina incluidas: **{len(rows)}**.",
    ]
    cpu_keys = {
        (
            row.get("cpu", ""),
            row.get("family", ""),
            row.get("model", ""),
            row.get("stepping", ""),
        )
        for row in rows
    }
    lines.append(f"- Microarquitecturas distintas: **{len(cpu_keys)}**.")
    if len(rows) < 2:
        lines.append(
            "- Con una sola microarquitectura, la comparación valida el pipeline;"
            " no demuestra diversidad de CPUs."
        )
    elif len(cpu_keys) < len(rows):
        lines.append(
            "- Hay varias entradas con la misma CPU/familia/modelo/stepping: son"
            " campañas distintas de la misma microarquitectura, no equipos"
            " independientes."
        )
    lines += [
        "",
        "## Equipos",
        "",
        "| máquina | CPU | familia/modelo/stepping | microcódigo | kernel | GCC |",
        "|---|---|---|---|---|---|",
    ]
    for row in rows:
        spec = "/".join(
            part
            for part in (
                row.get("family", ""),
                row.get("model", ""),
                row.get("stepping", ""),
            )
            if part
        )
        lines.append(
            f"| `{_machine_label(row)}` | {_cpu_label(row)} | {spec or 'n/a'} | "
            f"{row.get('microcode', '') or 'n/a'} | {row.get('kernel', '') or 'n/a'} | "
            f"{row.get('gcc', '') or 'n/a'} |"
        )

    lines += [
        "",
        "## E1 — calibración de caché",
        "",
        "| máquina | umbral (ciclos) | hit mediana [IC95] | miss mediana [IC95] |",
        "|---|---:|---:|---:|",
    ]
    for row in rows:
        lines.append(
            f"| `{_machine_label(row)}` | {row.get('threshold', 'n/a')} | "
            f"{_ci(row, 'hit_median', 'hit_median_low', 'hit_median_high')} | "
            f"{_ci(row, 'miss_median', 'miss_median_low', 'miss_median_high')} |"
        )

    lines += [
        "",
        "El umbral es el valle entre los dos modos de esta máquina. No se copia de",
        "otro equipo. El IC95 es el bootstrap de la mediana; p5–p95 queda en el CSV",
        "como medida de dispersión.",
        "",
        "## E2 — recuperación del secreto",
        "",
        "| máquina | baseline | LFENCE | máscara |",
        "|---|---:|---:|---:|",
    ]
    for row in rows:
        lines.append(
            f"| `{_machine_label(row)}` | {_rate_ci(row, 'baseline')} | "
            f"{_rate_ci(row, 'lfence')} | {_rate_ci(row, 'mask')} |"
        )
    lines += [
        "",
        "Entre paréntesis se muestra la tasa y el IC95 de Wilson. Un `0/N` es una",
        "cota superior, no una prueba de imposibilidad. `unclear` y el margen",
        "primero/segundo están en el CSV para separar los fallos claros del ruido.",
        "",
        "## E3 — sobrecoste",
        "",
        "| máquina | baseline (ciclos/iter) | LFENCE (ciclos/iter) | LFENCE coste | máscara (ciclos/iter) | máscara coste |",
        "|---|---:|---:|---:|---:|---:|",
    ]
    for row in rows:
        lines.append(
            f"| `{_machine_label(row)}` | "
            f"{_ci(row, 'e3_baseline_cycles', 'e3_baseline_median_low', 'e3_baseline_median_high')} | "
            f"{_ci(row, 'e3_lfence_cycles', 'e3_lfence_median_low', 'e3_lfence_median_high')} | "
            f"{_pct_points(_num(row, 'e3_lfence_pct'))} | "
            f"{_ci(row, 'e3_mask_cycles', 'e3_mask_median_low', 'e3_mask_median_high')} | "
            f"{_pct_points(_num(row, 'e3_mask_pct'))} |"
        )

    lines += [
        "",
        "El coste es la diferencia porcentual de la mediana frente a `baseline` de",
        "la misma máquina y los mismos flags. El IC95 se calcula por bootstrap.",
        "",
        "## Lectura rápida",
        "",
    ]
    for row in rows:
        base = _num(row, "e2_baseline_rate")
        lfence = _num(row, "e2_lfence_rate")
        mask = _num(row, "e2_mask_rate")
        lfence_pct = _num(row, "e3_lfence_pct")
        mask_pct = _num(row, "e3_mask_pct")
        lines.append(
            f"- `{_machine_label(row)}`: baseline {_pct(base)}, LFENCE {_pct(lfence)}, "
            f"máscara {_pct(mask)}; sobrecoste LFENCE {_pct_points(lfence_pct)}, "
            f"máscara {_pct_points(mask_pct)}."
        )
    lines += [
        "",
        "Estas frases son descriptivas. La discusión de significancia, causas",
        "microarquitectónicas y resultados negativos va en el informe, con los",
        "intervalos y el tamaño de muestra delante.",
        "",
        "## Reproducir",
        "",
        "```bash",
        "python3 analysis/compare_machines.py",
        "python3 analysis/summarize_results.py",
        "```",
        "",
        "## Límites",
        "",
        "El alcance y lo que no se puede afirmar están en",
        "[`docs/limitations.md`](../docs/limitations.md).",
        "",
    ]
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--compare-csv",
        default=str(DATA_DIR / "derived" / "compare_machines.csv"),
        help="CSV agregado por compare_machines.py",
    )
    parser.add_argument(
        "--out",
        default=str(
            Path(__file__).resolve().parents[1] / "report" / "results_summary.md"
        ),
        help="Markdown de salida",
    )
    parser.add_argument(
        "--title",
        default="Resumen de resultados — Spectre V1",
        help="Título del documento",
    )
    args = parser.parse_args()

    compare_path = Path(args.compare_csv)
    if not compare_path.is_file():
        raise SystemExit(
            f"No existe {compare_path}. Ejecuta antes: python3 analysis/compare_machines.py"
        )
    rows = read_rows(compare_path)
    if not rows:
        raise SystemExit(f"{compare_path} no tiene filas")

    text = render_summary(rows, args.title)
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding="utf-8")
    print(f"resumen: {out}")
    print(f"entradas de máquina: {len(rows)}")


if __name__ == "__main__":
    main()
