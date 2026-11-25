#!/usr/bin/env bash
# E1 jerárquico: latencia de pointer chasing frente al tamaño del working set.
# Uso: ./scripts/run_e1_hierarchy.sh <machine_id> [out_dir]
# Variables: PROFILE=default|smoke, SIZES, HOPS, REPS, WARMUP, NODE_SIZE,
#            HUGEPAGE=0|1, SESSION_ID, PIN_CPU.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [out_dir]"

PROFILE="${PROFILE:-default}"
case "$PROFILE" in
  default)
    HOPS="${HOPS:-1000000}"
    REPS="${REPS:-30}"
    WARMUP="${WARMUP:-1}"
    ;;
  smoke)
    SIZES="${SIZES:-4096,65536,1048576}"
    HOPS="${HOPS:-20000}"
    REPS="${REPS:-3}"
    WARMUP="${WARMUP:-1}"
    ;;
  *)
    die "PROFILE no válido: $PROFILE (usa default o smoke)"
    ;;
esac
NODE_SIZE="${NODE_SIZE:-64}"
HUGEPAGE="${HUGEPAGE:-0}"

if [ -n "${2:-}" ]; then
  OUT_DIR="$2"
elif [ -n "${SESSION_ID:-}" ]; then
  OUT_DIR="$(data_out_dir "$MACHINE_ID")"
else
  OUT_DIR="$(machine_dir "$MACHINE_ID")"
fi
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/e1_hierarchy_${MACHINE_ID}.csv"
STATE="$OUT_DIR/freq_${MACHINE_ID}_${SESSION_ID:-manual}.log"
CPU="${PIN_CPU:-$(pick_cpu)}"

need_cmd make
make -C "$ROOT" all

ARGS=(
  --machine-id "$MACHINE_ID"
  --node-size "$NODE_SIZE"
  --hops "$HOPS"
  --reps "$REPS"
  --warmup-passes "$WARMUP"
  --out "$OUT"
)
if [ -n "${SIZES:-}" ]; then
  ARGS+=(--sizes "$SIZES")
fi
if [ -n "${SESSION_ID:-}" ]; then
  ARGS+=(--session-id "$SESSION_ID")
fi
if [ "$HUGEPAGE" = "1" ]; then
  ARGS+=(--hugepage)
fi

echo "[E1-jerarquía] machine_id=$MACHINE_ID session=${SESSION_ID:-manual} profile=$PROFILE sizes=${SIZES:-barrido 4 KiB-256 MiB} hops=$HOPS reps=$REPS node=$NODE_SIZE cpu=$CPU"
record_state "$STATE" before "$CPU"
PIN_CPU="$CPU" run_pinned "$ROOT/bin/e1_hierarchy" "${ARGS[@]}"
record_state "$STATE" after "$CPU"

echo "[E1-jerarquía] escrito $OUT"
echo "[E1-jerarquía] estado: $STATE"
