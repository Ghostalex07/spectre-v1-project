# AGENTS.md — Instrucciones para agentes de IA

> **Léelo entero antes de actuar.** Este archivo manda si eres una IA y vas a
> tocar el repositorio. Si algo no está claro, o el usuario te pide algo que
> contradice estas reglas, **pregunta antes de hacer nada**.

## 0. Resumen en 30 segundos

- Es un **trabajo académico** sobre Spectre V1, no un proyecto de producción.
- `main` ya tiene el harness completo: `src/`, `Makefile`, `scripts/`,
  `analysis/` y documentación.
- E1/E2/E3 están implementados y validados en el Ryzen 5 PRO 5675U.
- Los datos de referencia están en `data/ryzen5pro5675u/` y
  `data/ryzen5pro5675u_final/`. **No los sobrescribas.**
- Falta la campaña en 2–3 microarquitecturas distintas, el informe y la defensa.
- La guía que debe seguir cada compañero en su máquina está en
  [`docs/campaign.md`](docs/campaign.md).

## 1. Orden de lectura obligatorio

Antes de modificar cualquier cosa, lee en este orden:

1. [`README.md`](README.md) — qué es el proyecto y cómo empezar.
2. [`PLAN.md`](PLAN.md) — alcance, fases, experimentos y criterios.
3. [`docs/campaign.md`](docs/campaign.md) — qué hace cada integrante en su CPU.
4. [`docs/manual.md`](docs/manual.md) — comandos exactos del harness.
5. [`CONTRIBUTING.md`](CONTRIBUTING.md) — flujo de trabajo y PRs.
6. La documentación específica del cambio: `docs/metrics.md`, `data/README.md`,
   `docs/thresholds.md`, `docs/troubleshooting.md`, etc.

No empieces a programar solo con el nombre del proyecto: el contexto está en esos
documentos.

## 2. Reglas duras (no negociables)

1. **No cambies la visibilidad del repositorio.** No lo hagas público, no crees
   forks públicos, no añadas colaboradores ni cambies los remotos.
2. **No borres ni modifiques `references/`.** Es material de terceros y es de
   solo lectura. Los originales de la carpeta local tampoco se tocan.
3. **No reescribas la historia de Git.** Prohibido `git push --force`,
   `git reset --hard`, `git clean -fdx`, `git rebase` sobre `main`, borrar
   `main` o tags. Las ramas de trabajo solo se borran después de fusionarlas y
   con permiso explícito.
4. **No ejecutes comandos destructivos** (`rm -rf`, `find -delete`, `truncate`,
   `dd`, `mkfs`, etc.) sin permiso explícito.
5. **No uses `sudo`.** No cambies kernel, `sysctl`, gobernadores de CPU ni
   mitigaciones. No ataques máquinas que no sean del grupo.
6. **No subas secretos, tokens, credenciales, datos personales, binarios
   grandes ni resultados crudos innecesariamente pesados.** Respeta
   `.gitignore`. Los CSV de referencia y las figuras sí se versionan.
7. **No amplíes el alcance:** nada de Meltdown, otras variantes de Spectre,
   ataques entre procesos o contra el kernel. Las mitigaciones hardware son solo
   contexto.
8. **No inventes resultados.** Si una máquina no filtra, se documenta tal cual.
9. **No uses `git add .` a ciegas.** Añade solo los archivos de la tarea. No
   añadas el `spectre.txt` duplicado de la raíz.
10. **No modifiques este archivo sin permiso.** Si crees que falta una regla,
    propón el cambio al usuario.
11. **Ante una acción irreversible, ambigua o que cambie el alcance, detente y
    pregunta.**

## 3. Qué puedes hacer

- Leer y crear código en `src/`, `scripts/`, `analysis/`, `tests/`, `docs/`,
  `report/` y `slides/`.
- Compilar y ejecutar el harness con `make`, `make smoke` y los scripts de
  `scripts/`.
- Medir en la máquina local y usar `objdump`, `lscpu` o `perf` si está
  disponible.
- Crear datos en `data/<machine_id>/` y figuras en `figures/`.
- Regenerar figuras con `analysis/plot_e1.py`, `plot_e2.py` y `plot_e3.py`.
- Crear commits pequeños y descriptivos.
- Actualizar las casillas de `PLAN.md` **solo con evidencia** de que el paso
  está hecho.
- Actualizar la documentación cuando cambie el comportamiento del harness.
- Hacer `push` a `main` **solo si el usuario lo pide explícitamente**.

## 4. Qué no debes hacer

- No sobrescribas `data/ryzen5pro5675u/` ni `data/ryzen5pro5675u_final/`.
  Para una máquina nueva, crea `data/<machine_id>/`.
- No mezcles CSV `-O0` con la campaña `-O2` en las figuras principales.
- No cambies los esquemas CSV sin actualizar `data/README.md` y
  `docs/metrics.md`.
- No cambies el secreto, el tamaño de `array1` ni la secuencia de entrenamiento
  sin volver a validar E2 y revisar el ensamblador.
- No metas `bin/`, `*.o`, `__pycache__/`, `*.pyc` ni datos temporales en Git.

## 5. Flujo obligatorio para cualquier cambio

1. Lee los documentos de la sección 1 que afecten al cambio.
2. Comprueba `git status` y no toques cambios ajenos.
3. Haz el cambio mínimo necesario.
4. Verifica con los comandos de la sección 6.
5. Resume qué cambiaste y qué evidencia tienes.
6. Si algo falla, no lo ocultes: documenta el error.

## 6. Verificación obligatoria

Antes de dar un cambio por bueno:

```bash
make
make smoke
bash -n scripts/*.sh
python3 -m py_compile analysis/*.py
```

Además:

- `objdump -d` si tocas la función vulnerable.
- Regenera las figuras si cambian los datos.
- `git diff --check` antes de commitear.
- `git status` sin archivos no intencionados.

Referencia del ensamblador esperado:

- `baseline`: `cmp` + salto condicional (`jbe`), no `cmov`.
- `lfence`: `cmp` + salto condicional + `lfence`.
- `mask`: `cmp` + `and`, **sin salto condicional** en `victim_function`.

## 7. Dónde está cada cosa

| Archivo | Para qué sirve |
|---|---|
| `README.md` | Visión general, inicio rápido y estado |
| `PLAN.md` | Alcance, fases, experimentos, métricas y riesgos |
| `docs/campaign.md` | Paso a paso para cada compañero en su máquina |
| `docs/manual.md` | Manual completo del harness |
| `docs/metrics.md` | Definición de métricas, IC y CSV |
| `docs/thresholds.md` | Umbral calibrado de cada máquina |
| `docs/machines.md` | Ficha de CPU de cada equipo |
| `docs/troubleshooting.md` | Errores típicos y cómo resolverlos |
| `CONTRIBUTING.md` | Ramas, PRs, roles y definición de “hecho” |
| `data/README.md` | Esquemas CSV y política de datos |
| `references/` | Paper, PoC y material de consulta |

## 8. Convenciones técnicas

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

## 9. Criterio de “hecho”

Un cambio está terminado cuando:

- El código compila sin warnings nuevos.
- `make smoke` pasa.
- `bash -n scripts/*.sh` y `python3 -m py_compile analysis/*.py` pasan.
- El ensamblador se revisó si se tocó la función vulnerable.
- Los CSV respetan el esquema y las figuras se regeneran desde los datos.
- `PLAN.md` y la documentación reflejan el estado real.
- No hay archivos no intencionados en `git status`.

## 10. Git y ramas

- `main` es la versión estable.
- Para cambios grandes, crea una rama `feat/...`, `docs/...` o
  `campaign/<machine_id>`.
- Fusiona en `main` solo cuando las comprobaciones pasen.
- Borra la rama de trabajo después del merge, con permiso explícito.
- No reescribas `main` ni uses `push --force`.
- No hagas `push` a `main` sin petición explícita del usuario.

## 11. Si algo no está claro

Pregunta antes de asumir. Es preferible una pregunta a un cambio destructivo o a
un resultado inventado.
