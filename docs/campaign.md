# Campaña final por máquina

Esta es la parte que hace **cada integrante en su propio equipo**. No hay que
repetir el harness ni reescribir documentación: se clona el repo, se ejecuta el
protocolo y se suben los datos.

> **Regla de oro:** el umbral de una máquina no sirve para otra. No copies el 80
> del Ryzen de referencia. Calibra el tuyo con E1.

## 0. Antes de empezar

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project

make
make smoke
```

Si no usas SSH, clona con HTTPS:

```bash
git clone https://github.com/Ghostalex07/spectre-v1-project.git
```

Requisitos: Linux x86-64 nativo, `gcc`, `make`, `python3`, `unzip`, `taskset`,
`objdump` y `matplotlib`:

```bash
python3 -m pip install -r analysis/requirements.txt
```

## 1. Identifica tu máquina

Elige un `machine_id` corto, en minúsculas y sin espacios. Ejemplos:
`intel_i7_1165g7`, `ryzen7_5800h`, `ryzen5pro5675u_final`.

```bash
./scripts/collect_env.sh <machine_id>
```

Esto guarda `data/<machine_id>/env_<machine_id>.txt`.

Rellena tu fila en [`machines.md`](machines.md) con:

- CPU y microarquitectura.
- `family`, `model`, `stepping` y microcódigo.
- Núcleos/hilos y cachés L1/L2/L3.
- Kernel, GCC y si es nativo o VM.
- Estado de `spectre_v1`.

Si `systemd-detect-virt` no devuelve `none`, es una VM o un contenedor: se puede
probar, pero se excluye de la comparación principal.

## 2. Calibra el umbral con E1

```bash
./scripts/run_e1.sh <machine_id> 10000 64
python3 analysis/plot_e1.py --machine-id <machine_id>
```

Abre `figures/e1_<machine_id>.png` y elige un valor en el valle entre `hit` y
`miss`. El script imprime una sugerencia, pero compruébala en el histograma.

Añade tu fila a [`thresholds.md`](thresholds.md):

```text
| `<machine_id>` | fecha | hit mediana | hit p5 | hit p95 | miss mediana | miss p5 | miss p95 | **T** | notas |
```

No sigas si `hit` y `miss` se solapan completamente: mira
[`troubleshooting.md`](troubleshooting.md).

## 3. Lanza la campaña final

```bash
THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

`run_all.sh` usa el protocolo final por defecto:

- E2: 1000 intentos, 50 runs, 40 bytes, `train=5`.
- E3: 10M iteraciones, 30 repeticiones.
- Variantes: `baseline`, `lfence` y `mask`.

No hace falta pasar intentos ni runs. Si quieres el control `-O0`:

```bash
RUN_O0=1 THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

Los CSV quedan en `data/<machine_id>/`.

## 4. Revisa el ensamblador

Antes de dar los datos por buenos:

```bash
objdump -d -Mintel bin/e2_baseline | awk '/<victim_function>:/,/^$/'
objdump -d -Mintel bin/e2_lfence  | awk '/<victim_function>:/,/^$/'
objdump -d -Mintel bin/e2_mask    | awk '/<victim_function>:/,/^$/'
```

Qué debe salir:

- `baseline`: un salto condicional real (`cmp` + `jbe`/`ja`), no un `cmov`.
- `lfence`: el salto y una instrucción `lfence` antes del acceso.
- `mask`: `cmp` + `and` (o `sbb`) y **ningún salto condicional** dentro de
  `victim_function`.

Si la máscara se compila a un salto, no uses esos datos: avisa y se corrige.

## 5. Genera las figuras

```bash
python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e2.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>
```

Las figuras se guardan en `figures/`. `plot_e2.py` excluye por defecto los CSV
`-O0` para no mezclarlos con la campaña principal.

## 6. Sube los datos al repo

Genera primero las figuras de la sección 5. Después crea una rama y añade solo
lo que corresponda:

```bash
git switch -c campaign/<machine_id>

git add data/<machine_id> \
        docs/machines.md docs/thresholds.md \
        figures/*_<machine_id>*.png

git commit -m "data: add campaign for <machine_id>"
git push -u origin campaign/<machine_id>
```

Abre un PR contra `main` y avisa al grupo. No subas:

- `spectre.txt` de la raíz.
- `bin/` ni binarios.
- `__pycache__/` ni `.pyc`.
- Datos de otra máquina.

## 7. Qué debe quedar claro en el PR

Incluye un resumen con:

- CPU, `family/model/stepping`, microcódigo, kernel, GCC y nativo/VM.
- Umbral elegido y por qué.
- E2: aciertos de `baseline`, `lfence` y `mask`.
- E3: mediana de ciclos/iteración y sobrecoste relativo.
- Resultado de `objdump` para las tres variantes.
- Si la máquina no filtra: dilo y explica qué probaste.

## 8. Si tu máquina no filtra

No es un fracaso y no se maquilla. Prueba, en este orden:

1. Revisa el umbral con E1.
2. Prueba `train=2,4,5,6,8,10`.
3. Prueba `-O0` como control.
4. Comprueba que el binario tiene el salto condicional.
5. Documenta el resultado negativo y sube los datos igualmente.

Una máquina sin fuga es un resultado comparativo del trabajo.

## 9. Tiempo orientativo

- Inventario y E1: 15–30 minutos.
- Campaña E2/E3: 10–20 minutos.
- Figuras y PR: 10 minutos.

## 10. Checklist final

- [ ] `make smoke` pasa.
- [ ] `data/<machine_id>/env_<machine_id>.txt` existe.
- [ ] Fila añadida a `docs/machines.md`.
- [ ] Umbral añadido a `docs/thresholds.md`.
- [ ] E1 tiene 10.000 muestras por modo.
- [ ] E2 tiene 50 runs y 40 bytes.
- [ ] E3 tiene 30 repeticiones.
- [ ] `objdump` revisado en las tres variantes.
- [ ] Figuras generadas.
- [ ] PR abierto contra `main`.
- [ ] `git status` no muestra archivos raros.
