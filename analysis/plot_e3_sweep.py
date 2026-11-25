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
import sys
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

# Sesiones medidas antes de corregir load_mask: su variante mask no conservaba
# el salto condicional y no es comparable con baseline/lfence. Los CSV no se
# modifican; el análisis descarta esa variante y avisa.
OBSOLETE_MASK_SESSIONS = {"20261124-200944", "20261125-084943"}
TABLE_FIELDS = [
    "machine_id",
    "session_id",
    "sessions",
    "scope",
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


def load_sweep(
    machine_id: str, session_id: str | None = None, path: Path | None = None
) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    paths = (
        [Path(path)]
        if path is not None
        else e3_sweep_paths(machine_id, session_id=session_id)
    )
    for csv_path in paths:
        if not is_e3_sweep_csv(csv_path):
            continue
        skipped_mask = False
        for row in read_rows(csv_path):
            session = row.get("session_id", "")
            if row.get("variant") == "mask" and session in OBSOLETE_MASK_SESSIONS:
                skipped_mask = True
                continue
            rows.append(row)
        if skipped_mask:
            print(
                f"aviso: {csv_path}: se excluye mask de la sesión obsoleta "
                f"{session or '?'} (load_mask anterior sin salto condicional)",
                file=sys.stderr,
            )
    return rows


def combo_key(row: dict[str, str]) -> tuple:
    return (
        row.get("machine_id", ""),
        to_int(row.get("work_per_iter")),
        row.get("predictability_mode", ""),
        to_int(row.get("array_bytes")),
    )


def _with_session_block(rows):
    """Clave de bloque única por sesión, para no emparejar bloques homónimos."""
    return [
        {
            **row,
            "block_id": f"{row.get('session_id', '')}:{row.get('block_id', '')}",
        }
        for row in rows
    ]


def _summarize_combo(
    rows,
    machine_id,
    work,
    mode,
    array_bytes,
    session_id,
    sessions,
    scope,
    n_boot,
    seed,
):
    by_variant: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        by_variant[row.get("variant", "")].append(row)

    baseline_rows = by_variant.get("baseline", [])
    if not baseline_rows:
        return []
    baseline_blocks = block_statistics(_with_session_block(baseline_rows))
    if not baseline_blocks:
        return []
    oor = median(to_float(row.get("out_of_range_fraction")) for row in rows)

    table: list[dict] = []
    for variant in sorted(by_variant):
        if variant == "baseline":
            continue
        variant_blocks = block_statistics(_with_session_block(by_variant[variant]))
        common_blocks = set(baseline_blocks) & set(variant_blocks)
        if not common_blocks:
            continue
        pct, low, high = paired_block_bootstrap(
            baseline_blocks, variant_blocks, n_boot=n_boot, seed=seed
        )
        baseline_cycles = median(baseline_blocks[key] for key in common_blocks)
        variant_cycles = median(variant_blocks[key] for key in common_blocks)
        variant_sessions = sorted(
            {
                row.get("session_id", "")
                for row in by_variant[variant]
                if row.get("session_id", "")
            }
        )
        session_label = (
            session_id if scope == "session" else ", ".join(variant_sessions)
        )
        slowdown = variant_cycles / baseline_cycles if baseline_cycles else float("nan")
        table.append(
            {
                "machine_id": machine_id,
                "session_id": session_id,
                "sessions": session_label,
                "scope": scope,
                "work_per_iter": work,
                "predictability_mode": mode,
                "out_of_range_fraction": oor,
                "array_bytes": array_bytes,
                "variant": variant,
                "n_blocks": len(common_blocks),
                "baseline_cycles": baseline_cycles,
                "variant_cycles": variant_cycles,
                "overhead_pct": pct,
                "ci_low": low,
                "ci_high": high,
                "slowdown": slowdown,
            }
        )
    return table


def overhead_table(rows, n_boot: int = 10_000, seed: int = 12345) -> list[dict]:
    """Tabla de sobrecoste por combinación, máquina y variante.

    Con varias sesiones se devuelven filas por sesión y una fila agregada. El
    bootstrap agregado usa claves de bloque ``sesión:bloque`` para respetar la
    estructura de cada sesión.
    """
    groups: dict[tuple, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        groups[combo_key(row)].append(row)

    table: list[dict] = []
    for key in sorted(groups):
        machine_id, work, mode, array_bytes = key
        combo_rows = groups[key]
        session_ids = sorted(
            {
                row.get("session_id", "")
                for row in combo_rows
                if row.get("session_id", "")
            }
        )
        if len(session_ids) <= 1:
            label = session_ids[0] if session_ids else "(sin-sesion)"
            table.extend(
                _summarize_combo(
                    combo_rows,
                    machine_id,
                    work,
                    mode,
                    array_bytes,
                    label,
                    label,
                    "agregado",
                    n_boot,
                    seed,
                )
            )
            continue

        for session_id in session_ids:
            session_rows = [
                row for row in combo_rows if row.get("session_id", "") == session_id
            ]
            table.extend(
                _summarize_combo(
                    session_rows,
                    machine_id,
                    work,
                    mode,
                    array_bytes,
                    session_id,
                    session_id,
                    "session",
                    n_boot,
                    seed,
                )
            )
        table.extend(
            _summarize_combo(
                combo_rows,
                machine_id,
                work,
                mode,
                array_bytes,
                "(agregado)",
                ", ".join(session_ids),
                "agregado",
                n_boot,
                seed,
            )
        )
    return table


def write_table(table: list[dict]) -> None:
    DERIVED_DIR.mkdir(parents=True, exist_ok=True)
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    with open(OVERHEAD_CSV, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=TABLE_FIELDS, lineterminator="\n")
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
        "El IC95 remuestrea bloques completos (emparejado). Las filas "
        "`(agregado)` combinan sesiones con claves de bloque `sesión:bloque`; "
        "las filas de sesión permiten comparar su consistencia.",
        "",
        "| máquina | sesión | sesiones | ámbito | W | predictibilidad | "
        "fuera rango | array B | variante | bloques | base ciclos | var ciclos | "
        "sobrecoste % | IC95 | slowdown |",
        "|---|---|---|---|---:|---|---:|---:|---|---:|---:|---:|---:|---|---:|",
    ]
    for row in table:
        ci = (
            f"[{fmt_num(row['ci_low'])}, {fmt_num(row['ci_high'])}]"
            if not math.isnan(row["ci_low"])
            else "n/a"
        )
        lines.append(
            f"| `{row['machine_id']}` | `{row['session_id']}` | "
            f"`{row['sessions']}` | `{row['scope']}` | {row['work_per_iter']} | "
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
    aggregate = [row for row in selected if row["scope"] == "agregado"]
    return aggregate or selected


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
        aggregate_rows = [row for row in machine_rows if row.get("scope") == "agregado"]
        if aggregate_rows:
            machine_rows = aggregate_rows
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
