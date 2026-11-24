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
es “esta CPU filtra”; “0/2000 en esta CPU” no es “la mitigación es imposible de
romper”.

## E1 — latencia de caché

Para cada máquina y modo (acceso caliente / acceso frío):

- Tomar 10.000 muestras con `clflush` + `rdtscp`.
- Reportar mediana, p5, p95 e histograma.
- Elegir el umbral `T` en el valle entre los dos modos.
- Comprobar la clasificación: `hit` si `latencia <= T`, `miss` si no.
- Reportar aciertos y falsos positivos/negativos de la clasificación.

El umbral es **por máquina**. No se copia el 80 de otra máquina: en el Ryzen 5
PRO 5675U de referencia funciona porque los aciertos están en ~46 ciclos y los
fallos por encima de ~230; en otra máquina hay que repetir E1 y elegir su propio
valle.

El resultado se guarda en [`docs/thresholds.md`](thresholds.md).

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

`R >= 50` si se ejecuta E2 en hardware. No se concluye con una sola ejecución.
La ejecución de referencia del repositorio usa `R=1` y sirve solo para validar
el harness, no para afirmar una tasa poblacional.

### Resultados negativos

Un `0` sobre `N` no demuestra imposibilidad. Reporta `N` y una cota superior
aproximada del 95 % (regla de tres: `3/N`). Por ejemplo, `0/2000` es una cota
superior de aproximadamente `0,15 %`, no “0 % garantizado”.

## E3 — mitigaciones y sobrecoste

Para cada variante (`baseline`, `lfence`, `mask`):

- La eficacia de seguridad se discute con el modelo conceptual y la literatura.
  Si hay E2 en hardware, se puede cruzar su `tasa global`, `unclear` y `margin`
  como evidencia adicional; no se duplica el ataque en el binario de E3.
- Medir el bucle de sobrecoste: 10 millones de iteraciones, mezcla de índices
  válidos, 30 repeticiones.
- `ciclos/iteración = ciclos_totales / iteraciones`.
- Reportar mediana y p95 de `ciclos/iteración` sobre las 30 repeticiones.

Métricas de coste:

```text
overhead_abs = mediana(variante) - mediana(baseline)
overhead_pct = 100 * overhead_abs / mediana(baseline)
slowdown     = mediana(variante) / mediana(baseline)
```

Se reportan valores absolutos y relativos. No se compara una variante `-O0` con
una `-O2`; se agrupan por flags. Tampoco se mezcla una VM con un equipo nativo en
la comparación principal.

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

### E2 (opcional) y eficacia de E3

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles
```

- `variant`: `baseline`, `lfence` o `mask`.
- `threshold`: umbral de E1 usado para esa máquina.
- `byte`: 0–39 para el secreto de 40 bytes.
- `guess`: 0–255.
- `score1`, `score2`: conteos de aciertos (0..attempts).
- `success`: 1 o 0.
- `cycles`: vacío en E2.

### E3 — sobrecoste

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,iterations,run,cycles_per_iteration,total_cycles
```

- `iterations`: iteraciones del bucle de coste.
- `run`: repetición (0..reps-1).
- `cycles_per_iteration`: `total_cycles / iterations`.
- `total_cycles`: ciclos totales del bucle.

Los detalles de nombres y carpetas están en [`../data/README.md`](../data/README.md).
