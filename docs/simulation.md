# Simulación conceptual de Spectre V1

Este documento explica el modelo de `analysis/simulate_spectre.py`. **No es un
ataque real ni ejecuta especulación real.** Es una herramienta para explicar y
visualizar el mecanismo que describe el paper, sin depender de que una CPU
concreta filtre.

## Por qué existe

El feedback del profesor pide centrar la experimentación práctica en:

1. la caracterización de la caché (E1);
2. el impacto de las mitigaciones sobre el rendimiento (E3).

El mecanismo de explotación (E2) se aborda con **análisis documental y
simulación conceptual**. La validación con la PoC en hardware se conserva como
anexo opcional, no como condición del proyecto.

## Qué modela

- `array1` con 16 posiciones válidas y un secreto simulado a continuación.
- Un predictor de 2 bits que aprende “tomado” con índices válidos y predice mal
  un índice fuera de rango.
- La ejecución transitoria del cuerpo de `victim_function` cuando la predicción
  falla.
- El acceso a `array2` con stride 512 y el rastro en caché.
- Flush+Reload: se vacía la caché, se ejecuta el ataque y se cuenta qué línea
  queda cacheada.
- Las tres variantes:
  - `baseline`: el acceso transitorio usa el índice fuera de rango;
  - `lfence`: la barrera impide el acceso transitorio;
  - `mask`: el índice se enmascara a 0 y se accede a una línea constante.

## Qué no modela

- Tiempos reales de caché, frecuencia, microcódigo o topología.
- El comportamiento exacto de un predictor comercial.
- Otras variantes de Spectre, Meltdown o ataques entre procesos.
- La eficacia real y universal de una mitigación.

Por eso el modelo sirve para **explicar**, no para sustituir E1/E3 ni para
afirmar que una CPU es segura o vulnerable.

## Cómo ejecutarlo

```bash
python3 analysis/simulate_spectre.py \
  --attempts 200 \
  --train 5 \
  --out data/simulation/spectre_model.csv \
  --figure figures/simulation_spectre.png
```

Para ver la línea temporal de un byte:

```bash
python3 analysis/simulate_spectre.py --timeline --attempts 200 --train 5
```

Para una sola variante:

```bash
python3 analysis/simulate_spectre.py --variant baseline
```

## Salidas

- `data/simulation/spectre_model.csv`: una fila por variante y byte, con
  `guess`, `score1`, `score2`, `success` y `transient`.
- `figures/simulation_spectre.png`: aciertos de caché por línea para el primer
  byte, comparando `baseline`, `lfence` y `mask`.

Resultado de referencia del modelo (secreto de 40 bytes, 200 intentos):

```text
baseline  40/40 bytes correctos (modelo)
lfence    0/40 bytes correctos (modelo)
mask      0/40 bytes correctos (modelo)
```

## Cómo usarlo en el informe

- En **E2** (análisis del mecanismo), presenta la línea temporal y el modelo.
- En **E3** (rendimiento), usa el modelo solo para explicar por qué se espera
  que LFENCE y la máscara bloqueen la fuga; el dato de coste sale de las
  mediciones.
- En **limitaciones**, di explícitamente que el modelo es una simplificación y
  que un `0/N` en hardware es “no observado”, no una prueba de imposibilidad.

## Tests

```bash
python3 -m unittest discover -s tests -v
```

Los tests comprueban que el predictor aprende, que `baseline` recupera el byte
modelado y que `lfence`/`mask` no lo hacen.
