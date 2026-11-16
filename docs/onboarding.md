# Onboarding — primeros pasos

Objetivo: que cualquier integrante pueda clonar el repositorio y empezar la
**Fase 0** sin depender de conversaciones privadas. Tiempo estimado: 2–3 días.

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
4. [`data/README.md`](../data/README.md)

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
mkdir -p data/<machine_id>
lscpu > data/<machine_id>/env_<machine_id>.txt
```

Rellena tu fila en [`docs/machines.md`](machines.md). Usa un `machine_id` corto,
en minúsculas y sin espacios (`ryzen5pro5675u`, `intel_i7_1165g7`, etc.).

**Si `systemd-detect-virt` no devuelve `none`, es una VM.** Se puede usar para
probar, pero no entra en la comparación principal.

## 2. Prueba de viabilidad del PoC (1–2 h)

El objetivo es comprobar si tu máquina filtra. **No** es la campaña de medidas.

```bash
mkdir -p /tmp/spectre-poc
unzip -o references/spectre.c.zip -d /tmp/spectre-poc
find /tmp/spectre-poc -name spectre.c
grep -n "_mm_lfence" /tmp/spectre-poc/spectre.c
```

Abre `spectre.c` y elimina la llamada `_mm_lfence()` que está **dentro de
`victim_function`**. Esa llamada convierte el PoC en la versión mitigada; para la
base de E2 no debe estar.

Compila:

```bash
gcc -O2 -o /tmp/spectre-poc/spectre /tmp/spectre-poc/spectre.c
```

Comprueba el ensamblador:

```bash
objdump -d /tmp/spectre-poc/spectre | grep -A30 -B5 "<victim_function>"
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

- Si recupera el secreto, la máquina filtra y es candidata para E2/E3.
- Si no filtra, no lo ocultes: prueba otro umbral y otro patrón de entrenamiento
  según `PLAN.md`; si sigue sin filtrar, documenta el resultado negativo.
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
| `docs/machines.md` | Ficha de cada equipo |
| `docs/metrics.md` | Definiciones de métricas y análisis |
| `data/README.md` | Esquema y política de datos |
| `references/` | Paper, PoC y material de consulta |
| `src/`, `scripts/`, `analysis/` | Se crean en la Fase 1 |
| `report/`, `slides/` | Informe y defensa |

## 7. Qué no hacer

- No uses una VM para los resultados principales.
- No uses `sudo` ni cambies kernel/sysctl/mitigaciones.
- No ataques máquinas fuera del grupo.
- No modifiques `references/`.
- No subas secretos, datos personales ni binarios grandes.
- No inventes resultados ni borres ejecuciones que no salieron.
