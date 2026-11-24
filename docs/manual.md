# Manual del harness

Este documento explica cómo ejecutar el proyecto de principio a fin **sin
depender de ninguna IA ni de conversaciones privadas**. Está pensado para que
cualquier integrante pueda clonar el repositorio, medir en su máquina y generar
resultados reproducibles.

Si algo falla, consulta [`troubleshooting.md`](troubleshooting.md). Si tu caso no
está ahí, abre un issue con el comando, la salida y tu `machine_id`.

> **Foco experimental (feedback del profesor):** E1 (caché) y E3 (sobrecoste)
> son la experimentación principal. E2 se cubre con análisis documental y
> simulación conceptual en [`simulation.md`](simulation.md); la PoC en hardware
> es opcional y se reporta como anexo.

## 1. Qué necesitas

- Linux x86-64 **nativo** para las medidas principales.
- `gcc`, `make`, `python3`, `unzip`, `taskset` y `objdump`.
- `matplotlib` para las figuras:
  ```bash
  python3 -m pip install -r analysis/requirements.txt
  ```
- Un núcleo físico libre. El harness intenta fijar el proceso al primer CPU
  permitido; puedes forzarlo con `PIN_CPU=<n>`.
- No hace falta `sudo`, ni cambiar el kernel, ni desactivar mitigaciones.

## 2. Mapa del repositorio

| Ruta | Qué contiene |
|---|---|
| `PLAN.md` | Plan, fases, protocolo, cronograma y criterios de aceptación |
| `README.md` | Resumen y inicio rápido |
| `CONTRIBUTING.md` | Flujo de trabajo, roles y definición de “hecho” |
| `docs/onboarding.md` | Primeros pasos de Fase 0 |
| `docs/campaign.md` | Campaña final: qué hace cada integrante en su máquina |
| `docs/manual.md` | Este manual |
| `docs/simulation.md` | Modelo conceptual de E2 y sus límites |
| `docs/metrics.md` | Definiciones de métricas y esquemas CSV |
| `docs/thresholds.md` | Umbral de cada máquina y `margin_min` |
| `docs/troubleshooting.md` | Errores típicos y cómo resolverlos |
| `docs/glossary.md` | Glosario de términos |
| `docs/report-guide.md` | Guía del informe |
| `docs/defense-guide.md` | Guía de la defensa y demo |
| `src/common.h` | `rdtscp`, `clflush`, barreras, lectura de CPU, CSV |
| `src/spectre.h` | Arrays víctima, secreto y las tres variantes |
| `src/e1_cache.c` | Experimento E1 |
| `src/e2_spectre.c` | Experimento E2 (opcional, hardware) |
| `src/e3_mitigations.c` | Experimento E3 (sobrecoste) |
| `scripts/` | Envoltorios reproducibles para ejecutar cada experimento |
| `analysis/` | Figuras, comparación, simulación conceptual y agregados |
| `analysis/simulate_spectre.py` | Modelo conceptual de E2, sin hardware |
| `tests/` | Tests de comparación y simulación |
| `data/<machine_id>/` | Datos crudos por máquina |
| `figures/` | Figuras generadas |
| `references/` | Paper, PoC y material de consulta |

## 3. Inicio rápido (10 minutos)

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project

make
make smoke
make test

./scripts/collect_env.sh <machine_id>
./scripts/run_e1.sh <machine_id> 10000 64
python3 analysis/plot_e1.py --machine-id <machine_id>
```

Mira el histograma y el “umbral sugerido”. Anótalo en
[`docs/thresholds.md`](thresholds.md). Después, para la campaña principal:

```bash
THRESHOLD=<T> RUN_E2=0 ./scripts/run_all.sh <machine_id> <T>
python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>
```

`run_all.sh` ejecuta el entorno, E1 y las tres variantes de E3. E2 en hardware
está **omitido por defecto** (`RUN_E2=0`) porque el mecanismo se cubre con el
modelo conceptual. Si quieres validarlo en tu CPU:

```bash
RUN_E2=1 THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
python3 analysis/plot_e2.py --machine-id <machine_id>
```

Tarda varios minutos; no lo lances en una VM para los resultados principales.

## 4. Fase 0: ficha del equipo

Antes de medir, guarda el entorno:

```bash
./scripts/collect_env.sh <machine_id>
```

Genera `data/<machine_id>/env_<machine_id>.txt` con `lscpu`, familia, modelo,
stepping, microcódigo, kernel, GCC, virtualización, gobernador y mitigaciones.
Rellena tu fila en [`docs/machines.md`](machines.md).

**Si `systemd-detect-virt` no devuelve `none`, es una VM o un contenedor.** Se
puede usar para probar el harness, pero se excluye de la comparación principal.

### Prueba de viabilidad del PoC

El PoC original está en `references/spectre.c.zip`. Trae `_mm_lfence()` activo
dentro de `victim_function`; para la versión base hay que quitarlo.

```bash
mkdir -p /tmp/spectre-poc
unzip -o references/spectre.c.zip -d /tmp/spectre-poc
POC="$(find /tmp/spectre-poc -name spectre.c | head -n1)"
echo "$POC"
grep -n "_mm_lfence" "$POC"
```

Abre ese `spectre.c` y elimina la llamada `_mm_lfence()` de `victim_function`.
Compila y revisa el ensamblador:

```bash
gcc -O2 -fno-if-conversion -fno-if-conversion2 \
  -o /tmp/spectre-poc/spectre "$POC"
objdump -d -Mintel /tmp/spectre-poc/spectre | awk '/<victim_function>:/,/^$/'
```

Debe quedar un salto condicional real (`cmp` + `jbe`/`jae`), no un `cmov`.
Ejecuta fijado a un núcleo y guarda la salida:

```bash
taskset -c 0 /tmp/spectre-poc/spectre | tee data/<machine_id>/poc_<machine_id>.txt
```

Si recupera el secreto, es evidencia opcional para el anexo de E2; E1 y E3 no
dependen de ello. Si no lo recupera, documenta el resultado: no es bloqueante y
no fuerces el PoC.

## 5. E1: latencia de caché

E1 mide cuántos ciclos tarda un acceso cuando la línea está en caché (`hit`) y
cuando se ha expulsado (`miss`). Sirve para elegir el umbral de E2 (si se
ejecuta).

```bash
./scripts/run_e1.sh <machine_id> 10000 64
```

Parámetros:

| Argumento | Defecto | Qué hace |
|---|---:|---|
| `machine_id` | — | Identificador de la máquina |
| `samples` | 10000 | Muestras por modo (`hit` y `miss`) |
| `buffer_mb` | 64 | Tamaño del buffer; debe superar la caché |
| `out_dir` | `data/<machine_id>` | Carpeta de salida |

Salida: `data/<machine_id>/e1_<machine_id>.csv` con
`mode,sample,cycles`.

Genera el histograma:

```bash
python3 analysis/plot_e1.py --machine-id <machine_id>
```

El script imprime mediana, p5 y p95 de cada modo, y sugiere un umbral en el
valle. **No copies el 80 de otra máquina**: en el Ryzen de referencia funciona
porque `hit` está en ~46 ciclos y `miss` por encima de ~230, pero cada CPU
necesita su propio valle. Calibra siempre con tu E1.

Anota el umbral en [`docs/thresholds.md`](thresholds.md). E2, si se ejecuta,
debe usar ese valor para esa máquina; E3 no depende del umbral.

## 6. E2 (opcional): validación en hardware

El mecanismo de E2 se cubre con el modelo conceptual de
[`simulation.md`](simulation.md). Esta sección solo aplica si quieres validarlo
en tu CPU; no es necesaria para la campaña principal.

E2 ejecuta el ataque de Spectre V1 y, para cada byte, elige el candidato con más
aciertos de caché. El secreto de prueba es:

```text
Spectre V1 test secret 0123456789ABCDEF!
```

(40 bytes; el harness lo copia en `.rodata`.)

```bash
THRESHOLD=<T> ./scripts/run_e2.sh <machine_id> baseline <T> 1000 5 50 40
```

Parámetros:

| Argumento | Defecto | Qué hace |
|---|---:|---|
| `machine_id` | — | Identificador de la máquina |
| `variant` | — | `baseline`, `lfence` o `mask` |
| `threshold` | — | Umbral de E1; obligatorio |
| `attempts` | 1000 | Intentos por byte; fijo para comparar |
| `train` | 5 | Aciertos de entrenamiento por ataque |
| `runs` | 50 | Repeticiones completas del secreto |
| `bytes` | 40 | Bytes a recuperar (máximo 40) |

Variables de entorno equivalentes: `THRESHOLD`, `ATTEMPTS`, `TRAIN`, `RUNS`,
`BYTES`, `OPT=O2|O0`, `PIN_CPU`.

Salida: `data/<machine_id>/e2_<machine_id>_<variant>.csv`. Columnas relevantes:

- `guess`: byte elegido.
- `score1`: aciertos del mejor candidato (0..attempts).
- `score2`: aciertos del segundo candidato distinto.
- `success`: 1 si `guess` es el byte correcto.
- `cycles`: vacío en E2.

### Variantes

- `baseline`: `if (x < array1_size) temp &= array2[array1[x] * 512];`
  Debe filtrar si la microarquitectura es vulnerable y el umbral/entrenamiento
  son correctos.
- `lfence`: añade `_mm_lfence()` después de la comprobación y antes del acceso.
  Debe bloquear la fuga.
- `mask`: `mask = -(size_t)(x < array1_size); idx = x & mask;` y acceso con
  `idx`. No debe haber salto dependiente del dato. Debe bloquear la fuga.

### Control a `-O0`

Para comprobar que el compilador no ha eliminado la vulnerabilidad:

```bash
OPT=O0 THRESHOLD=<T> ./scripts/run_e2.sh <machine_id> baseline <T> 1000 5 50 40
```

Salida: `e2_<machine_id>_baseline_O0.csv`. No entra en la comparación principal;
sirve para diagnosticar.

### Revisar el ensamblador

```bash
objdump -d -Mintel bin/e2_baseline | awk '/<victim_function>:/,/^$/'
objdump -d -Mintel bin/e2_mask     | awk '/<victim_function>:/,/^$/'
objdump -d -Mintel bin/e2_lfence   | awk '/<victim_function>:/,/^$/'
```

Qué buscar:

- `baseline`: `cmp` + salto condicional (`jbe`, `jae`, etc.), no `cmov`.
- `mask`: `cmp` + `and` (o `sbb`), **sin** salto condicional en la función
  vulnerable.
- `lfence`: `lfence` entre la comprobación y el acceso.

Si el compilador genera `cmov` en `baseline`, revisa que se compiló con
`-fno-if-conversion -fno-if-conversion2`. Si `mask` genera un salto, revisa el
código o usa una secuencia `cmp`/`sbb` en ensamblador y vuelve a verificar.

### Barrido de entrenamiento

Para ver cómo influye el predictor:

```bash
for t in 2 4 5 6 8 10; do
  mid="${machine_id}_train${t}"
  TRAIN=$t THRESHOLD=<T> ./scripts/run_e2.sh "$mid" baseline <T> 1000 "$t" 10 1
done
```

Cada valor de `train` usa un `machine_id` auxiliar y escribe en su propio
`data/<machine_id>_train<t>/`, así no sobrescribe la campaña principal. Estos
CSV son un diagnóstico del predictor, no la campaña final. Lo importante es
reportar la tasa por `train`, no solo el mejor valor.

### Interpretación

- `success=1` y `score1` cerca de `attempts`: recuperación clara.
- `success=0` y `margin` alto: candidato claro pero erróneo; el ataque no
  funciona en esa configuración.
- `margin` bajo: candidato “unclear”; no lo cuentes como recuperación clara.
- Un `0/N` no demuestra imposibilidad; reporta `N` y una cota `3/N`.

## 7. E3: mitigaciones y sobrecoste

E3 mide el coste del bucle vulnerable con cada variante. La eficacia se toma de
los CSV de E2; no se repite el ataque en E3.

```bash
./scripts/run_e3.sh <machine_id> baseline 10000000 30
./scripts/run_e3.sh <machine_id> lfence   10000000 30
./scripts/run_e3.sh <machine_id> mask     10000000 30
```

Parámetros:

| Argumento | Defecto | Qué hace |
|---|---:|---|
| `machine_id` | — | Identificador |
| `variant` | — | `baseline`, `lfence` o `mask` |
| `iterations` | 10000000 | Iteraciones del bucle |
| `reps` | 30 | Repeticiones |
| `out_dir` | `data/<machine_id>` | Carpeta de salida |

Salida: `data/<machine_id>/e3_<machine_id>_<variant>.csv` con
`cycles_per_iteration` y `total_cycles`.

Análisis:

```bash
python3 analysis/plot_e3.py --machine-id <machine_id>
```

Genera:

- `figures/e3_<machine>_overhead.png`: mediana y rango p5–p95 por variante.
- `figures/e3_<machine>_scatter.png`: eficacia (E2) frente a sobrecoste (E3).

Métricas:

```text
overhead_abs = mediana(variante) - mediana(baseline)
overhead_pct = 100 * overhead_abs / mediana(baseline)
slowdown     = mediana(variante) / mediana(baseline)
```

## 8. Campaña completa en una máquina

Si ya tienes el umbral, la campaña principal es E1 + E3:

```bash
THRESHOLD=<T> RUN_E2=0 ./scripts/run_all.sh <machine_id> <T>
```

Hace, en orden:

1. `collect_env.sh`
2. `run_e1.sh` (10.000 muestras, 64 MiB)
3. E3 `baseline`, `lfence`, `mask` (10M iteraciones, 30 reps)
4. E2 solo si `RUN_E2=1` (1000 intentos, train 5, 50 runs, 40 bytes)

Control `-O0` opcional de E2:

```bash
RUN_E2=1 RUN_O0=1 THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

Para una campaña más rápida de prueba, reduce los valores:

```bash
RUN_E2=0 ITERATIONS=1000000 REPS=3 \
  THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

No presentes esos valores reducidos como campaña final. La campaña final usa
los valores del protocolo y se identifica como tal.

## 9. Análisis y figuras

```bash
# Experimentación principal
python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>

# Modelo conceptual de E2
python3 analysis/simulate_spectre.py \
  --attempts 200 --train 5 \
  --out data/simulation/spectre_model.csv \
  --figure figures/simulation_spectre.png

# Opcional: si ejecutaste E2 en hardware
python3 analysis/plot_e2.py --machine-id <machine_id>

# Comparación entre máquinas
python3 analysis/compare_machines.py
```

Las figuras van a `figures/`. Los scripts imprimen tablas con tasas, intervalos
de Wilson, `unclear` y sobrecoste. `plot_e2.py` excluye por defecto los CSV
`-O0` para no mezclarlos con la campaña principal. `plot_e3.py` funciona sin
E2: en ese caso solo genera la figura de sobrecoste. No edites las figuras a
mano: si cambias el análisis, vuelve a generarlas.

`compare_machines.py` recorre `data/<machine_id>/`, escribe la tabla agregada
`data/derived/compare_machines.csv` y genera `figures/compare_success.png`,
`figures/compare_overhead.png` y `figures/compare_scatter.png`. Si solo hay una
microarquitectura, la comparación sirve para validar el pipeline, no para
afirmar diversidad de CPUs.

## 10. Datos

- Los CSV van en `data/<machine_id>/`.
- No se editan a mano.
- No se borran ejecuciones negativas.
- No se mezclan `-O0` y `-O2` en el mismo archivo.
- No se suben binarios, `.o`, `perf.data` ni trazas pesadas.
- Si un CSV supera 5 MB, pregunta antes de commitearlo.

Detalles en [`data/README.md`](../data/README.md).

## 11. Checklist de reproducibilidad

Antes de decir “he medido”:

- [ ] `make` compila sin errores.
- [ ] `make smoke` pasa.
- [ ] `make test` pasa.
- [ ] `env_<machine_id>.txt` guardado.
- [ ] Fila en `docs/machines.md`.
- [ ] Umbral de E1 anotado en `docs/thresholds.md`.
- [ ] E2 con `attempts` fijo y `threshold` documentado (solo si se ejecuta).
- [ ] Ensamblador de `baseline`, `lfence` y `mask` revisado en E3.
- [ ] E3 con 10M iteraciones y 30 reps (campaña final).
- [ ] Modelo conceptual generado (`data/simulation/spectre_model.csv`).
- [ ] Figuras de E1/E3 y simulación generadas desde los datos.
- [ ] `git status` sin archivos no intencionados.
- [ ] Resultados negativos documentados, no borrados.

## 12. Añadir una máquina

1. Ejecuta `./scripts/collect_env.sh <machine_id>`.
2. Rellena `docs/machines.md`.
3. Ejecuta E1 y elige el umbral; anótalo en `docs/thresholds.md`.
4. Ejecuta `RUN_E2=0 ./scripts/run_all.sh <machine_id> <T>` con ese umbral
   (añade `RUN_E2=1` solo si vas a validar E2 en hardware).
5. Genera las figuras.
6. Añade una nota si es VM, contenedor, portátil con turbo variable o una
   configuración especial.
7. Abre un PR con los CSV, la ficha y las figuras. No mezcles datos de varias
   máquinas en un solo CSV.

## 13. Resultados negativos

Un equipo que no filtra es un resultado, no un fracaso. Documenta:

- `machine_id`, CPU, familia/modelo/stepping, microcódigo, kernel, GCC.
- Umbral probado y por qué.
- `train` probado.
- `attempts` y `runs`.
- `score1`, `score2`, `margin` y tasa `unclear`.
- Si a `-O0` filtra y a `-O2` no.
- Si el ensamblador tiene el salto esperado.

No cambies el umbral ni el número de intentos después de ver el resultado para
“arreglarlo”. Si lo haces, documenta el cambio y repite la medida.

## 14. Dónde tocar el código

- `src/common.h`: medidas, CPU, CSV. Cambios aquí afectan a todos.
- `src/spectre.h`: arrays, secreto y variantes. Si cambias la función
  vulnerable, revisa el ensamblador y vuelve a ejecutar E2/E3.
- `src/e1_cache.c`: protocolo de E1.
- `src/e2_spectre.c`: ataque, intentos, selección de `x`, medida de líneas.
- `src/e3_mitigations.c`: bucle de coste.
- `scripts/`: envoltorios; no dupliques lógica del C.
- `analysis/`: solo lectura de CSV y figuras.

## 15. Resultados de referencia (Ryzen 5 PRO 5675U)

Estos valores son de la ejecución de referencia del repositorio, no de la
campaña final. Sirven para comprobar que el harness funciona.

Entorno: AMD Ryzen 5 PRO 5675U (Cezanne, Zen 3), family 25, model 80, stepping 0,
microcódigo `0xa500014`, 6C/12T, Ubuntu 22.04, kernel 6.8.0-149, GCC 11.4.

E1 (10.000 muestras, buffer 64 MiB):

```text
hit:  mediana 46 ciclos, p5 23, p95 46
miss: mediana 276 ciclos, p5 230, p95 690
umbral sugerido por el análisis: 138
umbral usado en E2: 80 (ambos separan los dos modos)
```

E2 conceptual (modelo, 200 intentos, train 5, 40 bytes):

```text
baseline: 40/40 bytes correctos (modelo)
lfence:    0/40 bytes correctos (modelo)
mask:      0/40 bytes correctos (modelo)
```

E2 en hardware (opcional; 300 intentos, train 5, 1 run, 40 bytes, threshold 80):

```text
baseline: 40/40 bytes correctos
lfence:    0/40
mask:      0/40
```

E3 (1M iteraciones, 3 reps):

```text
baseline: 3.33 ciclos/iteración
lfence:  13.52 ciclos/iteración  (~4.06x, +306 %)
mask:     3.68 ciclos/iteración  (~1.11x, +10.7 %)
```

Con 300 intentos y 1M iteraciones los números son orientativos.

Campaña final de la misma máquina (`ryzen5pro5675u_final`, 50 runs y 30 reps):

```text
E2 (opcional): baseline 2000/2000 byte-intentos (40/40 por run)
               lfence 0/2000; mask 0/2000
E3: baseline 3.34 ciclos/iteración
    lfence  13.40 ciclos/iteración  (~4.01x, +300.6 %)
    mask     3.39 ciclos/iteración  (~1.01x, +1.3 %)
```

Es la misma microarquitectura que la referencia; no sustituye a una segunda CPU
en la comparación. Los `0/2000` son “no observado”, no prueba de imposibilidad.

## 16. Seguridad y alcance

- Todo se ejecuta en tu propia máquina y en un proceso propio.
- No ataques máquinas de terceros.
- No uses `sudo` ni desactives mitigaciones.
- No amplíes el alcance a Meltdown, otras variantes, kernel o cross-process.
- No subas secretos, datos personales ni binarios grandes.
- No inventes ni maquilles resultados.

## 17. Dónde preguntar

- Abre un issue con `machine_id`, comando, salida y qué esperabas.
- Si el problema es de una medición, adjunta el CSV relevante (si no es enorme)
  y el `env_<machine_id>.txt`.
- Si el problema es de interpretación, enlaza la sección de
  [`metrics.md`](metrics.md) que no encaja.
