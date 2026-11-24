# Spectre V1 — Proyecto de Arquitectura Avanzada

Repositorio de trabajo para el proyecto **Spectre V1: ejecución especulativa,
predicción de saltos y canales laterales en caché**.

El objetivo es explicar cómo la ejecución especulativa puede filtrar información
a través de la caché y medir el **coste en rendimiento** de **LFENCE** y del
**enmascarado de índices** en distintos procesadores.

El enfoque experimental, revisado tras el feedback del profesor, es:

- **E1:** caracterización de la caché (experimento principal): calibración
  hit/miss y barrido jerárquico de pointer chasing.
- **E2:** análisis documental + modelo conceptual
  (`analysis/simulate_spectre.py`). No es un experimento práctico.
- **E3:** impacto de las mitigaciones en rendimiento (experimento principal).

## Cómo empezar

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project

make
make smoke
make test

./scripts/collect_env.sh <machine_id>
./scripts/run_e1.sh <machine_id> 10000 64
python3 analysis/plot_e1.py --machine-id <machine_id>

./scripts/run_e1_hierarchy.sh <machine_id>
./scripts/run_e1_timer.sh <machine_id>
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
```

Elige el umbral en el valle del histograma, anótalo en
[`docs/thresholds.md`](docs/thresholds.md) y ejecuta la campaña:

```bash
THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

El manual completo, con todos los comandos y la interpretación de cada
resultado, está en [`docs/manual.md`](docs/manual.md). El modelo conceptual de
E2 se explica en [`docs/simulation.md`](docs/simulation.md):

```bash
python3 analysis/simulate_spectre.py --attempts 200 --train 5 \
  --out data/simulation/spectre_model.csv \
  --figure figures/simulation_spectre.png
```

## Documentación

| Documento | Contenido |
|---|---|
| [`PLAN.md`](PLAN.md) | Plan, fases, experimentos, protocolo, cronograma y riesgos |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Acceso, flujo de trabajo, roles y definición de “hecho” |
| [`docs/onboarding.md`](docs/onboarding.md) | Primeros pasos y Fase 0 |
| [`docs/campaign.md`](docs/campaign.md) | Campaña final por máquina: qué hace cada integrante |
| [`docs/manual.md`](docs/manual.md) | Manual completo del harness |
| [`docs/simulation.md`](docs/simulation.md) | Modelo conceptual de E2 y sus límites |
| [`docs/e2-anexo.md`](docs/e2-anexo.md) | Estado de la PoC de E2 como posible anexo |
| [`docs/plan-cambios.md`](docs/plan-cambios.md) | Plan y decisiones de la reorientación |
| [`docs/asm/`](docs/asm/) | Desensamblado de las variantes de E3 |
| [`docs/metrics.md`](docs/metrics.md) | Métricas, IC y esquemas CSV |
| [`docs/thresholds.md`](docs/thresholds.md) | Umbral de cada máquina |
| [`docs/machines.md`](docs/machines.md) | Ficha de cada equipo |
| [`docs/troubleshooting.md`](docs/troubleshooting.md) | Errores típicos |
| [`docs/glossary.md`](docs/glossary.md) | Glosario |
| [`docs/report-guide.md`](docs/report-guide.md) | Guía del informe |
| [`docs/defense-guide.md`](docs/defense-guide.md) | Guía de la defensa y demo |
| [`docs/limitations.md`](docs/limitations.md) | Alcance, límites y qué no se puede afirmar |
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
    e1_hierarchy.c
    e1_timer.c
    e2_spectre.c
    e3_mitigations.c
    e3_sweep.c
  scripts/
    common.sh
    collect_env.sh
    run_e1.sh
    run_e1_hierarchy.sh
    run_e1_timer.sh
    run_e2.sh
    run_e3.sh
    run_all.sh
    smoke.sh
    demo.sh
  analysis/
    common.py
    compare_machines.py
    compare_extended.py
    regenerate.py
    validate_data.py
    plot_e1.py
    plot_e1_hierarchy.py
    plot_e2.py
    plot_e3.py
    plot_e3_sweep.py
    simulate_spectre.py
    summarize_results.py
    requirements.txt
  tests/
    test_compare_machines.py
    test_e1_hierarchy.py
    test_e3_asm.py
    test_e3_sweep.py
    test_simulate_spectre.py
    test_stats.py
    test_stats_extra.py
    test_summarize_results.py
    test_validate_data.py
  data/<machine_id>/
  data/derived/
  data/simulation/
  figures/
  docs/
  report/
  slides/
  references/
```

## Estado

- [x] Propuesta definida.
- [x] Repositorio y documentación de colaboración.
- [x] Harness E1/E3 compilable y con `make smoke`.
- [x] E1/E3 validados en el Ryzen 5 PRO 5675U de referencia.
- [x] Modelo conceptual de E2 (`analysis/simulate_spectre.py`).
- [x] Enfoque reorientado: E1/E3 empíricos; E2 documental y simulación.
- [x] Resumen de resultados con IC bootstrap (`make summary`).
- [x] E1 jerárquico y coste del temporizador implementados (campaña PENDIENTE).
- [x] E3 con barrido de sensibilidad y verificación del ensamblador.
- [ ] Campaña multi-máquina de E1 jerárquico y del barrido de E3.
- [ ] Confirmar con el profesor el anexo de E2.
- [ ] Informe y defensa final.

La campaña de referencia del Ryzen está en `data/ryzen5pro5675u/` y es una
**ejecución de validación**, no la campaña final. Consulta
[`data/README.md`](data/README.md).

## Resultados de referencia

### E1 y E3 (experimentación principal)

E1 en el Ryzen 5 PRO 5675U: `hit` mediana 46 ciclos, `miss` mediana 276;
umbral usado 80. E1 jerárquico: **PENDIENTE** de la campaña por máquina; el
harness y el análisis están implementados, pero aún no hay datos en
`data/` para publicar mesetas.

E3 con 1M iteraciones y 3 repeticiones:

```text
baseline: 3.33 ciclos/iteración
lfence:  13.52 ciclos/iteración  (~4.06x, +306 %)
mask:     3.68 ciclos/iteración  (~1.11x, +10.7 %)
```

Campaña final de esa misma CPU, 10M iteraciones y 30 repeticiones:

```text
baseline: 3.34 ciclos/iteración
lfence:  13.40 ciclos/iteración  (~4.01x, +300.6 %)
mask:     3.39 ciclos/iteración  (~1.01x, +1.3 %)
```

La diferencia de `mask` entre 3 y 30 repeticiones se discute en
[`docs/metrics.md`](docs/metrics.md); la campaña de 30 repeticiones es la que
debe citarse.

### E2: modelo conceptual

El modelo conceptual recupera el secreto en `baseline` y no en `lfence`/`mask`.
Son resultados **del modelo**, no medidas de hardware:

```text
baseline  40/40 bytes correctos (modelo)
lfence    0/40 bytes correctos (modelo)
mask      0/40 bytes correctos (modelo)
```

La PoC en hardware del periodo de validación no forma parte de la
experimentación. Su posible inclusión como anexo está pendiente de confirmar con
el profesor: [`docs/e2-anexo.md`](docs/e2-anexo.md).

Es la misma microarquitectura, no una CPU distinta. Los detalles y las figuras
se regeneran con `make figures`.

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

## Campaña multi-máquina y regeneración

La campaña nueva separa los datos por sesión: `data/<machine_id>/<session_id>/`.
Cada sesión incluye su ficha `env_<machine_id>.txt`, E1 de calibración, E1
jerárquico, coste del temporizador y E3 de barrido. Los datos antiguos de
`data/<machine_id>/` se siguen leyendo.

```bash
SESSION_ID=2026-11-24_01 ./scripts/collect_env.sh <machine_id>
SESSION_ID=2026-11-24_01 ./scripts/run_e1.sh <machine_id>
SESSION_ID=2026-11-24_01 ./scripts/run_e1_hierarchy.sh <machine_id>
SESSION_ID=2026-11-24_01 ./scripts/run_e1_timer.sh <machine_id>
SESSION_ID=2026-11-24_01 PROFILE=default ./scripts/run_e3.sh <machine_id>
```

Para regenerar figuras y tablas a partir de los CSV:

```bash
make figures
make validate
```

`make figures` ejecuta los análisis de E1, E1 jerárquico, E3 antiguo, barrido
E3, la comparativa entre máquinas y el resumen. `make validate` comprueba que
cada CSV de una sesión nueva tiene su ficha de entorno.

Documentos nuevos: [`docs/plan-cambios.md`](docs/plan-cambios.md),
[`docs/e2-anexo.md`](docs/e2-anexo.md) y `docs/asm/`.
