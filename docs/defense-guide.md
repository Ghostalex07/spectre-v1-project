# Guía de la defensa

Objetivo: explicar el mecanismo, mostrar la caracterización de caché y comparar
el sobrecoste de las mitigaciones **sin leer el informe**. E2 se explica con
análisis documental y simulación conceptual; la demo de hardware es opcional.
Una idea por diapositiva, figuras grandes y una demo corta.

## Formato

- 12–15 diapositivas.
- 15–20 minutos de exposición + preguntas.
- Ensayo cronometrado al menos dos veces.
- Demo probada en la máquina de la defensa y **vídeo de respaldo**.
- No proyectes el documento ni capturas de terminal ilegibles.

## Guion de diapositivas

1. **Título y gancho.** “Un procesador que acierta el salto puede filtrar un
   secreto sin que el programa lo lea.”
2. **Motivación.** Optimizaciones legítimas, estado arquitectónico vs
   microarquitectónico, impacto real.
3. **Pipeline y ejecución fuera de orden.** Fetch/decode/execute/commit;
   especulación y descarte.
4. **Predicción de saltos.** Entrenamiento, acierto/fallo, ventana transitoria.
5. **Caché y canal lateral.** Línea de 64 bytes, hit/miss, Flush+Reload.
6. **Spectre V1.** Código C, ensamblador y línea temporal:
   entrenar → malpredecir → acceso fuera de rango → rastro en caché → medir.
7. **Pregunta y objetivos.** Una pregunta, tres objetivos, hipótesis.
8. **Alcance y modelo de amenaza.** Mismo proceso, secreto de prueba, Linux
   nativo; fuera de alcance Meltdown, kernel y cross-process.
9. **Metodología.** E1/E3 empíricos; E2 documental y modelo conceptual.
10. **Equipos y protocolo.** Tabla de máquinas, umbral por máquina, `taskset`,
    SMT idle, flags.
11. **E1: resultados.** Histograma hit/miss, caracterización y umbral elegido.
12. **E2: mecanismo y modelo.** Línea temporal y simulación; qué explica y qué
    no. La validación en hardware, si existe, va al anexo.
13. **E3: resultados.** Ciclos/iteración y sobrecoste absoluto/porcentual.
14. **Comparación y discusión.** Diferencias microarquitectónicas, LFENCE vs
    máscara, límites de la evidencia.
15. **Conclusiones, demo y Q&A.** Qué se ha demostrado, qué no, y siguiente
    paso.

## Demo

La demo de hardware es **opcional y anecdótica**. No es un resultado principal
ni demuestra eficacia universal; sirve para visualizar el mecanismo. Si la
tienes, debe durar menos de 2
minutos:

```bash
make
THRESHOLD=<T> ./scripts/demo.sh <machine_id> 40
```

Salida esperada (Ryzen de referencia, threshold 80):

```text
== baseline ==
  recuperado: 'Spectre V1 test secret 0123456789ABCDEF!'
  aciertos:   40/40
== lfence ==
  recuperado: '...'
  aciertos:   0/40
== mask ==
  recuperado: '...'
  aciertos:   0/40
```

Si la máquina de la defensa no filtra, no improvises: explica que E2 en
hardware es opcional y usa la simulación conceptual. Si tienes vídeo de
respaldo, úsalo. Lleva también los CSV y las figuras en local.

### Guion de la demo

1. “Esta es la versión base; el programa solo debería poder leer 16 bytes.”
2. Ejecuta baseline y muestra el secreto.
3. “Esta es la misma función con LFENCE; el procesador ya no ejecuta el acceso
   fuera de rango.”
4. Ejecuta lfence y muestra 0/40.
5. “Esta es la máscara; el índice fuera de rango se convierte en 0.”
6. Ejecuta mask y muestra 0/40.
7. “En esta máquina no se observó fuga con LFENCE ni con máscara, pero LFENCE
   cuesta ~4× y la máscara ~1×.”

No digas “la máscara es gratis” con una sola medida. Di “en esta máquina y con
este bucle, el sobrecoste es aproximadamente el 1–2 %”. No presentes un `0/40`
como prueba universal de seguridad.

## Preguntas previsibles

**¿Es un ataque real o solo un experimento?**
Es una reproducción controlada de Spectre V1 en un proceso propio, con un
secreto sintético. No es un ataque remoto ni cross-process.

**¿Por qué el atacante puede medir?**
Porque el modelo de amenaza asume código local en el mismo proceso (o un
atacante que puede ejecutar y medir). El proyecto se limita a ese escenario.

**¿Por qué el umbral no es 80?**
80 es un valor del PoC original, específico de algunos Intel. En cada máquina
se mide E1 y se elige el valle. En el Ryzen de referencia, 80 cae en un valle
amplio, pero no es universal.

**¿Por qué `score1` y `score2` son conteos y no ciclos?**
Porque el ataque vota: para cada byte se cuenta cuántas veces cada línea parece
en caché. El candidato con más aciertos gana. Los ciclos se usan en E1 y E3.

**¿Por qué LFENCE cuesta más que la máscara?**
LFENCE serializa las cargas posteriores y limita la ejecución fuera de orden;
la máscara solo transforma el índice y elimina el salto, así que el coste es
mucho menor en este bucle. Los números exactos dependen de la microarquitectura.

**¿La máscara elimina la fuga?**
El argumento principal es de código: el índice fuera de rango se convierte en 0
y el acceso constante a `array1[0]` no revela el secreto. Si se ejecutó E2 en
hardware y no se observó fuga, es una observación de anexo, no una prueba
universal. `guess=1` con `score1` alto es el acceso constante, no una fuga. Un
`0/N` es una cota superior, no una prueba de imposibilidad.

**¿Por qué la variante LFENCE no recupera nada?**
El argumento principal es el ensamblador: la barrera impide que la carga
posterior se ejecute especulativamente antes de que se resuelva la comprobación.
Si en tu máquina recupera algo, revisa el ensamblador: puede que el compilador
haya movido o eliminado la barrera. La observación de E2, si existe, va al
anexo. No generalices el resultado a todas las CPUs.

**¿Por qué en AMD LFENCE puede no serializar igual que en Intel?**
En AMD, que LFENCE serialice el despacho depende de un bit de configuración que
el sistema operativo activa por Spectre. Es un compromiso rendimiento/seguridad
del diseño. Por eso se registra el estado de mitigaciones del equipo y no se
generaliza el coste de una marca a otra.

**¿Y si el compilador convierte el `if` en `cmov`?**
Entonces la versión base puede dejar de filtrar. Compilamos con
`-fno-if-conversion -fno-if-conversion2` y verificamos con `objdump` que queda
un salto condicional real. El control a `-O0` ayuda a diagnosticar.

**¿Por qué una máquina no filtra?**
Puede ser la microarquitectura, el predictor, el umbral, el entrenamiento o la
virtualización. Se documenta como resultado negativo; no se fuerza.

**¿Por qué no atacáis el kernel o otros procesos?**
Está fuera del alcance. El proyecto estudia el mecanismo en un proceso propio
y las mitigaciones LFENCE y máscara.

**¿Qué validez tienen los resultados?**
Son medidas locales, con un número fijo de intentos, repeticiones, IC de Wilson
y bootstrap. No son un estudio exhaustivo de todas las microarquitecturas. Las
limitaciones se declaran y están cerradas en
[`docs/limitations.md`](limitations.md).

**¿Qué pasa con Meltdown y Spectre V2?**
Están fuera del alcance. Se mencionan solo como contexto.

**¿Por qué no usáis una VM?**
Porque los tiempos y la topología de caché pueden no ser representativos. Una
VM se puede usar para probar el harness, pero se excluye de la comparación
principal.

**¿Cómo se reproduce?**
Clonando el repo, ejecutando `make`, `make smoke`, `make test` y
`RUN_E2=0 ./scripts/run_all.sh <machine_id> <T>` con el umbral de la máquina.
E2 se reproduce conceptualmente con `analysis/simulate_spectre.py`; la
validación en hardware es opcional. Los CSV y las figuras se regeneran desde
los scripts.

## Checklist antes de la defensa

- [ ] Diapositivas ensayadas y cronometradas.
- [ ] Demo ejecutada en la máquina de la defensa.
- [ ] Vídeo de respaldo grabado y accesible sin internet.
- [ ] CSV y figuras en local.
- [ ] Respuestas a las preguntas de arriba preparadas.
- [ ] Una frase clara de limitaciones y otra de conclusiones.
- [ ] No hay afirmaciones que no estén en los datos.
