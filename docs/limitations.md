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

## 9. Ética y seguridad

- Todas las pruebas se ejecutan en máquinas propias o del grupo, en un entorno
  controlado y sin `sudo`.
- No se desactivan mitigaciones del sistema ni se ataca infraestructura de
  terceros.
- El repositorio es privado y el material de referencia es de solo lectura.
