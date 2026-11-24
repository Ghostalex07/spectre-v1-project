# Campaña final por máquina

Esta es la parte que hace **cada integrante en su propio equipo**. No hay que
repetir el harness ni reescribir documentación: se clona el repo, se ejecuta el
protocolo y se suben los datos.

> **Foco experimental (feedback del profesor):** E1 (caracterización de caché) y
> E3 (impacto de mitigaciones en rendimiento) son los experimentos. E2 no forma
> parte de la campaña: el mecanismo se cubre con análisis documental y
> [`simulation.md`](simulation.md). La PoC en hardware solo podría ir como anexo,
> pendiente de confirmar con el profesor.

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

Esto guarda `data/<machine_id>/env_<machine_id>.txt`. Para una campaña con
sesiones, define `SESSION_ID`:

```bash
SESSION_ID=$(date -u +%Y%m%dT%H%M%SZ) ./scripts/collect_env.sh <machine_id>
# ficha en data/<machine_id>/<SESSION_ID>/env_<machine_id>.txt
export SESSION_ID
```

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

### Caracteriza la jerarquía con E1 jerárquico

La calibración anterior solo dice dónde separar hit/miss. E1 jerárquico mide
pointer chasing para localizar las mesetas de L1d, L2, L3 y memoria:

```bash
./scripts/run_e1_hierarchy.sh <machine_id>
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
```

Por defecto barre 4 KiB–256 MiB con puntos `2^k` y `1,5·2^k`, 1.000.000 de
hops y 30 repeticiones. La semilla de Sattolo y el estado de
`MADV_HUGEPAGE` quedan en el CSV. Genera:

- `figures/e1_hierarchy_<machine_id>.png` con mediana, bandas p5–p95 e IQR y
  líneas L1d/L2/L3 tomadas de la ficha de entorno;
- `data/derived/e1_hierarchy_plateaus.csv` y
  `report/e1_hierarchy_plateaus.md` con las mesetas y su IC bootstrap.

Criterio de meseta: tamaños en [25 %, 75 %] de la capacidad de cada nivel;
memoria es todo tamaño >= 2·L3. Si falta la ficha o no hay puntos en la ventana,
la tabla lo marca como `sin-ficha` o `sin-muestras`; no se inventan cifras.

### Mide el coste del temporizador

```bash
./scripts/run_e1_timer.sh <machine_id>
python3 analysis/plot_e1.py --machine-id <machine_id>
```

Guarda `e1_timer_<machine_id>.csv` con la distribución del intervalo vacío
`lfence;rdtscp;lfence;rdtscp`. `plot_e1.py` añade
`figures/e1_<machine_id>_timer.png` si encuentra ese CSV. **No se resta** de
las latencias: sirve para juzgar si las diferencias de pocos ciclos son
concluyentes.

## 3. Lanza la campaña principal (E1 + E3)

Haz **al menos dos sesiones en arranques distintos** de la misma máquina. Así
puedes separar la variabilidad entre sesiones de la variabilidad dentro de una
sesión.

```bash
SESSION_ID="$(date +%Y%m%d-%H%M%S)" THRESHOLD=<T> \
  ./scripts/run_all.sh <machine_id> <T>
```

Repite el comando tras reiniciar, con otro `SESSION_ID`. Antes de medir,
comprueba que el gobernador es `performance` y que el turbo está documentado. El
script fija el proceso con `taskset`, pero no cambia la configuración del
sistema.

`run_all.sh` usa el protocolo final por defecto:

- Entorno: `collect_env.sh` con la sesión (`SESSION_ID`) en
  `data/<machine_id>/<session_id>/`.
- E1 calibración: 10.000 muestras por modo, buffer de 64 MiB.
- E1 jerárquico: barrido 4 KiB–256 MiB, 30 repeticiones.
- E1 temporizador: 100.000 muestras × 3 repeticiones.
- E2: **omitido** por defecto; la PoC no forma parte de la campaña.
- E3: barrido de sensibilidad con perfil `default` (W, previsibilidad y tamaño
  de array configurables), variantes `baseline`, `lfence` y `mask` intercaladas
  por bloques.
- Warm-up: el binario de E3 ejecuta llamadas de calentamiento antes de medir; no
  se incluyen en los ciclos.

Los CSV de E1 y E3 del barrido quedan en
`data/<machine_id>/<session_id>/`. Si quieres un ensayo corto:

```bash
PROFILE=smoke SESSION_ID=smoke-$(date +%H%M%S) THRESHOLD=<T> \
  ./scripts/run_all.sh <machine_id> <T>
```

No presentes el perfil smoke como campaña final. El modo `E3_MODE=legacy`
conserva el bucle antiguo para comparar con los datos históricos.

### E2 en hardware: fuera de la campaña

La PoC de E2 **no forma parte de esta campaña** ni de los resultados. Se
conserva el código del periodo de validación, pero su posible inclusión como
anexo está pendiente de confirmar con el profesor. No la ejecutes para generar
datos de campaña; el mecanismo se cubre con el modelo conceptual.

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

## 5. Genera las figuras

Obligatorias (E1 y E3):

```bash
python3 analysis/plot_e1.py --machine-id <machine_id>
python3 analysis/plot_e1_hierarchy.py --machine-id <machine_id>
python3 analysis/plot_e3_sweep.py --machine-id <machine_id>
```

O, si prefieres regenerar todo desde los datos:

```bash
make figures
make validate
```

Las figuras se guardan en `figures/`. `plot_e3_sweep.py` lee el barrido nuevo e
ignora los CSV antiguos; `plot_e3.py` sigue disponible para los datos históricos.

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
- Si la máquina no filtra en E2: no aplica a esta campaña; E2 no se ejecuta.

## 8. Tiempo orientativo

- Inventario y E1: 15–30 minutos.
- E1 jerárquico: 5–15 minutos según CPU y barrido.
- E1 temporizador: 1–3 minutos.
- E3: 5–10 minutos.
- Figuras y PR: 10 minutos.

## 9. Checklist final

- [ ] `make smoke` pasa.
- [ ] `make test` pasa.
- [ ] `data/<machine_id>/<session_id>/env_<machine_id>.txt` existe en cada sesión.
- [ ] Fila añadida a `docs/machines.md`.
- [ ] Umbral añadido a `docs/thresholds.md`.
- [ ] E1 tiene 10.000 muestras por modo.
- [ ] E1 jerárquico tiene el barrido completo y 30 repeticiones.
- [ ] E1 temporizador se midió y se comparó con la meseta L1d.
- [ ] Tabla de mesetas generada y revisada.
- [ ] E3 tiene el barrido completo (`PROFILE=default`) y bloques suficientes.
- [ ] `make asm` ejecutado y verificado en las tres variantes de E3.
- [ ] Figuras de E1/E3 generadas con `make figures`.
- [ ] Al menos dos sesiones en arranques distintos.
- [ ] PR abierto contra `main`.
- [ ] `git status` no muestra archivos raros.
