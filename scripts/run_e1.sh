#!/usr/bin/env bash
# E1: mide latencias de acceso a caché en caliente y en frío.
# Uso: ./scripts/run_e1.sh <machine_id> [samples] [buffer_mb] [out_dir]
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [samples] [buffer_mb] [out_dir]"

SAMPLES="${2:-10000}"
BUFFER_MB="${3:-64}"
OUT_DIR="${4:-$(machine_dir "$MACHINE_ID")}"
ensure_machine_dir "$MACHINE_ID"
OUT="$OUT_DIR/e1_${MACHINE_ID}.csv"

need_cmd make
make -C "$ROOT" all

echo "[E1] machine_id=$MACHINE_ID samples=$SAMPLES buffer=${BUFFER_MB}MiB cpu=${PIN_CPU:-auto}"
run_pinned "$ROOT/bin/e1_cache" \
  --machine-id "$MACHINE_ID" \
  --mode both \
  --samples "$SAMPLES" \
  --buffer-mb "$BUFFER_MB" \
  --out "$OUT"

echo "[E1] escrito $OUT"
