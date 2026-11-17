#!/usr/bin/env bash
# E2: intenta recuperar el secreto con una variante.
# Uso: THRESHOLD=80 ./scripts/run_e2.sh <machine_id> <baseline|lfence|mask> [threshold] [attempts] [train] [runs] [bytes]
# Variables: THRESHOLD, ATTEMPTS, TRAIN, RUNS, BYTES, OPT=O2|O0, PIN_CPU.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
VARIANT="${2:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> <baseline|lfence|mask> [threshold] [attempts] [train] [runs] [bytes]"
[ -n "$VARIANT" ] || die "falta la variante: baseline, lfence o mask"

case "$VARIANT" in
  baseline|lfence|mask) ;;
  *) die "variante no válida: $VARIANT (usa baseline, lfence o mask)" ;;
esac

THRESHOLD="${THRESHOLD:-${3:-}}"
[ -n "$THRESHOLD" ] || die "falta THRESHOLD. Calíbralo con E1 y pásalo como tercer argumento o variable de entorno."

ATTEMPTS="${ATTEMPTS:-${4:-1000}}"
TRAIN="${TRAIN:-${5:-5}}"
RUNS="${RUNS:-${6:-50}}"
BYTES="${BYTES:-${7:-40}}"
OPT="${OPT:-O2}"
OUT_DIR="$(machine_dir "$MACHINE_ID")"
ensure_machine_dir "$MACHINE_ID"

case "$OPT" in
  O2)
    BIN="$ROOT/bin/e2_${VARIANT}"
    OUT="$OUT_DIR/e2_${MACHINE_ID}_${VARIANT}.csv"
    ;;
  O0)
    BIN="$ROOT/bin/e2_${VARIANT}_O0"
    OUT="$OUT_DIR/e2_${MACHINE_ID}_${VARIANT}_O0.csv"
    ;;
  *)
    die "OPT no válido: $OPT (usa O2 u O0)"
    ;;
esac

need_cmd make
make -C "$ROOT" all

echo "[E2] machine_id=$MACHINE_ID variant=$VARIANT opt=$OPT threshold=$THRESHOLD attempts=$ATTEMPTS train=$TRAIN runs=$RUNS bytes=$BYTES cpu=${PIN_CPU:-auto}"
run_pinned "$BIN" \
  --machine-id "$MACHINE_ID" \
  --threshold "$THRESHOLD" \
  --attempts "$ATTEMPTS" \
  --train "$TRAIN" \
  --runs "$RUNS" \
  --bytes "$BYTES" \
  --out "$OUT"

echo "[E2] escrito $OUT"
