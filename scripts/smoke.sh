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

echo "[smoke] E1 jerárquico"
./bin/e1_hierarchy --machine-id smoke --session-id smoke \
  --sizes 4096,65536 --hops 5000 --reps 2 --warmup-passes 1 \
  --out "$TMP/e1_hierarchy.csv"
head -n1 "$TMP/e1_hierarchy.csv" | grep -q \
  '^machine_id,session_id,timestamp,working_set_bytes,node_size_bytes,hops,repetition,total_cycles,cycles_per_load,seed,cpu_pinned,hugepage$'
test "$(wc -l < "$TMP/e1_hierarchy.csv")" -eq 5

echo "[smoke] E1 temporizador"
./bin/e1_timer --machine-id smoke --session-id smoke \
  --samples 1000 --reps 2 --warmup 100 --out "$TMP/e1_timer.csv"
head -n1 "$TMP/e1_timer.csv" | grep -q \
  '^machine_id,session_id,timestamp,repetition,sample,cpu_pinned,cycles$'
test "$(wc -l < "$TMP/e1_timer.csv")" -eq 2001

if [ "${RUN_E2:-0}" = "1" ]; then
  echo "[smoke] E2"
  ./bin/e2_baseline --machine-id smoke --threshold 150 --attempts 10 \
    --train 5 --runs 1 --bytes 1 --out "$TMP/e2.csv"
  head -n1 "$TMP/e2.csv" | grep -q \
    '^machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles$'
  test "$(wc -l < "$TMP/e2.csv")" -eq 2
else
  echo "[smoke] E2 hardware omitido (RUN_E2=0)"
fi

echo "[smoke] E3"
./bin/e3_baseline --machine-id smoke --iterations 100000 --reps 2 \
  --out "$TMP/e3.csv"
head -n1 "$TMP/e3.csv" | grep -q \
  '^machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,iterations,run,cycles_per_iteration,total_cycles$'
test "$(wc -l < "$TMP/e3.csv")" -eq 3

echo "[smoke] E3 barrido"
./bin/e3_sweep --machine-id smoke --session-id smoke \
  --work 0,8 --predictability inrange,random_p50 \
  --array-bytes 4096,33554432 --iterations 2000 --blocks 2 --reps 1 \
  --warmup 32 --out "$TMP/e3_sweep.csv"
head -n1 "$TMP/e3_sweep.csv" | grep -q \
  '^machine_id,session_id,timestamp,variant,flags,work_per_iter,predictability_mode,out_of_range_fraction,array_bytes,iterations,repetition,block_id,total_cycles,cycles_per_iter,seed,cpu_pinned$'
# 3 variantes x 2 W x 2 modos x 2 arrays x 2 bloques x 1 repetición = 48 filas
test "$(wc -l < "$TMP/e3_sweep.csv")" -eq 49

echo "smoke: OK"
