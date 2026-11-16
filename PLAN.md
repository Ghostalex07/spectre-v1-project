# Plan de ejecución — Spectre V1

Proyecto de Arquitectura Avanzada. Este documento describe cómo llevar el
proyecto desde la propuesta hasta la defensa final: qué se construye, en qué
orden, con qué controles experimentales y qué se entrega.

## 1. Ficha del proyecto

**Título:** Spectre V1: ejecución especulativa, predicción de saltos y canales
laterales en caché.

**Pregunta de investigación:** ¿Cómo provocan la predicción de saltos y la
ejecución especulativa una filtración de información observable a través de la
caché, y qué eficacia y coste en rendimiento tienen las mitigaciones de Spectre
V1 en distintos procesadores?

**Objetivo general:** explicar cómo la ejecución especulativa, un mecanismo de
optimización legítimo, puede utilizarse para inferir información a través de la
caché, y medir el coste de las principales mitigaciones.

**Objetivos específicos:**

1. Describir los mecanismos de predicción de saltos, ejecución especulativa y
   caché que intervienen en Spectre V1.
2. Reproducir y analizar experimentalmente el canal lateral en un entorno
   controlado.
3. Evaluar la eficacia y el sobrecoste de LFENCE y del enmascarado de índices en
   distintos procesadores.

**Alcance:** pipeline, ejecución fuera de orden, predicción de saltos,
recuperación ante fallos, jerarquía de caché y diferencia entre estado
arquitectónico y microarquitectónico. Spectre V1 en un único proceso, con un
secreto de prueba, y las mitigaciones LFENCE y enmascarado de índices.

**Fuera de alcance:** otras variantes de Spectre, Meltdown y ataques entre
procesos o contra el kernel. Las mitigaciones hardware se mencionan solo como
contexto.

**Hipótesis:** ambas mitigaciones reducirán significativamente la filtración,
aunque su eficacia y sobrecoste dependerán de la microarquitectura. Se espera que
LFENCE tenga un coste mayor que el enmascarado de índices.

## 2. Entregables

- Repositorio reproducible con código C, scripts de ejecución y análisis.
- Datos crudos en CSV por máquina y configuración.
- Figuras y tablas de E1, E2 y E3.
- Informe final en PDF.
- Presentación de defensa final y demo de respaldo grabada.
- Ficha de cada equipo: CPU, family/model/stepping, microcódigo, kernel,
  compilador, flags y mitigaciones activas.

## 3. Estructura del repositorio

```text
spectre-v1/
  Makefile
  README.md
  PLAN.md
  src/
    common.h
    spectre.h
    e1_cache.c
    e2_spectre.c
    e3_mitigations.c
  scripts/
    collect_env.sh
    run_e1.sh
    run_e2.sh
    run_e3.sh
    run_all.sh
  analysis/
    plot_e1.py
    plot_e2.py
    plot_e3.py
  data/
    <machine_id>/
  figures/
  report/
  slides/
```

## 4. Fases

### Fase 0 — Inventario y viabilidad (2–3 días)

**Objetivo:** saber en qué hardware se puede medir y confirmar que el PoC filtra
al menos en una máquina antes de invertir tiempo en el harness.

- [ ] Cada integrante ejecuta y guarda la salida de:

  ```bash
  lscpu
  grep -m1 'model name' /proc/cpuinfo
  grep -m1 'cpu family' /proc/cpuinfo
  grep -m1 '^model[[:space:]]*:' /proc/cpuinfo
  grep -m1 'stepping' /proc/cpuinfo
  grep -m1 'microcode' /proc/cpuinfo
  systemd-detect-virt
  cat /sys/devices/system/cpu/vulnerabilities/spectre_v1
  ```

- [ ] Construir `docs/machines.md` con una fila por equipo: CPU, familia, modelo,
  stepping, microcódigo, núcleos/hilos, L1/L2/L3, kernel, GCC y si es VM.
- [ ] Confirmar que hay al menos 2–3 microarquitecturas distintas. Si no, decidir
  el plan alternativo antes de continuar.
- [ ] Compilar el `spectre.c` original **sin `_mm_lfence()`** y ejecutarlo en cada
  máquina. Registrar si recupera el secreto o no.
- [ ] Si no filtra: ajustar umbral y patrón de entrenamiento. Si sigue sin
  filtrar, documentarlo y apoyarse en las máquinas que sí filtran.

**Verificación:** existe una tabla de equipos completa y al menos una máquina
recupera el secreto de prueba.

### Fase 1 — Repositorio y harness (2–3 días)

**Objetivo:** tener una base común, compilable y con salida CSV, antes de medir.

- [ ] Crear la estructura de carpetas y el `Makefile`.
- [ ] Implementar `src/common.h`:
  - `rdtscp` con ordenación suficiente.
  - `clflush`, `mfence`, `lfence`.
  - lectura `volatile`.
  - escritura de CSV.
- [ ] Implementar `src/spectre.h` con los arrays víctima, el secreto y las tres
  variantes de la función vulnerable.
- [ ] Crear `scripts/collect_env.sh` para guardar la ficha del equipo junto a los
  datos.
- [ ] Fijar el esquema CSV común (ver sección 6).
- [ ] Compilar con `-O2` como configuración principal y `-O0` como control.

**Verificación:** `make` compila E1, E2 y E3; una ejecución de humo genera una
línea CSV válida.

### Fase 2 — E1: latencia de caché (3–4 días)

**Objetivo:** calibrar el umbral de acierto/fallo de cada máquina.

- [ ] Implementar `src/e1_cache.c` con un buffer grande y medidas de acceso en
  caliente y en frío usando `clflush` + `rdtscp`.
- [ ] Aleatorizar direcciones y fijar el proceso a un núcleo físico.
- [ ] Tomar 10.000 muestras por modo y máquina.
- [ ] Generar histogramas y calcular mediana, p5 y p95.
- [ ] Elegir el umbral en el valle entre los dos modos y guardarlo en
  `docs/thresholds.md`.
- [ ] No usar el valor 80 del PoC original: es específico de Intel.

**Verificación:** los histogramas muestran dos modos separados y el umbral
clasifica correctamente la mayoría de accesos.

### Fase 3 — E2: fuga base (1 semana)

**Objetivo:** reproducir Spectre V1 y medir la tasa de recuperación por byte.

- [ ] Partir del PoC de Kocher.
- [ ] Quitar `_mm_lfence()` de `victim_function` para la versión base.
- [ ] Añadir `__attribute__((noinline))` y evitar que el compilador elimine el
  bucle o el acceso.
- [ ] Pasar el umbral por argumento y fijar el número de intentos.
- [ ] Verificar el ensamblador con `objdump -d`: debe quedar un salto condicional
  real antes del acceso, no un `cmov` que elimine la vulnerabilidad.
- [ ] Barrido de entrenamiento: 2, 4, 5, 6, 8 y 10 aciertos por ataque.
- [ ] Probar `-O0` y `-O2`.
- [ ] Ejecutar 50–100 repeticiones por configuración con un secreto de 40 bytes.
- [ ] Medir: acierto por byte, margen entre el primero y el segundo, tasa de
  “unclear” e intentos-hasta-éxito si se usa parada temprana.

**Verificación:** al menos una máquina recupera el secreto por encima del azar,
con intervalo de confianza.

### Fase 4 — E3: mitigaciones (1 semana)

**Objetivo:** comparar eficacia y sobrecoste de LFENCE y del enmascarado.

Variantes:

1. **Base:** `if (x < array1_size) temp &= array2[array1[x] * 512];`
2. **LFENCE:** `_mm_lfence()` después del chequeo y antes del acceso.
3. **Máscara:** `mask = -(size_t)(x < array1_size); idx = x & mask;` y acceso con
   `idx`. Verificar que el compilador genera una dependencia de datos y no un
   salto.

Tareas:

- [ ] Implementar las tres variantes en `src/spectre.h`.
- [ ] Verificar el ensamblador de cada una con `objdump -d`.
- [ ] Repetir el protocolo de E2 para medir eficacia, con la misma configuración
  base por máquina.
- [ ] Implementar el bucle de sobrecoste: 10 millones de iteraciones, mezcla de
  índices válidos, 30 repeticiones, mediana y p95 de ciclos/iteración.
- [ ] Reportar ciclos absolutos y porcentaje relativo frente a la base.

**Verificación:** la base filtra; LFENCE y máscara reducen la fuga a cero o a una
cota muy baja; el sobrecoste es medible y comparable.

### Fase 5 — Campaña y análisis (1 semana)

- [ ] Ejecutar `scripts/run_all.sh` en todas las máquinas.
- [ ] Mergear los CSV por `machine_id`.
- [ ] Generar figuras:
  - histogramas de E1;
  - acierto por byte y barrido de entrenamiento de E2;
  - eficacia de E3;
  - scatter de sobrecoste frente a fuga.
- [ ] Calcular intervalos de confianza por bootstrap.
- [ ] Discutir: ¿se cumple la hipótesis? ¿LFENCE costó más que la máscara? ¿Influyó
  la microarquitectura? ¿Hubo máquinas sin fuga? ¿Por qué?

**Verificación:** todas las figuras y tablas se regeneran desde los CSV con los
scripts del repositorio.

### Fase 6 — Informe y defensa final (1–2 semanas)

**Informe:**

1. Resumen.
2. Introducción: motivación, pregunta, objetivos y contribución.
3. Fundamentos: pipeline, ejecución fuera de orden, predicción de saltos,
   especulación, caché y estado arquitectónico frente a microarquitectónico.
4. Spectre V1: modelo de amenaza, código C, ensamblador, línea temporal y
   Flush+Reload.
5. Metodología: equipos, controles, E1/E2/E3, métricas y validez.
6. Resultados: E1, E2, E3 y comparación entre máquinas.
7. Discusión: hipótesis, diferencias microarquitectónicas, limitaciones.
8. Conclusiones y trabajo futuro.
9. Referencias.
10. Anexos: código, datos crudos y fichas de equipos.

**Defensa final (12–15 diapositivas):**

1. Título y gancho.
2. Motivación.
3. Pipeline, especulación, predictor y caché.
4. Spectre V1: código, ensamblador y línea temporal.
5. Pregunta y objetivos.
6. Metodología E1/E2/E3.
7. Tabla de equipos.
8. E1: histogramas y umbrales.
9. E2: recuperación por byte y entrenamiento.
10. E3: eficacia.
11. E3: sobrecoste y scatter.
12. Discusión.
13. Limitaciones.
14. Conclusiones.
15. Referencias / Q&A.

**Demo:** mostrar la versión base leyendo el secreto y LFENCE/máscara fallando.
Llevar un vídeo grabado como respaldo.

**Verificación:** ensayo cronometrado, demo probada en la máquina de la defensa y
respuestas preparadas para las preguntas previsibles.

## 5. Protocolo experimental

- Ejecutar en Linux nativo. Evitar VM en los resultados principales; si no queda
  otra, documentarlo y excluirlo de la comparación.
- Fijar el proceso a un núcleo físico con `taskset`; dejar el sibling SMT idle.
- Gobernador `performance`; registrar frecuencia y si hay turbo.
- Umbral calibrado por máquina con E1.
- Número fijo de intentos para comparar variantes; la parada temprana se reporta
  aparte.
- Verificar el ensamblador de cada variante con `objdump -d`.
- Repeticiones suficientes, mediana/p95 e intervalos de confianza; no concluir con
  una sola ejecución.
- Mismo código y flags en todas las máquinas; compilar localmente.
- Documentar resultados negativos: una máquina sin fuga es un resultado.

## 6. Esquema CSV

```text
machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,variant,threshold,train,run,byte,guess,score1,score2,success,cycles
```

- `variant`: `baseline`, `lfence`, `mask`.
- `success`: 1 si el byte recuperado coincide con el secreto, 0 si no.
- `cycles`: solo para las filas de sobrecoste.

## 7. Cronograma orientativo

| Semana | Foco | Entregable |
|---|---|---|
| 1 | Inventario, repo, viabilidad, E1 | `machines.md`, umbrales |
| 2 | E2 base y barrido | CSV E2 |
| 3 | E2 campaña + variantes E3 | CSV E2 completo, código E3 |
| 4 | E3 campaña | CSV E3 |
| 5 | Análisis y borrador | figuras y draft |
| 6 | Informe, slides y ensayo | PDF, defensa, demo |

Si la fecha aprieta, priorizar E1/E2/E3 y recortar el barrido de entrenamiento.
No recortar la verificación del ensamblador ni los intervalos de confianza.

## 8. Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| Ninguna máquina filtra | Ajustar umbral/entrenamiento; probar otra máquina; documentar el resultado negativo |
| Solo hay una microarquitectura | Comparar configuraciones/compiladores y declarar la limitación; buscar una máquina prestada |
| El compilador elimina la vulnerabilidad | `objdump -d`, `-O0` como control, `noinline`, `volatile` |
| El enmascarado se optimiza a un salto | Usar dependencia de datos o `cmp`/`sbb` en ensamblador y verificar |
| Ruido de medidas | `taskset`, gobernador `performance`, repeticiones, mediana/p95, CIs |
| VM contamina los tiempos | Excluir de la comparación principal y documentar |
| Falta de tiempo | Priorizar E1/E2/E3; dejar extras para anexos |

## 9. Primeros tres días

1. Pedir a cada integrante la ficha de CPU y confirmar cuántas microarquitecturas
   hay.
2. Quitar `_mm_lfence()` del PoC y probarlo en el Ryzen actual; si no filtra,
   ajustar umbral y entrenamiento antes de seguir.
3. Crear el repo, el esquema CSV y repartir roles: harness, campaña de medidas,
   análisis, informe y slides.

## 10. Referencias

- P. Kocher et al., “Spectre Attacks: Exploiting Speculative Execution”, IEEE
  S&P 2019.
- Documentación de AMD e Intel sobre ejecución especulativa y LFENCE.
- Documentación del kernel Linux sobre mitigaciones de Spectre.
- P0928R1, “Mitigating Spectre v1 Attacks in C++”.
- Y. Zhu et al., “Place Protections at the Right Place: Targeted Hardening for
  Cryptographic Code against Spectre v1”, USENIX Security 2025.
