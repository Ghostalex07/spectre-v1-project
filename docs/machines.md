# Ficha de equipos

Una fila por máquina. Los comandos para obtener los datos están en
[`onboarding.md`](onboarding.md). Guarda la salida completa de `lscpu` en
`data/<machine_id>/env_<machine_id>.txt`.

## Tabla

| machine_id | fabricante | familia/generación | microarquitectura | modelo | stepping | microcódigo | cachés (L1d / L2 / L3) | kernel | compilador | mitigaciones activas | sesiones realizadas | owner | native/vm | notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `ryzen5pro5675u` | AMD | Family 25 (0x19) / Zen 3 | Cezanne | Ryzen 5 PRO 5675U | 0 | `0xa500014` | 192 KiB / 3 MiB / 16 MiB | 6.8.0-149 | GCC 11.4 | `spectre_v1`: usercopy/swapgs barriers + `__user` pointer sanitization | `20261124-200944`, `20261125-084943`, `20261125-141147` (A), `20261125-143804` (B); datos antiguos en la raíz | — | native | Cuatro sesiones en arranques distintos; A y B son el resultado principal de E3 (15 bloques, máscara nueva); L3 depende de la frecuencia |
| `ryzen5pro5675u_final` | AMD | Family 25 (0x19) / Zen 3 | Cezanne | Ryzen 5 PRO 5675U | 0 | `0xa500014` | 192 KiB / 3 MiB / 16 MiB | 6.8.0-149 | GCC 11.4 | `spectre_v1`: usercopy/swapgs barriers + `__user` pointer sanitization | Datos antiguos en la raíz, sin `session_id` (**legacy**) | — | native | **Legacy**: campaña con metodología antigua (E2 hardware, E3 de un solo bucle). Se conserva como referencia histórica; no cuenta como CPU distinta ni se usa en la comparación principal |
| `pendiente-1` | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |
| `pendiente-2` | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE | PENDIENTE |

No borres la fila de ejemplo: sustituye `pendiente-1` y `pendiente-2` por los
equipos reales. Si un equipo se descarta, déjalo en la tabla con `descartado` en
`notes` y explica por qué.

## Cómo completar una fila

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

- `machine_id`: minúsculas, sin espacios (`ryzen5pro5675u`, `intel_i7_1165g7`).
- `fabricante`: AMD, Intel u otro; no lo deduzcas solo del nombre comercial.
- `familia/generación`: familia de CPU y generación conocida; si no se puede
  confirmar, `PENDIENTE`.
- `microarquitectura`: nombre de la microarquitectura (por ejemplo, Zen 3,
  Cezanne); si no se puede confirmar, `PENDIENTE`.
- `family`, `model` y `stepping`: en decimal; si el comando los da en
  hexadecimal, conviértelos y anota la correspondencia.
- `cachés`: tamaños L1d / L2 / L3 tal como los reporta `lscpu`; no los calcules.
- `mitigaciones activas`: copia literal de
  `/sys/devices/system/cpu/vulnerabilities/spectre_v1` y del resto de ficheros
  de mitigaciones que se registren en la ficha de entorno.
- `sesiones realizadas`: lista de `session_id` con datos en
  `data/<machine_id>/<session_id>/`; si solo hay datos antiguos en la raíz,
  indícalo como `PENDIENTE`.
- `native/vm`: `native` si `systemd-detect-virt` devuelve `none`; si no, `vm`.
- `notes`: incidencias, frecuencia, gobernador, si se usó para la comparación
  principal o solo como prueba.

## Criterio para el plan alternativo

Si al completar la tabla hay **menos de dos microarquitecturas distintas**, se
aplica el plan alternativo de `PLAN.md`: comparar configuraciones y compiladores
sobre la misma microarquitectura y declarar la limitación en el informe. No se
presenta una sola máquina como si fueran varias.
