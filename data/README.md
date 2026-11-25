# Datos

Los datos crudos y los CSV viven aquí. La política es simple: **se conservan, no
se editan a mano y las figuras se pueden regenerar desde ellos**.

## Estructura

```text
data/
  <machine_id>/
    env_<machine_id>.txt
    poc_<machine_id>.txt
    e1_<machine_id>.csv
    e2_<machine_id>_baseline.csv
    e2_<machine_id>_lfence.csv
    e2_<machine_id>_mask.csv
    e2_<machine_id>_baseline_O0.csv   # control opcional
    e3_<machine_id>_baseline.csv
    e3_<machine_id>_lfence.csv
    e3_<machine_id>_mask.csv
  <machine_id>/<session_id>/
    env_<machine_id>.txt
    e1_<machine_id>.csv
    e1_hierarchy_<machine_id>.csv
    e1_timer_<machine_id>.csv
    e3_sweep_<machine_id>_<session_id>.csv   # barrido E3 nuevo
  simulation/
    spectre_model.csv
  derived/
```

- `machine_id` debe coincidir con la fila de [`docs/machines.md`](../docs/machines.md).
- Las campañas nuevas pueden usar `data/<machine_id>/<session_id>/` para el
  entorno y E1 (calibración, jerárquico y temporizador). Los análisis aceptan
  ambas estructuras y, sin `--session-id`, eligen la sesión más reciente.
- `env_*.txt`: salida de `lscpu`, kernel, GCC, microcódigo, mitigaciones, THP,
  CFLAGS, git y gobernador.
- `poc_*.txt`: salida de la prueba de viabilidad de Fase 0.
- `e1_*.csv`: latencias de caché.
- `e2_*.csv`: recuperación del secreto por variante. Es **validación opcional**
  de hardware; la explicación del mecanismo va en el modelo y en el análisis
  documental.
- `e3_*.csv`: sobrecoste por variante en el formato antiguo (una configuración,
  firma `scripts/run_e3.sh <machine_id> <variant>`).
- `e3_sweep_<machine_id>_<session_id>.csv`: barrido de sensibilidad nuevo
  (W, predictibilidad, tamaño de array y bloques intercalados). Se genera con
  `scripts/run_e3.sh <machine_id> sweep`. No se mezcla con el E3 antiguo.
- `e3_order_<machine_id>.txt`: orden aleatorizado de las variantes en el modo
  legacy de E3, para que la secuencia de medición quede registrada. El barrido
  nuevo guarda la semilla y el bloque en cada fila.
- `simulation/spectre_model.csv`: salida del modelo conceptual de
  `analysis/simulate_spectre.py`; no es una medida de hardware.
- `derived/`: tablas agregadas generadas por `analysis/`; no se editan a mano.
  `compare_machines.csv` es la tabla comparativa que genera
  `analysis/compare_machines.py`. Incluye `hit_median_low/high`,
  `miss_median_low/high` y `e3_<variant>_median_low/high` con el IC95 bootstrap
  de cada mediana, además de los percentiles p5/p95 descriptivos. Para E2 añade
  `e2_<variant>_rate_low/high` (Wilson), `e2_<variant>_unclear_rate` y
  `e2_<variant>_median_margin`.

## Datos de referencia incluidos

`data/ryzen5pro5675u/` contiene los datos de referencia del Ryzen, incluidos
los datos antiguos de la raíz y dos sesiones de la metodología nueva:

- `20261124-200944`: E1 calibración, E1 jerárquico, temporizador y E3 barrido.
- `20261125-084943`: la misma campaña, en un arranque distinto.

Las dos sesiones permiten comprobar repetibilidad. El umbral cambió entre
arranques (184 y 138), así que debe registrarse por sesión y no copiarse de una
máquina o sesión a otra. Los datos antiguos de la raíz se conservan para no
romper análisis previos.

`data/ryzen5pro5675u_final/` es **legacy**: se generó con la metodología
anterior (E2 hardware y E3 de un solo bucle). Se conserva como referencia
histórica y comprobación cruzada, pero **no se usa en la comparación principal**,
no se citan sus cifras E2 y su E3 no es comparable con el barrido nuevo. Es la
misma microarquitectura que `ryzen5pro5675u`, así que tampoco cuenta como una
CPU distinta para el objetivo de 2–3 microarquitecturas.

La simulación conceptual de referencia está en
`data/simulation/spectre_model.csv` y se regenera con `make simulate`. No es una
medida de hardware: sirve para explicar el mecanismo y comparar las variantes de
forma reproducible.

La campaña de cada compañero debe usar los valores del protocolo y quedar
identificada con su propio `machine_id` y su `session_id`.

## Esquemas CSV

### E1

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,mode,sample,cycles
```

- `mode`: `hit` o `miss`.
- `sample`: índice de muestra.
- `cycles`: latencia medida con `rdtscp`.

### E1 jerárquico

```text
machine_id,session_id,timestamp,working_set_bytes,node_size_bytes,hops,repetition,total_cycles,cycles_per_load,seed,cpu_pinned,hugepage
```

- `working_set_bytes`: tamaño del buffer; `node_size_bytes`: nodo (64 B).
- `hops`: cargas medidas; `repetition`: índice de repetición.
- `cycles_per_load = total_cycles / hops`.
- `seed`: semilla de Sattolo; `hugepage`: `none`, `madvise` o
  `madvise-failed`; `cpu_pinned`: CPU observada.

### E1 coste del temporizador

```text
machine_id,session_id,timestamp,repetition,sample,cpu_pinned,cycles
```

- `cycles`: intervalo vacío `lfence;rdtscp;lfence;rdtscp`.
- No se resta de E1; se analiza como distribución.

### E2 — validación opcional de hardware

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles
```

- `variant`: `baseline`, `lfence` o `mask`.
- `success`: 1 si `guess` coincide con el byte secreto, 0 si no.
- `cycles`: vacío en E2.
- `byte`: 0–39 para el secreto de 40 bytes.
- `guess`: 0–255.
- `train`: número de aciertos de entrenamiento por ataque.
- `score1`, `score2`: **conteos de aciertos** (0..attempts), no ciclos.
- `threshold`: umbral de E1 de esa máquina.

### E3 — sobrecoste

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,iterations,run,cycles_per_iteration,total_cycles
```

- `variant`: `baseline`, `lfence` o `mask`.
- `iterations`: iteraciones del bucle de coste.
- `run`: repetición (0..reps-1).
- `cycles_per_iteration`: `total_cycles / iterations`.
- `total_cycles`: ciclos totales del bucle.

### E3 — barrido de sensibilidad

```text
machine_id,session_id,timestamp,variant,flags,work_per_iter,predictability_mode,out_of_range_fraction,array_bytes,iterations,repetition,block_id,total_cycles,cycles_per_iter,seed,cpu_pinned
```

- `work_per_iter`: W dependiente del dato cargado.
- `predictability_mode`: `inrange` o `random_pX` (X = 1, 10, 50).
- `out_of_range_fraction`: fracción real de índices fuera de rango.
- `array_bytes`: tamaño del array de datos.
- `block_id` / `repetition`: bloque aleatorizado y repetición dentro del bloque.
- `cycles_per_iter = total_cycles / iterations`.
- `seed`: semilla de generación de índices y del orden de variantes.

El análisis del barrido es `analysis/plot_e3_sweep.py`; `analysis/plot_e3.py`
sigue leyendo solo el E3 antiguo. Cada script detecta la cabecera y no mezcla
formatos.

## Nombres

```text
e1_ryzen5pro5675u.csv
e2_ryzen5pro5675u_baseline.csv
e2_ryzen5pro5675u_lfence.csv
e2_ryzen5pro5675u_mask.csv
e3_ryzen5pro5675u_baseline.csv
```

El `machine_id` va en minúsculas y sin espacios. Si hay varias configuraciones
del mismo equipo, añade un sufijo claro (`_turbo`, `_noturbo`, etc.) y explícalo
en `docs/machines.md`.

## Reglas

- UTF-8, saltos de línea LF, separador coma y cabecera en la primera fila.
- No editar un CSV crudo a mano. Si hay que corregirlo, conserva el original y
  crea `*_fixed.csv` con una nota en el PR.
- No borrar ejecuciones negativas: un equipo que no filtra es un resultado.
- No mezclar en el mismo archivo `-O0` y `-O2`; usa el sufijo de flags.
- No mezclar VM y equipos nativos en la comparación principal; si se incluye una
  VM, que esté marcada.
- No subir binarios, `.o`, `perf.data` ni trazas pesadas.
- Si un CSV supera los 5 MB, pregunta antes de commitearlo.
- Los datos deben ser reproducibles: mismo código, mismas flags y el comando
  usado documentado en el PR o en `env_*.txt`.
- Los CSV se generan con los scripts; no se teclean a mano.
