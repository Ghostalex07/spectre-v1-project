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
| `src/e1_cache.c` | E1 de calibración (hit/miss) |
| `src/e1_hierarchy.c` | E1 jerárquico (pointer chasing y mesetas) |
| `src/e1_timer.c` | Coste del temporizador `rdtscp` |
| `src/e2_spectre.c` | PoC histórica de E2; no forma parte de la experimentación |
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

./scripts/run_e1_hierarchy.sh <machine_id>
./scripts/run_e1_timer.sh <machine_id>
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
```

Mira el histograma y el “umbral sugerido”. Anótalo en
[`docs/thresholds.md`](thresholds.md). Después, para la campaña principal:

```bash
SESSION_ID="$(date +%Y%m%d-%H%M%S)" THRESHOLD=<T> \
  ./scripts/run_all.sh <machine_id> <T>
python3 analysis/plot_e1.py --machine-id <machine_id> --session-id <session_id>
python3 analysis/plot_e3_sweep.py --machine-id <machine_id> --session-id <session_id>
```

`run_all.sh` ejecuta el entorno, E1 (calibración, jerarquía y temporizador) y el
barrido de E3. E2 en hardware **no forma parte de la campaña**; el mecanismo se
cubre con el modelo conceptual y la PoC queda como anexo ilustrativo,
subordinado al modelo y a la literatura.

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

Si recupera el secreto, es una observación cualitativa para el anexo ilustrativo
de E2; E1 y E3 no dependen de ello. Si no lo recupera, documenta el resultado:
no es bloqueante y no fuerces el PoC.

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

El script imprime mediana, IC95 bootstrap de la mediana, p5 y p95 de cada modo,
y sugiere un umbral en el valle. El IC indica la precisión de la mediana; p5–p95
indica la dispersión de las muestras. **No copies el 80 de otra máquina**: en el Ryzen de referencia funciona
porque `hit` está en ~46 ciclos y `miss` por encima de ~230, pero cada CPU
necesita su propio valle. Calibra siempre con tu E1.

Anota el umbral en [`docs/thresholds.md`](thresholds.md). E2, si se ejecuta,
debe usar ese valor para esa máquina; E3 no depende del umbral.

### E1 jerárquico: mesetas de caché

E1 jerárquico barre tamaños de working set y mide la latencia de pointer
chasing. Sirve para localizar las mesetas de L1d, L2, L3 y memoria, y para
cruzar la calibración con la jerarquía real.

```bash
./scripts/run_e1_hierarchy.sh <machine_id>
```

Parámetros (variables de entorno, no posicionales):

| Variable | Defecto | Qué hace |
|---|---:|---|
| `PROFILE` | `default` | `default` (barrido completo) o `smoke` (corto) |
| `SIZES` | barrido 4 KiB–256 MiB | Lista de tamaños en bytes (`4096,6144,8192,...`); admite `K/M/G` |
| `HOPS` | 1000000 | Cargas medidas por repetición |
| `REPS` | 30 | Repeticiones por tamaño |
| `WARMUP` | 1 | Pasadas completas de calentamiento antes de medir |
| `NODE_SIZE` | 64 | Tamaño de nodo; debe ser múltiplo de 64 |
| `HUGEPAGE` | 0 | `1` pide `MADV_HUGEPAGE` (sin privilegios) |
| `SESSION_ID` | vacío | Si existe, escribe en `data/<machine_id>/<session_id>/` |
| `PIN_CPU` | auto | CPU forzada con `taskset` |

El barrido por defecto incluye potencias de dos y puntos `1,5·2^k`. El binario
usa Sattolo (un único ciclo) y guarda la semilla. El calentamiento recorre el
ciclo completo antes de cada repetición. La salida es
`e1_hierarchy_<machine_id>.csv` dentro de la carpeta de sesión o de la máquina.

Perfil smoke:

```bash
PROFILE=smoke HOPS=20000 REPS=3 \
  ./scripts/run_e1_hierarchy.sh <machine_id>
```

Figura y tabla de mesetas:

```bash
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
# varias máquinas:
python3 analysis/plot_e1_hierarchy.py \
  --machine-id cpu_a --machine-id cpu_b
```

Genera `figures/e1_hierarchy_<machine_id>.png` (eje X logarítmico, mediana,
banda p5–p95 e IQR, líneas verticales L1d/L2/L3 si están en la ficha),
`data/derived/e1_hierarchy_plateaus.csv` y
`report/e1_hierarchy_plateaus.md`. El criterio de meseta (25 %–75 % de la
capacidad) está en [`metrics.md`](metrics.md).

### Coste del temporizador

```bash
./scripts/run_e1_timer.sh <machine_id>
```

Variables: `PROFILE` (`default`/`smoke`), `SAMPLES` (100000), `REPS` (3),
`WARMUP` (1000), `SESSION_ID`, `PIN_CPU`. Genera
`e1_timer_<machine_id>.csv` con la distribución del intervalo vacío
`lfence;rdtscp;lfence;rdtscp`.

`plot_e1.py` incorpora esa distribución si encuentra el CSV y genera
`figures/e1_<machine_id>_timer.png`. **No se resta** de las latencias: se muestra
para juzgar el peso del montaje en los tamaños pequeños.

## 6. E2: modelo conceptual

La PoC de E2 en hardware no forma parte de la experimentación principal. El
mecanismo se cubre con el análisis documental y el modelo conceptual de
[`simulation.md`](simulation.md). La PoC se conserva como **anexo ilustrativo**,
subordinado al modelo y a la literatura; no es un resultado.

No hay instrucciones de campaña de E2 en este manual. Para el estado del
anexo, consulta [`e2-anexo.md`](e2-anexo.md).

## 7. E3: mitigaciones y sobrecoste

E3 mide el coste del chequeo de límites con cada variante. La eficacia de
seguridad se toma del modelo conceptual y de la literatura; no se repite el
ataque en E3.

### 7.1 Barrido de sensibilidad (recomendado)

```bash
# Perfil por defecto: W 0..64, inrange/random_p1/p10/p50, 4 KiB y 64 MiB.
./scripts/run_e3.sh <machine_id>
# o explícitamente
./scripts/run_e3.sh <machine_id> sweep

# Perfil corto para validar el harness
PROFILE=smoke ./scripts/run_e3.sh <machine_id> sweep
```

Salida: `data/<machine_id>/<session_id>/e3_sweep_<machine_id>_<session_id>.csv`
si hay `SESSION_ID`; si no, `data/<machine_id>/e3_sweep_<machine_id>_manual.csv`.
Las tres variantes van en el mismo CSV y se intercalan por bloques.

Parámetros configurables (variables de entorno):

| Variable | Defecto (default) | Qué hace |
|---|---:|---|
| `E3_WORK` | `0,1,2,4,8,16,32,64` | Valores de W |
| `E3_PREDICTABILITY` | `inrange,random_p1,random_p10,random_p50` | Modos |
| `E3_ARRAY_BYTES` | `4096,67108864` | Tamaños de array |
| `E3_ITERATIONS` | 200000 | Iteraciones por medida |
| `E3_BLOCKS` | 5 | Bloques aleatorizados |
| `E3_REPS` | 3 | Repeticiones por bloque |
| `E3_WARMUP` | 256 | Llamadas de calentamiento |
| `E3_SEED` | 20261124 | Semilla de índices y orden |
| `PROFILE` | `default` | `default` o `smoke` |

El perfil `smoke` usa W 0/8, `inrange/random_p50`, arrays de 4 KiB y 32 MiB,
2.000 iteraciones, 2 bloques y 1 repetición. `make smoke` valida la cabecera y
el número de filas de E1/E3; la PoC de E2 hardware solo se ejecuta si
`RUN_E2=1`.

### 7.2 Modo antiguo (una variante)

Se mantiene para reproducir datos anteriores:

```bash
./scripts/run_e3.sh <machine_id> baseline 10000000 30
./scripts/run_e3.sh <machine_id> lfence   10000000 30
./scripts/run_e3.sh <machine_id> mask     10000000 30
```

Salida: `data/<machine_id>/e3_<machine_id>_<variant>.csv` con
`cycles_per_iteration` y `total_cycles`. No se mezcla con el barrido.

### 7.3 Análisis

```bash
# Barrido nuevo
python3 analysis/plot_e3_sweep.py --machine-id <machine_id>
# Repetir --machine-id para superponer varias máquinas en la figura

# E3 antiguo (sigue funcionando)
python3 analysis/plot_e3.py --machine-id <machine_id>
```

El barrido genera:

- `figures/e3_sweep_<machine>_overhead_vs_work.png`: sobrecoste frente a W,
  con bandas IC95 por predictibilidad y tamaño.
- `figures/e3_sweep_overlay.png`: superposición multi-máquina.
- `data/derived/e3_sweep_overhead.csv` y `report/e3_sweep_overhead.md`.

El IC se calcula remuestreando **bloques completos** (emparejado), no filas
sueltas. Fórmulas en [`metrics.md`](metrics.md).

### 7.4 Verificación del ensamblador

```bash
make asm
python3 -m unittest discover -s tests -p 'test_e3_asm.py' -v
```

Genera `docs/asm/` y comprueba que `baseline` conserva el salto condicional y
no usa `cmov`, que `lfence` contiene `lfence` y que `mask` no contiene `lfence`.
Si falla, no se usan esos datos: se documenta y se corrige.

## 8. Campaña completa en una máquina

Si ya tienes el umbral, la campaña principal es E1 + E3:

```bash
SESSION_ID="$(date +%Y%m%d-%H%M%S)" THRESHOLD=<T> \
  ./scripts/run_all.sh <machine_id> <T>
```

Hace, en orden:

1. `collect_env.sh`
2. `run_e1.sh` (10.000 muestras, 64 MiB)
3. `run_e1_hierarchy.sh` (barrido 4 KiB–256 MiB, 30 reps)
4. `run_e1_timer.sh` (100.000 muestras × 3 reps)
5. E3 barrido de sensibilidad (`PROFILE=default`), con variantes
   `baseline`, `lfence` y `mask` intercaladas por bloques
6. E2 **no se ejecuta**: la PoC no forma parte de la campaña

La ficha de entorno, E1 de calibración, E1 jerárquico, el temporizador y el CSV
del barrido E3 se guardan en `data/<machine_id>/<session_id>/`. Si no defines
`SESSION_ID`, `run_all.sh` crea una con la fecha UTC. Haz al menos dos sesiones
en arranques distintos.

Duración orientativa: el perfil `smoke` termina en segundos; el perfil `default`
puede tardar decenas de minutos por sesión, según la CPU y el número de
repeticiones.

Perfil rápido de prueba (no es campaña final):

```bash
PROFILE=smoke THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

El perfil smoke reduce tamaños, hops, repeticiones y muestras del temporizador.
No presentes esos valores como campaña final. El modo `E3_MODE=legacy` conserva
el bucle antiguo para comparar con datos históricos.

## 9. Análisis y figuras

```bash
# Experimentación principal
python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>

# Modelo conceptual de E2
python3 analysis/simulate_spectre.py \
  --attempts 200 --train 5 \
  --out data/simulation/spectre_model.csv \
  --figure figures/simulation_spectre.png

# E1 jerárquico y coste del temporizador
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
python3 analysis/plot_e1.py --machine-id <machine_id>

# E3 barrido de sensibilidad
python3 analysis/plot_e3_sweep.py --machine-id <machine_id>

# Comparación entre máquinas
python3 analysis/compare_machines.py
```

Las figuras van a `figures/`. `plot_e1_hierarchy.py` genera la curva de
latencia por tamaño, las bandas y la tabla de mesetas. `plot_e3_sweep.py` genera
las curvas de sobrecoste frente a W y la tabla con IC por bloques. No edites las
figuras a mano: si cambias el análisis, vuelve a generarlas con `make figures`.

`compare_machines.py` recorre `data/<machine_id>/`, escribe la tabla agregada
`data/derived/compare_machines.csv` (incluye IC95 bootstrap de las medianas en
columnas `*_median_low/high` y los IC de Wilson de E2). Por defecto genera solo
`figures/compare_overhead.png`; con `--with-e2` añade `compare_success.png` y
`compare_scatter.png` como material de anexo.

Para regenerar la tabla y el resumen del informe de una vez:

```bash
make summary
```

Eso deja `report/results_summary.md` con tablas de equipos, E1 y E3 listas para
copiar al informe. E2 se añade solo con `make summary-e2` (o
`python3 analysis/summarize_results.py --include-e2-hardware`) y es material de
anexo. El
resumen es descriptivo: la discusión y los límites van en el texto. Si solo hay
una microarquitectura, la comparación sirve para validar el pipeline, no para
afirmar diversidad de CPUs.

## 10. Datos

- Los CSV van en `data/<machine_id>/` (estructura antigua) o en
  `data/<machine_id>/<session_id>/` (campañas nuevas).
- E1 de calibración, E1 jerárquico y el temporizador pueden convivir en la
  misma sesión; los análisis buscan primero la sesión indicada y, si no, la
  estructura antigua.
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
- [ ] E1 jerárquico ejecutado (barrido 4 KiB–256 MiB, 30 reps) y figura generada.
- [ ] Distribución del temporizador generada y comparada con la meseta L1d.
- [ ] Tabla de mesetas (`data/derived/e1_hierarchy_plateaus.csv`) revisada.
- [ ] E2 con `attempts` fijo y `threshold` documentado (solo si se ejecuta).
- [ ] Ensamblador de `baseline`, `lfence` y `mask` revisado en E3.
- [ ] E1 jerárquico con al menos dos sesiones y mesetas calculadas.
- [ ] E3 con el barrido de sensibilidad (`PROFILE=default`) y `make asm` OK.
- [ ] Modelo conceptual generado (`data/simulation/spectre_model.csv`).
- [ ] Figuras de E1/E3 y simulación generadas desde los datos.
- [ ] `git status` sin archivos no intencionados.
- [ ] Resultados negativos documentados, no borrados.

## 12. Añadir una máquina

1. Ejecuta `./scripts/collect_env.sh <machine_id>`.
2. Rellena `docs/machines.md`.
3. Ejecuta E1 y elige el umbral; anótalo en `docs/thresholds.md`.
4. Ejecuta `./scripts/run_all.sh <machine_id> <T>` con ese umbral, al menos en
   dos sesiones y arranques distintos.
5. Genera las figuras con `make figures`.
6. Añade una nota si es VM, contenedor, portátil con turbo variable o una
   configuración especial.
7. Abre un PR con los CSV, la ficha, los `session_id` y las figuras. No mezcles
   datos de varias máquinas en un solo CSV.

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

La PoC de E2 en hardware no forma parte de los resultados principales. Se
conserva como anexo ilustrativo, subordinado al modelo y a la literatura; ver
[`e2-anexo.md`](e2-anexo.md).

E3 (1M iteraciones, 3 reps):

```text
baseline: 3.33 ciclos/iteración
lfence:  13.52 ciclos/iteración  (~4.06x, +306 %)
mask:     3.68 ciclos/iteración  (~1.11x, +10.7 %)
```

Con 300 intentos y 1M iteraciones los números son orientativos.

Los E3 de 1M/3 repeticiones y de 30 repeticiones (`ryzen5pro5675u_final`)
corresponden a la **metodología antigua** y se conservan solo como comprobación
cruzada legacy. La campaña nueva usa el barrido E3 y las dos sesiones de
`data/ryzen5pro5675u/`; sus resultados están en el `README.md` y en
`report/results_summary.md`. `_final` no se usa en la comparación principal.
Los resultados de E2 en hardware no se incluyen como resultado: ver
[`e2-anexo.md`](e2-anexo.md).

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
