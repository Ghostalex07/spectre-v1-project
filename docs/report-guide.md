# Guía del informe

El informe cuenta una historia: **qué mecanismo permite la fuga, cómo se
caracteriza la caché y cuánto cuesta mitigarlo**. No es un diario de depuración
ni una colección de capturas.

El foco experimental es E1 (caché) y E3 (rendimiento). E2 se aborda con análisis
documental y simulación conceptual; la validación en hardware es opcional y va
como anexo.

## Estructura recomendada

1. **Resumen** (1 página): pregunta, método, resultados principales y
   conclusión. Escríbelo al final.
2. **Introducción** (2–3 páginas): motivación, pregunta de investigación,
   objetivos y contribución.
3. **Fundamentos** (3–4 páginas): pipeline, ejecución fuera de orden,
   predicción de saltos, especulación, jerarquía de caché y diferencia entre
   estado arquitectónico y microarquitectónico.
4. **Spectre V1** (4–5 páginas): modelo de amenaza, código C, ensamblador,
   línea temporal del ataque y Flush+Reload.
5. **Metodología** (3–4 páginas): equipos, protocolo, E1/E3 como experimentos
   principales, E2 documental y modelo conceptual, métricas, controles y validez.
6. **Resultados E1** (2–3 páginas): caracterización de caché y umbrales.
7. **Mecanismo E2** (2–3 páginas): análisis documental, línea temporal y
   simulación conceptual; no es un resultado experimental. La validación
   opcional en hardware va como anexo separado.
8. **Resultados E3** (3–4 páginas): sobrecoste y comparación entre máquinas.
   No se presenta una tasa de recuperación como resultado principal.
9. **Discusión** (2–3 páginas): hipótesis de coste, diferencias
   microarquitectónicas, límites de la evidencia y ausencia de comportamiento
   observable.
10. **Conclusiones y trabajo futuro** (1–2 páginas).
11. **Referencias**.
12. **Anexos**: código, datos crudos, fichas de equipos y comandos. El posible
    anexo de la PoC E2 en hardware queda pendiente de confirmar con el profesor.

## Figuras y tablas mínimas

| Elemento | Qué debe mostrar | Fuente |
|---|---|---|
| Tabla de equipos | CPU, familia/modelo/stepping, microcódigo, kernel, GCC, VM/nativo | `docs/machines.md` |
| Tabla de umbrales | hit/miss, mediana/p5/p95, umbral elegido | `docs/thresholds.md` |
| Figura E1 | Histograma hit/miss con el umbral marcado | `analysis/plot_e1.py` |
| Tabla E2 | Línea temporal y supuestos del modelo | `analysis/simulate_spectre.py` |
| Figura E2 | Aciertos por línea en `baseline`/`lfence`/`mask` (modelo) | `analysis/simulate_spectre.py` |
| Tabla E3 | Mediana/p95 de ciclos, sobrecoste absoluto/porcentual | `analysis/plot_e3.py` |
| Figura E3 | Sobrecoste por variante | `analysis/plot_e3.py` |
| Figura E3 | Comparación entre máquinas | `analysis/compare_machines.py` |

No inventes una figura “bonita” que no salga de los CSV o del modelo. La PoC E2
en hardware no forma parte de los resultados; su inclusión como anexo está
pendiente de confirmación con el profesor (ver [`e2-anexo.md`](e2-anexo.md)).

## Metodología: qué debe quedar claro

- **Modelo de amenaza:** mismo proceso, secreto de prueba, atacante que puede
  medir tiempos. No es un ataque remoto ni cross-process.
- **Aislamiento:** Linux nativo, `taskset`, SMT sibling idle, gobernador
  registrado, turbo documentado, warm-up descartado y orden de variantes
  aleatorizado o alternado. Mismas flags.
- **E1:** cómo se mide `hit`/`miss`, cuántas muestras, cómo se elige el umbral
  en el valle del histograma.
- **E2:** análisis documental y modelo conceptual; supuestos y límites. La
  validación en hardware solo va al anexo, con número fijo de intentos y umbral.
- **E3:** iteraciones, repeticiones, definición de ciclos/iteración y
  comparación contra baseline. **Solo sobrecoste**: la eficacia se argumenta con
  el ensamblador y el modelo, no con una tasa de recuperación.
- **Estadística:** mediana, p5, p95 e IQR; IC bootstrap para medianas; IC de
  Wilson para proporciones; `unclear` y cota superior para `0/N`. No usar media y
  desviación típica como métrica principal.
- **Reproducibilidad:** scripts, CSV crudos, flags, GCC, kernel, microcódigo y
  `/sys/devices/system/cpu/vulnerabilities/spectre_v1` de cada equipo.
- **Validez:** VM excluidas, resultados negativos incluidos, cambios de umbral
  documentados y conclusiones limitadas a las condiciones medidas.

## Resultados: cómo escribirlos

- Empieza por E1: “la caché muestra dos modos separados; el umbral elegido es
  T para esta máquina”.
- Sigue por E3: “LFENCE cuesta X % más; la máscara, Y %”.
- Presenta E2 como mecanismo: línea temporal, modelo y límites. La PoC en
  hardware no es un resultado; no la uses para afirmar eficacia.
- Da la incertidumbre: “N/N, IC 95 % [a, b]” no es lo mismo que “100 %”.
- Separa eficacia de coste: una mitigación puede ser eficaz y cara; otra puede
  ser barata y no serlo.
- Explica los casos raros: `guess=1` en máscara es el acceso constante a
  `array1[0]`, no una fuga del secreto.
- Si una máquina no filtra, no la escondas: es parte del resultado comparativo.
- Para arrancar las tablas, ejecuta `make summary` y usa
  `report/results_summary.md`; después redacta la interpretación, no solo los
  números.

## Discusión: preguntas que debes responder

- ¿Se cumple la hipótesis de coste?
- ¿LFENCE costó más que la máscara? ¿Cuánto?
- ¿El sobrecoste depende de la microarquitectura? ¿Cómo se ve en los datos?
- En AMD, LFENCE no era históricamente serializante de dispatch por defecto;
  Linux activa ese comportamiento mediante un bit de un MSR cuando aplica la
  mitigación de Spectre. Por tanto, el coste de LFENCE puede depender del
  fabricante y de la configuración del sistema, no solo de la microarquitectura.
  Es un buen punto de discusión sobre compromisos de diseño.
  **PENDIENTE: añadir referencia exacta de AMD y del kernel Linux.**
- ¿Qué genera `-mspeculative-load-hardening` de Clang frente al enmascarado
  manual inspirado en `array_index_nospec`?
- ¿Qué explica el modelo y qué no puede explicar?
- ¿Se incluye finalmente el anexo E2 en hardware o se deja fuera?
- ¿Qué limitaciones tiene el experimento? (mismo proceso, secreto sintético,
  umbral por máquina, ruido, VM, número de equipos, modelo simplificado). La
  lista cerrada está en [`docs/limitations.md`](limitations.md).
- ¿Qué harías con más tiempo? (más microarquitecturas, más variantes, energía,
  otras mitigaciones, etc.). No lo presentes como resultado.

## Estilo

- Una idea por párrafo; frases cortas.
- Cada figura debe tener una frase que diga qué mirar.
- No pegues capturas de terminal; usa tablas y figuras.
- No uses “obviamente”, “siempre” o “nunca” sin datos.
- Distingue “no se observó” de “no es posible”.
- Cita el paper original, la documentación de AMD/Intel y el kernel.
- Mantén los nombres de las variantes (`baseline`, `lfence`, `mask`) iguales en
  todo el informe.

## Checklist antes de entregar

- [ ] La pregunta de investigación aparece en la introducción y se responde en
      las conclusiones.
- [ ] Todas las figuras se regeneran desde `data/` con los scripts.
- [ ] Todas las tablas tienen unidades y número de muestras.
- [ ] Los IC y los `unclear` están reportados.
- [ ] Las limitaciones son explícitas.
- [ ] Las referencias están completas y son las mismas que en `references/`.
- [ ] No hay resultados inventados ni ejecuciones borradas.
- [ ] El PDF se genera desde la fuente versionada, no desde una copia suelta.

## Comandos útiles

```bash
make
make smoke
make test

./scripts/run_all.sh <machine_id> <threshold>

python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>
python3 analysis/simulate_spectre.py --attempts 200 --train 5 \
  --out data/simulation/spectre_model.csv \
  --figure figures/simulation_spectre.png
```

Las tablas de los scripts se pueden copiar al informe, pero revisa que las
cifras coincidan con los CSV y que la fecha/configuración estén claras.
