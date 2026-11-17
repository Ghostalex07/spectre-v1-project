#!/usr/bin/env bash
# E3: mide el sobrecoste de una variante en ciclos por iteración.
# Uso: ./scripts/run_e3.sh <machine_id> <baseline|lfence|mask> [iterations] [reps] [out_dir]
# Variables: ITERATIONS, REPS, PIN_CPU.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
VARIANT="${2:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> <baseline|lfence|mask> [iterations] [reps] [out_dir]"
[ -n "$VARIANT" ] || die "falta la variante: baseline, lfence o mask"

case "$VARIANT" in
  baseline|lfence|mask) ;;
  *) die "variante no válida: $VARIANT (usa baseline, lfence o mask)" ;;
esac

ITERATIONS="${ITERATIONS:-${3:-10000000}}"
REPS="${REPS:-${4:-30}}"
OUT_DIR="${5:-$(machine_dir "$MACHINE_ID")}"
ensure_machine_dir "$MACHINE_ID"
OUT="$OUT_DIR/e3_${MACHINE_ID}_${VARIANT}.csv"

need_cmd make
make -C "$ROOT" all

echo "[E3] machine_id=$MACHINE_ID variant=$VARIANT iterations=$ITERATIONS reps=$REPS cpu=${PIN_CPU:-auto}"
run_pinned "$ROOT/bin/e3_${VARIANT}" \
  --machine-id "$MACHINE_ID" \
  --iterations "$ITERATIONS" \
  --reps "$REPS" \
  --out "$OUT"

echo "[E3] escrito $OUT"
