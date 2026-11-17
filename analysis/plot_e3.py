#!/usr/bin/env python3
"""E3: sobrecoste de las mitigaciones y scatter eficacia/sobrecoste."""

from __future__ import annotations

import argparse
from collections import defaultdict

from common import (
    FIGURES_DIR,
    e2_paths,
    e3_paths,
    fmt_num,
    fmt_pct,
    median,
    p5,
    p95,
    read_rows,
    require_matplotlib,
    to_float,
    to_int,
    wilson_ci,
)


def load_e3(machine_id: str):
    by_variant = defaultdict(list)
    for path in e3_paths(machine_id):
        for row in read_rows(path):
            by_variant[row.get("variant", "")].append(
                to_float(row.get("cycles_per_iteration"))
            )
    if not by_variant:
        raise SystemExit(f"No hay CSV E3 para {machine_id} en data/{machine_id}/")
    return by_variant


def load_efficacy(machine_id: str):
    by_variant = {}
    for path in e2_paths(machine_id):
        rows = read_rows(path)
        for row in rows:
            variant = row.get("variant", "")
            entry = by_variant.setdefault(variant, {"successes": 0, "total": 0})
            entry["successes"] += to_int(row.get("success"))
            entry["total"] += 1
    return by_variant


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--machine-id", required=True)
    parser.add_argument("--out-prefix", default="")
    args = parser.parse_args()

    overhead = load_e3(args.machine_id)
    efficacy = load_efficacy(args.machine_id)
    variants = sorted(overhead)
    baseline = median(overhead.get("baseline", []))

    print(
        f"{'variant':10} {'n':>4} {'mediana':>10} {'p5':>9} {'p95':>9} {'coste abs':>10} {'coste %':>9} {'slowdown':>9} {'eficacia':>9}"
    )
    stats = {}
    for variant in variants:
        values = overhead[variant]
        med = median(values)
        stats[variant] = {
            "median": med,
            "p5": p5(values),
            "p95": p95(values),
            "abs": med - baseline,
            "pct": 100 * (med - baseline) / baseline if baseline else float("nan"),
            "slowdown": med / baseline if baseline else float("nan"),
        }
        eff = efficacy.get(variant)
        eff_text = "n/a"
        if eff and eff["total"]:
            eff_text = fmt_pct(eff["successes"] / eff["total"])
        print(
            f"{variant:10} {len(values):4d} {med:10.3f} {p5(values):9.3f} {p95(values):9.3f} "
            f"{stats[variant]['abs']:10.3f} {stats[variant]['pct']:8.1f}% "
            f"{stats[variant]['slowdown']:9.2f} {eff_text:>9}"
        )

    plt = require_matplotlib()
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    prefix = args.out_prefix or str(FIGURES_DIR / f"e3_{args.machine_id}")

    # Sobrecoste: mediana con rango p5-p95.
    fig, ax = plt.subplots(figsize=(7, 4.5))
    xs = list(range(len(variants)))
    medians = [stats[v]["median"] for v in variants]
    lower = [stats[v]["median"] - stats[v]["p5"] for v in variants]
    upper = [stats[v]["p95"] - stats[v]["median"] for v in variants]
    ax.bar(
        xs,
        medians,
        yerr=[lower, upper],
        capsize=4,
        color=["#4c78a8", "#f58518", "#54a24b"][: len(variants)],
    )
    ax.set_xticks(xs)
    ax.set_xticklabels(variants)
    ax.set_ylabel("ciclos por iteración (mediana, rango p5-p95)")
    ax.set_title(f"E3 — sobrecoste ({args.machine_id})")
    ax.grid(axis="y", alpha=0.25)
    fig.tight_layout()
    overhead_out = f"{prefix}_overhead.png"
    fig.savefig(overhead_out, dpi=160)
    print(f"figura: {overhead_out}")

    # Scatter eficacia frente a sobrecoste.
    if efficacy:
        fig, ax = plt.subplots(figsize=(7, 4.5))
        for variant in variants:
            eff = efficacy.get(variant)
            if not eff or not eff["total"]:
                continue
            rate = eff["successes"] / eff["total"]
            low, high = wilson_ci(eff["successes"], eff["total"])
            x = stats[variant]["pct"]
            ax.scatter([x], [100 * rate], s=70, label=variant)
            ax.errorbar(
                [x],
                [100 * rate],
                yerr=[[100 * (rate - low)], [100 * (high - rate)]],
                fmt="none",
                capsize=3,
            )
            ax.annotate(
                variant, (x, 100 * rate), textcoords="offset points", xytext=(6, 4)
            )
        ax.set_xlabel("sobrecoste frente a baseline (%)")
        ax.set_ylabel("recuperación correcta (%)")
        ax.set_ylim(-2, 102)
        ax.set_title(f"E3 — eficacia frente a sobrecoste ({args.machine_id})")
        ax.grid(alpha=0.25)
        fig.tight_layout()
        scatter_out = f"{prefix}_scatter.png"
        fig.savefig(scatter_out, dpi=160)
        print(f"figura: {scatter_out}")


if __name__ == "__main__":
    main()
