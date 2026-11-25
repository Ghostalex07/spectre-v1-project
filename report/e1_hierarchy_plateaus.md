# Mesetas de E1 jerárquico

Criterio: para L1d/L2/L3 se usan los tamaños en [25 %, 75 %] de la
capacidad de cada nivel. Para memoria se usa todo tamaño >= 2·L3 (o el
mayor medido si no hay ficha de L3). Las capacidades se toman de
`env_<machine_id>.txt`; L1d/L2 se dividen por instancia.

| machine_id | nivel | capacidad | rango usado | puntos | muestras | ciclos/carga | IC95 | estado |
|---|---|---:|---|---:|---:|---:|---|---|
| `ryzen5pro5675u` | L1d | 32.00 KiB | 8.00 KiB–24.00 KiB | 4 | 120 | 2.128 | [2.126, 2.130] | ok |
| `ryzen5pro5675u` | L2 | 512.00 KiB | 128.00 KiB–384.00 KiB | 4 | 120 | 6.721 | [6.697, 6.816] | ok |
| `ryzen5pro5675u` | L3 | 16.00 MiB | 4.00 MiB–12.00 MiB | 4 | 120 | 30.264 | [29.062, 32.553] | ok |
| `ryzen5pro5675u` | memoria | — | >= 32.00 MiB | 7 | 210 | 274.747 | [271.456, 279.088] | ok |

Un estado `sin-ficha` indica que falta la ficha de entorno;
`sin-muestras` indica que el barrido no tiene puntos en la ventana.
No se rellenan cifras que los datos no contienen.
