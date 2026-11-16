# Datos

Los datos crudos y los CSV viven aquí. La política es simple: **se conservan, no
se editan a mano y se pueden regenerar las figuras desde ellos**.

## Estructura

```text
data/
  <machine_id>/
    env_<machine_id>.txt
    poc_<machine_id>.txt
    e1_<machine_id>.csv
    e2_<machine_id>_O2.csv
    e2_<machine_id>_O0.csv
    e3_<machine_id>_O2.csv
  derived/
```

- `machine_id` debe coincidir con la fila de [`docs/machines.md`](../docs/machines.md).
- `env_*.txt`: salida de `lscpu`, kernel, GCC, microcódigo y mitigaciones.
- `poc_*.txt`: salida de la prueba de viabilidad de Fase 0.
- `e1_*.csv`: latencias de caché.
- `e2_*.csv`: recuperación del secreto.
- `e3_*.csv`: eficacia y sobrecoste de las variantes.
- `derived/`: tablas agregadas generadas por `analysis/`; no se editan a mano.

## Esquema CSV

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles
```

- `variant`: `baseline`, `lfence` o `mask`.
- `success`: 1 si `guess` coincide con el byte secreto, 0 si no.
- `cycles`: solo en las filas de sobrecoste de E3; vacío en el resto.
- `byte`: 0–39 para el secreto de 40 bytes.
- `guess`: 0–255.
- `train`: número de aciertos de entrenamiento por ataque.
- `score1`, `score2`: puntuaciones medias por intento, en ciclos.
- `threshold`: umbral de E1 de esa máquina.

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

## Nombres

```text
e2_ryzen5pro5675u_O2.csv
e3_ryzen5pro5675u_O2.csv
e1_intel_i7_1165g7.csv
```

El `machine_id` va en minúsculas y sin espacios. Si hay varias configuraciones
del mismo equipo, añade un sufijo claro (`_turbo`, `_noturbo`, etc.) y explícalo
en `docs/machines.md`.
