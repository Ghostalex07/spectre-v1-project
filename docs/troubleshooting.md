# Solución de problemas

Problemas típicos al clonar, compilar, medir o analizar. Si tu caso no está
aquí, abre un issue con el comando, la salida y el `machine_id`.

## Compilación

### `make: gcc: No such file or directory`

Falta el compilador. En Ubuntu/Debian:

```bash
sudo apt install build-essential
```

Si no tienes `sudo`, pide que lo instalen o usa otra máquina. No ejecutes
`make` como root.

### `make: *** No rule to make target 'all'`

Estás en el directorio equivocado. Ejecuta desde la raíz del repositorio:

```bash
cd spectre-v1-project
make
```

### El enlazador se queja de `posix_memalign` o `rand_r`

El código define `_GNU_SOURCE` en `src/common.h`. Si modificaste las cabeceras,
comprueba que sigue estando **antes** de los `#include`. No cambies a
`malloc` sin alinear; E1 y E2 dependen de la alineación.

### `warning: implicit declaration of function 'rdtscp'`

Falta `_GNU_SOURCE` o estás compilando en un entorno no x86-64. El harness es
para Linux x86-64.

## Ejecución y afinidad

### `taskset: failed to set pid ... affinity: Invalid argument`

El CPU que intentas usar no está permitido (contenedor, cgroup o CPU offline).
Mira tu afinidad actual:

```bash
taskset -pc $$
lscpu -e=CPU,CORE,SOCKET,NODE,ONLINE
```

Elige un CPU permitido y pásalo explícitamente:

```bash
PIN_CPU=2 ./scripts/run_e1.sh <machine_id>
```

Si estás en un contenedor, usa un CPU del cgroup; si no hay ninguno estable, no
uses esa máquina para la comparación principal.

### `Permission denied` al ejecutar un script

```bash
chmod +x scripts/*.sh
```

### El script se queda sin `THRESHOLD`

Es intencionado. Primero hay que calibrar E1:

```bash
./scripts/run_e1.sh <machine_id>
python3 analysis/plot_e1.py --machine-id <machine_id>
```

Elige el valle y pasa el valor:

```bash
THRESHOLD=80 ./scripts/run_e2.sh <machine_id> baseline 80
```

No uses 80 por defecto en otra máquina.

## E1: latencias raras o solapadas

### `hit` y `miss` se solapan

- Aumenta el buffer: `./scripts/run_e1.sh <machine_id> 10000 128`.
- Comprueba que el proceso está fijado a un CPU: `PIN_CPU=...`.
- Cierra cargas pesadas y deja el hermano SMT idle.
- Revisa el gobernador: `cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor`.
- No cambies el gobernador a `performance` sin permiso; si no puedes, registra
  el valor y mide en las mismas condiciones.
- En una VM los tiempos pueden ser inestables; exclúyela.

### `miss` sale casi igual que `hit`

Puede que el buffer sea demasiado pequeño y quepa en caché, o que el acceso se
esté optimizando. Prueba un buffer de 64–256 MiB. Revisa que `value` se use y
que el compilador no elimine la carga.

### El umbral sugerido no está en un valle claro

No lo uses a ciegas. Mira el histograma y elige un punto entre los dos modos.
Si no hay separación, no hay umbral fiable: documenta el problema y prueba otra
máquina o configuración.

## E2: no recupera el secreto

### Todos los bytes dan `guess=0` y `score1≈attempts`

Síntoma clásico de que `array2[0]` comparte línea de caché con variables
calientes o de que el acceso no se está midiendo. Comprueba:

- `array2` debe estar alineado a 64 bytes:
  `static uint8_t array2[256 * 512] __attribute__((aligned(64)));`
- `array1_size` debe ser `volatile` para poder expulsarlo de caché.
- `temp` debe ser `volatile`.
- No midas con `lfence` alrededor de cada acceso en E2; el PoC original no lo
  hace.

### `guess=1` con `score1` alto en la variante `mask`

Es esperado. La máscara convierte el índice fuera de rango en `0`, así que el
acceso constante a `array1[0]` (valor 1) deja caliente la línea 1. Eso **no** es
el secreto. Lo importante es `success=0` y que el `guess` no sea el byte secreto.
Si `mask` recupera el secreto, la máscara está mal implementada.

### La variante `lfence` recupera el secreto

No debería. Revisa el ensamblador:

```bash
objdump -d -Mintel bin/e2_lfence | awk '/<victim_function>:/,/^$/'
```

Debe haber un `lfence` entre la comprobación y el acceso. Si el compilador lo
movió o lo eliminó, revisa `src/spectre.h` y vuelve a compilar. No “arregles” el
resultado a mano.

### La variante base no filtra en mi máquina

En orden:

1. Comprueba que el binario tiene un salto condicional real, no `cmov`:
   ```bash
   objdump -d -Mintel bin/e2_baseline | awk '/<victim_function>:/,/^$/'
   ```
   Debe aparecer `cmp` + `jbe`/`jae` (o similar). Si aparece `cmov`, revisa que
   se compiló con `-fno-if-conversion -fno-if-conversion2`.
2. Prueba el control a `-O0`:
   ```bash
   OPT=O0 THRESHOLD=80 ./scripts/run_e2.sh <machine_id> baseline 80 300 5 1 40
   ```
   Si a `-O0` filtra y a `-O2` no, el compilador está transformando el código.
3. Ajusta el umbral: prueba 60, 80, 100, 120, 150. El umbral debe estar entre
   `hit` y `miss` de E1.
4. Aumenta intentos: `ATTEMPTS=1000`. Si `score1` está cerca de `attempts` y el
   segundo candidato está bajo, el ataque funciona; el problema es el umbral o
   la selección del byte.
5. Prueba `train` 2, 4, 5, 6, 8, 10:
   ```bash
   TRAIN=4 THRESHOLD=80 ./scripts/run_e2.sh <machine_id> baseline 80 1000 4 1 1
   ```
6. Comprueba que no hay una rama en la selección de `x`. El harness usa el
   bit-twiddling del PoC original; si lo cambias por un ternario, el predictor se
   contamina y el ataque falla.
7. Si sigue sin filtrar, documenta el resultado negativo. No todas las
   microarquitecturas se comportan igual. Prueba otra máquina del grupo.

### `score1` y `score2` son ambos altos

El candidato no es claro. Mira `margin` y la tasa `unclear`. Si `margin` es bajo,
no interpretes el `guess` como una recuperación. Aumenta intentos o ajusta el
umbral; no cambies `margin_min` después de ver los resultados.

### El secreto recuperado es correcto solo en algunos bytes

Es normal. Reporta la tasa por byte, no solo “funciona/no funciona”. Un byte
puede fallar por ruido, por el entrenamiento o por el valor del byte. Repite con
más runs y reporta el intervalo.

## E3: sobrecoste

### Todos los ciclos/iteración son enormes o ruidosos

- Fija el CPU con `PIN_CPU`.
- Cierra procesos pesados.
- Aumenta repeticiones (`REPS=30`) y usa la mediana, no una sola medida.
- No mezcles `-O0` y `-O2`.
- En una VM, el sobrecoste puede no ser representativo.

### `mask` sale más rápido que `baseline`

Puede pasar: la máscara elimina el salto y el coste del salto mal predicho puede
ser mayor que el de `cmp`+`and`. No es un error. Reporta el valor y discútelo; no
fuerces que la mitigación sea más lenta.

### `lfence` sale muchísimo más lento

Es lo esperado en muchas microarquitecturas: LFENCE serializa cargas posteriores.
Cuantifica el sobrecoste y compáralo con la eficacia. No ocultes el coste.

## Análisis y figuras

### `ModuleNotFoundError: No module named 'matplotlib'`

```bash
python3 -m pip install -r analysis/requirements.txt
```

Si no puedes instalar, los scripts de análisis seguirán imprimiendo las tablas;
solo fallará la generación de figuras.

### `No existe data/<machine_id>`

Ejecuta primero la campaña o revisa el `machine_id`:

```bash
ls data/
./scripts/run_all.sh <machine_id>
```

### `FileNotFoundError: .../e1_<machine>.csv`

El nombre debe coincidir exactamente. Los scripts generan
`e1_<machine_id>.csv`; si cambiaste el nombre a mano, renómbralo o vuelve a
generarlo.

### La cabecera CSV no coincide

No edites la cabecera a mano. Regenera el CSV con el script. Si el esquema ha
cambiado, actualiza `data/README.md`, `docs/metrics.md` y el código a la vez.

## Entorno y VM

### `systemd-detect-virt` devuelve `kvm`, `vmware` o `docker`

Es una VM o un contenedor. Se puede usar para probar el harness, pero **no**
para la comparación principal. Anótalo en `docs/machines.md` y exclúyelo del
análisis. No desactives mitigaciones ni cambies el kernel para “mejorar” los
tiempos.

### `spectre_v1` dice “Mitigation: ...”

Es la mitigación del kernel para espacio de usuario (usercopy/swapgs). No impide
que el PoC se ejecute en tu propio proceso. No la desactives. Si el PoC no
filtra, el problema está en el umbral, el entrenamiento o la microarquitectura,
no en ese mensaje.

### `perf` no funciona

No es necesario para el proyecto. Si lo usas, puede requerir
`kernel.perf_event_paranoid`; no cambies parámetros del sistema sin permiso.

## Git y colaboración

### `git push` rechazado

No uses `--force`. Actualiza tu rama con los cambios de `main` y resuelve los
conflictos en tu rama:

```bash
git switch main
git pull
git switch feat/tu-rama
git merge main
```

Si el conflicto es delicado, pide revisión antes de mergear.

### `spectre.txt` aparece como `??` en la raíz

Es un duplicado local del material de referencia. No lo añadas ni lo borres; la
copia versionada está en `references/spectre.txt`.

### No sé qué archivos añadir

```bash
git status --short
git diff
```

Añade solo los archivos de tu cambio. No uses `git add .` a ciegas.

## Cuándo parar y preguntar

- Antes de borrar datos o ramas.
- Antes de cambiar la visibilidad del repo, remotos o colaboradores.
- Antes de usar `sudo` o tocar kernel/sysctl/gobernadores.
- Antes de cambiar el alcance (Meltdown, otras variantes, kernel,
  cross-process).
- Cuando un resultado no cuadra y la “solución” sería maquillarlo.
