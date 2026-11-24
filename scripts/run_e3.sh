#!/usr/bin/env bash
# E3: sobrecoste de las mitigaciones.
#
# Dos modos:
#   1) Barrido de sensibilidad (por defecto):
#        ./scripts/run_e3.sh <machine_id>
#        PROFILE=smoke ./scripts/run_e3.sh <machine_id>
#      Barre W, predictibilidad y tamaño de array, intercalando variantes por
#      bloques. Escribe e3_sweep_<machine_id>_<session>.csv.
#
#   2) Compatibilidad con la firma antigua (una variante y una configuración):
#        ./scripts/run_e3.sh <machine_id> <baseline|lfence|mask> [iterations] [reps] [out_dir]
#
# Variables del barrido: E3_WORK, E3_PREDICTABILITY, E3_ARRAY_BYTES,
# E3_ITERATIONS (o ITERATIONS), E3_BLOCKS, E3_REPS (o REPS), E3_WARMUP,
# E3_SEED, SESSION_ID, PIN_CPU. PROFILE=default|smoke.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [sweep|<baseline|lfence|mask>] [iterations] [reps] [out_dir]"
MODE="${2:-sweep}"

need_cmd make
make -C "$ROOT" all

case "$MODE" in
  baseline|lfence|mask)
    # Firma antigua: un binario por variante, sin barrido.
    ITERATIONS="${ITERATIONS:-${3:-10000000}}"
    REPS="${REPS:-${4:-30}}"
    OUT_DIR="${5:-$(machine_dir "$MACHINE_ID")}"
    ensure_machine_dir "$MACHINE_ID"
    OUT="$OUT_DIR/e3_${MACHINE_ID}_${MODE}.csv"

    echo "[E3] machine_id=$MACHINE_ID variant=$MODE iterations=$ITERATIONS reps=$REPS cpu=${PIN_CPU:-auto}"
    run_pinned "$ROOT/bin/e3_${MODE}" \
      --machine-id "$MACHINE_ID" \
      --iterations "$ITERATIONS" \
      --reps "$REPS" \
      --out "$OUT"
    echo "[E3] escrito $OUT"
    ;;
  sweep)
    PROFILE="${PROFILE:-default}"
    case "$PROFILE" in
      default|smoke) ;;
      *) die "PROFILE no válido: $PROFILE (usa default o smoke)" ;;
    esac

    if [ "$PROFILE" = "smoke" ]; then
      WORK="${E3_WORK:-0,8}"
      PRED="${E3_PREDICTABILITY:-inrange,random_p50}"
      ARRAYS="${E3_ARRAY_BYTES:-4096,33554432}"
      ITER="${E3_ITERATIONS:-${ITERATIONS:-2000}}"
      BLOCKS="${E3_BLOCKS:-2}"
      REPS="${E3_REPS:-${REPS:-1}}"
      WARMUP="${E3_WARMUP:-64}"
    else
      WORK="${E3_WORK:-0,1,2,4,8,16,32,64}"
      PRED="${E3_PREDICTABILITY:-inrange,random_p1,random_p10,random_p50}"
      ARRAYS="${E3_ARRAY_BYTES:-4096,67108864}"
      ITER="${E3_ITERATIONS:-${ITERATIONS:-200000}}"
      BLOCKS="${E3_BLOCKS:-5}"
      REPS="${E3_REPS:-${REPS:-3}}"
      WARMUP="${E3_WARMUP:-256}"
    fi
    SEED="${E3_SEED:-20261124}"

    SESSION="${SESSION_ID:-manual}"
    export SESSION_ID="$SESSION"
    OUT_DIR="$(prepare_out_dir "$MACHINE_ID")"
    OUT="${E3_OUT:-$OUT_DIR/e3_sweep_${MACHINE_ID}_${SESSION}.csv}"

    echo "[E3 barrido] machine_id=$MACHINE_ID profile=$PROFILE session=$SESSION"
    echo "[E3 barrido] W=$WORK pred=$PRED arrays=$ARRAYS iter=$ITER blocks=$BLOCKS reps=$REPS seed=$SEED cpu=${PIN_CPU:-auto}"
    run_pinned "$ROOT/bin/e3_sweep" \
      --machine-id "$MACHINE_ID" \
      --session-id "$SESSION" \
      --work "$WORK" \
      --predictability "$PRED" \
      --array-bytes "$ARRAYS" \
      --iterations "$ITER" \
      --blocks "$BLOCKS" \
      --reps "$REPS" \
      --warmup "$WARMUP" \
      --seed "$SEED" \
      --out "$OUT"

    echo "[E3 barrido] escrito $OUT"
    ;;
  *)
    die "modo no válido: $MODE (usa sweep, baseline, lfence o mask)"
    ;;
esac
