# Resumen de resultados — Spectre V1

> Documento generado por `analysis/summarize_results.py` a partir de
> `data/derived/compare_machines.csv`. No se edita a mano: los números
> salen de los CSV de la campaña.

## Cobertura

- Entradas de máquina incluidas: **2**.
- Microarquitecturas distintas: **1**.
- Hay varias entradas con la misma CPU/familia/modelo/stepping: son campañas distintas de la misma microarquitectura, no equipos independientes.

## Equipos

| máquina | CPU | familia/modelo/stepping | microcódigo | kernel | GCC |
|---|---|---|---|---|---|
| `ryzen5pro5675u` | AMD Ryzen 5 PRO 5675U with Radeon Graphics | 25/80/0 | 0xa500014 | 6.8.0-149-generic | 11.4.0 |
| `ryzen5pro5675u_final` | AMD Ryzen 5 PRO 5675U with Radeon Graphics | 25/80/0 | 0xa500014 | 6.8.0-149-generic | 11.4.0 |

## E1 — calibración de caché

| máquina | umbral (ciclos) | hit mediana [IC95] | miss mediana [IC95] |
|---|---:|---:|---:|
| `ryzen5pro5675u` | 138 | 46.00 [46.00, 46.00] | 276.00 [276.00, 276.00] |
| `ryzen5pro5675u_final` | 138 | 46.00 [46.00, 46.00] | 276.00 [276.00, 276.00] |

El umbral es el valle entre los dos modos de esta máquina. No se copia de
otro equipo. El IC95 es el bootstrap de la mediana; p5–p95 queda en el CSV
como medida de dispersión.

## E2 — recuperación del secreto

| máquina | baseline | LFENCE | máscara |
|---|---:|---:|---:|
| `ryzen5pro5675u` | 1.000 [0.912, 1.000] | 0.000 [0.000, 0.088] | 0.000 [0.000, 0.088] |
| `ryzen5pro5675u_final` | 1.000 [0.998, 1.000] | 0.000 [0.000, 0.002] | 0.000 [0.000, 0.002] |

Entre paréntesis se muestra la tasa y el IC95 de Wilson. Un `0/N` es una
cota superior, no una prueba de imposibilidad. `unclear` y el margen
primero/segundo están en el CSV para separar los fallos claros del ruido.

## E3 — sobrecoste

| máquina | baseline (ciclos/iter) | LFENCE (ciclos/iter) | LFENCE coste | máscara (ciclos/iter) | máscara coste |
|---|---:|---:|---:|---:|---:|
| `ryzen5pro5675u` | 3.33 [3.30, 3.40] | 13.52 [13.51, 13.60] | +306.3% | 3.68 [3.40, 3.81] | +10.7% |
| `ryzen5pro5675u_final` | 3.34 [3.34, 3.35] | 13.40 [13.39, 13.41] | +300.6% | 3.39 [3.38, 3.40] | +1.3% |

El coste es la diferencia porcentual de la mediana frente a `baseline` de
la misma máquina y los mismos flags. El IC95 se calcula por bootstrap.

## Lectura rápida

- `ryzen5pro5675u`: baseline 100.0%, LFENCE 0.0%, máscara 0.0%; sobrecoste LFENCE +306.3%, máscara +10.7%.
- `ryzen5pro5675u_final`: baseline 100.0%, LFENCE 0.0%, máscara 0.0%; sobrecoste LFENCE +300.6%, máscara +1.3%.

Estas frases son descriptivas. La discusión de significancia, causas
microarquitectónicas y resultados negativos va en el informe, con los
intervalos y el tamaño de muestra delante.

## Reproducir

```bash
python3 analysis/compare_machines.py
python3 analysis/summarize_results.py
```

## Límites

El alcance y lo que no se puede afirmar están en
[`docs/limitations.md`](../docs/limitations.md).
