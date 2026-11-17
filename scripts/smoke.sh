#!/usr/bin/env bash
# Prueba de humo del harness. Comprueba que compila y que los tres
# experimentos generan CSV con el esquema esperado.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

make

TMP="$(mktemp -d "${TMPDIR:-/tmp}/spectre-smoke.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

echo "[smoke] E1"
./bin/e1_cache --machine-id smoke --mode both --samples 200 \
  --buffer-mb 8 --out "$TMP/e1.csv"
head -n1 "$TMP/e1.csv" | grep -q \
  '^machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,mode,sample,cycles$'
test "$(wc -l < "$TMP/e1.csv")" -ge 401

echo "[smoke] E2"
./bin/e2_baseline --machine-id smoke --threshold 150 --attempts 10 \
  --train 5 --runs 1 --bytes 1 --out "$TMP/e2.csv"
head -n1 "$TMP/e2.csv" | grep -q \
  '^machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles$'
test "$(wc -l < "$TMP/e2.csv")" -eq 2

echo "[smoke] E3"
./bin/e3_baseline --machine-id smoke --iterations 100000 --reps 2 \
  --out "$TMP/e3.csv"
head -n1 "$TMP/e3.csv" | grep -q \
  '^machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,iterations,run,cycles_per_iteration,total_cycles$'
test "$(wc -l < "$TMP/e3.csv")" -eq 3

echo "smoke: OK"
