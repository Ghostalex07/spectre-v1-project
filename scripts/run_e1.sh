#!/usr/bin/env bash
# E1: mide latencias de acceso a caché en caliente y en frío.
# Uso: ./scripts/run_e1.sh <machine_id> [samples] [buffer_mb] [out_dir]
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [samples] [buffer_mb] [out_dir]"

SAMPLES="${2:-10000}"
BUFFER_MB="${3:-64}"
if [ -n "${4:-}" ]; then
  OUT_DIR="$4"
elif [ -n "${SESSION_ID:-}" ]; then
  OUT_DIR="$(data_out_dir "$MACHINE_ID")"
else
  OUT_DIR="$(machine_dir "$MACHINE_ID")"
fi
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/e1_${MACHINE_ID}.csv"
STATE="$OUT_DIR/freq_${MACHINE_ID}_${SESSION_ID:-manual}.log"
CPU="${PIN_CPU:-$(pick_cpu)}"

need_cmd make
make -C "$ROOT" all

echo "[E1] machine_id=$MACHINE_ID samples=$SAMPLES buffer=${BUFFER_MB}MiB cpu=$CPU"
record_state "$STATE" before "$CPU"
PIN_CPU="$CPU" run_pinned "$ROOT/bin/e1_cache" \
  --machine-id "$MACHINE_ID" \
  --mode both \
  --samples "$SAMPLES" \
  --buffer-mb "$BUFFER_MB" \
  --out "$OUT"
record_state "$STATE" after "$CPU"

echo "[E1] escrito $OUT"
echo "[E1] estado: $STATE"
