# Métricas y análisis

Este documento fija las definiciones **antes** de medir. Si hay que cambiar una,
se anota la razón y se aplica a todas las máquinas; no se cambia después de ver
los resultados para que el resultado quede mejor.

## Notación

- `B` = bytes del secreto de prueba (40).
- `R` = repeticiones por configuración.
- `C` = candidatos posibles (256).
- `score[c]` = coste agregado del candidato `c`. **Menor es mejor** (latencia o
  ciclos). Si una implementación usa mayor-es-mejor, se invierte el signo antes
  de escribir el CSV y se documenta.
- `train` = número de aciertos de entrenamiento por ataque.
- `run` = índice de repetición (0..R-1).

El secreto es sintético y público para el experimento. No se usan datos
personales ni secretos reales.

## E1 — latencia de caché

Para cada máquina y modo (acceso caliente / acceso frío):

- Tomar 10.000 muestras con `clflush` + `rdtscp`.
- Reportar mediana, p5, p95 e histograma.
- Elegir el umbral `T` en el valle entre los dos modos.
- Comprobar la clasificación: `hit` si `latencia < T`, `miss` si no.
- Reportar aciertos y falsos positivos/negativos de la clasificación.

El umbral es **por máquina**. No se usa el valor 80 del PoC original: es
específico de Intel.

## E2 — recuperación del secreto

Para cada byte `b` y repetición `r`:

```text
guess[b,r] = argmin_c score[c]
success[b,r] = 1 si guess[b,r] == secreto[b], 0 si no
```

- `score[c]`: suma de latencias de los intentos de ese byte (como el PoC). Si se
  usa mediana en vez de suma, se documenta y no se mezcla con la suma.
- `score1`: mejor puntuación media por intento.
- `score2`: segunda mejor puntuación media por intento.
- `margin = score2 - score1` (ciclos medios por intento; mayor = más claro).
- `unclear = 1` si `margin < margin_min`.

`margin_min` se fija antes de la campaña. Valor inicial: **10 ciclos**. Se puede
ajustar por máquina a partir de E1, pero se registra en `docs/thresholds.md` y no
se cambia después de ver los resultados.

### Tasa de recuperación

- **Tasa global:** `sum(success) / (B * R)`. Es la métrica principal.
- **Tasa por ejecución:** para cada `r`, `(1/B) * sum_b success[b,r]`. Se
  reporta mediana, p5 y p95 sobre las `R` ejecuciones.
- **Tasa “clear”:** `sum(success y no unclear) / sum(no unclear)`. Es
  secundaria; sirve para ver si los `unclear` esconden fallos.
- **Tasa `unclear`:** `sum(unclear) / (B * R)`. Se reporta siempre.

Intervalo de confianza del 95 % para proporciones: **Wilson**. Para medianas:
**bootstrap** con 10.000 remuestreos (percentiles 2,5 y 97,5).

`R >= 50` para E2. No se concluye con una sola ejecución.

### Resultados negativos

Un `0` sobre `N` no demuestra imposibilidad. Reporta `N` y una cota superior
aproximada del 95 % (regla de tres: `3/N`). Por ejemplo, `0/2000` es una cota
superior de aproximadamente `0,15 %`, no “0 % garantizado”.

## E3 — mitigaciones y sobrecoste

Para cada variante (`baseline`, `lfence`, `mask`):

- Repetir el protocolo de E2 para medir eficacia (`tasa global`, `unclear`,
  `margin`).
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

## Esquema de las filas

Cada fila del CSV es un intento de un byte:

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles
```

- `variant`: `baseline`, `lfence` o `mask`.
- `success`: 1 o 0.
- `cycles`: solo para las filas de sobrecoste de E3; vacío en el resto.
- `score1` y `score2`: puntuaciones medias por intento, en ciclos.
- `threshold`: umbral de E1 usado para esa máquina.

Los detalles de nombres y carpetas están en [`../data/README.md`](../data/README.md).
