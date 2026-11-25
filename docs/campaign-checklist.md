# Checklist de campaña

Úsala antes de abrir el PR de una máquina. La guía completa está en
[`campaign.md`](campaign.md).

## 0. Antes de medir

- [ ] He clonado el repositorio y `make`, `make smoke` y `make test` pasan.
- [ ] Mi `machine_id` es nuevo y descriptivo (`intel_i7_1165g7`,
      `ryzen7_5800h`, …). No uso `ryzen5pro5675u_final`.
- [ ] No voy a sobrescribir `data/ryzen5pro5675u/` ni
      `data/ryzen5pro5675u_final/`.
- [ ] La máquina es nativa, no una VM ni un contenedor.
- [ ] He anotado CPU, family/model/stepping, microcódigo, kernel, GCC y estado
      de `spectre_v1`.

## 1. Entorno y sesiones

- [ ] He ejecutado `./scripts/collect_env.sh <machine_id>` con una
      `SESSION_ID` propia.
- [ ] Cada sesión tiene su `env_<machine_id>.txt` en
      `data/<machine_id>/<session_id>/`.
- [ ] He hecho **dos sesiones en arranques distintos**.
- [ ] Las dos sesiones tienen E1 calibración, E1 jerárquico, temporizador y E3
      barrido.

## 2. E1

- [ ] `./scripts/run_e1.sh <machine_id> 10000 64`.
- [ ] He mirado el histograma y elegido el umbral en el valle.
- [ ] El umbral está anotado en `docs/thresholds.md` **por sesión**.
- [ ] `./scripts/run_e1_hierarchy.sh <machine_id>`.
- [ ] `./scripts/run_e1_timer.sh <machine_id>`.
- [ ] Las mesetas L1d/L2/L3/memoria tienen sentido y no las he forzado.

## 3. E3

- [ ] `PROFILE=default ./scripts/run_e3.sh <machine_id>`.
- [ ] No he usado `PROFILE=smoke` como campaña.
- [ ] El barrido cubre `W=0..64`, las cuatro predictibilidades y los dos
      tamaños de array.
- [ ] Los IC por bloques están calculados.

## 4. Ensamblador

- [ ] `make asm` pasa.
- [ ] `baseline` tiene `cmp` + salto condicional, no `cmov`.
- [ ] `lfence` tiene `cmp` + salto + `lfence`.
- [ ] `mask` tiene `cmp` + `and` y **ningún salto condicional** en la función
      vulnerable.

## 5. Figuras y validación

- [ ] `make figures` termina sin errores.
- [ ] `make validate` dice `validación OK`.
- [ ] Las figuras de mi máquina existen en `figures/`.
- [ ] `report/results_summary.md` se ha regenerado.
- [ ] No hay CSV `-O0` mezclados con `-O2` en las figuras principales.

## 6. Documentación

- [ ] He añadido mi fila a `docs/machines.md`.
- [ ] He añadido mis umbrales a `docs/thresholds.md`.
- [ ] He explicado cualquier resultado negativo o anomalía.
- [ ] No he presentado `0/N` como prueba de imposibilidad.

## 7. Git y PR

- [ ] Rama `campaign/<machine_id>`.
- [ ] `git status` solo muestra los archivos de mi campaña.
- [ ] No he añadido `spectre.txt`, `bin/`, `__pycache__/`, `*.pyc` ni
      temporales.
- [ ] El commit explica qué máquina y qué sesiones añade.
- [ ] El PR sigue la plantilla de `.github/pull_request_template.md`.
- [ ] No he hecho `push --force`, `reset --hard` ni `rebase` sobre `main`.
