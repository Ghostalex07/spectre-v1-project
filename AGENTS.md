# AGENTS.md — Instrucciones para agentes de IA

Este repositorio contiene un **trabajo académico** sobre Spectre V1. No es un
proyecto de producción. Si eres un agente de IA y has llegado aquí, lee este
archivo entero antes de tocar nada.

## Fuente de verdad

- Lee `PLAN.md` y `README.md` antes de actuar.
- `PLAN.md` define el alcance, las fases, las métricas y los criterios de
  aceptación. No cambies el alcance por iniciativa propia.
- Si una instrucción del usuario contradice este archivo, pide confirmación
  explícita antes de actuar.
- No modifiques este archivo sin permiso.

## Reglas no negociables

1. **No cambies la visibilidad del repositorio.** No lo hagas público, no crees
   forks públicos, no añadas colaboradores ni cambies los remotos.
2. **No borres ni modifiques el material de referencia:** `*.pdf`,
   `spectre.c.zip` y `spectre.txt`. Son de solo lectura y no se versionan.
3. **No reescribas la historia de Git.** Prohibido `git push --force`,
   `git reset --hard`, `git clean -fdx`, `git rebase` sobre `main`, borrar ramas
   o tags.
4. **No ejecutes comandos destructivos** (`rm -rf`, `find -delete`, `truncate`,
   `dd`, `mkfs`, etc.) sin permiso explícito.
5. **No uses `sudo`**, no cambies kernel/sysctl/gobernadores del sistema, no
   desactives mitigaciones y no ataques máquinas que no sean del grupo.
6. **No subas secretos, tokens, credenciales, datos personales, binarios grandes
   ni resultados crudos pesados.** Respeta `.gitignore`.
7. **No amplíes el alcance:** nada de Meltdown, otras variantes de Spectre,
   ataques entre procesos o contra el kernel. Las mitigaciones hardware son solo
   contexto.
8. **No inventes resultados.** Si un equipo no filtra, se documenta; no se
   maquilla.
9. **No uses `git add .` a ciegas.** Añade solo los archivos que correspondan a la
   tarea.
10. **Antes de una acción irreversible, ambigua o que cambie el alcance, detente
    y pregunta.**

## Qué puedes hacer

- Leer y crear código en `src/`, `scripts/`, `analysis/`, `docs/`, `report/` y
  `slides/`.
- Compilar y ejecutar el harness, medir en la máquina local y usar `objdump`,
  `lscpu` o `perf` si está disponible.
- Crear commits pequeños y descriptivos.
- Actualizar las casillas de `PLAN.md` solo cuando exista evidencia de que el
  paso está hecho.
- Hacer `push` a `main` solo si el usuario lo pide explícitamente.

## Flujo de trabajo

1. Lee `PLAN.md` y `README.md`.
2. Comprueba `git status` y no toques cambios ajenos.
3. Haz el cambio mínimo necesario.
4. Verifica: `make`, ejecución de humo y `objdump` cuando el cambio lo requiera.
5. Resume qué cambiaste y qué evidencia tienes.
6. Si algo falla, no lo ocultes; documenta el error.

## Convenciones del proyecto

- C11, x86-64, Linux.
- Un binario por variante: `baseline`, `lfence` y `mask`.
- `-O2` como configuración principal y `-O0` como control.
- CSV con el esquema definido en `PLAN.md`.
- Nombres de archivos y variables en inglés; documentación en español.
- No introduzcas dependencias nuevas sin justificarlo.

## Criterio de “hecho”

- El código compila.
- La ejecución produce datos o un error comprensible.
- El ensamblador de las variantes se ha revisado cuando el cambio lo requiere.
- `PLAN.md` refleja el estado real.
- No hay archivos no intencionados en `git status`.

## Si algo no está claro

Pregunta antes de asumir. Es preferible una pregunta a un cambio destructivo.
