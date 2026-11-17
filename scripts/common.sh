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
