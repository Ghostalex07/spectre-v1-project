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
  simulation/
    spectre_model.csv
  derived/
```

- `machine_id` debe coincidir con la fila de [`docs/machines.md`](../docs/machines.md).
- `env_*.txt`: salida de `lscpu`, kernel, GCC, microcódigo, mitigaciones y
  gobernador.
- `poc_*.txt`: salida de la prueba de viabilidad de Fase 0.
- `e1_*.csv`: latencias de caché.
- `e2_*.csv`: recuperación del secreto por variante. Es **validación opcional**
  de hardware; la explicación del mecanismo va en el modelo y en el análisis
  documental.
- `e3_*.csv`: sobrecoste por variante.
- `e3_order_<machine_id>.txt`: orden aleatorizado de las variantes de E3, para
  que la secuencia de medición quede registrada.
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

`data/ryzen5pro5675u/` contiene una **ejecución de referencia** hecha para
validar el harness, no la campaña final:

- E1: 10.000 muestras por modo, buffer de 64 MiB.
- E2: 40 bytes, 300 intentos, `train=5`, **1 run** (validación opcional).
- E3: 1.000.000 iteraciones, 3 repeticiones.

`data/ryzen5pro5675u_final/` contiene la **campaña final** de esa misma máquina,
con el protocolo completo:

- E1: 10.000 muestras por modo, buffer de 64 MiB.
- E2: 40 bytes, 1000 intentos, `train=5`, **50 runs** (validación opcional).
- E3: 10.000.000 iteraciones, **30 repeticiones**.

La simulación conceptual de referencia está en
`data/simulation/spectre_model.csv` y se regenera con `make simulate`. No es una
medida de hardware: sirve para explicar el mecanismo y comparar las variantes de
forma reproducible.

Es la misma microarquitectura que `ryzen5pro5675u`, así que sirve como campaña
completa de referencia, pero **no cuenta como una CPU distinta** para el
objetivo de 2–3 microarquitecturas. El archivo
`e2_ryzen5pro5675u_baseline_O0.csv` es un control `-O0` de 1 byte; no se mezcla
con la campaña `-O2` en las figuras. La campaña final de cada compañero debe
usar los valores del protocolo y quedar identificada con su propio
`machine_id`.

## Esquemas CSV

### E1

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,mode,sample,cycles
```

- `mode`: `hit` o `miss`.
- `sample`: índice de muestra.
- `cycles`: latencia medida con `rdtscp`.

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
