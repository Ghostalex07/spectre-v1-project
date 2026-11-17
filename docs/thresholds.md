# Umbrales por máquina

El umbral `T` separa un acceso que está en caché (`hit`) de uno que no
(`miss`). **No es universal.** El valor 80 del PoC original es específico de
algunos Intel; en cada equipo hay que medir E1 y elegir el valle del histograma.

## Cómo elegir el umbral

1. Ejecuta E1 con un buffer grande y muestras suficientes:

   ```bash
   ./scripts/run_e1.sh <machine_id> 10000 64
   ```

2. Genera el histograma:

   ```bash
   python3 analysis/plot_e1.py --machine-id <machine_id>
   ```

3. Mira la mediana y los percentiles de `hit` y `miss`. El umbral debe caer
   entre ambos modos, no dentro de la zona densa de uno de ellos.
4. Si los modos se solapan, aumenta el buffer, revisa la afinidad de CPU y el
   gobernador, y repite. No elijas un umbral que clasifique mal una parte grande
   de las muestras.
5. Anota el valor y la fecha en la tabla de abajo. E2 y E3 deben usar **ese**
   valor para esa máquina.

## Tabla de umbrales

| machine_id | fecha | hit mediana | hit p5 | hit p95 | miss mediana | miss p5 | miss p95 | umbral T | notas |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `ryzen5pro5675u` | 2026-11-17 | 46 | 23 | 46 | 276 | 230 | 690 | **80** | Ryzen 5 PRO 5675U, Zen 3; 10.000 muestras, buffer 64 MiB. El análisis sugiere 138; se usa 80, que también separa los modos. Otra ejecución con 5000 muestras y 32 MiB dio miss mediana 437. |

### Plantilla para añadir una máquina

| machine_id | fecha | hit mediana | hit p5 | hit p95 | miss mediana | miss p5 | miss p95 | umbral T | notas |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `ejemplo` | | | | | | | | | |

## Margen mínimo (`margin_min`)

`margin_min` es el mínimo de `score1 - score2` (aciertos) para considerar que un
byte tiene un candidato claro. Valor inicial: **5**. Si una máquina tiene mucha
varianza, se puede subir antes de la campaña; se anota aquí y se aplica a todas
las variantes de esa máquina.

| machine_id | margin_min | notas |
|---|---:|---|
| `ryzen5pro5675u` | 5 | Baseline suele dar márgenes ~280–300; LFENCE queda por debajo de 5 en la mayoría de bytes. |

## Reglas

- No cambiar el umbral después de ver los resultados de E2/E3 para “mejorar” la
  tasa. Si hay que cambiarlo, se deja constancia y se repite la medida.
- Un umbral distinto por máquina es correcto y esperado; un umbral distinto por
  variante dentro de la misma máquina no lo es.
- El CSV guarda el umbral usado en la columna `threshold`.
- Si una máquina no filtra con ningún umbral razonable, se documenta como
  resultado negativo; no se fuerza el valor para que parezca que filtra.
