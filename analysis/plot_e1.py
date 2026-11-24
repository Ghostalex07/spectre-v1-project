#!/usr/bin/env python3
"""E1: histograma de latencias y umbral sugerido."""

from __future__ import annotations

import argparse
from pathlib import Path

from common import (
    DATA_DIR,
    FIGURES_DIR,
    find_data_file,
    find_e1_path,
    is_timer_csv,
    median,
    median_ci,
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
    parser.add_argument("--session-id", default="")
    parser.add_argument("--data-dir", default="")
    parser.add_argument("--bins", type=int, default=80)
    parser.add_argument("--timer-csv", default="")
    parser.add_argument("--out", default="")
    parser.add_argument("--timer-out", default="")
    args = parser.parse_args()

    data_dir = Path(args.data_dir) if args.data_dir else DATA_DIR
    path = find_e1_path(
        args.machine_id,
        data_dir=data_dir,
        session_id=args.session_id or None,
    )
    rows = read_rows(path)
    hit = [to_float(row["cycles"]) for row in rows if row.get("mode") == "hit"]
    miss = [to_float(row["cycles"]) for row in rows if row.get("mode") == "miss"]
    hit = [value for value in hit if value == value]
    miss = [value for value in miss if value == value]

    if not hit and not miss:
        raise SystemExit(f"No hay muestras hit/miss en {path}")

    threshold = suggest_threshold(hit, miss)
    hit_ci = median_ci(hit)
    miss_ci = median_ci(miss)
    print(f"CSV: {path}")
    print(
        f"hit:  n={len(hit):5d} mediana={median(hit):8.2f} p5={p5(hit):8.2f} p95={p95(hit):8.2f} "
        f"IC95 mediana=[{hit_ci[0]:.2f}, {hit_ci[1]:.2f}]"
    )
    print(
        f"miss: n={len(miss):5d} mediana={median(miss):8.2f} p5={p5(miss):8.2f} p95={p95(miss):8.2f} "
        f"IC95 mediana=[{miss_ci[0]:.2f}, {miss_ci[1]:.2f}]"
    )
    print(f"umbral sugerido: {threshold} ciclos (valle entre los dos modos)")
    print(
        "p5-p95 describe la dispersión; el IC bootstrap describe la precisión de la mediana."
    )
    print("Guárdalo en docs/thresholds.md y úsalo en E2/E3 para esta máquina.")

    plt = require_matplotlib()
    fig, ax = plt.subplots(figsize=(8, 4.5))
    if hit:
        ax.hist(
            hit, bins=args.bins, alpha=0.65, color="C0", label=f"hit (n={len(hit)})"
        )
        ax.axvspan(
            hit_ci[0], hit_ci[1], color="C0", alpha=0.12, label="IC95 mediana hit"
        )
    if miss:
        ax.hist(
            miss, bins=args.bins, alpha=0.65, color="C1", label=f"miss (n={len(miss)})"
        )
        ax.axvspan(
            miss_ci[0], miss_ci[1], color="C1", alpha=0.12, label="IC95 mediana miss"
        )
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

    timer_path = None
    if args.timer_csv:
        timer_path = Path(args.timer_csv)
    else:
        timer_path = find_data_file(
            args.machine_id,
            f"e1_timer_{args.machine_id}.csv",
            data_dir=data_dir,
            session_id=args.session_id or None,
        )

    if timer_path and timer_path.is_file():
        if not is_timer_csv(timer_path):
            print(f"aviso: {timer_path} no parece un CSV de temporizador; se omite")
            return
        timer_rows = read_rows(timer_path)
        timer = [to_float(row.get("cycles")) for row in timer_rows]
        timer = [value for value in timer if value == value]
        if not timer:
            print(f"aviso: no hay muestras en {timer_path}")
            return
        timer_median = median(timer)
        timer_low, timer_high = median_ci(timer)
        print(f"timer: {timer_path}")
        print(
            f"timer: n={len(timer):d} mediana={timer_median:.2f} "
            f"p5={p5(timer):.2f} p95={p95(timer):.2f} "
            f"IC95 mediana=[{timer_low:.2f}, {timer_high:.2f}]"
        )
        if hit:
            print(
                "coste del temporizador / mediana hit: "
                f"{100 * timer_median / median(hit):.1f}% (no se resta)"
            )
        fig2, ax2 = plt.subplots(figsize=(8, 4.5))
        ax2.hist(
            timer,
            bins=args.bins,
            alpha=0.7,
            color="C2",
            label=f"intervalo vacío (n={len(timer)})",
        )
        ax2.axvline(
            timer_median,
            color="black",
            linestyle="-",
            linewidth=1.2,
            label=f"mediana={timer_median:.1f}",
        )
        ax2.axvline(
            p95(timer),
            color="black",
            linestyle=":",
            linewidth=1.2,
            label=f"p95={p95(timer):.1f}",
        )
        if threshold:
            ax2.axvline(
                threshold,
                color="C3",
                linestyle="--",
                linewidth=1.2,
                label=f"umbral E1={threshold}",
            )
        ax2.set_xlabel("ciclos del intervalo vacío")
        ax2.set_ylabel("muestras")
        ax2.set_title(f"E1 — coste del temporizador rdtscp ({args.machine_id})")
        ax2.legend()
        ax2.grid(alpha=0.25)
        timer_out = args.timer_out or str(
            FIGURES_DIR / f"e1_{args.machine_id}_timer.png"
        )
        fig2.tight_layout()
        fig2.savefig(timer_out, dpi=160)
        print(f"figura temporizador: {timer_out}")
    elif args.timer_csv:
        print(f"aviso: no existe {timer_path}")


if __name__ == "__main__":
    main()
