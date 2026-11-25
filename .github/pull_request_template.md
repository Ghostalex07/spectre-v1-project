# Campaña de <machine_id>

## Resumen

- **Máquina:** `<machine_id>` (`<CPU>`, `<microarquitectura>`)
- **Sesiones:** `<session_id_1>`, `<session_id_2>`
- **Arranques distintos:** sí / no
- **Entorno:** native / VM / contenedor
- **Kernel / GCC / microcódigo:** `<valores>`

## Qué incluye este PR

- [ ] `data/<machine_id>/` con las dos sesiones.
- [ ] Ficha en `docs/machines.md`.
- [ ] Umbrales por sesión en `docs/thresholds.md`.
- [ ] Figuras de la máquina en `figures/`.
- [ ] Tablas derivadas y `report/results_summary.md` regenerados.

## Checklist obligatoria

He seguido [`docs/campaign-checklist.md`](../docs/campaign-checklist.md) y
confirmo:

- [ ] `make`, `make smoke` y `make test` pasan.
- [ ] `make asm` pasa y he revisado el ensamblador de las tres variantes.
- [ ] He hecho dos sesiones en arranques distintos.
- [ ] Cada sesión tiene su `env_<machine_id>.txt`.
- [ ] E1 calibración, E1 jerárquico y temporizador están completos.
- [ ] El umbral está elegido en el valle y anotado **por sesión**.
- [ ] E3 se ha ejecutado con `PROFILE=default`, no con `smoke`.
- [ ] `make figures` y `make validate` terminan bien.
- [ ] No he mezclado CSV `-O0` con `-O2` en las figuras principales.
- [ ] No he sobrescrito `data/ryzen5pro5675u/` ni
      `data/ryzen5pro5675u_final/`.
- [ ] No he añadido `spectre.txt`, `bin/`, `__pycache__/`, `*.pyc` ni
      temporales.
- [ ] No he usado `push --force`, `reset --hard` ni `rebase` sobre `main`.

## Resultados

### E1 calibración

| Sesión | hit mediana | miss mediana | Umbral |
|---|---:|---:|---:|
| `<session_id_1>` | | | |
| `<session_id_2>` | | | |

### E1 jerárquico (ciclos/carga)

| Nivel | Sesión 1 | Sesión 2 |
|---|---:|---:|
| L1d | | |
| L2 | | |
| L3 | | |
| Memoria | | |

### E3 barrido

- `LFENCE`: `<rango de sobrecoste>`
- Máscara: `<rango de sobrecoste>`
- Observaciones: `<qué cambia con W, predictibilidad y tamaño de array>`

## Anomalías y limitaciones

- `<resultados negativos, mesetas inestables, ruido, frecuencia, etc.>`

## Notas para quien revise

- `<cualquier decisión metodológica que no sea obvia>`
