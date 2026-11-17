# AGENTS.md — Instrucciones para agentes de IA

Este repositorio contiene un **trabajo académico** sobre Spectre V1. No es un
proyecto de producción. Si eres un agente de IA y has llegado aquí, lee este
archivo entero antes de tocar nada.

## Estado actual

Actualizado el 2026-11-17.

- `main` contiene el harness completo: `src/`, `Makefile`, `scripts/`,
  `analysis/` y documentación.
- E1, E2 y E3 están implementados y validados en el Ryzen 5 PRO 5675U de
  referencia. Los datos están en `data/ryzen5pro5675u/`.
- La campaña final de referencia está en `data/ryzen5pro5675u_final/`.
- La guía paso a paso para la campaña multi-máquina está en
  [`docs/campaign.md`](docs/campaign.md).
- `make smoke` debe pasar antes de dar cualquier cambio por bueno.
- Pendiente: campaña en 2–3 microarquitecturas, informe y defensa final.
- La rama de trabajo `feat/self-contained-repo` ya se fusionó en `main` y se
  eliminó. No la recrees.

## Fuente de verdad

- Lee `README.md`, `PLAN.md`, `CONTRIBUTING.md`, `docs/campaign.md` y
  `docs/manual.md` antes de actuar.
- `PLAN.md` define el alcance, las fases, las métricas y los criterios de
  aceptación. No cambies el alcance por iniciativa propia.
- `docs/campaign.md` contiene el paso a paso que debe seguir cada integrante en
  su máquina: inventario, E1, umbral, E2/E3, `objdump`, figuras y PR.
- `docs/manual.md` contiene los comandos exactos; `docs/metrics.md` y
  `data/README.md` definen las métricas y los CSV.
- Si una instrucción del usuario contradice este archivo, pide confirmación
  explícita antes de actuar.
- No modifiques este archivo sin permiso.

## Reglas no negociables

1. **No cambies la visibilidad del repositorio.** No lo hagas público, no crees
   forks públicos, no añadas colaboradores ni cambies los remotos.
2. **No borres ni modifiques el material de referencia.** Las copias versionadas
   están en `references/` y son de solo lectura; los originales de la carpeta
   local no se tocan.
3. **No reescribas la historia de Git.** Prohibido `git push --force`,
   `git reset --hard`, `git clean -fdx`, `git rebase` sobre `main`, borrar
   `main` o tags. Las ramas de trabajo solo se borran después de fusionarlas y
   con permiso explícito.
4. **No ejecutes comandos destructivos** (`rm -rf`, `find -delete`, `truncate`,
   `dd`, `mkfs`, etc.) sin permiso explícito.
5. **No uses `sudo`**, no cambies kernel/sysctl/gobernadores del sistema, no
   desactives mitigaciones y no ataques máquinas que no sean del grupo.
6. **No subas secretos, tokens, credenciales, datos personales, binarios grandes
   ni resultados crudos innecesariamente pesados.** Los CSV de referencia de
   `data/ryzen5pro5675u/` y las figuras de `figures/` sí se versionan. Respeta
   `.gitignore`.
7. **No amplíes el alcance:** nada de Meltdown, otras variantes de Spectre,
   ataques entre procesos o contra el kernel. Las mitigaciones hardware son solo
   contexto.
8. **No inventes resultados.** Si un equipo no filtra, se documenta; no se
   maquilla.
9. **No uses `git add .` a ciegas.** Añade solo los archivos que correspondan a la
   tarea. No añadas el `spectre.txt` duplicado de la raíz.
10. **Antes de una acción irreversible, ambigua o que cambie el alcance, detente
    y pregunta.**

## Qué puedes hacer

- Leer y crear código en `src/`, `scripts/`, `analysis/`, `tests/`, `docs/`,
  `report/` y `slides/`.
- Compilar y ejecutar el harness con `make`, `make smoke` y los scripts de
  `scripts/`; medir en la máquina local y usar `objdump`, `lscpu` o `perf` si
  está disponible.
- Crear datos en `data/<machine_id>/` y figuras en `figures/`.
- Regenerar figuras con `analysis/plot_e1.py`, `plot_e2.py` y `plot_e3.py`.
- Crear commits pequeños y descriptivos.
- Actualizar las casillas de `PLAN.md` solo cuando exista evidencia de que el
  paso está hecho.
- Actualizar la documentación cuando cambie el comportamiento del harness.
- Hacer `push` a `main` solo si el usuario lo pide explícitamente.

## Qué no debes hacer

- No sobrescribas `data/ryzen5pro5675u/`: es la referencia de validación. Para
  una máquina nueva, crea `data/<machine_id>/`.
- No mezcles CSV `-O0` con la campaña `-O2` en las figuras principales.
- No cambies los esquemas CSV sin actualizar `data/README.md` y
  `docs/metrics.md`.
- No cambies el secreto, el tamaño de `array1` ni la secuencia de entrenamiento
  sin volver a validar E2 y revisar el ensamblador.

## Flujo de trabajo

1. Lee `README.md`, `PLAN.md` y la documentación relacionada con el cambio.
2. Comprueba `git status` y no toques cambios ajenos.
3. Haz el cambio mínimo necesario.
4. Verifica:
   - `make`
   - `make smoke`
   - `bash -n scripts/*.sh`
   - `python3 -m py_compile analysis/*.py`
   - `objdump -d` cuando se toque la función vulnerable.
   - Regenera las figuras si cambian los datos.
5. Resume qué cambiaste y qué evidencia tienes.
6. Si algo falla, no lo ocultes; documenta el error.

## Convenciones del proyecto

- C11, x86-64, Linux.
- GCC; `-O2` como configuración principal y `-O0` como control.
- E2/E3 usan `-fno-if-conversion -fno-if-conversion2` para conservar el salto
  condicional real.
- Un binario por variante: `baseline`, `lfence` y `mask`.
- La función vulnerable se marca `noinline`; `array1_size` es `volatile`.
- CSV con los esquemas de `data/README.md`; no mezcles E1, E2 y E3.
- En E2/E3, `score1` y `score2` son **conteos de aciertos**, no ciclos.
- Nombres de archivos y variables en inglés; documentación en español.
- Python 3 y `matplotlib`; no introduzcas dependencias nuevas sin justificarlo.

## Criterio de “hecho”

- El código compila sin warnings nuevos.
- `make smoke` pasa.
- `bash -n scripts/*.sh` y `python3 -m py_compile analysis/*.py` pasan.
- El ensamblador de las variantes se ha revisado cuando el cambio lo requiere.
- Los CSV respetan el esquema y las figuras se regeneran desde los datos.
- `PLAN.md` y la documentación reflejan el estado real.
- No hay archivos no intencionados en `git status`.

## Ramas

- `main` es la versión estable.
- Para cambios grandes, crea una rama `feat/...` o `docs/...`.
- Fusiona en `main` solo cuando las comprobaciones pasen.
- Borra la rama de trabajo después del merge, con permiso explícito.
- No reescribas `main` ni uses `push --force`.

## Si algo no está claro

Pregunta antes de asumir. Es preferible una pregunta a un cambio destructivo.
