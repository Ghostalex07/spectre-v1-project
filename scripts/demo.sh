#!/usr/bin/env bash
# Demo para la defensa: baseline recupera el secreto; LFENCE y máscara no.
# Uso: THRESHOLD=80 ./scripts/demo.sh [machine_id] [bytes]
# Requiere que el umbral sea válido para la máquina de la demo.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-demo}"
BYTES="${2:-40}"
THRESHOLD="${THRESHOLD:-80}"
ATTEMPTS="${ATTEMPTS:-300}"

need_cmd make
make -C "$ROOT" all >/dev/null

TMP="$(mktemp -d "${TMPDIR:-/tmp}/spectre-demo.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

for variant in baseline lfence mask; do
  echo "== $variant =="
  "$ROOT/bin/e2_$variant" \
    --machine-id "$MACHINE_ID" \
    --threshold "$THRESHOLD" \
    --attempts "$ATTEMPTS" \
    --train 5 \
    --runs 1 \
    --bytes "$BYTES" \
    --out "$TMP/$variant.csv" >/dev/null

  python3 - "$TMP/$variant.csv" <<'PY'
import csv
import sys

rows = list(csv.DictReader(open(sys.argv[1], encoding="utf-8")))
recovered = "".join(chr(int(row["guess"])) for row in rows)
correct = sum(int(row["success"]) for row in rows)
print(f"  recuperado: {recovered!r}")
print(f"  aciertos:   {correct}/{len(rows)}")
PY
done

echo
echo "Lectura: baseline debe mostrar el secreto; lfence y mask no deben recuperarlo."
echo "Si tu máquina no filtra ni en baseline, mira docs/troubleshooting.md."
