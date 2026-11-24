#!/usr/bin/env bash
# Guarda una ficha reproducible del entorno de medida (sin privilegios).
# Uso: ./scripts/collect_env.sh <machine_id> [out_dir]
# Variables: SESSION_ID (si existe, guarda en data/<machine_id>/<session_id>/).
set -euo pipefail

source "$(dirname "$0")/common.sh"

MACHINE_ID="${1:-}"
[ -n "$MACHINE_ID" ] || die "uso: $0 <machine_id> [out_dir]"

if [ -n "${2:-}" ]; then
  OUT_DIR="$2"
  mkdir -p "$OUT_DIR"
else
  OUT_DIR="$(prepare_out_dir "$MACHINE_ID")"
fi
OUT="$OUT_DIR/env_${MACHINE_ID}.txt"

need_cmd lscpu
need_cmd gcc

print_file() {
  local label="$1" path="$2"
  if [ -n "$label" ]; then
    printf '%s: ' "$label"
  fi
  if [ -r "$path" ]; then
    cat "$path"
  else
    echo "no disponible"
  fi
}

GIT_HASH="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo 'no disponible')"
if [ -n "$(git -C "$ROOT" status --porcelain 2>/dev/null || true)" ]; then
  GIT_DIRTY="si"
else
  GIT_DIRTY="no"
fi
CFLAGS_USED="$(make -C "$ROOT" -s print-cflags 2>/dev/null || echo 'no disponible')"

{
  echo "# Entorno de medida"
  echo "machine_id: $MACHINE_ID"
  if [ -n "${SESSION_ID:-}" ]; then
    echo "session_id: $SESSION_ID"
  else
    echo "session_id: (sin sesión; estructura antigua)"
  fi
  echo "date: $(date -Is)"
  echo "hostname: $(hostname)"
  echo "user: $(id -un)"
  echo "kernel: $(uname -srmo)"
  echo "uname: $(uname -a)"
  echo "nproc: $(nproc)"
  echo "affinity: $(taskset -pc $$ 2>/dev/null || echo 'no disponible')"
  echo "git_commit: $GIT_HASH"
  echo "git_dirty: $GIT_DIRTY"
  echo "cflags: $CFLAGS_USED"
  echo
  echo "## /proc/cmdline"
  cat /proc/cmdline 2>/dev/null || echo "no disponible"
  echo
  echo "## lscpu"
  lscpu
  echo
  echo "## Campos de /proc/cpuinfo"
  for field in 'model name' 'vendor_id' 'cpu family' 'model' 'stepping' \
               'microcode' 'cache size' 'cpu MHz' 'cpu cores' \
               'siblings' 'flags'; do
    printf '%s: ' "$field"
    grep -m1 "^${field}[[:space:]]*:" /proc/cpuinfo \
      | sed 's/^[^:]*:[[:space:]]*//' || echo 'no disponible'
  done
  echo
  echo "## Compilador"
  gcc --version | head -n1
  echo "CFLAGS: $CFLAGS_USED"
  echo
  echo "## Virtualización"
  if command -v systemd-detect-virt >/dev/null 2>&1; then
    systemd-detect-virt || true
  else
    echo "systemd-detect-virt no disponible"
  fi
  echo
  echo "## Gobernador y frecuencias"
  for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*; do
    [ -d "$cpu_dir/cpufreq" ] || continue
    printf '%s: governor=' "$(basename "$cpu_dir")"
    print_file "" "$cpu_dir/cpufreq/scaling_governor"
    printf '%s: cur_freq_khz=' "$(basename "$cpu_dir")"
    print_file "" "$cpu_dir/cpufreq/scaling_cur_freq"
    printf '%s: min_freq_khz=' "$(basename "$cpu_dir")"
    print_file "" "$cpu_dir/cpufreq/cpuinfo_min_freq"
    printf '%s: max_freq_khz=' "$(basename "$cpu_dir")"
    print_file "" "$cpu_dir/cpufreq/cpuinfo_max_freq"
  done
  echo
  echo "## Transparent Huge Pages"
  print_file "enabled" /sys/kernel/mm/transparent_hugepage/enabled
  print_file "defrag" /sys/kernel/mm/transparent_hugepage/defrag
  print_file "hpage_pmd_size" /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
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
