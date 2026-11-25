#!/usr/bin/env bash
# Utilidades compartidas por los scripts del harness.
# Se carga con: source "$(dirname "$0")/common.sh"

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/bin"

die() {
  echo "error: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "falta el comando '$1'"
}

# Devuelve el primer CPU permitido por la afinidad actual. Sirve para
# contenedores y para máquinas donde el CPU 0 no está disponible.
pick_cpu() {
  local list first
  list="$(taskset -pc $$ 2>/dev/null | sed 's/.*: //' || true)"
  if [ -z "$list" ]; then
    echo 0
    return
  fi
  first="${list%%,*}"
  if [[ "$first" == *-* ]]; then
    echo "${first%-*}"
  else
    echo "$first"
  fi
}

# Frecuencia y estado del sistema para el registro antes/después de medir.
read_cpu_mhz() {
  awk -F: '/^cpu MHz/{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}' \
    /proc/cpuinfo 2>/dev/null || true
}

read_scaling_freq_khz() {
  local cpu="$1"
  cat "/sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_cur_freq" \
    2>/dev/null || echo "na"
}

read_governor() {
  local cpu="$1"
  cat "/sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor" \
    2>/dev/null || echo "na"
}

read_power_supply() {
  local out="" path name value
  for path in /sys/class/power_supply/*; do
    [ -d "$path" ] || continue
    name="$(basename "$path")"
    if [ -r "$path/online" ]; then
      value="$(cat "$path/online" 2>/dev/null || echo na)"
      out="${out}${out:+;}${name}:online=${value}"
    elif [ -r "$path/status" ]; then
      value="$(cat "$path/status" 2>/dev/null || echo na)"
      out="${out}${out:+;}${name}:status=${value}"
    fi
  done
  echo "${out:-no disponible}"
}

read_platform_profile() {
  cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "no disponible"
}

# Añade una línea de estado al registro de la sesión.
record_state() {
  local file="$1" phase="$2" cpu="$3"
  mkdir -p "$(dirname "$file")"
  printf '%s phase=%s cpu=%s cpu_mhz=%s scaling_cur_freq_khz=%s governor=%s power=%s platform_profile=%s\n' \
    "$(date -Is)" "$phase" "$cpu" "$(read_cpu_mhz)" \
    "$(read_scaling_freq_khz "$cpu")" "$(read_governor "$cpu")" \
    "$(read_power_supply)" "$(read_platform_profile)" >> "$file"
}

# Ejecuta un comando fijado a un CPU físico. Se puede forzar con PIN_CPU=3.
run_pinned() {
  local cpu="${PIN_CPU:-$(pick_cpu)}"
  if command -v taskset >/dev/null 2>&1; then
    taskset -c "$cpu" "$@"
  else
    "$@"
  fi
}

machine_dir() {
  echo "$ROOT/data/$1"
}

ensure_machine_dir() {
  mkdir -p "$(machine_dir "$1")"
}

# Carpeta de salida con soporte de sesiones. Si hay SESSION_ID (o se pasa como
# segundo argumento), escribe en data/<machine_id>/<session_id>/; si no,
# mantiene la estructura antigua data/<machine_id>/.
data_out_dir() {
  local machine_id="$1"
  local session_id="${2:-${SESSION_ID:-}}"
  if [ -n "$session_id" ]; then
    echo "$ROOT/data/$machine_id/$session_id"
  else
    echo "$ROOT/data/$machine_id"
  fi
}

prepare_out_dir() {
  local directory
  directory="$(data_out_dir "$1" "${2:-}")"
  mkdir -p "$directory"
  echo "$directory"
}

# Sesión por defecto para una campaña lanzada desde run_all.sh.
default_session_id() {
  echo "${SESSION_ID:-$(date -u +%Y%m%dT%H%M%SZ)}"
}
