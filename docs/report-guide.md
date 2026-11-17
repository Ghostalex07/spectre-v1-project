# Guía del informe

El informe cuenta una historia: **qué mecanismo permite la fuga, cómo se
reproduce, cuánto filtra y cuánto cuesta mitigarlo**. No es un diario de
depuración ni una colección de capturas.

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
5. **Metodología** (3–4 páginas): equipos, protocolo, E1/E2/E3, métricas,
   controles y validez.
6. **Resultados** (5–7 páginas): E1, E2, E3 y comparación entre máquinas.
7. **Discusión** (2–3 páginas): hipótesis, diferencias microarquitectónicas,
   coste de LFENCE frente a máscara, limitaciones.
8. **Conclusiones y trabajo futuro** (1–2 páginas).
9. **Referencias**.
10. **Anexos**: código, datos crudos, fichas de equipos, comandos.

## Figuras y tablas mínimas

| Elemento | Qué debe mostrar | Fuente |
|---|---|---|
| Tabla de equipos | CPU, familia/modelo/stepping, microcódigo, kernel, GCC, VM/nativo | `docs/machines.md` |
| Tabla de umbrales | hit/miss, mediana/p5/p95, umbral elegido | `docs/thresholds.md` |
| Figura E1 | Histograma hit/miss con el umbral marcado | `analysis/plot_e1.py` |
| Tabla E2 | Tasa por variante y `train`, con IC de Wilson | `analysis/plot_e2.py` |
| Figura E2 | Recuperación vs `train` y por byte | `analysis/plot_e2.py` |
| Tabla E3 | Eficacia, mediana/p95 de ciclos, sobrecoste absoluto/porcentual | `analysis/plot_e3.py` |
| Figura E3 | Sobrecoste por variante | `analysis/plot_e3.py` |
| Figura E3 | Scatter eficacia/sobrecoste | `analysis/plot_e3.py` |

No inventes una figura “bonita” que no salga de los CSV. Si una máquina no
filtra, inclúyela en la tabla y explica por qué.

## Metodología: qué debe quedar claro

- **Modelo de amenaza:** mismo proceso, secreto de prueba, atacante que puede
  medir tiempos. No es un ataque remoto ni cross-process.
- **Aislamiento:** Linux nativo, `taskset`, SMT sibling idle, gobernador
  registrado, mismas flags.
- **E1:** cómo se mide `hit`/`miss`, cuántas muestras, cómo se elige el umbral.
- **E2:** número de intentos fijo, `train`, `runs`, bytes, umbral, variantes y
  revisión del ensamblador.
- **E3:** iteraciones, repeticiones, definición de ciclos/iteración y
  comparación contra baseline.
- **Estadística:** tasa global, IC de Wilson, bootstrap para medianas, `unclear`
  y límite superior para `0/N`.
- **Validez:** VM excluidas, resultados negativos incluidos, cambios de umbral
  documentados.

## Resultados: cómo escribirlos

- Empieza por lo que se ve: “la versión base recuperó 40/40 bytes; LFENCE y
  máscara, 0/40”.
- Da la incertidumbre: “40/40, IC 95 % [91,2 %, 100 %]” no es lo mismo que
  “100 %”.
- Separa eficacia de coste: una mitigación puede ser eficaz y cara; otra puede
  ser barata y no serlo.
- Explica los casos raros: `guess=1` en máscara es el acceso constante a
  `array1[0]`, no una fuga del secreto.
- Si una máquina no filtra, no la escondas: es parte del resultado comparativo.

## Discusión: preguntas que debes responder

- ¿Se cumple la hipótesis?
- ¿LFENCE costó más que la máscara? ¿Cuánto?
- ¿La eficacia depende de la microarquitectura? ¿Cómo se ve en los datos?
- ¿Hubo máquinas sin fuga? ¿Qué las diferencia?
- ¿Qué limitaciones tiene el experimento? (mismo proceso, secreto sintético,
  umbral por máquina, ruido, VM, número de equipos).
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

./scripts/run_all.sh <machine_id> <threshold>

python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e2.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>
```

Las tablas de los scripts se pueden copiar al informe, pero revisa que las
cifras coincidan con los CSV y que la fecha/configuración estén claras.
