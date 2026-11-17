# Spectre V1 — Proyecto de Arquitectura Avanzada

Repositorio de trabajo para el proyecto **Spectre V1: ejecución especulativa,
predicción de saltos y canales laterales en caché**.

El objetivo es explicar cómo la ejecución especulativa puede filtrar información
a través de la caché, reproducirlo en un entorno controlado y medir la eficacia
y el coste de **LFENCE** y del **enmascarado de índices** en distintos
procesadores.

## Cómo empezar

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project

make
make smoke

./scripts/collect_env.sh <machine_id>
./scripts/run_e1.sh <machine_id> 10000 64
python3 analysis/plot_e1.py --machine-id <machine_id>
```

Elige el umbral en el valle del histograma, anótalo en
[`docs/thresholds.md`](docs/thresholds.md) y ejecuta la campaña:

```bash
THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

El manual completo, con todos los comandos y la interpretación de cada
resultado, está en [`docs/manual.md`](docs/manual.md).

## Documentación

| Documento | Contenido |
|---|---|
| [`PLAN.md`](PLAN.md) | Plan, fases, experimentos, protocolo, cronograma y riesgos |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Acceso, flujo de trabajo, roles y definición de “hecho” |
| [`docs/onboarding.md`](docs/onboarding.md) | Primeros pasos y Fase 0 |
| [`docs/manual.md`](docs/manual.md) | Manual completo del harness |
| [`docs/metrics.md`](docs/metrics.md) | Métricas, IC y esquemas CSV |
| [`docs/thresholds.md`](docs/thresholds.md) | Umbral de cada máquina |
| [`docs/machines.md`](docs/machines.md) | Ficha de cada equipo |
| [`docs/troubleshooting.md`](docs/troubleshooting.md) | Errores típicos |
| [`docs/glossary.md`](docs/glossary.md) | Glosario |
| [`docs/report-guide.md`](docs/report-guide.md) | Guía del informe |
| [`docs/defense-guide.md`](docs/defense-guide.md) | Guía de la defensa y demo |
| [`references/`](references/README.md) | Paper, PoC y material de consulta |

## Estructura

```text
spectre-v1-project/
  Makefile
  README.md
  PLAN.md
  CONTRIBUTING.md
  AGENTS.md
  src/
    common.h
    spectre.h
    e1_cache.c
    e2_spectre.c
    e3_mitigations.c
  scripts/
    common.sh
    collect_env.sh
    run_e1.sh
    run_e2.sh
    run_e3.sh
    run_all.sh
    smoke.sh
    demo.sh
  analysis/
    common.py
    plot_e1.py
    plot_e2.py
    plot_e3.py
    requirements.txt
  data/<machine_id>/
  figures/
  docs/
  report/
  slides/
  references/
```

## Estado

- [x] Propuesta definida.
- [x] Repositorio y documentación de colaboración.
- [x] Harness E1/E2/E3 compilable y con `make smoke`.
- [x] E1/E2/E3 validados en el Ryzen 5 PRO 5675U de referencia.
- [ ] Campaña multi-máquina.
- [ ] Informe y defensa final.

La campaña de referencia del Ryzen está en `data/ryzen5pro5675u/` y es una
**ejecución de validación**, no la campaña final. Consulta
[`data/README.md`](data/README.md).

## Resultado de referencia

En el Ryzen 5 PRO 5675U (Cezanne, Zen 3), con umbral 80, 300 intentos,
`train=5`, 1 run y 40 bytes:

```text
baseline: 40/40 bytes correctos
lfence:    0/40
mask:      0/40
```

Sobrecoste con 1M iteraciones y 3 repeticiones:

```text
baseline: 3.33 ciclos/iteración
lfence:  13.52 ciclos/iteración  (~4.06x, +306 %)
mask:     3.68 ciclos/iteración  (~1.11x, +10.7 %)
```

Son valores orientativos de validación. La campaña final usa 1000 intentos,
50 runs y 10M/30. Los detalles y las figuras se regeneran con los scripts de
[`analysis/`](analysis/).

## Referencias

El material de consulta está en [`references/`](references/README.md): paper
original, PoC, análisis de Kocher, propuesta P0928R1 y paper de USENIX Security
2025.

## Reglas

- Es un trabajo académico, no producción.
- No cambies la visibilidad del repositorio, los remotos ni los colaboradores.
- No modifiques `references/`.
- No uses `sudo` ni desactives mitigaciones.
- No amplíes el alcance a Meltdown, otras variantes, kernel o cross-process.
- No inventes resultados: un equipo que no filtra es un resultado.
- Las instrucciones para agentes de IA están en [`AGENTS.md`](AGENTS.md).
