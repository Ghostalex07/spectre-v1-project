# Resumen de resultados — Spectre V1

> Documento generado por `analysis/summarize_results.py` a partir de
> `data/derived/compare_machines.csv`. No se edita a mano: los números
> salen de los CSV de la campaña.

## Cobertura

- Entradas de máquina incluidas: **1**.
- Microarquitecturas distintas: **1**.
- Con una sola microarquitectura, la comparación valida el pipeline; no demuestra diversidad de CPUs.

## Equipos

| máquina | CPU | familia/modelo/stepping | microcódigo | kernel | GCC |
|---|---|---|---|---|---|
| `ryzen5pro5675u` | AMD Ryzen 5 PRO 5675U with Radeon Graphics | 25/80/0 | 0xa500014 | 6.8.0-149-generic | 11.4.0 |

## E1 — calibración de caché

| máquina | umbral (ciclos) | hit mediana [IC95] | miss mediana [IC95] |
|---|---:|---:|---:|
| `ryzen5pro5675u` | 138 | 46.00 [46.00, 46.00] | 276.00 [276.00, 276.00] |

El umbral es el valle entre los dos modos de esta máquina. No se copia de
otro equipo. El IC95 es el bootstrap de la mediana; p5–p95 queda en el CSV
como medida de dispersión.

## E3 — sobrecoste

| máquina | baseline (ciclos/iter) | LFENCE (ciclos/iter) | LFENCE coste | máscara (ciclos/iter) | máscara coste |
|---|---:|---:|---:|---:|---:|
| `ryzen5pro5675u` | 3.33 [3.30, 3.40] | 13.52 [13.51, 13.60] | +306.3% | 3.68 [3.40, 3.81] | +10.7% |

El coste es la diferencia porcentual de la mediana frente a `baseline` de
la misma máquina y los mismos flags. El IC95 se calcula por bootstrap.

## Lectura rápida

- `ryzen5pro5675u`: sobrecoste LFENCE +306.3%, máscara +10.7%.

Estas frases son descriptivas. La eficacia de seguridad se argumenta con
el ensamblador, el modelo y la literatura, no con una tasa de recuperación.
La discusión de significancia, causas microarquitectónicas y resultados
negativos va en el informe, con los intervalos y el tamaño de muestra
delante.

## Reproducir

```bash
python3 analysis/compare_machines.py
python3 analysis/summarize_results.py
```

## Límites

El alcance y lo que no se puede afirmar están en
[`docs/limitations.md`](../docs/limitations.md).
