# Campaña final por máquina

Esta es la parte que hace **cada integrante en su propio equipo**. No hay que
repetir el harness ni reescribir documentación: se clona el repo, se ejecuta el
protocolo y se suben los datos.

> **Foco experimental (feedback del profesor):** E1 (caracterización de caché) y
> E3 (impacto de mitigaciones en rendimiento) son obligatorios. E2 en hardware
> es **opcional**; el mecanismo se cubre con análisis documental y
> [`simulation.md`](simulation.md). Si tu CPU no filtra, no es un problema.

> **Regla de oro:** el umbral de una máquina no sirve para otra. No copies el 80
> del Ryzen de referencia. Calibra el tuyo con E1.

## 0. Antes de empezar

```bash
git clone git@github.com:Ghostalex07/spectre-v1-project.git
cd spectre-v1-project

make
make smoke
make test
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

## 3. Lanza la campaña principal (E1 + E3)

```bash
THRESHOLD=<T> RUN_E2=0 ./scripts/run_all.sh <machine_id> <T>
```

Antes de medir, comprueba que el gobernador es `performance` y que el turbo está
documentado. El script fija el proceso con `taskset`, pero no cambia la
configuración del sistema.

`run_all.sh` usa el protocolo final por defecto:

- E1: 10.000 muestras por modo, buffer de 64 MiB.
- E2: **omitido** con `RUN_E2=0`; es opcional.
- E3: 10M iteraciones, 30 repeticiones.
- Variantes: `baseline`, `lfence` y `mask`.
- Orden de E3 aleatorizado por defecto (`E3_ORDER=random`) y registrado en
  `data/<machine_id>/e3_order_<machine_id>.txt`; usa `E3_ORDER=fixed` si
  necesitas reproducir un orden concreto.
- Warm-up: el binario de E3 ejecuta 1.000 llamadas de calentamiento antes de
  medir; no se incluyen en los ciclos.

Los CSV quedan en `data/<machine_id>/`.

### Validación opcional de E2 en hardware

Si quieres comprobar la fuga en tu máquina, ejecuta además:

```bash
RUN_E2=1 THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

E2 usa 1000 intentos, 50 runs, 40 bytes y `train=5`. Si no recupera el secreto,
se documenta como “no observado” y no se maquilla. Para el control `-O0`:

```bash
RUN_E2=1 RUN_O0=1 THRESHOLD=<T> ./scripts/run_all.sh <machine_id> <T>
```

## 4. Revisa el ensamblador

Antes de dar los datos por buenos, revisa las variantes de E3:

```bash
for v in baseline lfence mask; do
  echo "== $v =="
  objdump -d -Mintel "bin/e3_$v" | awk '/<victim_function>:/,/^$/'
done
```

Qué debe salir:

- `baseline`: un salto condicional real (`cmp` + `jbe`/`ja`), no un `cmov`.
- `lfence`: el salto y una instrucción `lfence` antes del acceso.
- `mask`: `cmp` + `and` (o `sbb`) y **ningún salto condicional** dentro de
  `victim_function`.

Si la máscara se compila a un salto, no uses esos datos: avisa y se corrige.

Si además ejecutas E2 en hardware, repite la revisión con `bin/e2_*`.

## 5. Genera las figuras

Obligatorias (E1 y E3):

```bash
python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e3.py --machine-id <machine_id>
```

Opcional (si ejecutaste E2 en hardware):

```bash
python3 analysis/plot_e2.py --machine-id <machine_id>
```

Las figuras se guardan en `figures/`. `plot_e2.py` excluye por defecto los CSV
`-O0` para no mezclarlos con la campaña principal. `plot_e3.py` funciona aunque
no haya E2: en ese caso solo genera la figura de sobrecoste.

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
- E1: medianas, p5/p95 y separación de modos.
- E3: mediana de ciclos/iteración y sobrecoste relativo.
- Resultado de `objdump` para las tres variantes de E3.
- E2 (opcional): aciertos de `baseline`, `lfence` y `mask`, o “no ejecutado”.
- Si la máquina no filtra: dilo y explica qué probaste; no es bloqueante.

## 8. Si tu máquina no filtra (E2 opcional)

No es un fracaso y no se maquilla. E1/E3 siguen siendo válidos. Si decides
probar E2, hazlo en este orden:

1. Revisa el umbral con E1.
2. Prueba `train=2,4,5,6,8,10`.
3. Prueba `-O0` como control.
4. Comprueba que el binario tiene el salto condicional.
5. Documenta el resultado negativo y sube los datos igualmente.

Una máquina sin fuga es un resultado comparativo; un `0/N` es una cota
superior, no una prueba de imposibilidad.

## 9. Tiempo orientativo

- Inventario y E1: 15–30 minutos.
- E3: 5–10 minutos.
- E2 opcional: 10–20 minutos.
- Figuras y PR: 10 minutos.

## 10. Checklist final

- [ ] `make smoke` pasa.
- [ ] `make test` pasa.
- [ ] `data/<machine_id>/env_<machine_id>.txt` existe.
- [ ] Fila añadida a `docs/machines.md`.
- [ ] Umbral añadido a `docs/thresholds.md`.
- [ ] E1 tiene 10.000 muestras por modo.
- [ ] E3 tiene 30 repeticiones.
- [ ] `objdump` revisado en las tres variantes de E3.
- [ ] Figuras de E1/E3 generadas.
- [ ] E2 ejecutado (opcional) o marcado como “no ejecutado”.
- [ ] PR abierto contra `main`.
- [ ] `git status` no muestra archivos raros.
