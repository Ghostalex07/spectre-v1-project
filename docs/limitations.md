# Limitaciones del trabajo

Este documento fija qué se puede afirmar con los datos del repositorio y qué
queda fuera. Sirve para el informe y para responder en la defensa sin
sobreinterpretar los resultados.

## 1. Alcance del ataque

- Se estudia **Spectre V1 en un único proceso**: el atacante y la víctima
  comparten espacio de direcciones y el atacante puede ejecutar código y medir
  tiempos.
- No se cubren Meltdown, Spectre V2, Spectre-BHB, variantes entre procesos,
  ataques contra el kernel ni escapes de sandbox.
- El secreto es **sintético y conocido por el diseño del experimento**. El
  objetivo es medir si se filtra, no demostrar un robo de datos reales.
- El PoC usa un patrón de entrenamiento controlado. Un atacante real no siempre
  controla el predictor con esa precisión.

## 2. Cobertura de hardware

- La campaña aspira a **2–3 microarquitecturas**, no a un estudio exhaustivo de
  todos los procesadores x86-64.
- Los resultados dependen de la CPU, el **microcódigo**, el kernel, las
  mitigaciones activas y la versión de GCC. Cambiar cualquiera de ellos puede
  cambiar la tasa de recuperación y el sobrecoste.
- Una máquina virtual no es una medida fiable de la microarquitectura: el
  hipervisor puede cambiar la temporización, el scheduling y la topología. Los
  datos de VM se excluyen de la comparación principal.
- Si una máquina no filtra, se documenta como resultado negativo. Un `0/N` es
  una cota superior (`≈3/N` al 95 %), no una prueba de que el ataque sea
  imposible en esa CPU.

## 3. Mitigaciones estudiadas

- Solo se comparan **LFENCE** y **enmascarado de índices**.
- No se evalúan `array_index_nospec`, retpoline, IBRS/IBPB, STIBP, honeypots ni
  las mitigaciones que aplica el kernel de Linux.
- `-mspeculative-load-hardening` de Clang se menciona como comparación
  conceptual con el enmascarado manual; no forma parte de la campaña medida.
- LFENCE se coloca después de la comprobación de límites y antes del acceso
  vulnerable. Otras colocaciones pueden tener otro coste y otra eficacia.
- El enmascarado se implementa con una máscara dependiente de datos. Si el
  compilador lo transforma en un salto o lo elimina, la variante deja de ser
  válida; por eso se revisa el ensamblador.
- En el **E3 legacy** (`src/e3_mitigations.c`, que usa `src/spectre.h`) la
  variante `mask` no conserva el salto condicional. Eso solo es aceptable
  porque allí todos los índices están en rango; no se usa para comparar
  variantes con índices fuera de rango ni se mezcla con el barrido nuevo.
- El coste medido es el de este bucle microbenchmark, no el de una aplicación
  completa.

## 4. Medición y ruido

- `rdtscp` y `clflush` permiten medir, pero no son un reloj perfecto: la
  frecuencia puede variar, el TSC puede no ser invariante en todos los equipos y
  el sistema operativo puede interrumpir.
- Se fija el proceso a un núcleo físico con `taskset`, se procura que el hermano
  SMT esté inactivo y se usa el gobernador `performance` cuando es posible. No
  siempre se puede garantizar en máquinas compartidas.
- El umbral de E1 es **por máquina**. Copiar el umbral de otro equipo invalida
  la comparación.
- Las medianas y los intervalos bootstrap describen la precisión de la
  estimación en las condiciones medidas; no eliminan el sesgo del montaje.
- Las repeticiones son finitas. Las diferencias pequeñas de sobrecoste pueden
  quedar dentro del ruido y no deben presentarse como concluyentes.

### 4.1 Coste del temporizador

- `rdtscp` mide ciclos de referencia (TSC), no necesariamente ciclos de núcleo.
  Con turbo o cambios de frecuencia, la conversión no es exacta.
- La secuencia `lfence; rdtscp; ...; lfence; rdtscp` tiene un coste propio. E1
  jerárquico mide ese intervalo vacío en un CSV aparte y **no lo resta** de las
  latencias. Así el lector puede juzgar cuánto pesa en los tamaños pequeños.
- En un acceso a L1d de pocos ciclos, el coste del temporizador y el ruido del
  sistema pueden ser del mismo orden. No se deben presentar diferencias de uno
  o dos ciclos como una característica estable de la microarquitectura.

### 4.2 TLB y páginas grandes

- El pointer chasing recorre una página distinta cada 4 KiB. En working sets
  grandes, parte de la latencia puede venir de **fallos de TLB** (page walks) y
  no solo de la jerarquía de caché. Las mesetas de L2/L3 y memoria deben
  interpretarse con esta cautela.
- `madvise(MADV_HUGEPAGE)` puede reducir esos efectos, pero no se garantiza que
  el kernel entregue páginas grandes. La columna `hugepage` registra si se pidió
  y si la llamada tuvo éxito; no se usan páginas grandes privilegiadas ni se
  cambia la configuración del sistema.
- Un working set que cabe en caché pero no en TLB puede mostrar una latencia
  mayor que la de un nivel superior; por eso el criterio de mesetas usa una
  ventana central y no un único punto.

## 5. Código y compilador

- El comportamiento depende de las optimizaciones. La campaña principal usa
  `-O2` y `-O0` queda como control; no se mezclan en las mismas figuras.
- E2/E3 usan `-fno-if-conversion -fno-if-conversion2` y funciones `noinline`
  para conservar el salto condicional. Aun así, el ensamblador se verifica con
  `objdump`.
- Cambiar el compilador, la versión de GCC o los flags puede cambiar el
  ensamblador y, con ello, la fuga y el coste.
- El modelo conceptual de `analysis/simulate_spectre.py` explica el mecanismo;
  no sustituye una medida de hardware.

## 6. Estadística

- La tasa de recuperación se estima sobre `B` bytes y `R` ejecuciones. Con
  pocas repeticiones el intervalo de confianza es ancho.
- Wilson es una aproximación para proporciones; el bootstrap de la mediana es
  una aproximación por remuestreo. Ninguno corrige un diseño experimental
  sesgado.
- Un `success=1` con margen pequeño puede ser ruido. Por eso se reporta
  `score1 - score2`, la tasa `unclear` y el margen, no solo el acierto.
- Los resultados de una microarquitectura no se generalizan sin más a otra.

## 7. Validez externa

- El montaje es de laboratorio: arrays pequeños, secreto conocido, atacante
  local y sin defensas adicionales.
- No se modela un adversario real, ni ASLR, ni sandboxing, ni un servicio
  remoto.
- Las conclusiones son sobre el mecanismo y sobre el coste relativo de dos
  mitigaciones en las máquinas medidas, no una auditoría de seguridad de un
  producto.

## 8. Cómo formular las conclusiones

- No escribas “este procesador no es vulnerable”. Escribe “en este microcódigo,
  este kernel y este tamaño de muestra no se observó la fuga”.
- No escribas “esta mitigación no tiene coste”. Escribe “el sobrecoste medido
  fue X, con IC Y, en este bucle y estas condiciones”.
- La ausencia de un comportamiento observable no demuestra que no pueda
  producirse. Es una cota superior bajo las condiciones del experimento.
- E2 en hardware, si se ejecuta, es una observación de anexo. No es la base de
  la conclusión de E3 ni demuestra eficacia universal.
- Si el sobrecoste de una variante cae dentro del ruido, dilo: no fuerces una
  diferencia que los datos no sostienen.

## 9. Limitaciones específicas de las métricas

- **TSC frente a ciclos reales.** `rdtscp` cuenta ciclos de referencia a
  frecuencia constante, no ciclos reales del núcleo. Como no se puede fijar la
  frecuencia ni desactivar el turbo sin privilegios, los valores absolutos en
  “ciclos” dependen de la frecuencia efectiva. Por eso las comparaciones
  relativas dentro de un mismo bloque intercalado son más robustas que los
  valores absolutos.
- **Coste del temporizador.** Las latencias de E1 incluyen el coste de `rdtscp`
  y de las barreras. Se publica aparte y no se resta silenciosamente; cualquier
  valor “corregido” debe presentarse junto al bruto y explicar la corrección.
- **TLB en conjuntos grandes.** Para tamaños de trabajo grandes, la latencia
  medida incluye fallos de TLB y recorridos de tabla de páginas; el escalón de
  DRAM no es “latencia de DRAM pura”.
- **Microbenchmark de E3.** El bucle de E3 mide un patrón muy concreto con
  índices preparados y trabajo dependiente acotado. Sus sobrecostes son cotas
  para ese bucle, no el coste de LFENCE o de la máscara en una aplicación real.
- **Modelo E2.** El modelo conceptual demuestra la lógica del mecanismo (estado
  arquitectónico restaurado frente a huella microarquitectónica persistente, y
  cómo LFENCE y el enmascarado la cortan), no su eficacia ni su magnitud en
  hardware real.
- **Ausencia de comportamiento observable.** Como recuerda el profesor, la
  ausencia de un comportamiento observable no implica que no pueda producirse.
  Un `0/N` es una cota superior en esas condiciones, no una prueba de
  imposibilidad.
- **Diferencias entre máquinas.** Pueden deberse a microcódigo, kernel,
  compilador, mitigaciones activas o configuración del sistema, no solo a la
  microarquitectura. Por eso se registra la ficha de entorno y se reporta junto
  a los resultados.

## 10. Ética y seguridad

- Todas las pruebas se ejecutan en máquinas propias o del grupo, en un entorno
  controlado y sin `sudo`.
- No se desactivan mitigaciones del sistema ni se ataca infraestructura de
  terceros.
- El repositorio es privado y el material de referencia es de solo lectura.
