# Glosario

Términos que aparecen en el código, el informe y la defensa. Si añades uno,
defínelo aquí antes de usarlo en público.

## Arquitectura y microarquitectura

- **Estado arquitectónico:** el estado visible del programa: registros, memoria,
  flags, contador de programa. Es lo que un programa puede observar
  correctamente.
- **Estado microarquitectónico:** estado interno del procesador que no forma
  parte de la arquitectura: líneas de caché, predictores, buffers, unidades de
  ejecución. Spectre V1 filtra información a través de este estado.
- **Pipeline:** división de la ejecución de una instrucción en etapas
  (fetch, decode, execute, memory, write-back) para solapar instrucciones.
- **Ejecución fuera de orden (OoO):** el procesador ejecuta instrucciones en un
  orden distinto al del programa, respetando las dependencias de datos y control.
- **Ejecución especulativa:** el procesador ejecuta instrucciones antes de saber
  si debe ejecutarlas (por ejemplo, antes de resolver un salto). Si se equivoca,
  descarta el estado arquitectónico, pero pueden quedar efectos
  microarquitectónicos.
- **Retiro (commit):** momento en el que una instrucción pasa a formar parte del
  estado arquitectónico. Una instrucción especulativa puede ejecutarse sin
  retirarse.
- **Predicción de saltos:** mecanismo que adivina si un salto se tomará y hacia
  dónde. Si acierta, no hay burbuja; si falla, se descarta el camino especulado.
- **Predictor de saltos:** estructura microarquitectónica que aprende patrones
  de saltos. Spectre V1 entrena el predictor para que prediga un camino que
  viola la comprobación de límites.
- **SMT (Simultaneous Multithreading):** dos hilos comparten un núcleo físico.
  El hermano SMT puede interferir en las medidas; déjalo idle.
- **VM (máquina virtual):** entorno virtualizado. Los tiempos y la topología de
  caché pueden no ser representativos; se excluye de la comparación principal.

## Caché y canal lateral

- **Línea de caché:** unidad de transferencia entre memoria y caché; en x86-64
  suele ser de 64 bytes.
- **L1d / L2 / L3:** niveles de caché de datos. L1 es la más pequeña y rápida;
  L3 es la más grande y lenta.
- **Acierto (hit):** el dato está en caché; el acceso es rápido.
- **Fallo (miss):** el dato no está en caché; hay que traerlo de un nivel
  inferior o de memoria; el acceso es lento.
- **Canal lateral (side channel):** inferencia de información a partir de
  efectos observables que no son el dato en sí (tiempos, caché, consumo,
  radiación, etc.).
- **Flush+Reload:** técnica de canal lateral: se expulsa una línea con
  `clflush`, se ejecuta la víctima y se mide cuánto tarda en volver a acceder a
  esa línea. Si está en caché, la víctima la tocó.
- **`clflush`:** instrucción x86 que invalida una línea de caché.
- **`rdtscp`:** instrucción x86 que lee el contador de ciclos y espera a que las
  instrucciones anteriores hayan terminado; se usa para medir tiempos.
- **`lfence`:** barrera de carga. Impide que las cargas posteriores se ejecuten
  antes de que se resuelva la barrera; se usa como mitigación de Spectre V1,
  pero tiene coste.
- **`mfence`:** barrera de memoria completa; ordena cargas y almacenes.
- **Umbral (`threshold`):** valor en ciclos que separa `hit` de `miss` en una
  máquina concreta. Se calibra con E1.

## Spectre V1

- **Spectre V1:** ataque que explota una comprobación de límites mal predicha.
  El procesador ejecuta especulativamente un acceso fuera de rango y deja un
  rastro en caché.
- **`array1`:** array de bytes válidos; en el PoC tiene 16 elementos útiles.
- **`array2`:** array grande usado como canal; se accede a
  `array2[array1[x] * 512]` para que cada valor caiga en una línea distinta.
- **`malicious_x`:** índice fuera de rango que el atacante quiere usar para leer
  un byte del secreto.
- **`training_x`:** índice válido usado para entrenar el predictor.
- **Ventana transitoria:** intervalo en el que las instrucciones especulativas
  se ejecutan antes de que el procesador detecte el fallo y las descarte.
- **Enmascarado de índices (index masking):** mitigación que convierte el índice
  fuera de rango en un índice seguro mediante una máscara, sin introducir un
  salto dependiente del dato.
- **`cmov`:** instrucción de movimiento condicional. Si el compilador convierte
  el `if` en `cmov`, puede eliminar el salto que Spectre V1 necesita; hay que
  revisar el ensamblador.

## Métricas y estadística

- **`attempts`:** número de intentos por byte en E2. Debe ser fijo para comparar
  variantes.
- **`train`:** número de aciertos de entrenamiento por ataque.
- **`score[c]`:** número de aciertos de caché del candidato `c`; mayor es mejor.
- **`score1` / `score2`:** mayor y segundo mayor `score` de candidatos distintos.
- **`margin`:** `score1 - score2`; mide la claridad del candidato.
- **`unclear`:** byte cuyo `margin` es menor que `margin_min`; el candidato no es
  fiable.
- **Tasa de recuperación:** proporción de bytes recuperados correctamente.
- **Wilson:** intervalo de confianza para una proporción; se usa en E2/E3.
- **Bootstrap:** remuestreo con reemplazo para estimar la incertidumbre de una
  mediana o un percentil.
- **p5 / p95:** percentiles 5 y 95; resumen de la cola de una distribución.
- **Sobrecoste (`overhead`):** diferencia de ciclos por iteración entre una
  variante y la base; se reporta absoluta y porcentual.
- **`slowdown`:** cociente entre la mediana de una variante y la de la base.
