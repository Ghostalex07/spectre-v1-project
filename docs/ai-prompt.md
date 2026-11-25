# Prompt para la IA de cada compañero

Este archivo existe para que cada integrante pueda pegar un prompt en su IA y
ejecutar la campaña de su máquina sin depender de este chat.

## Cómo usarlo

1. Clonad el repositorio y entrad en él.
2. Abrid este archivo y copiad **todo el bloque de la sección “Prompt”**.
3. Sustituid `<MACHINE_ID>` por un identificador corto, en minúsculas y sin
   espacios. Ejemplos: `intel_i7_1165g7`, `ryzen7_5800h`.
4. Pegadlo en vuestra IA.
5. Revisad siempre el `git diff` y el PR antes de darlo por bueno.

La fuente de verdad sigue siendo [`campaign.md`](campaign.md). Este prompt solo
la convierte en instrucciones para un agente.

---

## Prompt

```text
Eres un agente de IA que ayuda a ejecutar una campaña experimental de un
trabajo académico sobre Spectre V1. El repositorio ya contiene el harness, los
scripts y la documentación. Tu tarea NO es reescribir el proyecto: es ejecutar
la campaña en esta máquina, dejar los datos reproducibles y preparar un PR.

MACHINE_ID: <MACHINE_ID>

## Reglas duras

1. Lee primero, en este orden:
   - README.md
   - AGENTS.md
   - PLAN.md
   - docs/campaign.md
   - docs/manual.md
   - docs/metrics.md
   - data/README.md
2. No cambies el alcance del trabajo. Nada de Meltdown, otras variantes de
   Spectre, ataques entre procesos ni ataques al kernel.
3. No modifiques references/, no cambies la visibilidad del repositorio, no
   cambies remotos, no añadas colaboradores y no reescribas la historia de Git.
4. No uses sudo, no cambies el kernel, sysctl, gobernadores ni mitigaciones.
5. No ejecutes E2 en hardware. E2 no forma parte de la campaña: se cubre con
   análisis documental y el modelo conceptual de docs/simulation.md.
6. No inventes resultados. Si una medición falla o no separa hit/miss, se
   documenta tal cual.
7. No uses `git add .`. Añade solo los archivos de esta campaña. No añadas
   `spectre.txt`, `bin/`, `*.o`, `__pycache__/` ni `*.pyc`.
8. No hagas push a `main`. Trabaja en una rama `campaign/<MACHINE_ID>` y abre
   un PR contra `main`.
9. Si algo es ambiguo o destructivo, detente y pregunta al humano.
10. No cambies el umbral después de ver los resultados de E3. El umbral se
    elige antes, con E1, y se documenta.

## Objetivo

Ejecutar la campaña E1 + E3 en esta máquina, con al menos dos sesiones en
arranques distintos si es posible, y dejar:

- `data/<MACHINE_ID>/<SESSION_ID>/` con la ficha de entorno y los CSV;
- una fila en `docs/machines.md`;
- una fila por sesión en `docs/thresholds.md`;
- las figuras de esta máquina en `figures/`;
- una rama y un PR contra `main`.

## Paso 0. Comprueba el entorno

Ejecuta:

    git status
    uname -a
    lscpu
    gcc --version | head -n1
    systemd-detect-virt
    cat /sys/devices/system/cpu/vulnerabilities/spectre_v1

Comprueba que es Linux x86-64. Si `systemd-detect-virt` no devuelve `none`, es
una VM o un contenedor: se puede probar, pero se documenta y se excluye de la
comparación principal.

## Paso 1. Comprueba que el harness funciona

    make
    make smoke
    make test

Si `make smoke` o `make test` fallan, no sigas: copia el error, revisa
`docs/troubleshooting.md` y para.

## Paso 2. Calibra el umbral con E1

Elige una sesión de calibración:

    export MACHINE_ID=<MACHINE_ID>
    export SESSION_ID="cal-$(date +%Y%m%d-%H%M%S)"
    ./scripts/collect_env.sh "$MACHINE_ID"
    SESSION_ID="$SESSION_ID" ./scripts/run_e1.sh "$MACHINE_ID" 10000 64
    python3 analysis/plot_e1.py --machine-id "$MACHINE_ID" --session-id "$SESSION_ID"

Abre `figures/e1_<MACHINE_ID>.png`, mira el valle entre `hit` y `miss` y elige
un umbral. No copies el 80 del Ryzen de referencia. Anota el umbral y el motivo.

Añade una fila a `docs/thresholds.md` con el formato que ya usa el archivo.

## Paso 3. Primera sesión de campaña

Reinicia si puedes para que la sesión sea independiente. Después:

    export MACHINE_ID=<MACHINE_ID>
    export SESSION_ID="camp1-$(date +%Y%m%d-%H%M%S)"
    export THRESHOLD=<T>
    THRESHOLD="$THRESHOLD" ./scripts/run_all.sh "$MACHINE_ID" "$THRESHOLD"

Esto ejecuta entorno, E1 calibración, E1 jerárquico, E1 temporizador y E3 con el
perfil `default`. No ejecutes el perfil `smoke` como campaña final.

Si el comando falla, guarda la salida completa, revisa `docs/troubleshooting.md`
y no maquilles el resultado.

## Paso 4. Segunda sesión

Reinicia otra vez y repite el paso 3 con otra sesión:

    export SESSION_ID="camp2-$(date +%Y%m%d-%H%M%S)"
    THRESHOLD="$THRESHOLD" ./scripts/run_all.sh "$MACHINE_ID" "$THRESHOLD"

El objetivo es tener dos arranques distintos. Si no puedes reiniciar, haz una
sola sesión y dilo claramente en el PR.

## Paso 5. Revisa el ensamblador

    for v in baseline lfence mask; do
      echo "== $v =="
      objdump -d -Mintel "bin/e3_$v" | awk '/<victim_function>:/,/^$/'
    done

Debe verse:

- baseline: `cmp` + salto condicional (`jbe`/`ja`), no `cmov`;
- lfence: salto condicional + `lfence` antes del acceso;
- mask: `cmp` + salto condicional + `sbb` + `and`, sin `lfence` dentro de
  `victim_function`.

Si la máscara se compila a un salto, no uses esos datos: avisa y para.

## Paso 6. Genera figuras y valida

    make figures
    make validate

Comprueba que aparecen las figuras de E1, E1 jerárquico, temporizador y E3 de
esta máquina. No inventes figuras que no se hayan generado.

## Paso 7. Documenta la máquina

Añade o completa tu fila en `docs/machines.md` con:

- CPU, fabricante, familia/generación y microarquitectura;
- family, model, stepping y microcódigo;
- núcleos/hilos y cachés L1/L2/L3;
- kernel, GCC, nativo/VM;
- estado de `spectre_v1`;
- sesiones realizadas.

Añade las filas de umbral en `docs/thresholds.md`. No toques las filas de otras
máquinas.

## Paso 8. Prepara el PR

    git switch main
    git pull
    git switch -c campaign/<MACHINE_ID>

    git add data/<MACHINE_ID> \
            docs/machines.md docs/thresholds.md \
            figures/*_<MACHINE_ID>*.png

    git commit -m "data: add campaign for <MACHINE_ID>"
    git push -u origin campaign/<MACHINE_ID>

Abre un PR contra `main` usando la plantilla
[`.github/pull_request_template.md`](../.github/pull_request_template.md) y
repasa [`docs/campaign-checklist.md`](campaign-checklist.md). En el PR incluye:

- CPU, family/model/stepping, microcódigo, kernel, GCC y nativo/VM;
- umbral elegido y por qué;
- E1: medianas, p5/p95 y separación hit/miss;
- E1 jerárquico: mesetas L1d/L2/L3/memoria;
- E1 temporizador: mediana y comparación con L1d;
- E3: mediana de ciclos/iteración y sobrecoste de lfence/mask;
- resultado de `objdump`;
- sesiones incluidas y si son arranques distintos;
- cualquier anomalía o resultado negativo.

No subas `data/derived/` ni `report/` si no se te pide: son agregados de todas
las máquinas y el responsable del repo los regenera al mergear.

## Paso 9. Respuesta final al humano

Cuando termines, responde con:

- `MACHINE_ID`;
- modelo de CPU y microarquitectura;
- `SESSION_ID` de cada sesión;
- umbral elegido;
- resultados E1/E3 principales;
- si `make smoke`, `make test`, `make asm`, `make figures` y `make validate`
  pasan;
- enlace al PR;
- cualquier cosa que no hayas podido hacer.

Si no puedes completar algún paso, dilo. Es mejor un PR incompleto y honesto
que datos inventados.
```

---

## Qué debe mirar el compañero antes de enviar el PR

- `git status` no muestra `spectre.txt`, binarios ni datos de otra máquina.
- El PR no toca `references/` ni `data/` de otras máquinas.
- Las dos sesiones, si existen, tienen `env_<machine_id>.txt`.
- El umbral está justificado con el histograma, no copiado.
- `make smoke`, `make test`, `make figures` y `make validate` pasan.
- El ensamblador de las tres variantes se ha revisado.
