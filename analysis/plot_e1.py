#!/usr/bin/env python3
"""E1: histograma de latencias y umbral sugerido."""

from __future__ import annotations

import argparse

from common import (
    FIGURES_DIR,
    e1_path,
    median,
    p5,
    p95,
    percentile,
    read_rows,
    require_matplotlib,
    to_float,
)


def suggest_threshold(hit: list[float], miss: list[float]) -> int:
    if hit and miss:
        # Si los dos modos están separados, el punto medio entre el p95 de
        # aciertos y el p5 de fallos cae en el valle.
        hit_high = percentile(hit, 95)
        miss_low = percentile(miss, 5)
        if miss_low > hit_high:
            return int(round((hit_high + miss_low) / 2))
        return int(round((median(hit) + median(miss)) / 2))
    if hit:
        return int(round(p95(hit)))
    if miss:
        return int(round(p5(miss)))
    return 0


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--machine-id", required=True)
    parser.add_argument("--bins", type=int, default=80)
    parser.add_argument("--out", default="")
    args = parser.parse_args()

    path = e1_path(args.machine_id)
    rows = read_rows(path)
    hit = [to_float(row["cycles"]) for row in rows if row.get("mode") == "hit"]
    miss = [to_float(row["cycles"]) for row in rows if row.get("mode") == "miss"]
    hit = [value for value in hit if value == value]
    miss = [value for value in miss if value == value]

    if not hit and not miss:
        raise SystemExit(f"No hay muestras hit/miss en {path}")

    threshold = suggest_threshold(hit, miss)
    print(f"CSV: {path}")
    print(
        f"hit:  n={len(hit):5d} mediana={median(hit):8.2f} p5={p5(hit):8.2f} p95={p95(hit):8.2f}"
    )
    print(
        f"miss: n={len(miss):5d} mediana={median(miss):8.2f} p5={p5(miss):8.2f} p95={p95(miss):8.2f}"
    )
    print(f"umbral sugerido: {threshold} ciclos (valle entre los dos modos)")
    print("Guárdalo en docs/thresholds.md y úsalo en E2/E3 para esta máquina.")

    plt = require_matplotlib()
    fig, ax = plt.subplots(figsize=(8, 4.5))
    if hit:
        ax.hist(hit, bins=args.bins, alpha=0.65, label=f"hit (n={len(hit)})")
    if miss:
        ax.hist(miss, bins=args.bins, alpha=0.65, label=f"miss (n={len(miss)})")
    ax.axvline(
        threshold,
        color="black",
        linestyle="--",
        linewidth=1.2,
        label=f"umbral={threshold}",
    )
    ax.set_xlabel("ciclos por acceso")
    ax.set_ylabel("muestras")
    ax.set_title(f"E1 — latencia de caché ({args.machine_id})")
    ax.legend()
    ax.grid(alpha=0.25)

    out = args.out or str(FIGURES_DIR / f"e1_{args.machine_id}.png")
    FIGURES_DIR.mkdir(parents=True, exist_ok=True)
    fig.tight_layout()
    fig.savefig(out, dpi=160)
    print(f"figura: {out}")


if __name__ == "__main__":
    main()
