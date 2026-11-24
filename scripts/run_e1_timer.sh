#!/usr/bin/env bash
# E1 temporizador: distribución del coste del intervalo vacío rdtscp+barreras.
# Uso: ./scripts/run_e1_timer.sh <machine_id> [out_dir]
# Variables: PROFILE=default|smoke, SAMPLES, REPS, WARMUP, SESSION_ID, PIN_CPU.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [out_dir]"

PROFILE="${PROFILE:-default}"
case "$PROFILE" in
  default)
    SAMPLES="${SAMPLES:-100000}"
    REPS="${REPS:-3}"
    WARMUP="${WARMUP:-1000}"
    ;;
  smoke)
    SAMPLES="${SAMPLES:-2000}"
    REPS="${REPS:-2}"
    WARMUP="${WARMUP:-100}"
    ;;
  *)
    die "PROFILE no válido: $PROFILE (usa default o smoke)"
    ;;
esac

if [ -n "${2:-}" ]; then
  OUT_DIR="$2"
elif [ -n "${SESSION_ID:-}" ]; then
  OUT_DIR="$(data_out_dir "$MACHINE_ID")"
else
  OUT_DIR="$(machine_dir "$MACHINE_ID")"
fi
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/e1_timer_${MACHINE_ID}.csv"

need_cmd make
make -C "$ROOT" all

ARGS=(
  --machine-id "$MACHINE_ID"
  --samples "$SAMPLES"
  --reps "$REPS"
  --warmup "$WARMUP"
  --out "$OUT"
)
if [ -n "${SESSION_ID:-}" ]; then
  ARGS+=(--session-id "$SESSION_ID")
fi

echo "[E1-temporizador] machine_id=$MACHINE_ID session=${SESSION_ID:-manual} profile=$PROFILE samples=$SAMPLES reps=$REPS cpu=${PIN_CPU:-auto}"
run_pinned "$ROOT/bin/e1_timer" "${ARGS[@]}"

echo "[E1-temporizador] escrito $OUT"
