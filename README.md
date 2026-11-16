# Spectre V1 — Proyecto de Arquitectura Avanzada

Repositorio de trabajo para el proyecto **Spectre V1: ejecución especulativa,
predicción de saltos y canales laterales en caché**.

El plan de ejecución completo está en [`PLAN.md`](PLAN.md): fases, experimentos
E1/E2/E3, protocolo de medida, cronograma, riesgos y estructura de la defensa
final. Las instrucciones para agentes de IA están en [`AGENTS.md`](AGENTS.md).

## Cómo empezar

1. Lee [`PLAN.md`](PLAN.md).
2. Sigue [`docs/onboarding.md`](docs/onboarding.md) para la Fase 0.
3. Consulta [`CONTRIBUTING.md`](CONTRIBUTING.md) para el flujo de trabajo.
4. Rellena tu equipo en [`docs/machines.md`](docs/machines.md).
5. Antes de medir, lee [`docs/metrics.md`](docs/metrics.md) y
   [`data/README.md`](data/README.md).

## Referencias

El material de consulta está en [`references/`](references/README.md): paper
original, PoC, análisis de Kocher, propuesta P0928R1 y paper de USENIX Security
2025.

## Estado

- [x] Propuesta definida.
- [x] Guía de colaboración, onboarding y métricas.
- [ ] Inventario de equipos y prueba de viabilidad.
- [ ] E1: calibración de latencia de caché.
- [ ] E2: reproducción de la fuga.
- [ ] E3: LFENCE y enmascarado de índices.
- [ ] Campaña multi-máquina y análisis.
- [ ] Informe y defensa final.
