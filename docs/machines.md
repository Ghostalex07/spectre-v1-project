# Ficha de equipos

Una fila por máquina. Los comandos para obtener los datos están en
[`onboarding.md`](onboarding.md). Guarda la salida completa de `lscpu` en
`data/<machine_id>/env_<machine_id>.txt`.

## Tabla

| machine_id | owner | cpu | family | model | stepping | microcode | cores/threads | L1d | L2 | L3 | kernel | gcc | native/vm | spectre_v1 | notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `ryzen5pro5675u` | — | AMD Ryzen 5 PRO 5675U (Cezanne, Zen 3) | 25 | 80 | 0 | `0xa500014` | 6/12 | 192 KiB | 3 MiB | 16 MiB | 6.8.0-149 | 11.4 | native | usercopy/swapgs barriers + `__user` pointer sanitization | Datos iniciales; confirmar con `lscpu` |
| `pendiente-1` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `pendiente-2` |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |

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
- `family`, `model` y `stepping`: en decimal; si el comando los da en
  hexadecimal, conviértelos y anota la correspondencia.
- `native/vm`: `native` si `systemd-detect-virt` devuelve `none`; si no, `vm`.
- `spectre_v1`: copia literal de `/sys/devices/system/cpu/vulnerabilities/spectre_v1`.
- `notes`: incidencias, frecuencia, gobernador, si se usó para la comparación
  principal o solo como prueba.

## Criterio para el plan alternativo

Si al completar la tabla hay **menos de dos microarquitecturas distintas**, se
aplica el plan alternativo de `PLAN.md`: comparar configuraciones y compiladores
sobre la misma microarquitectura y declarar la limitación en el informe. No se
presenta una sola máquina como si fueran varias.
