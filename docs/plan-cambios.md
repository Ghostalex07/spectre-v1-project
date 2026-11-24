# Plan de cambios

Documento de trabajo para reorientar el repositorio según el feedback del
profesor. Se actualiza al final con lo realmente hecho.

## 1. Estado actual entendido

### Enfoque

- **E1** es la caracterización de caché con `clflush` + `rdtscp`: genera
  `data/<machine_id>/e1_<machine_id>.csv` con una fila por muestra
  (`mode=hit|miss`, `sample`, `cycles`). Se usa para elegir un umbral por
  máquina.
- **E2** es la PoC de Spectre V1 en hardware. Sigue existiendo en
  `src/e2_spectre.c`, `scripts/run_e2.sh` y `analysis/plot_e2.py`, pero el
  profesor ha pedido que no sea experimento práctico. El modelo conceptual está
  en `analysis/simulate_spectre.py` y `docs/simulation.md`.
- **E3** mide sobrecoste con `src/e3_mitigations.c`: tres variantes
  (`baseline`, `lfence`, `mask`), un array fijo de 16 índices, 10M iteraciones
  y 30 repeticiones. CSV:
  `machine_id,cpu,...,flags,variant,iterations,run,cycles_per_iteration,total_cycles`.
- La estadística actual usa mediana, p5, p95, IC bootstrap de la mediana e IC
  Wilson para proporciones.

### Scripts y análisis

- `scripts/run_all.sh` hace `collect_env.sh`, E1, E3 y, solo con
  `RUN_E2=1`, E2. `RUN_E2` ya vale 0 por defecto.
- `analysis/plot_e1.py` genera el histograma hit/miss y sugiere umbral.
- `analysis/plot_e3.py` genera barras de sobrecoste; el scatter E2/E3 es
  opcional.
- `analysis/compare_machines.py` agrega E1/E3 (y E2 opcional) en
  `data/derived/compare_machines.csv`.
- `analysis/summarize_results.py` genera `report/results_summary.md`; E2 está
  fuera por defecto.
- `docs/manual.md` y `docs/campaign.md` describen la campaña antigua: E1 de
  calibración + E3 de un solo bucle.
- `scripts/collect_env.sh` guarda un `env_<machine_id>.txt` en la raíz de la
  máquina, sin sesiones, sin CFLAGS exactas, sin `/proc/cmdline`, sin THP, sin
  hash de git y sin frecuencias.

### Datos existentes

- `data/ryzen5pro5675u/` y `data/ryzen5pro5675u_final/` están en la estructura
  antigua (CSV directamente bajo `data/<machine_id>/`). No se modifican.
- No hay datos de E1 jerárquico, coste del temporizador ni barrido de E3.
- `docs/thresholds.md` guarda el umbral usado (80) y el sugerido (138) para el
  Ryzen.

## 2. Cambios por tarea

### Tarea 1 — Rebajar E2 hardware

- `README.md`: E2 solo documental + modelo; quitar cifras E2 hardware de
  "Resultados de referencia"; quitar comandos de E2 hardware del inicio.
- `analysis/summarize_results.py`: flag `--include-e2-hardware`, desactivado
  por defecto; renombrar textos y tests.
- `Makefile`: `summary-e2` pasa a `--include-e2-hardware`.
- `docs/report-guide.md` y `docs/defense-guide.md`: demo y resultados basados
  en E1, E3 y modelo; E2 hardware solo anexo pendiente de confirmar.
- `docs/e2-anexo.md`: nuevo, sin cifras ni instrucciones.
- `docs/simulation.md`: revisar y completar solo si falta la aclaración
  "qué demuestra / qué no demuestra".

### Tarea 2 — E1 jerárquico

- `src/e1_hierarchy.c`: pointer chasing con Sattolo, tamaños configurables,
  semilla, hops, repeticiones, `madvise` opcional, CSV con sesión.
- `src/e1_timer.c`: coste del temporizador con la misma secuencia de barreras.
- `scripts/run_e1_hierarchy.sh`, `scripts/run_e1_timer.sh`: envoltorios.
- `scripts/collect_env.sh`: sesión, frecuencias, governor, CFLAGS, git, THP,
  `/proc/cmdline`, mitigaciones.
- `scripts/run_all.sh`: E1 calibración + jerarquía + timer + E3 barrido.
- `scripts/run_e3.sh`: perfil por defecto y smoke.
- `analysis/plot_e1_hierarchy.py`: latencia vs tamaño, bandas, líneas L1/L2/L3,
  varias máquinas, tabla de mesetas con IC bootstrap.
- `analysis/plot_e1.py`: añadir distribución del temporizador y umbral.
- `Makefile`: binarios, `asm`, `figures`, `smoke` corto.
- `docs/manual.md`, `docs/metrics.md`, `docs/limitations.md`: comandos,
  esquemas y límites (TLB, temporizador, TSC).

### Tarea 3 — E3 sensibilidad

- `src/e3_mitigations.c` o nuevo `src/e3_sweep.c`: W (0..64), predictibilidad
  `inrange|random_pX`, tamaño de array, bloques intercalados, semilla, sesión.
  Mantener el modo antiguo sin argumentos como caso por defecto.
- `scripts/run_e3.sh`: perfiles `default` y `smoke`, barrido de W,
  predictibilidad y tamaños.
- `Makefile`: objetivo `asm` y binarios nuevos.
- `analysis/plot_e3_sweep.py`: sobrecoste vs W, IC bootstrap por bloques,
  comparación entre máquinas, tabla CSV/Markdown.
- `docs/metrics.md`: bootstrap por bloques, fórmula de sobrecoste, esquema CSV.
- `docs/asm/`: desensamblados generados.
- `tests/test_e3_asm.py`: verificación automática del ensamblador.

### Tarea 4 — Estadística y reproducibilidad

- `analysis/common.py`: IQR, bootstrap de mediana, ratio de medianas,
  bootstrap por bloques, semilla y `n_boot` configurables.
- `docs/metrics.md`: sección de la discrepancia mask +10,7 % (3 reps) vs +1,3 %
  (30 reps), con IC calculados desde los CSV existentes.
- Sesiones: `data/<machine_id>/<session_id>/...`; análisis compatibles con la
  estructura antigua.
- `scripts/collect_env.sh`: ficha completa en la sesión.
- `analysis` y scripts: validación de ficha de entorno; error claro en sesión
  nueva, aviso en datos antiguos.
- `Makefile`: `figures` regenera todo.

### Tarea 5 — Limitaciones y comparativa

- `docs/limitations.md`: TSC, coste del temporizador, TLB, cotas de E3, modelo
  E2, ausencia de comportamiento, diferencias por microcódigo/kernel/compilador.
- `docs/machines.md`: ficha estructurada; Ryzen rellenado, resto PENDIENTE.
- `docs/report-guide.md` o documento de discusión: nota AMD LFENCE/MSR con
  "PENDIENTE: añadir referencia exacta".
- `analysis/compare_machines.py`: comparativa E1 jerárquico y E3 barrido;
  funciona con una sola máquina y con datos antiguos.

### Tarea 6 — Tests y documentación final

- Tests nuevos: Sattolo, estadística, parseo CSV nuevos/antiguos, summarize sin
  E2, ensamblador E3.
- `README.md`, `docs/manual.md`, `docs/campaign.md`, `PLAN.md`: nuevo enfoque,
  comandos, sesiones, pendientes.
- `docs/plan-cambios.md`: actualizar con lo hecho y lo no hecho.

## 3. Ficheros previstos

### Nuevos

- `docs/plan-cambios.md`
- `docs/e2-anexo.md`
- `src/e1_hierarchy.c`
- `src/e1_timer.c`
- `src/e3_sweep.c` (o ampliación de `e3_mitigations.c`)
- `scripts/run_e1_hierarchy.sh`
- `scripts/run_e1_timer.sh`
- `analysis/plot_e1_hierarchy.py`
- `analysis/plot_e3_sweep.py`
- `analysis/regenerate.py`
- `tests/test_e1_hierarchy.py`
- `tests/test_e3_asm.py`
- `tests/test_sessions.py`
- `docs/asm/` (generado)

### Modificados

- `README.md`, `PLAN.md`, `Makefile`
- `src/common.h`, `src/e3_mitigations.c` (si se amplía)
- `scripts/common.sh`, `collect_env.sh`, `run_all.sh`, `run_e1.sh`,
  `run_e3.sh`, `smoke.sh`
- `analysis/common.py`, `plot_e1.py`, `plot_e3.py`, `compare_machines.py`,
  `summarize_results.py`
- `docs/manual.md`, `metrics.md`, `limitations.md`, `machines.md`,
  `report-guide.md`, `defense-guide.md`, `campaign.md`
- `data/README.md`, `tests/test_stats.py`, `tests/test_compare_machines.py`,
  `tests/test_summarize_results.py`

## 4. Ambigüedades y conflictos detectados

1. **Estructura de datos nueva vs antigua.** El encargo pide sesiones
   `data/<machine_id>/<session_id>/`, pero los datos existentes están en
   `data/<machine_id>/`. Se mantienen ambos: los scripts nuevos escriben en
   sesión y los análisis detectan y leen la estructura antigua con aviso.
2. **Esquema E3 nuevo vs antiguo.** El E3 parametrizado necesita columnas
   nuevas; los CSV antiguos no las tienen. El análisis detectará la cabecera:
   si faltan `work_per_iter`, `predictability_mode`, etc., tratará el archivo
   como campaña antigua y no lo mezclará con el barrido.
3. **Barrido E3 y duración.** Un producto cartesiano completo de W,
   predictibilidad, tamaño, variantes, repeticiones y máquinas es enorme. Se
   definirá un perfil `default` moderado y un `smoke` mínimo; la campaña final
   se documenta como PENDIENTE.
4. **Trabajo útil W.** Debe depender del dato cargado y acabar en un sumidero
   `volatile`; si el compilador lo pliega, la comparación no mide lo que dice.
   Se verificará con `objdump`/asm.
5. **Tamaño de array en E3.** `src/spectre.h` usa arrays fijos de 16 elementos y
   lo comparte con E2. Para no tocar E2, el barrido E3 usará arrays propios
   asignados dinámicamente y funciones `noinline` específicas.
6. **Ficha de entorno y sesiones.** `collect_env.sh` se amplía con un argumento
   de sesión opcional. Sin sesión, mantiene el comportamiento antiguo para no
   romper los datos existentes.
7. **`make smoke`.** Debe seguir siendo rápido. El E1 jerárquico y el barrido
   E3 tendrán perfiles smoke de pocos tamaños/reps; no se ejecutarán campañas
   largas.
8. **Flags de E2.** El encargo pide `--include-e2-hardware`; se renombra el flag
   actual `--include-e2` y se actualizan tests/Makefile. No se toca
   `src/e2_spectre.c`, `scripts/run_e2.sh` ni `analysis/plot_e2.py`.
9. **Referencia AMD.** La nota sobre LFENCE/MSR se deja con
   "PENDIENTE: añadir referencia exacta"; no se inventan URLs ni citas.
10. **Datos de referencia.** No se modifica ningún CSV existente. Las figuras
    antiguas se regeneran solo si sus scripts siguen siendo compatibles; si un
    script nuevo no puede leer un CSV antiguo, lo ignora con aviso.

## 5. Estado de ejecución — Tarea 2 (E1 jerárquico)

Hecho en esta tarea (commit único, sin tocar E2 ni datos existentes):

- `src/e1_hierarchy.c`: pointer chasing con buffer alineado a 64 B, nodos de
  una línea, permutación de Sattolo con semilla guardada, calentamiento completo
  antes de medir, `--hops` (defecto 1.000.000), `--reps` (30), barrido por
  defecto 4 KiB–256 MiB con `2^k` y `1,5·2^k`, `rdtscp` con las barreras del
  repo y CSV con sesión, `hugepage` y CPU observada. Incluye
  `--dump-permutation` para verificar el ciclo único.
- `src/e1_timer.c`: coste del intervalo vacío con la misma secuencia de
  barreras y CSV propio; no se resta de E1.
- `src/common.h`: `machine_info_write_prefix` pasa a `static inline` para no
  generar avisos en los binarios nuevos.
- `scripts/collect_env.sh`: sesiones, `/proc/cmdline`, THP, gobernador y
  frecuencias, CFLAGS reales de `make print-cflags`, git (hash y sucio),
  mitigaciones y más campos de CPU; mantiene `data/<machine_id>/` y añade
  `data/<machine_id>/<session_id>/`.
- `scripts/common.sh`: helpers de carpeta de salida y sesión.
- `scripts/run_e1_hierarchy.sh`, `scripts/run_e1_timer.sh`: perfiles
  `default`/`smoke`.
- `scripts/run_e1.sh`: usa la sesión si `SESSION_ID` está definido.
- `scripts/run_all.sh`: sesión para E1 y ficha; ejecuta calibración + jerarquía
  + temporizador; E3 sigue en la raíz para no romper análisis.
- `scripts/smoke.sh`: comprueba cabeceras y número de filas de los CSV nuevos.
- `Makefile`: binarios `e1_hierarchy` y `e1_timer`, `print-cflags`, `test`
  depende de `all`.
- `analysis/common.py`: búsqueda de CSV en raíz/sesiones y validación de
  cabeceras nuevas.
- `analysis/plot_e1_hierarchy.py`: figura log con mediana, p5–p95, IQR, líneas
  L1d/L2/L3 y tablas CSV/Markdown de mesetas con IC bootstrap; acepta varias
  máquinas.
- `analysis/plot_e1.py`: sesiones y distribución opcional del temporizador con
  umbral.
- `tests/test_e1_hierarchy.py`: Sattolo de ciclo único (binario real), parseo
  del CSV nuevo, rechazo del E1 antiguo, compatibilidad de rutas y mesetas.
- Documentación: `docs/metrics.md`, `docs/limitations.md`, `docs/manual.md`,
  `docs/campaign.md`, `data/README.md`, `README.md` y `PLAN.md`.

Pendiente (no es parte del código de esta tarea):

- Ejecutar la campaña real de E1 jerárquico y temporizador en 2–3 máquinas y
  publicar las mesetas. Hasta entonces, las cifras de mesetas son
  **PENDIENTES**; no se inventan.
- Las tareas 3–5 (barrido E3, estadística por bloques, comparativa final) no se
  abordan aquí.
