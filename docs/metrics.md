# Métricas y análisis

Este documento fija las definiciones **antes** de medir. Si hay que cambiar una,
se anota la razón y se aplica a todas las máquinas; no se cambia después de ver
los resultados para que el resultado quede mejor.

## Notación

- `B` = bytes del secreto de prueba (40).
- `R` = repeticiones (runs) por configuración.
- `A` = intentos (attempts) por byte en E2.
- `C` = candidatos posibles (256 valores de byte).
- `score[c]` = **número de aciertos de caché** observados para el candidato `c`
  en los `A` intentos. **Mayor es mejor.**
- `train` = número de aciertos de entrenamiento por ataque.
- `run` = índice de repetición (0..R-1).
- `margin_min` = margen mínimo de aciertos para considerar que un byte tiene un
  candidato claro.

El secreto es sintético y público para el experimento. No se usan datos
personales ni secretos reales.

## Tipos de evidencia

- **Empírica:** E1 y E3, medidas en hardware con CSV y repeticiones.
- **Conceptual:** E2, modelo explícito de predictor/caché; explica el mecanismo,
  no demuestra el comportamiento de una CPU concreta.
- **Documental:** paper, PoC, ensamblador y documentación de AMD/Intel.

No mezcles las tres en una misma afirmación. “El modelo recupera el secreto” no
es “esta CPU filtra”; “0/N en esta CPU” no es “la mitigación es imposible de
romper”.

## E1 — latencia de caché

Para cada máquina y modo (acceso caliente / acceso frío):

- Tomar 10.000 muestras con `clflush` + `rdtscp`.
- Reportar mediana, p5, p95, IQR e histograma. La media y la desviación típica
  no son la métrica principal: las latencias tienen colas largas.
- Elegir el umbral `T` en el valle entre los dos modos.
- Comprobar la clasificación: `hit` si `latencia <= T`, `miss` si no.
- Reportar aciertos y falsos positivos/negativos de la clasificación.

El umbral es **por máquina**. No se copia el 80 de otra máquina: en el Ryzen 5
PRO 5675U de referencia funciona porque los aciertos están en ~46 ciclos y los
fallos por encima de ~230; en otra máquina hay que repetir E1 y elegir su propio
valle.

El resultado se guarda en [`docs/thresholds.md`](thresholds.md).

## E1 jerárquico — mesetas de la jerarquía de caché

E1 jerárquico mide la latencia de **pointer chasing** frente al tamaño del
working set. No sustituye a la calibración hit/miss: la complementa para ver
dónde aparecen las mesetas de L1d, L2, L3 y memoria.

Protocolo:

- Buffer alineado a 64 B con nodos de una línea; cada nodo guarda el puntero al
  siguiente.
- Permutación **Sattolo**, que produce un único ciclo: se recorre todo el
  working set sin repeticiones y sin que el prefetch encuentre un patrón
  trivial. La semilla se guarda en el CSV.
- Calentamiento completo del ciclo antes de cada medida.
- `hops` cargas dependientes por repetición y `reps` repeticiones por tamaño.
- Medida con `lfence` + `rdtscp` + `lfence`, la misma secuencia de barreras que
  E1 de calibración.
- Barrido por defecto: 4 KiB–256 MiB con puntos `2^k` y `1,5·2^k`.
- `cycles_per_load = total_cycles / hops`.
- `madvise(MADV_HUGEPAGE)` es opcional y se registra en la columna `hugepage`;
  no requiere privilegios y no se fuerza si el sistema no lo admite.

Para cada tamaño se reporta mediana, p5, p95, IQR e IC95 bootstrap de la
mediana. La figura usa eje X logarítmico y bandas p5–p95 e IQR.

### Criterio de mesetas

Las capacidades se toman de la ficha `env_<machine_id>.txt`. `lscpu` da el total
de instancias de L1d y L2; para un hilo se usa la capacidad **por instancia**.
L3 se usa como capacidad total (habitualmente compartida).

```text
meseta L1d/L2/L3 = tamaños en [0,25·C, 0,75·C]
meseta memoria   = tamaños >= 2·L3  (o el mayor medido si no hay L3)
```

El rango 25 %–75 % evita los extremos: por debajo del 25 % caben efectos de
línea y del propio temporizador; por encima del 75 % empiezan las colisiones de
conjunto y la transición al siguiente nivel. Si un nivel no tiene puntos en la
ventana, se marca `sin-muestras`; si falta la ficha, `sin-ficha`. Nunca se
rellena una cifra que los datos no contengan.

La tabla de mesetas se exporta a
`data/derived/e1_hierarchy_plateaus.csv` y
`report/e1_hierarchy_plateaus.md`, con IC bootstrap de la mediana.

## Coste del temporizador

`src/e1_timer.c` mide el **intervalo vacío** entre dos `rdtscp` con las mismas
barreras que E1 jerárquico, pero sin la carga dependiente intermedia. Sirve para
saber cuánto del coste de un acceso pequeño es del montaje de medida.

- Cientos de miles de muestras configurables y varias repeticiones.
- Se publica como distribución aparte (histograma, mediana, p5, p95).
- **No se resta** de `hit`, `miss` ni de `cycles_per_load`. Restarlo
  silenciosamente introduciría un sesgo que el lector no puede auditar.
- En la interpretación se compara con la meseta de L1d: si el temporizador pesa
  mucho, las diferencias de pocos ciclos no son concluyentes.

## E2 — recuperación del secreto (modelo y validación opcional)

El mecanismo se explica con `analysis/simulate_spectre.py`. Si además se ejecuta
la PoC en hardware, se aplican estas métricas y se reportan como anexo.

Para cada byte `b`, repetición `r` e intento `a`, el programa mide las 256
líneas de `array2` y cuenta cuántas veces cada línea parece estar en caché.

```text
score[c] = número de aciertos del candidato c (0..A)
guess[b,r] = argmax_c score[c]
success[b,r] = 1 si guess[b,r] == secreto[b], 0 si no
score1 = mayor score[c]
score2 = segundo mayor score[c] de un candidato distinto
margin = score1 - score2          (aciertos; mayor = más claro)
unclear = 1 si margin < margin_min
```

Notas:

- `score1` y `score2` son **conteos de aciertos**, no ciclos. El CSV de E2 deja
  la columna `cycles` vacía.
- Si hay empate en el máximo, se elige el candidato de menor índice y se anota.
- `margin_min` se fija antes de la campaña. Valor inicial: **5 aciertos**. Se
  puede ajustar por máquina a partir de E1 y se registra en
  `docs/thresholds.md`; no se cambia después de ver los resultados.
- Un `guess` con `score1` alto pero `margin` bajo es un candidato poco fiable.
  Un `guess` con `margin` alto pero `success=0` es un candidato claro y erróneo:
  el ataque no está funcionando en esa configuración.

### Tasa de recuperación

- **Tasa global:** `sum(success) / (B * R)`. Es la métrica principal.
- **Tasa por ejecución:** para cada `r`, `(1/B) * sum_b success[b,r]`. Se
  reporta mediana, p5 y p95 sobre las `R` ejecuciones.
- **Tasa “clear”:** `sum(success y no unclear) / sum(no unclear)`. Es
  secundaria; sirve para ver si los `unclear` esconden fallos.
- **Tasa `unclear`:** `sum(unclear) / (B * R)`. Se reporta siempre.

Intervalo de confianza del 95 % para proporciones: **Wilson**. Para medianas:
**bootstrap** con 10.000 remuestreos (percentiles 2,5 y 97,5).

#### Dispersión frente a precisión

No son lo mismo y se reportan por separado:

- **p5–p95** describe la dispersión de las muestras individuales. En E1 sirve
  para ver si los modos `hit` y `miss` están separados y dónde cae el umbral.
- **IC95 bootstrap de la mediana** describe la precisión de la mediana
  estimada. Es lo que se usa en las barras de E3 y en las columnas `*_median_low`
  y `*_median_high` de `data/derived/compare_machines.csv`.

Una distribución puede tener mucha dispersión (p5–p95 ancho) y una mediana muy
precisa (IC estrecho) si hay muchas muestras. Por eso las figuras de barras
llevan IC y los histogramas de E1 muestran ambas cosas.

`data/derived/compare_machines.csv` exporta los IC de Wilson de E2
(`e2_<variant>_rate_low/high`), la tasa `unclear`, el margen mediano y los IC
bootstrap de E1/E3, para que el informe no dependa de leer las figuras.

`R >= 50` si se ejecuta E2 en hardware. No se concluye con una sola ejecución.
La ejecución de referencia del repositorio usa `R=1` y sirve solo para validar
el harness, no para afirmar una tasa poblacional.

### Resultados negativos

Un `0` sobre `N` no demuestra imposibilidad. Reporta `N` y una cota superior
aproximada del 95 % (regla de tres: `3/N`). Por ejemplo, `0/N` es una cota
superior de aproximadamente `0,15 %`, no “0 % garantizado”.

## E3 — mitigaciones y sobrecoste

Para cada variante (`baseline`, `lfence`, `mask`):

- La eficacia de seguridad se discute con el modelo conceptual y la literatura.
  Si hay E2 en hardware, se puede cruzar su `tasa global`, `unclear` y `margin`
  como evidencia adicional; no se duplica el ataque en el binario de E3.
- Medir el bucle de sobrecoste: 10 millones de iteraciones, mezcla de índices
  válidos, 30 repeticiones.
- `ciclos/iteración = ciclos_totales / iteraciones`.
- Reportar mediana, IC95 bootstrap de la mediana, p5 y p95 de
  `ciclos/iteración` sobre las 30 repeticiones.

Métricas de coste:

```text
overhead_abs = mediana(variante) - mediana(baseline)
overhead_pct = 100 * overhead_abs / mediana(baseline)
slowdown     = mediana(variante) / mediana(baseline)
```

Se reportan valores absolutos y relativos. No se compara una variante `-O0` con
una `-O2`; se agrupan por flags. Tampoco se mezcla una VM con un equipo nativo en
la comparación principal.

## E3 barrido de sensibilidad

El E3 antiguo mide una sola configuración. El barrido nuevo (`src/e3_sweep.c`)
mide el coste del chequeo de límites en función de:

- `work_per_iter` (**W**): operaciones dependientes del byte cargado. W = 0
  significa que el valor solo se consume en un sumidero `volatile`; W > 0 aplica
  una cadena de multiplicaciones y sumas cuyo resultado también acaba en el
  sumidero. El compilador no puede eliminarla.
- `predictability_mode`: `inrange` (todos los índices dentro del array) o
  `random_pX` con X = 1, 10, 50 (porcentaje de índices fuera de rango generado
  al azar). `out_of_range_fraction` guarda la fracción real observada.
- `array_bytes`: tamaño del array de datos. El perfil por defecto incluye 4 KiB
  (L1) y 64 MiB (mayor que la L3 habitual). Se reserva el doble para que un
  acceso especulativo fuera de rango no toque memoria no mapeada.
- `iterations`, `blocks`, `reps`, `seed`, CPU fijada con `taskset` y
  `pinned_cpu` observado con `sched_getcpu()`.

Protocolo:

- Los índices se generan **antes** de medir con un PRNG `splitmix64` y una
  semilla que se escribe en el CSV. Las tres variantes de una combinación usan
  los mismos índices, de modo que la comparación es emparejada.
- Las variantes `baseline`, `lfence` y `mask` se intercalan por bloques: en cada
  bloque y repetición se mide cada variante una vez, en orden aleatorio derivado
  de `seed`. No se mide una variante entera seguida de otra.
- Antes de cada medida se ejecuta un calentamiento (`--warmup`).
- La máscara se aplica **dentro** de la comprobación de límites, como
  `array_index_nospec` en el kernel: si `x >= limit`, la función retorna 0 sin
  acceder; si `x < limit`, aplica `mask = (size_t)0 - (size_t)(x < limit)` y
  accede a `array[x & mask]`. Así `baseline`, `lfence` y `mask` conservan el
  mismo salto condicional y son comparables. El compilador puede eliminar el
  `and` redundante, pero no el salto; se verifica con `objdump`.
- Las cargas de cada variante son funciones `noinline` separadas para poder
  revisar el desensamblado.

### Sobrecoste por bloques

Para cada combinación y variante se resume cada bloque completo con la mediana
de sus repeticiones (`cycles_per_iter`). El sobrecoste relativo se calcula
frente a `baseline` y el IC95 se obtiene remuestreando **bloques completos**, no
filas sueltas, y de forma emparejada (solo bloques presentes en las dos
variantes):

```text
por_bloque_b       = mediana(cycles_per_iter de las reps del bloque b)
overhead_pct       = 100 * (mediana(por_bloque_variante) - mediana(por_bloque_base))
                           / mediana(por_bloque_base)
slowdown           = mediana(por_bloque_variante) / mediana(por_bloque_base)
IC95               = percentiles 2,5 y 97,5 del mismo cociente en B remuestreos
                     de bloques con reemplazo (B = n_boot, semilla fija)
```

El remuestreo por bloques evita tratar como independientes las repeticiones de
un mismo bloque, que comparten temperatura, frecuencia y estado del predictor.

### Compatibilidad de CSV

El análisis detecta la cabecera:

- CSV antiguo: `cycles_per_iteration`, `run`, columnas de máquina.
- CSV nuevo: `work_per_iter`, `predictability_mode`, `array_bytes`,
  `block_id`, `cycles_per_iter`.

`plot_e3.py` solo lee el antiguo; `plot_e3_sweep.py` solo lee el nuevo. Nunca se
mezclan en la misma figura ni en el mismo agregado.

### Verificación del ensamblador

`make asm` genera `docs/asm/`. `tests/test_e3_asm.py` comprueba sobre
`bin/e3_sweep`:

- `load_lfence` contiene `lfence`;
- `load_baseline` contiene un salto condicional y ningún `cmov`;
- `load_mask` no contiene `lfence`.

Si el compilador cambia el código y una comprobación falla, no se usan esos
datos: se documenta el fallo y se corrige el código o los flags.

## Reglas de comparación

- Mismo código y flags en todas las máquinas; compilar localmente.
- Umbral y `margin_min` por máquina, documentados antes de la campaña.
- Mismo número de intentos y de repeticiones para las tres variantes.
- No se descartan ejecuciones “malas” sin dejar constancia. Si se excluye una,
  se documenta el criterio y se reporta también sin excluir.
- Si se hacen muchas comparaciones, se indica que el análisis es exploratorio o
  se corrige por comparaciones múltiples (por ejemplo, Holm). No se elige la
  comparación que más conviene.
- Las figuras y tablas se generan desde los CSV; no se teclean a mano.

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
machine_id,session_id,timestamp,working_set_bytes,node_size_bytes,hops,repetition,total_cycles,cycles_per_load,seed,pinned_cpu,hugepage
```

- `session_id`: sesión de medida (`data/<machine_id>/<session_id>/`).
- `timestamp`: instante UTC de la ejecución.
- `working_set_bytes`: tamaño del buffer recorrido.
- `node_size_bytes`: tamaño de nodo; 64 B por defecto (una línea).
- `hops`: cargas dependientes medidas en esa repetición.
- `repetition`: índice de repetición (0..reps-1).
- `total_cycles`: ciclos totales del recorrido.
- `cycles_per_load`: `total_cycles / hops`.
- `seed`: semilla de la permutación Sattolo.
- `pinned_cpu`: CPU observada con `sched_getcpu()`, o `-1` si no se pudo leer.
  Los CSV anteriores a esta corrección usan `cpu_pinned`; el análisis acepta
  ambas columnas.
- `hugepage`: `none`, `madvise` o `madvise-failed`.

### E1 coste del temporizador

```text
machine_id,session_id,timestamp,repetition,sample,pinned_cpu,cycles
```

- `repetition`: índice de repetición.
- `sample`: índice de intervalo dentro de la repetición.
- `cycles`: ciclos del intervalo vacío `lfence;rdtscp;lfence;rdtscp`.
- No se usa para restar; se analiza como distribución independiente.

### E2 (anexo ilustrativo)

E2 no es un experimento principal y no se usa para calcular la eficacia de E3.
Los CSV de la PoC histórica se conservan para trazabilidad, pero no entran en la
campaña ni en las figuras principales. La PoC se conserva como anexo
ilustrativo, subordinado al modelo y a la literatura; ver
[`e2-anexo.md`](e2-anexo.md).

### E3 — sobrecoste

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,iterations,run,cycles_per_iteration,total_cycles
```

- `iterations`: iteraciones del bucle de coste.
- `run`: repetición (0..reps-1).
- `cycles_per_iteration`: `total_cycles / iterations`.
- `total_cycles`: ciclos totales del bucle.

### E3 — barrido de sensibilidad

```text
machine_id,session_id,timestamp,variant,flags,work_per_iter,predictability_mode,out_of_range_fraction,array_bytes,iterations,repetition,block_id,total_cycles,cycles_per_iter,seed,pinned_cpu
```

- `variant`: `baseline`, `lfence` o `mask`.
- `work_per_iter`: W, trabajo dependiente del dato (0, 1, 2, 4, ..., 64).
- `predictability_mode`: `inrange` o `random_pX` (X = 1, 10, 50).
- `out_of_range_fraction`: fracción real de índices fuera de rango (0–1).
- `array_bytes`: tamaño del array de datos; el doble está reservado.
- `iterations`: iteraciones por medida.
- `repetition`: repetición dentro del bloque (0..reps-1).
- `block_id`: bloque aleatorizado (0..blocks-1).
- `total_cycles`: ciclos de la medida completa.
- `cycles_per_iter = total_cycles / iterations`.
- `seed`: semilla de los índices y del orden de variantes.
- `pinned_cpu`: CPU observada con `sched_getcpu()`.

Los detalles de nombres y carpetas están en [`../data/README.md`](../data/README.md).

### Nota sobre `flags` en CSV E3 antiguos

Los CSV de E3 anteriores a la corrección del Makefile registran en la columna
`flags` solo `$(CFLAGS)`, sin `-fno-if-conversion -fno-if-conversion2`, aunque
los binarios se compilaron con esas dos opciones. No se modifican esos CSV: la
nota queda aquí para no interpretar mal la columna. Los CSV nuevos de E3
registran exactamente las flags efectivas.

## CSV de barrido anteriores a la corrección de `load_mask`

Las sesiones `20261124-200944` y `20261125-084943` se midieron con un
`load_mask` que no conservaba el salto condicional: la variante `mask` no era
comparable con `baseline` y `lfence`. Los CSV **no se borran ni se modifican**;
`analysis/plot_e3_sweep.py` excluye la variante `mask` de esas sesiones y emite
un aviso, y `data/README.md` las marca como obsoletas para `mask`. Las campañas
nuevas usan el código corregido y sí incluyen `mask`.

## Repeticiones y estabilidad del sobrecoste

La comparación entre la validación inicial y la campaña antigua del Ryzen 5 PRO
5675U muestra por qué no basta con tres repeticiones. La campaña antigua
(`ryzen5pro5675u_final`) es **legacy**: se usa aquí solo como referencia de
estabilidad, no como resultado principal. Los intervalos se calculan con
bootstrap de la mediana (10.000 remuestreos) sobre los CSV existentes; no se ha
modificado ningún dato.

| máquina | repeticiones | variante | mediana (ciclos/iter) | IC95 bootstrap |
|---|---:|---|---:|---|
| `ryzen5pro5675u` | 3 | baseline | 3,328 | [3,303; 3,405] |
| `ryzen5pro5675u` | 3 | lfence | 13,523 | [13,514; 13,600] |
| `ryzen5pro5675u` | 3 | mask | 3,683 | [3,404; 3,810] |
| `ryzen5pro5675u_final` (legacy) | 30 | baseline | 3,344 | [3,337; 3,353] |
| `ryzen5pro5675u_final` (legacy) | 30 | lfence | 13,397 | [13,391; 13,406] |
| `ryzen5pro5675u_final` (legacy) | 30 | mask | 3,386 | [3,383; 3,396] |

Con tres repeticiones, el IC de `mask` es unas diez veces más ancho y su mediana
(+10,7 %) se aleja de la estimación con 30 repeticiones (+1,3 %). La causa es la
variabilidad térmica, de frecuencia y de planificación entre ejecuciones cortas.
Por eso el protocolo exige varios bloques y repeticiones para E3 y recomienda
repetir la campaña en sesiones distintas. La estimación que debe citarse es la
del barrido nuevo con IC por bloques; la comparación de 3 vs 30 repeticiones
queda como evidencia de la inestabilidad, no como resultado principal.

Este cálculo no corrige el sesgo del montaje: solo muestra la precisión de cada
estimación en sus propias condiciones.
