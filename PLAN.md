# Plan de ejecución — Spectre V1

Proyecto de Arquitectura Avanzada. Este documento describe cómo llevar el
proyecto desde la propuesta hasta la defensa final: qué se construye, en qué
orden, con qué controles experimentales y qué se entrega.

## 0. Estado de implementación

Actualizado el 2026-11-24 tras el feedback del profesor.

- [x] Fase 1: harness, `Makefile`, scripts, análisis y documentación.
- [x] E1/E2/E3 implementados y validados en el Ryzen 5 PRO 5675U de referencia.
- [x] `make smoke` y `make test` pasan.
- [x] Modelo conceptual de E2 (`analysis/simulate_spectre.py`).
- [x] Enfoque experimental reorientado: **E1 y E3 son el núcleo empírico**;
      **E2 se cubre con análisis documental y simulación conceptual**.
- [ ] Campaña multi-máquina de E1/E3 con 2–3 microarquitecturas.
- [ ] Informe y defensa final.

Los datos de validación están en `data/ryzen5pro5675u/` (1 run en E2) y la
campaña final de esa misma CPU en `data/ryzen5pro5675u_final/` (50 runs en E2,
30 reps en E3). No son dos microarquitecturas distintas. El manual de ejecución
está en [`docs/manual.md`](docs/manual.md), la campaña por máquina en
[`docs/campaign.md`](docs/campaign.md) y el modelo conceptual en
[`docs/simulation.md`](docs/simulation.md).

## 1. Ficha del proyecto

**Título:** Spectre V1: ejecución especulativa, predicción de saltos y canales
laterales en caché.

**Pregunta de investigación:** ¿Cómo provocan la predicción de saltos y la
ejecución especulativa una filtración de información observable a través de la
caché, y qué **sobrecoste** tienen las mitigaciones de Spectre V1 en distintas
microarquitecturas? La eficacia de seguridad se argumenta con el modelo, el
ensamblador y la literatura; no se mide como experimento práctico principal.

**Objetivo general:** explicar cómo la ejecución especulativa, un mecanismo de
optimización legítimo, puede utilizarse para inferir información a través de la
caché, y medir el coste de las principales mitigaciones.

**Objetivos específicos:**

1. Describir los mecanismos de predicción de saltos, ejecución especulativa y
   caché que intervienen en Spectre V1.
2. Analizar el mecanismo de explotación mediante **análisis documental y un
   modelo conceptual reproducible**; la validación en hardware es opcional y se
   reporta como anexo, no como condición del proyecto.
3. Caracterizar experimentalmente la caché (E1) y evaluar el **sobrecoste** de
   LFENCE y del enmascarado de índices en distintas microarquitecturas (E3).
   La eficacia de seguridad se argumenta a partir del modelo, el ensamblador y
   la literatura; la validación opcional en hardware queda como anexo.

**Alcance:** pipeline, ejecución fuera de orden, predicción de saltos,
recuperación ante fallos, jerarquía de caché y diferencia entre estado
arquitectónico y microarquitectónico. Spectre V1 en un único proceso, con un
secreto de prueba, y las mitigaciones LFENCE y enmascarado de índices.

**Enfoque experimental (revisado tras el feedback del profesor):**

- **E1 — caracterización de caché:** experimentación principal. Latencia de
  acierto/fallo, histogramas y umbral por máquina.
- **E2 — mecanismo de explotación:** análisis documental (paper, PoC,
  ensamblador, línea temporal) y **simulación conceptual** con
  `analysis/simulate_spectre.py`. No depende de que una CPU concreta filtre.
- **E3 — impacto de las mitigaciones:** experimentación principal. Solo
  **sobrecoste**: ciclos por iteración de `baseline`, `lfence` y `mask` en cada
  microarquitectura. La eficacia se explica con el ensamblador y el modelo, no
  con una tasa de recuperación.
- **E2 en hardware:** opcional y fuera de los resultados principales. Si se
  ejecuta, va en un anexo como observación limitada; no se usa para afirmar que
  una mitigación es universalmente infalible ni para construir el scatter
  principal de E3.

**Fuera de alcance:** otras variantes de Spectre, Meltdown y ataques entre
procesos o contra el kernel. Las mitigaciones hardware se mencionan solo como
contexto.

**Hipótesis:** LFENCE tendrá un sobrecoste mayor que el enmascarado de índices,
con diferencias ligadas a la microarquitectura. Esta es la hipótesis que se
contrasta experimentalmente en E3. La eficacia de seguridad no se contrasta con
una tasa de recuperación: se argumenta con el ensamblador (barrera o dependencia
de datos), el modelo conceptual y la literatura. Un resultado de “no observado”
no demuestra imposibilidad, y una mitigación barata no implica que sea gratuita
en todos los contextos.

## 2. Entregables

- Repositorio reproducible con código C, scripts de ejecución y análisis.
- Datos crudos en CSV por máquina y configuración.
- Modelo conceptual reproducible (`analysis/simulate_spectre.py`) y sus salidas.
- Figuras y tablas de E1, E3 y simulación; E2 en hardware solo si se ejecuta,
  como anexo.
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
    simulate_spectre.py
  tests/
    test_simulate_spectre.py
  docs/
    simulation.md
  data/
    <machine_id>/
    simulation/
  figures/
  report/
  slides/
```

## 4. Fases

### Fase 0 — Inventario y viabilidad (2–3 días)

**Objetivo:** saber en qué hardware se puede medir E1/E3 y confirmar que hay
suficiente diversidad de microarquitecturas. La comprobación del PoC es
opcional: el proyecto no se bloquea si una máquina no filtra.

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
- [ ] (Opcional) Compilar el `spectre.c` original **sin `_mm_lfence()`** y
  ejecutarlo en cada máquina. Registrar si recupera el secreto o no. Si no
  filtra, no es un fallo del proyecto: es un resultado que se documenta.
- [ ] Confirmar que cada máquina puede ejecutar E1 y E3 (compilador, `taskset`,
  permisos y entorno nativo).

**Verificación:** existe una tabla de equipos completa, hay 2–3
microarquitecturas o un plan alternativo declarado, y E1/E3 pueden ejecutarse.
La fuga en hardware no es un criterio de aceptación.

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

**Objetivo:** caracterizar la caché de cada máquina y calibrar el umbral de
acierto/fallo. Esta fase es el núcleo experimental de caracterización, no solo
un preparativo de E2.

- [ ] Implementar `src/e1_cache.c` con un buffer grande y medidas de acceso en
  caliente y en frío usando `clflush` + `rdtscp`.
- [ ] Aleatorizar direcciones y fijar el proceso a un núcleo físico.
- [ ] Tomar 10.000 muestras por modo y máquina.
- [ ] Generar histogramas y calcular mediana, p5 y p95.
- [ ] Elegir el umbral en el valle entre los dos modos y guardarlo en
  `docs/thresholds.md`.
- [ ] No usar el valor 80 del PoC original: es específico de Intel.
- [x] Implementar E1 jerárquico (`src/e1_hierarchy.c`): pointer chasing con
  Sattolo, barrido 4 KiB–256 MiB, sesiones y CSV con semilla y `hugepage`.
- [x] Medir el coste del temporizador (`src/e1_timer.c`) y publicarlo aparte.
- [ ] Ejecutar E1 calibración + jerarquía + temporizador en cada máquina de la
  campaña (PENDIENTE).

**Verificación:** los histogramas muestran dos modos separados, el umbral
clasifica correctamente la mayoría de accesos y se documenta la relación con la
jerarquía de caché y la frecuencia de la CPU.

### Fase 3 — E2: análisis documental y simulación conceptual (3–4 días)

**Objetivo:** explicar el mecanismo de Spectre V1 sin depender de que una CPU
concreta filtre. La experimentación principal de esta fase es documental y
conceptual; la PoC en hardware queda como validación opcional.

- [ ] Analizar el paper de Kocher, el PoC original y el ensamblador de
  `victim_function`.
- [ ] Construir la línea temporal: entrenamiento → malpredicción → acceso
  transitorio → rastro en caché → Flush+Reload.
- [ ] Implementar `analysis/simulate_spectre.py` con un modelo explícito de
  predictor de 2 bits, caché y variantes `baseline`, `lfence`, `mask`.
- [ ] Documentar los supuestos y límites del modelo en `docs/simulation.md`.
- [ ] Generar `data/simulation/spectre_model.csv` y
  `figures/simulation_spectre.png`.
- [ ] (Opcional) Validar en hardware con `src/e2_spectre.c`, manteniendo el
  umbral por máquina y el número fijo de intentos. Si se hace, va en un anexo.

**Verificación:** el modelo es reproducible, muestra que `baseline` recupera el
secreto y que `lfence`/`mask` no lo recuperan en el caso modelado, y las
limitaciones están escritas. No se exige que una máquina real filtre.

### Fase 4 — E3: mitigaciones (1 semana)

**Objetivo:** medir el **impacto en rendimiento** de LFENCE y del enmascarado en
cada microarquitectura. La eficacia de seguridad se discute con el modelo
conceptual, la literatura y, si existe, la validación opcional de E2 en
hardware.

Variantes:

1. **Base:** `if (x < array1_size) temp &= array2[array1[x] * 512];`
2. **LFENCE:** `_mm_lfence()` después del chequeo y antes del acceso.
3. **Máscara:** `mask = -(size_t)(x < array1_size); idx = x & mask;` y acceso con
   `idx`. Verificar que el compilador genera una dependencia de datos y no un
   salto.

Tareas:

- [ ] Implementar las tres variantes en `src/spectre.h`.
- [ ] Verificar el ensamblador de cada una con `objdump -d`.
- [ ] Implementar el bucle de sobrecoste: 10 millones de iteraciones, mezcla de
  índices válidos, 30 repeticiones, mediana y p95 de ciclos/iteración.
- [ ] Reportar ciclos absolutos y porcentaje relativo frente a la base.
- [ ] Comparar 2–3 microarquitecturas; si solo hay una, aplicar el plan
  alternativo y declararlo como limitación.
- [ ] Justificar la eficacia con el ensamblador de cada variante: en `lfence`,
  la barrera; en `mask`, la dependencia de datos que impide un índice fuera de
  rango. No usar una tasa de recuperación como resultado principal de E3.
- [ ] (Anexo opcional) Si se ejecutó E2 en hardware, comentar la observación sin
  mezclarla con la conclusión de sobrecoste.

**Verificación:** el sobrecoste es medible y comparable entre variantes y
máquinas. No se afirma que una mitigación sea universalmente infalible: un
`0/N` se reporta con su cota superior y como “no observado”, no como prueba de
imposibilidad.

### Fase 5 — Campaña y análisis (1 semana)

- [ ] Ejecutar `scripts/run_all.sh` en todas las máquinas.
- [ ] Mergear los CSV por `machine_id`.
- [ ] Generar figuras:
  - histogramas de E1;
  - sobrecoste de E3 por variante y máquina;
  - comparación de sobrecoste entre microarquitecturas;
  - simulación conceptual de E2;
  - anexo ilustrativo de E2 en hardware, separado de E3 y sin valor de resultado.
- [ ] Calcular intervalos de confianza por bootstrap y cotas superiores para
  resultados `0/N`.
- [ ] Discutir: ¿se cumple la hipótesis de coste? ¿LFENCE costó más que la
  máscara? ¿Influyó la microarquitectura? ¿Qué explica el modelo? ¿Qué no se
  puede concluir de los datos?

**Verificación:** todas las figuras y tablas se regeneran desde los CSV con los
scripts del repositorio. Las conclusiones distinguen evidencia empírica,
modelo y literatura.

### Fase 6 — Informe y defensa final (1–2 semanas)

**Informe:**

1. Resumen.
2. Introducción: motivación, pregunta, objetivos y contribución.
3. Fundamentos: pipeline, ejecución fuera de orden, predicción de saltos,
   especulación, caché y estado arquitectónico frente a microarquitectónico.
4. Spectre V1: modelo de amenaza, código C, ensamblador, línea temporal y
   Flush+Reload.
5. Metodología: equipos, controles, E1/E3 como experimentación principal, E2
   documental y modelo conceptual, métricas y validez.
6. Resultados E1: caracterización de caché y umbrales por máquina.
7. Mecanismo E2: análisis documental y simulación conceptual; no es un
   resultado experimental. La validación opcional en hardware va como anexo.
8. Resultados E3: sobrecoste de mitigaciones y comparación entre máquinas; sin
   tasa de recuperación como resultado principal.
9. Discusión: hipótesis de coste, diferencias microarquitectónicas, límites de
   la evidencia y ausencia de comportamiento observable.
10. Conclusiones y trabajo futuro.
11. Referencias.
12. Anexos: código, datos crudos, fichas de equipos y validación opcional E2.

**Defensa final (12–15 diapositivas):**

1. Título y gancho.
2. Motivación.
3. Pipeline, especulación, predictor y caché.
4. Spectre V1: código, ensamblador y línea temporal.
5. Pregunta y objetivos.
6. Metodología: E1/E3 empíricos; E2 documental y modelo conceptual.
7. Tabla de equipos.
8. E1: histogramas, caracterización de caché y umbrales.
9. E2: mecanismo, línea temporal y simulación conceptual.
10. E3: sobrecoste por variante.
11. E3: comparación entre microarquitecturas.
12. Discusión: coste, seguridad y compromisos.
13. Limitaciones y validez.
14. Conclusiones.
15. Referencias / Q&A.

**Demo:** si la validación opcional en hardware está disponible, mostrar
`baseline` leyendo el secreto y `lfence`/`mask` sin recuperarlo. Si no, usar la
simulación conceptual y explicar que no demuestra comportamiento universal.
Llevar un vídeo grabado como respaldo.

**Verificación:** ensayo cronometrado, demo probada en la máquina de la defensa y
respuestas preparadas para las preguntas previsibles.

## 5. Protocolo experimental

### 5.1. Control del ruido

- Ejecutar en Linux nativo. Evitar VM en los resultados principales; si no queda
  otra, documentarlo y excluirlo de la comparación.
- Fijar el proceso a un núcleo físico con `taskset`; dejar el sibling SMT idle.
- Gobernador `performance`; registrar frecuencia, turbo y si se ha podido
  desactivar. Si no se puede, queda documentado como factor de ruido.
- Descartar las iteraciones de calentamiento antes de medir.
- Aleatorizar o alternar el orden de las variantes (`baseline`, `lfence`,
  `mask`) entre repeticiones para que la deriva térmica no favorezca siempre a
  la misma.
- No mezclar ejecuciones `-O0` con la campaña principal `-O2`.

### 5.2. Estadística

- Las latencias tienen colas largas por interrupciones y migraciones. Usar
  **mediana, p5, p95 e IQR**; no usar media y desviación típica como métrica
  principal.
- Para el sobrecoste relativo, reportar mediana e **IC95 bootstrap**.
- En E1, elegir el umbral en el valle del histograma entre los modos `hit` y
  `miss`, y documentarlo por máquina. No copiar el 80 del PoC original.
- Reportar el tamaño de muestra y no concluir con una sola ejecución.
- Para `0/N`, reportar la cota superior y decir “no observado”, no “imposible”.

### 5.3. Reproducibilidad

- Mismo código y flags en todas las máquinas; compilar localmente.
- Publicar scripts, CSV crudos, flags, versión de GCC, kernel y microcódigo.
- Guardar por equipo el contenido de
  `/sys/devices/system/cpu/vulnerabilities/spectre_v1`, `lscpu` y la ficha de
  CPU en `docs/machines.md`.
- Verificar el ensamblador de cada variante con `objdump -d`.
- E1/E3 son la experimentación principal; E2 en hardware es opcional y va en
  anexo.
- Separar evidencia empírica, modelo conceptual y literatura en la discusión.
- Documentar resultados negativos: una máquina sin fuga es un resultado, no un
  fallo que se oculta.

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
| 1 | Inventario, repo, E1 calibración | `machines.md`, umbrales, CSV E1 |
| 2 | E1 jerárquico y coste del temporizador | CSV de mesetas, figura y tabla |
| 3 | E3: barrido de sensibilidad y ensamblador | CSV E3 nuevo, `docs/asm/`, `make asm` |
| 4 | Campaña en 2–3 microarquitecturas, al menos dos sesiones | CSV por máquina y sesión |
| 5 | Análisis comparativo, E2 documental y borrador | figuras, tablas y draft |
| 6 | Informe, slides y ensayo | PDF, defensa, demo |

Si la fecha aprieta, priorizar E1/E3 y la simulación conceptual. La validación
E2 en hardware es lo primero que se recorta. No recortar la verificación del
ensamblador, los intervalos de confianza ni la discusión de limitaciones.

## 8. Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| Ninguna máquina filtra en E2 hardware | No es bloqueante ni forma parte de los resultados principales: E2 se cubre con modelo y literatura; la PoC va en un anexo ilustrativo |
| El sobrecoste cae dentro del ruido | Aumentar repeticiones, aleatorizar el orden, reportar IC bootstrap y no afirmar diferencias que no se distingan del ruido |
| Solo hay una microarquitectura | Comparar configuraciones/compiladores y declarar la limitación; buscar una máquina prestada |
| El compilador elimina la vulnerabilidad | `objdump -d`, `-O0` como control, `noinline`, `volatile` |
| El enmascarado se optimiza a un salto | Usar dependencia de datos o `cmp`/`sbb` en ensamblador y verificar |
| Ruido de medidas | `taskset`, gobernador `performance`, repeticiones, mediana/p95, CIs |
| VM contamina los tiempos | Excluir de la comparación principal y documentar |
| Interpretar un `0/N` como imposibilidad | Reportar cota superior y hablar de “no observado”; discutir límites |
| Falta de tiempo | Priorizar E1/E3 y simulación; recortar E2 hardware |

## 9. Primeros tres días

1. Pedir a cada integrante la ficha de CPU y confirmar cuántas microarquitecturas
   hay.
2. Ejecutar E1 en cada máquina y anotar el umbral; no hace falta que E2 filtre.
3. Revisar `analysis/simulate_spectre.py` y `docs/simulation.md`; después
   repartir roles: E1, E3, análisis, informe y slides.

## 10. Referencias

- P. Kocher et al., “Spectre Attacks: Exploiting Speculative Execution”, IEEE
  S&P 2019.
- Documentación de AMD e Intel sobre ejecución especulativa y LFENCE.
- Documentación del kernel Linux sobre mitigaciones de Spectre.
- P0928R1, “Mitigating Spectre v1 Attacks in C++”.
- Y. Zhu et al., “Place Protections at the Right Place: Targeted Hardening for
  Cryptographic Code against Spectre v1”, USENIX Security 2025.
