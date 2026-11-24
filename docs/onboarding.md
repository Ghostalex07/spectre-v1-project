# Onboarding — primeros pasos

Objetivo: que cualquier integrante pueda clonar el repositorio y empezar sin
depender de conversaciones privadas. Tiempo estimado: 2–3 días.

La experimentación principal es **E1 (caracterización de caché)** y **E3
(sobrecoste de mitigaciones)**. La prueba del PoC de E2 es **opcional**: el
mecanismo se explica con el modelo conceptual de
[`docs/simulation.md`](simulation.md).

Si algo no está en el repositorio, abre un issue; no lo resuelvas por chat.

## 0. Clona y lee

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project
```

Lee, en este orden:

1. [`PLAN.md`](../PLAN.md)
2. [`CONTRIBUTING.md`](../CONTRIBUTING.md)
3. [`docs/metrics.md`](metrics.md)
4. [`docs/manual.md`](manual.md)
5. [`docs/simulation.md`](simulation.md)
6. [`docs/campaign.md`](campaign.md)
7. [`data/README.md`](../data/README.md)

## 1. Ficha del equipo (30 min)

Ejecuta y guarda la salida:

```bash
lscpu
grep -m1 '^model name' /proc/cpuinfo
grep -m1 '^cpu family' /proc/cpuinfo
grep -m1 '^model[[:space:]]*:' /proc/cpuinfo
grep -m1 '^stepping' /proc/cpuinfo
grep -m1 '^microcode' /proc/cpuinfo
systemd-detect-virt
cat /sys/devices/system/cpu/vulnerabilities/spectre_v1
gcc --version | head -n1
```

Crea la carpeta de tu equipo y guarda el entorno:

```bash
./scripts/collect_env.sh <machine_id>
```

Rellena tu fila en [`docs/machines.md`](machines.md). Usa un `machine_id` corto,
en minúsculas y sin espacios (`ryzen5pro5675u`, `intel_i7_1165g7`, etc.).

**Si `systemd-detect-virt` no devuelve `none`, es una VM.** Se puede usar para
probar, pero no entra en la comparación principal.

## 1.5. Comprueba el harness (5 min)

```bash
make
make smoke
make test
make simulate
```

`make smoke` compila E1/E3 y valida sus cabeceras CSV con ejecuciones pequeñas;
la PoC de E2 hardware se omite por defecto (`RUN_E2=0`) y solo se prueba con
`RUN_E2=1` por interés diagnóstico. `make test` valida el análisis y el modelo;
`make simulate` genera la simulación conceptual. Si algo falla, no sigas:
consulta [`troubleshooting.md`](troubleshooting.md).

## 2. Prueba opcional de viabilidad del PoC (1–2 h)

El objetivo es comprobar si tu máquina filtra. **No** es la campaña de medidas y
**no es necesario** para E1/E3. Sirve como evidencia opcional para el anexo de
E2.

```bash
mkdir -p /tmp/spectre-poc
unzip -o references/spectre.c.zip -d /tmp/spectre-poc
POC="$(find /tmp/spectre-poc -name spectre.c | head -n1)"
echo "$POC"
grep -n "_mm_lfence" "$POC"
```

Abre ese `spectre.c` y elimina la llamada `_mm_lfence()` que está **dentro de
`victim_function`**. Esa llamada convierte el PoC en la versión mitigada; para la
base de E2 no debe estar.

Compila:

```bash
gcc -O2 -o /tmp/spectre-poc/spectre "$POC"
```

Comprueba el ensamblador:

```bash
objdump -d -Mintel /tmp/spectre-poc/spectre | awk '/<victim_function>:/,/^$/'
```

Debe quedar un salto condicional real antes del acceso (por ejemplo `cmp` +
`jae`/`jb`), no un `cmov` que elimine la vulnerabilidad. Si el símbolo no
aparece, prueba con `-O0` para el control y documenta lo que ves.

Ejecuta fijado a un núcleo:

```bash
taskset -c 0 /tmp/spectre-poc/spectre
```

Guarda la salida:

```bash
taskset -c 0 /tmp/spectre-poc/spectre > data/<machine_id>/poc_<machine_id>.txt 2>&1
```

Interpretación:

- Si recupera el secreto, la máquina filtra: es evidencia opcional para el anexo
  de E2. E1/E3 no dependen de esto.
- Si no filtra, no lo ocultes: prueba otro umbral y otro patrón de entrenamiento
  según `PLAN.md`; si sigue sin filtrar, documenta el resultado negativo. No es
  bloqueante para el proyecto.
- No modifiques el PoC para “forzar” que filtre.

## 3. Entorno de medida

Antes de medir en serio:

```bash
lscpu -e=CPU,CORE,SOCKET,NODE,ONLINE
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

- Elige un núcleo físico y fija el proceso con `taskset -c <cpu>`.
- Deja el hermano SMT de ese núcleo idle. En un 6C/12T los hermanos suelen ser
  0–6, 1–7, etc.; confírmalo con `lscpu -e`.
- Si el gobernador no es `performance`, pídelo al responsable. No cambies
  configuración del sistema por tu cuenta.
- Registra la frecuencia, el gobernador y si hay turbo en la ficha del equipo.

## 4. Primera tarea y reporte

Cuando termines, reporta en un issue o PR:

```text
machine_id:
CPU:
native/vm:
PoC base (sin lfence): filtra / no filtra
umbral ajustado (si procede):
asm revisado: sí/no
gobernador:
notas:
```

Si tienes acceso a una segunda máquina, repite el proceso. El objetivo es tener
**2–3 microarquitecturas distintas**; si no las hay, se aplica el plan
alternativo de `PLAN.md` y se declara la limitación.

## 5. Checklist de la primera semana

- [ ] Repositorio clonado y `PLAN.md` leído.
- [ ] `make` y `make smoke` pasan.
- [ ] Fila en `docs/machines.md`.
- [ ] `env_<machine_id>.txt` guardado.
- [ ] PoC base (sin `_mm_lfence()`) compilado y ejecutado.
- [ ] Ensamblador revisado con `objdump`.
- [ ] Resultado de viabilidad reportado.
- [ ] Rol asignado en `CONTRIBUTING.md`.

## 6. Mapa rápido del repositorio

| Ruta | Qué hay |
|---|---|
| `PLAN.md` | Plan completo, fases, protocolo, CSV y riesgos |
| `docs/onboarding.md` | Este documento |
| `docs/manual.md` | Manual completo del harness |
| `docs/machines.md` | Ficha de cada equipo |
| `docs/metrics.md` | Definiciones de métricas y análisis |
| `docs/troubleshooting.md` | Errores típicos |
| `data/README.md` | Esquema y política de datos |
| `references/` | Paper, PoC y material de consulta |
| `src/` | E1, E2, E3 y cabeceras comunes |
| `scripts/` | Envoltorios reproducibles |
| `analysis/` | Figuras y agregados |
| `report/`, `slides/` | Informe y defensa |

## 7. Qué no hacer

- No uses una VM para los resultados principales.
- No uses `sudo` ni cambies kernel/sysctl/mitigaciones.
- No ataques máquinas fuera del grupo.
- No modifiques `references/`.
- No subas secretos, datos personales ni binarios grandes.
- No inventes resultados ni borres ejecuciones que no salieron.
