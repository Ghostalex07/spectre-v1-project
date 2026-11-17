#!/usr/bin/env bash
# Campaña completa en una máquina: entorno, E1, E2 (tres variantes) y E3.
# Uso: THRESHOLD=80 ./scripts/run_all.sh <machine_id> [threshold]
# Variables: ATTEMPTS, TRAIN, RUNS, BYTES, ITERATIONS, REPS, RUN_O0=1, PIN_CPU.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: THRESHOLD=80 $0 <machine_id> [threshold]"
THRESHOLD="${THRESHOLD:-${2:-}}"
[ -n "$THRESHOLD" ] || die "falta THRESHOLD. Ejecuta E1, elige el umbral y vuelve a lanzar con THRESHOLD=<valor>."

"$ROOT/scripts/collect_env.sh" "$MACHINE_ID"
"$ROOT/scripts/run_e1.sh" "$MACHINE_ID"

for variant in baseline lfence mask; do
  "$ROOT/scripts/run_e2.sh" "$MACHINE_ID" "$variant" "$THRESHOLD"
done

# Control opcional a -O0: útil para comprobar que el compilador no ha
# eliminado la vulnerabilidad. No entra en la comparación principal.
if [ "${RUN_O0:-0}" = "1" ]; then
  OPT=O0 "$ROOT/scripts/run_e2.sh" "$MACHINE_ID" baseline "$THRESHOLD"
fi

for variant in baseline lfence mask; do
  "$ROOT/scripts/run_e3.sh" "$MACHINE_ID" "$variant"
done

echo
echo "[run_all] campaña terminada para $MACHINE_ID"
echo "  E1:  data/${MACHINE_ID}/e1_${MACHINE_ID}.csv"
echo "  E2:  data/${MACHINE_ID}/e2_${MACHINE_ID}_{baseline,lfence,mask}.csv"
echo "  E3:  data/${MACHINE_ID}/e3_${MACHINE_ID}_{baseline,lfence,mask}.csv"
echo "  Figuras:"
echo "    python3 analysis/plot_e1.py --machine-id ${MACHINE_ID}"
echo "    python3 analysis/plot_e2.py --machine-id ${MACHINE_ID}"
echo "    python3 analysis/plot_e3.py --machine-id ${MACHINE_ID}"
