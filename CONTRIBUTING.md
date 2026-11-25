# Cómo contribuir

Este repositorio es un **trabajo académico** sobre Spectre V1. No es un proyecto
de producción: prima la claridad, la reproducibilidad y no inventar resultados.

Antes de tocar nada, lee:

- [`PLAN.md`](PLAN.md): alcance, fases, experimentos y criterios de aceptación.
- [`docs/onboarding.md`](docs/onboarding.md): primeros pasos y Fase 0.
- [`docs/campaign.md`](docs/campaign.md): qué ejecuta cada integrante en su máquina.
- [`docs/ai-prompt.md`](docs/ai-prompt.md): prompt listo para la IA de cada compañero.
- [`docs/manual.md`](docs/manual.md): manual completo del harness.
- [`docs/simulation.md`](docs/simulation.md): modelo conceptual de Spectre V1.
- [`docs/metrics.md`](docs/metrics.md): cómo se mide y cómo se reporta.
- [`docs/troubleshooting.md`](docs/troubleshooting.md): errores típicos.
- [`AGENTS.md`](AGENTS.md): reglas para agentes de IA (a los humanos también os
  sirve de contexto).

## Acceso y clonado

El repositorio es privado. Acepta la invitación de GitHub y clónalo:

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project
```

Si no usas SSH:

```bash
git clone https://github.com/Ghostalex07/spectre-v1-project.git
```

Para HTTPS necesitas un token personal de GitHub; no compartas el token ni lo
guardes en el repositorio.

## Requisitos

- Linux x86-64 **nativo** para las medidas principales. Una VM se documenta y se
  excluye de la comparación.
- `gcc`, `make`, `python3`, `unzip`, `taskset` y `objdump`.
- `matplotlib` para las figuras:
  ```bash
  python3 -m pip install -r analysis/requirements.txt
  ```
- Opcional: `perf` para inspección.
- No introduzcas dependencias nuevas sin justificarlo en el PR.

## Enfoque actual

Tras el feedback del profesor, la experimentación principal es **E1
(caracterización de caché)** y **E3 (sobrecoste de mitigaciones)**. El mecanismo
de explotación de E2 se cubre con análisis documental y el modelo conceptual de
[`docs/simulation.md`](docs/simulation.md). Ejecutar E2 en hardware es
**opcional** y va como anexo.

## Primer comando

```bash
make
make smoke
make test
make simulate
```

Si `make smoke` pasa, el harness está sano. Después sigue
[`docs/manual.md`](docs/manual.md) para medir en tu máquina. La campaña principal
se lanza con `RUN_E2=0` para no ejecutar la validación opcional de E2.

## Flujo de trabajo

`main` es la versión estable. No trabajes directamente sobre ella:

```bash
git switch main
git pull
git switch -c feat/e1-harness
```

Haz cambios pequeños, verifica y después:

```bash
git add <archivos concretos>
git commit -m "feat: add cache latency harness"
git push -u origin feat/e1-harness
```

Abre un pull request a `main`. El responsable del repositorio lo revisa y lo
mergea. No hagas `push --force`, `reset --hard` ni reescribas ramas compartidas.

### Commits

- Mensajes en inglés, estilo `tipo: descripción` (`feat:`, `fix:`, `docs:`,
  `data:`, `analysis:`).
- Un commit = un cambio coherente. No mezcles código, datos y documentación no
  relacionados.
- No uses `git add .` a ciegas; revisa `git status` antes.

## Definición de “hecho”

Un cambio está terminado cuando:

- `make` compila sin errores y sin warnings nuevos.
- `make smoke` pasa.
- `make test` pasa.
- Los scripts de shell pasan `bash -n`.
- Los scripts de Python pasan `python3 -m py_compile`.
- Si se tocó la función vulnerable, se revisó el ensamblador con `objdump -d`.
- El CSV sigue el esquema de [`data/README.md`](data/README.md).
- La casilla correspondiente de `PLAN.md` se actualiza **solo con evidencia**.
- `git status` no muestra archivos no intencionados.
- La documentación afectada está actualizada.

## Reparto de roles

Rellenad los nombres en la primera reunión. Una persona puede cubrir más de un
rol, pero que quede escrito.

| Rol | Responsable | Tareas |
|---|---|---|
| Coordinación | — | Reparto, plazos, revisión de PRs, coherencia del alcance |
| Harness | — | `src/`, `Makefile`, `scripts/`, compilación y humo |
| Campaña | — | Ejecutar en los equipos, rellenar fichas y CSV |
| Análisis | — | `analysis/`, figuras, intervalos de confianza |
| Informe | — | `report/`, redacción y bibliografía |
| Slides y demo | — | `slides/`, defensa y vídeo de respaldo |

## Reglas de seguridad y alcance

- No cambies la visibilidad del repositorio, los remotos ni los colaboradores.
- No modifiques ni borres `references/`; son materiales de terceros de solo
  lectura.
- No uses `sudo`, no cambies kernel/sysctl/gobernadores del sistema sin permiso
  y no desactives mitigaciones.
- No ataques máquinas que no sean del grupo. Todo se ejecuta en local y en un
  entorno controlado.
- No subas secretos, tokens, credenciales, datos personales ni binarios grandes.
- No amplíes el alcance: nada de Meltdown, otras variantes de Spectre, ataques
  entre procesos o contra el kernel.
- No inventes ni maquilles resultados. Un equipo que no filtra es un resultado.

## Datos

- Los CSV van en `data/<machine_id>/` con el esquema acordado.
- Los datos crudos no se editan a mano. Si hay que corregir algo, se conserva el
  original y se documenta la corrección.
- No se commitean binarios, `.o`, `perf.data` ni trazas pesadas.
- Si un CSV supera los 5 MB, pregunta antes de subirlo.

## Dudas

Abre un issue o comenta en el PR con:

- `machine_id` y configuración.
- Comando ejecutado.
- Salida relevante.
- Qué esperabas y qué obtuviste.

No dependas de conversaciones privadas: si una decisión afecta al grupo, que
quede en el repositorio.
