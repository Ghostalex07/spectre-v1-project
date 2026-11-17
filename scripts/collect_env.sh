#!/usr/bin/env bash
# Guarda una ficha reproducible del entorno de medida.
# Uso: ./scripts/collect_env.sh <machine_id> [out_dir]
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [out_dir]"

OUT_DIR="${2:-$(machine_dir "$MACHINE_ID")}"
mkdir -p "$OUT_DIR"
OUT="$OUT_DIR/env_${MACHINE_ID}.txt"

need_cmd lscpu
need_cmd gcc

{
  echo "# Entorno de medida"
  echo "machine_id: $MACHINE_ID"
  echo "date: $(date -Is)"
  echo "hostname: $(hostname)"
  echo "user: $(id -un)"
  echo "kernel: $(uname -srmo)"
  echo "nproc: $(nproc)"
  echo "affinity: $(taskset -pc $$ 2>/dev/null || echo 'no disponible')"
  echo
  echo "## lscpu"
  lscpu
  echo
  echo "## Campos de /proc/cpuinfo"
  for field in 'model name' 'cpu family' 'model' 'stepping' 'microcode' 'cache size'; do
    printf '%s: ' "$field"
    grep -m1 "^${field}[[:space:]]*:" /proc/cpuinfo | sed 's/^[^:]*:[[:space:]]*//' || echo 'no disponible'
  done
  echo
  echo "## Compilador"
  gcc --version | head -n1
  echo
  echo "## Virtualización"
  if command -v systemd-detect-virt >/dev/null 2>&1; then
    systemd-detect-virt || true
  else
    echo "systemd-detect-virt no disponible"
  fi
  echo
  echo "## Gobernador de frecuencia"
  for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -e "$f" ] || continue
    printf '%s: ' "$f"
    cat "$f"
  done
  echo
  echo "## Mitigaciones del kernel"
  if [ -d /sys/devices/system/cpu/vulnerabilities ]; then
    for f in /sys/devices/system/cpu/vulnerabilities/*; do
      [ -e "$f" ] || continue
      printf '%s: ' "$(basename "$f")"
      cat "$f"
    done
  else
    echo "directorio de vulnerabilidades no disponible"
  fi
} > "$OUT" 2>&1

echo "[env] escrito $OUT"
