#!/usr/bin/env python3
"""E2: tasa de recuperación por variante, entrenamiento y byte."""

from __future__ import annotations

import argparse
from collections import defaultdict

from common import (
    FIGURES_DIR,
    e2_paths,
    fmt_pct,
    median,
    read_rows,
    require_matplotlib,
    to_int,
    wilson_ci,
)


def load(machine_id: str):
    rows = []
    for path in e2_paths(machine_id):
        for row in read_rows(path):
            row = dict(row)
            row["_path"] = str(path)
            rows.append(row)
    if not rows:
        raise SystemExit(f"No hay CSV E2 para {machine_id} en data/{machine_id}/")
    return rows


def summarize(rows, margin_min: int):
    groups = defaultdict(list)
    for row in rows:
        key = (row.get("variant", ""), to_int(row.get("train")))
        groups[key].append(row)

    summary = []
    for (variant, train), items in sorted(groups.items()):
        total = len(items)
        successes = sum(to_int(row.get("success")) for row in items)
        low, high = wilson_ci(successes, total)
        margins = [
            to_int(row.get("score1")) - to_int(row.get("score2")) for row in items
        ]
        unclear = sum(1 for margin in margins if margin < margin_min)
        summary.append(
            {
                "variant": variant,
                "train": train,
                "n": total,
                "successes": successes,
                "rate": successes / total if total else float("nan"),
                "low": low,
                "high": high,
                "unclear_rate": unclear / total if total else float("nan"),
                "median_margin": median(margins),
            }
        )
    return summary


def print_table(summary):
    print(
        f"{'variant':10} {'train':>5} {'n':>7} {'aciertos':>9} {'tasa':>8} {'IC95':>18} {'unclear':>8} {'margen':>8}"
    )
    for item in summary:
        ci = f"[{fmt_pct(item['low'])}, {fmt_pct(item['high'])}]"
        print(
            f"{item['variant']:10} {item['train']:5d} {item['n']:7d} "
            f"{item['successes']:9d} {fmt_pct(item['rate']):>8} {ci:>18} "
            f"{fmt_pct(item['unclear_rate']):>8} {item['median_margin']:8.1f}"
        )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--machine-id", required=True)
    parser.add_argument(
        "--margin-min",
        type=int,
        default=5,
        help="margen mínimo (score1-score2) para considerar claro un byte",
    )
    parser.add_argument("--out-prefix", default="")
    args = parser.parse_args()

    rows = load(args.machine_id)
    summary = summarize(rows, args.margin_min)
    print_table(summary)

    plt = require_matplotlib()
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    prefix = args.out_prefix or str(FIGURES_DIR / f"e2_{args.machine_id}")

    # Curva tasa vs entrenamiento.
    variants = sorted({item["variant"] for item in summary})
    fig, ax = plt.subplots(figsize=(8, 4.5))
    for variant in variants:
        points = [item for item in summary if item["variant"] == variant]
        points.sort(key=lambda item: item["train"])
        xs = [item["train"] for item in points]
        ys = [100 * item["rate"] for item in points]
        lower = [100 * (item["rate"] - item["low"]) for item in points]
        upper = [100 * (item["high"] - item["rate"]) for item in points]
        ax.errorbar(xs, ys, yerr=[lower, upper], marker="o", capsize=3, label=variant)
    ax.set_xlabel("aciertos de entrenamiento por ataque (train)")
    ax.set_ylabel("recuperación correcta (%)")
    ax.set_ylim(-2, 102)
    ax.set_title(f"E2 — recuperación vs entrenamiento ({args.machine_id})")
    ax.legend()
    ax.grid(alpha=0.25)
    fig.tight_layout()
    train_out = f"{prefix}_train.png"
    fig.savefig(train_out, dpi=160)
    print(f"figura: {train_out}")

    # Recuperación por byte.
    by_byte = defaultdict(lambda: defaultdict(list))
    for row in rows:
        by_byte[row.get("variant", "")][to_int(row.get("byte"))].append(
            to_int(row.get("success"))
        )

    fig, ax = plt.subplots(figsize=(9, 4.5))
    for variant in variants:
        byte_ids = sorted(by_byte[variant])
        rates = [
            100 * sum(by_byte[variant][b]) / len(by_byte[variant][b]) for b in byte_ids
        ]
        ax.plot(byte_ids, rates, marker="o", markersize=3, label=variant)
    ax.set_xlabel("byte del secreto")
    ax.set_ylabel("recuperación correcta (%)")
    ax.set_ylim(-2, 102)
    ax.set_title(f"E2 — recuperación por byte ({args.machine_id})")
    ax.legend()
    ax.grid(alpha=0.25)
    fig.tight_layout()
    bytes_out = f"{prefix}_bytes.png"
    fig.savefig(bytes_out, dpi=160)
    print(f"figura: {bytes_out}")


if __name__ == "__main__":
    main()
