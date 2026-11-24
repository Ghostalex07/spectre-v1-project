#!/usr/bin/env bash
# Campaña completa en una máquina: entorno, E1 (calibración + jerarquía +
# temporizador), E2 opcional y E3.
# Uso: THRESHOLD=80 RUN_E2=0 ./scripts/run_all.sh <machine_id> [threshold]
# Variables: PROFILE=default|smoke, RUN_E2=0|1, ATTEMPTS, TRAIN, RUNS, BYTES,
# ITERATIONS, REPS, RUN_O0=1, PIN_CPU, E3_ORDER=random|fixed, SESSION_ID,
# HOPS, SIZES, HUGEPAGE, SAMPLES (temporizador).
#
# Foco experimental: E1 y E3 son obligatorios. E2 en hardware es opcional;
# el mecanismo se cubre con análisis documental y simulación conceptual.
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: THRESHOLD=80 $0 <machine_id> [threshold]"
THRESHOLD="${THRESHOLD:-${2:-}}"
[ -n "$THRESHOLD" ] || die "falta THRESHOLD. Ejecuta E1, elige el umbral y vuelve a lanzar con THRESHOLD=<valor>."

PROFILE="${PROFILE:-default}"
case "$PROFILE" in
  default|smoke) ;;
  *) die "PROFILE no válido: $PROFILE (usa default o smoke)" ;;
esac

# Toda la campaña de E1 y la ficha de entorno comparten una sesión. Los datos
# de E3 siguen en data/<machine_id>/ para no romper los análisis actuales.
SESSION_ID="${SESSION_ID:-$(default_session_id)}"
export SESSION_ID
SESSION_DIR="$(prepare_out_dir "$MACHINE_ID")"

"$ROOT/scripts/collect_env.sh" "$MACHINE_ID"
"$ROOT/scripts/run_e1.sh" "$MACHINE_ID"
PROFILE="$PROFILE" "$ROOT/scripts/run_e1_hierarchy.sh" "$MACHINE_ID"
PROFILE="$PROFILE" "$ROOT/scripts/run_e1_timer.sh" "$MACHINE_ID"

RUN_E2="${RUN_E2:-0}"
if [ "$RUN_E2" = "1" ]; then
  for variant in baseline lfence mask; do
    "$ROOT/scripts/run_e2.sh" "$MACHINE_ID" "$variant" "$THRESHOLD"
  done

  # Control opcional a -O0: útil para comprobar que el compilador no ha
  # eliminado la vulnerabilidad. No entra en la comparación principal.
  if [ "${RUN_O0:-0}" = "1" ]; then
    OPT=O0 "$ROOT/scripts/run_e2.sh" "$MACHINE_ID" baseline "$THRESHOLD"
  fi
else
  echo "[run_all] E2 hardware omitido (RUN_E2=0; opcional)."
fi

E3_VARIANTS=(baseline lfence mask)
if [ "${E3_ORDER:-random}" = "random" ] && command -v shuf >/dev/null 2>&1; then
  mapfile -t E3_VARIANTS < <(printf '%s\n' "${E3_VARIANTS[@]}" | shuf)
fi
ORDER_FILE="$(machine_dir "$MACHINE_ID")/e3_order_${MACHINE_ID}.txt"
printf '%s\n' "${E3_VARIANTS[@]}" > "$ORDER_FILE"
echo "[run_all] orden E3: ${E3_VARIANTS[*]} (registrado en $ORDER_FILE)"

if [ "$PROFILE" = "smoke" ]; then
  E3_ITER="${E3_ITERATIONS:-${ITERATIONS:-200000}}"
  E3_REPS="${E3_REPS:-${REPS:-3}}"
else
  E3_ITER="${E3_ITERATIONS:-${ITERATIONS:-10000000}}"
  E3_REPS="${E3_REPS:-${REPS:-30}}"
fi
for variant in "${E3_VARIANTS[@]}"; do
  ITERATIONS="$E3_ITER" REPS="$E3_REPS" \
    "$ROOT/scripts/run_e3.sh" "$MACHINE_ID" "$variant"
done

echo
echo "[run_all] campaña terminada para $MACHINE_ID (perfil $PROFILE)"
echo "  sesión E1: $SESSION_DIR"
echo "  E1:       $SESSION_DIR/e1_${MACHINE_ID}.csv"
echo "  E1 jer.:  $SESSION_DIR/e1_hierarchy_${MACHINE_ID}.csv"
echo "  E1 temp.: $SESSION_DIR/e1_timer_${MACHINE_ID}.csv"
if [ "$RUN_E2" = "1" ]; then
  echo "  E2:  data/${MACHINE_ID}/e2_${MACHINE_ID}_{baseline,lfence,mask}.csv"
else
  echo "  E2:  omitido (opcional; el mecanismo se cubre con simulación)"
fi
echo "  E3:  data/${MACHINE_ID}/e3_${MACHINE_ID}_{baseline,lfence,mask}.csv"
echo "  Figuras:"
echo "    python3 analysis/plot_e1.py --machine-id ${MACHINE_ID} --session-id ${SESSION_ID}"
echo "    python3 analysis/plot_e1_hierarchy.py --machine-id ${MACHINE_ID} --session-id ${SESSION_ID}"
if [ "$RUN_E2" = "1" ]; then
  echo "    python3 analysis/plot_e2.py --machine-id ${MACHINE_ID}"
fi
echo "    python3 analysis/plot_e3.py --machine-id ${MACHINE_ID}"
