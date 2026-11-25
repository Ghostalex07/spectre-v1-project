# Spectre V1: ejecución especulativa, predicción de saltos y canales laterales en caché

**Trabajo de Arquitectura Avanzada**  
**Estado:** esqueleto con resultados del Ryzen 5 PRO 5675U. Las celdas
`PENDIENTE` corresponden a las otras microarquitecturas y no deben rellenarse con
datos inventados.

---

## Resumen

Este trabajo estudia cómo la predicción de saltos y la ejecución especulativa
pueden producir una fuga de información observable a través de la caché, y cuál
es el coste de dos mitigaciones de Spectre V1: `LFENCE` y el enmascarado de
índices. La experimentación empírica se centra en la caracterización de la caché
(E1) y en el sobrecoste de las mitigaciones (E3). El mecanismo de explotación
(E2) se aborda desde el análisis documental y un modelo conceptual; la PoC en
hardware se conserva como anexo ilustrativo, no como resultado.

**Resultados disponibles:** dos sesiones del Ryzen 5 PRO 5675U. En E1, el umbral
de calibración cambió entre arranques (184 y 138 ciclos), lo que muestra la
variabilidad del montaje. En E3, `LFENCE` añadió entre ~10,5 % y ~833,8 % de
sobrecoste según la combinación, mientras que la máscara quedó entre ~−56,9 % y
+34,4 %, muchas veces sin sobrecoste estable. La comparación entre
microarquitecturas queda pendiente de la campaña de los compañeros.

---

## 1. Introducción y motivación

- Los procesadores modernos predicen saltos y ejecutan instrucciones fuera de
  orden para mantener el pipeline lleno.
- Una predicción errónea se corrige arquitectónicamente, pero puede dejar
  efectos microarquitectónicos: líneas de caché cargadas, buffers ocupados,
  estado del predictor.
- Spectre V1 explota una comprobación de límites mal predicha para ejecutar
  transitoriamente un acceso fuera de rango y inferir el rastro en caché.
- El interés no es solo la fuga: también el **coste** de las mitigaciones y su
  dependencia de la microarquitectura.

**Pregunta de investigación:** ¿cómo provocan la predicción de saltos y la
ejecución especulativa una filtración observable a través de la caché, y qué
sobrecoste tienen `LFENCE` y el enmascarado de índices en distintas
microarquitecturas?

**Hipótesis de coste:** `LFENCE` tendrá más sobrecoste que el enmascarado, y la
diferencia dependerá de la microarquitectura. La eficacia se argumenta con el
modelo, el ensamblador y la literatura; no se mide como experimento principal.

---

## 2. Fundamentos

### 2.1 Pipeline, ejecución fuera de orden y predicción de saltos

[PENDIENTE: explicar pipeline, ventana de ejecución, predictor, recuperación y
estado arquitectónico frente a estado microarquitectónico. Figuras sugeridas:
esquema de pipeline y línea temporal de una mala predicción.]

### 2.2 Jerarquía de caché

[PENDIENTE: niveles L1/L2/L3, líneas, conjuntos, inclusividad, latencias y
medición con `rdtscp`/`clflush`. Enlazar con E1.]

### 2.3 Estado arquitectónico frente a estado microarquitectónico

[PENDIENTE: explicar por qué el resultado de un acceso transitorio no es
arquitectónicamente visible pero sí puede dejar una huella en caché.]

---

## 3. Spectre V1: mecanismo

### 3.1 Ejemplo mínimo en C

Incluir el fragmento del PoC y explicar:

```c
if (x < array1_size)
    temp &= array2[array1[x] * 512];
```

- `x` fuera de rango;
- el predictor aprende que la condición es verdadera;
- la comprobación se malpredice;
- el acceso a `array1[x]` y a `array2[...]` se ejecuta transitoriamente;
- el estado arquitectónico se descarta, pero la línea de `array2` queda en
  caché.

### 3.2 Secuencia de explotación

1. Entrenar el predictor con índices válidos.
2. Expulsar `array1_size` y las líneas de `array2`.
3. Ejecutar el acceso fuera de rango.
4. Medir las 256 líneas de `array2` con `rdtscp`.
5. Inferir el byte por la línea más rápida.

### 3.3 Del modelo al hardware

El modelo conceptual [`analysis/simulate_spectre.py`](../analysis/simulate_spectre.py)
reproduce la lógica anterior con un predictor de 2 bits y Flush+Reload
simulado. No modela tiempos reales, frecuencia, microcódigo ni topología. La
PoC en hardware se usa solo como comprobación cualitativa en el anexo.

---

## 4. Metodología

### 4.1 Diseño experimental

| Experimento | Tipo | Qué mide | Estado |
|---|---|---|---|
| E1 calibración | Empírico | Latencia hit/miss y umbral | Hecho en Ryzen; faltan CPUs |
| E1 jerárquico | Empírico | Mesetas L1/L2/L3/memoria | Hecho en Ryzen; faltan CPUs |
| E1 temporizador | Empírico | Coste de `rdtscp`/barreras | Hecho en Ryzen |
| E3 barrido | Empírico | Sobrecoste de LFENCE/máscara | Hecho en Ryzen; faltan CPUs |
| E2 documental | Documental | Mecanismo y mitigaciones | En curso |
| E2 modelo | Conceptual | Lógica de la fuga | Hecho |
| E2 hardware | Anexo ilustrativo | Coincidencia cualitativa | Fuera de resultados |

### 4.2 Protocolo de medida

- Linux nativo; evitar VM en la comparación principal.
- `taskset` a un núcleo físico; SMT sibling idle si es posible.
- Gobernador `performance`; documentar turbo y frecuencia.
- Calentamiento descartado; orden de variantes aleatorizado o alternado.
- Umbral de E1 elegido en el valle del histograma **por sesión**.
- Mediana, p5, p95 e IQR; IC bootstrap para medianas y para el sobrecoste.
- Dos sesiones en arranques distintos por máquina.
- No mezclar `-O0` con `-O2` en las figuras principales.

### 4.3 Estadística

- Proporciones: intervalo de Wilson.
- Medianas: bootstrap de 10.000 remuestreos.
- E3: bootstrap por bloques emparejados; el IC se calcula sobre el cociente
  variante/baseline.
- `0/N` se reporta como cota superior, no como prueba de imposibilidad.
- Los IC no corrigen el sesgo del montaje; solo cuantifican la precisión.

### 4.4 Reproducibilidad

- Código, scripts, flags, versión de GCC, kernel, microcódigo y estado de
  `spectre_v1` quedan registrados.
- `make`, `make smoke`, `make test`, `make asm`, `make figures` y `make validate`.
- Los CSV crudos se conservan en `data/<machine_id>/<session_id>/`.

---

## 5. Resultados E1: caracterización de la caché

### 5.1 Calibración hit/miss

| Sesión | `hit` mediana | `hit` p5/p95 | `miss` mediana | `miss` p5/p95 | Umbral |
|---|---:|---:|---:|---:|---:|
| `20261124-200944` | 69 | 69 / 92 | 322 | 276 / 874 | 184 |
| `20261125-084943` | 46 | 23 / 46 | 276 | 230 / 621 | 138 |

**Lectura:** los dos modos se separan con claridad, pero el umbral cambia entre
arranques. No se debe copiar el umbral de otra sesión ni de otra máquina.

Figura: [`figures/e1_ryzen5pro5675u.png`](../figures/e1_ryzen5pro5675u.png).

### 5.2 Jerarquía de caché

| Nivel | Sesión 1 | Sesión 2 | Agregado (2 sesiones) | IC95 |
|---|---:|---:|---:|---:|
| L1d | 3,55 | 2,16 | 2,857 | [2,160; 3,555] |
| L2 | 10,21 | 6,47 | 8,340 | [6,467; 10,214] |
| L3 | 298,29 | 29,35 | 163,819 | [29,346; 298,292] |
| Memoria | 361,49 | 284,67 | 323,077 | [284,668; 361,486] |

**Lectura:** L3 es la meseta más inestable. El IC agregado es enorme y no se
debe presentar un único valor como si fuera estable. Hay que discutir si la
primera sesión fue un outlier o si el montaje tiene una fuente de variación no
controlada.

Figura: [`figures/e1_hierarchy_ryzen5pro5675u.png`](../figures/e1_hierarchy_ryzen5pro5675u.png).

Tabla: [`report/e1_hierarchy_plateaus.md`](e1_hierarchy_plateaus.md).

### 5.3 Coste del temporizador

[PENDIENTE: pegar la tabla de `report/results_summary.md` y explicar que el
coste del temporizador se publica aparte y no se resta de E1.]

---

## 6. Resultados E3: sobrecoste de las mitigaciones

### 6.1 Diseño del barrido

- `W` (trabajo por iteración): 0, 1, 2, 4, 8, 16, 32, 64.
- Predictibilidad: `inrange`, `random_p1`, `random_p10`, `random_p50`.
- Arrays: 4 KiB y 64 MiB.
- 5 bloques y 3 repeticiones por combinación.
- 128 combinaciones en total.

### 6.2 Resultados

| Variante | Rango de sobrecoste | Observación |
|---|---:|---|
| `LFENCE` | ~+10,5 % a ~+833,8 % | Habitualmente 2–9× más lento; crece con el array y `W` |
| Máscara | ~−56,9 % a +34,4 % | Muchas veces negativo o IC cruza cero; no hay sobrecoste estable |

**Lectura:** la hipótesis de coste se cumple en el Ryzen para `LFENCE`, que es
claramente más caro. La máscara no muestra un sobrecoste consistente en estas
combinaciones; eso no significa que sea gratuita en todas las máquinas.

Figuras:

- [`figures/e3_sweep_overlay.png`](../figures/e3_sweep_overlay.png)
- [`figures/e3_sweep_ryzen5pro5675u_overhead_vs_work.png`](../figures/e3_sweep_ryzen5pro5675u_overhead_vs_work.png)

Tabla: [`report/e3_sweep_overhead.md`](e3_sweep_overhead.md).

### 6.3 Comparación entre máquinas

| Máquina | Microarquitectura | E1 umbral | LFENCE | Máscara |
|---|---|---:|---:|---:|
| `ryzen5pro5675u` | Zen 3 (Cezanne) | 138 | +300,6 % (legacy 30 reps) | +1,3 % (legacy 30 reps) |
| `PENDIENTE` | `PENDIENTE` | `PENDIENTE` | `PENDIENTE` | `PENDIENTE` |
| `PENDIENTE` | `PENDIENTE` | `PENDIENTE` | `PENDIENTE` | `PENDIENTE` |

**Nota:** la fila del Ryzen usa la campaña legacy de 30 repeticiones solo como
comprobación cruzada; el resultado principal es el barrido. No se debe mezclar
con las filas nuevas sin indicar la diferencia de metodología.

Figura: [`figures/compare_overhead.png`](../figures/compare_overhead.png).

---

## 7. E2: análisis documental y modelo conceptual

### 7.1 Análisis documental

[PENDIENTE: sintetizar Kocher et al. (2019), la propuesta P0928R1, el documento
de Kocher sobre mitigaciones en MSVC y el artículo de USENIX Security 2025.
Relacionar cada uno con el mecanismo, la mitigación y el coste.]

### 7.2 Modelo conceptual

El modelo reproduce el predictor, la ejecución transitoria, el acceso a
`array2`, el rastro en caché y Flush+Reload. Resultado del modelo:

```text
baseline  40/40 bytes correctos (modelo)
lfence    0/40 bytes correctos (modelo)
mask      0/40 bytes correctos (modelo)
```

**Lectura:** el modelo explica la lógica, no mide eficacia real. Que `LFENCE` y
la máscara bloqueen la fuga en el modelo no demuestra que la bloqueen en todas
las microarquitecturas.

Figura: [`figures/simulation_spectre.png`](../figures/simulation_spectre.png).

### 7.3 Anexo ilustrativo de hardware

La PoC se conserva como anexo ilustrativo, subordinado al modelo y a la
literatura. No produce resultados ni se usa para calcular eficacia. Ver
[`docs/e2-anexo.md`](../docs/e2-anexo.md).

---

## 8. Discusión

- **Coste:** `LFENCE` es claramente más caro en el Ryzen; la máscara no muestra
  un sobrecoste estable. La diferencia depende de `W`, del array y de la
  predictibilidad.
- **Microarquitectura:** la comparación real entre CPUs está pendiente. No se
  puede afirmar que el comportamiento del Ryzen se repita en Intel u otras
  generaciones de AMD.
- **Variabilidad:** el umbral y la meseta de L3 cambian entre arranques. Hay que
  reportar las sesiones por separado y no ocultar la dispersión.
- **Eficacia:** se argumenta con el modelo, el ensamblador y la literatura; no
  se mide como experimento principal. La PoC hardware solo muestra coincidencia
  cualitativa.
- **Limitaciones:** una sola microarquitectura, mismo proceso, secreto
  sintético, umbral por sesión, ruido, compilador y modelo simplificado.

---

## 9. Limitaciones y validez

Resumen de [`docs/limitations.md`](../docs/limitations.md):

- Los datos actuales son de una sola microarquitectura; no hay comparación
  entre fabricantes.
- `0/N` es una cota superior, no una prueba de imposibilidad.
- El modelo no mide tiempos reales ni eficacia.
- El compilador puede eliminar la vulnerabilidad; hay que revisar `objdump`.
- La VM y el ruido de planificación quedan fuera de la comparación principal.
- Las conclusiones deben formularse como “en estas condiciones” y no como
  “esta CPU no es vulnerable” o “esta mitigación no tiene coste”.

---

## 10. Conclusiones

[PENDIENTE: cerrar con 3–5 conclusiones verificables:
1. El mecanismo se explica y el modelo lo reproduce.
2. `LFENCE` tiene un coste alto y creciente con el trabajo y el array.
3. La máscara no muestra sobrecoste estable en el Ryzen.
4. La comparación entre microarquitecturas queda como trabajo pendiente.
5. La variabilidad entre sesiones obliga a reportar IC y no un único valor.]

---

## Referencias

- Kocher, P. et al. “Spectre Attacks: Exploiting Speculative Execution”.
  IEEE S&P 2019. [`references/spectre.pdf`](../references/spectre.pdf).
- P0928R1. “Mitigating Spectre v1 Attacks in C++”.
  [`references/p0928r1.pdf`](../references/p0928r1.pdf).
- Kocher, P. “Spectre Mitigations in Microsoft's C/C++ Compiler”, 2018.
  [`references/spectre.txt`](../references/spectre.txt).
- Zhu, Y. et al. “Place Protections at the Right Place: Targeted Hardening for
  Cryptographic Code against Spectre v1”. USENIX Security 2025.
  [`references/usenixsecurity25-zhu-yiming.pdf`](../references/usenixsecurity25-zhu-yiming.pdf).
- Documentación de AMD, Intel y del kernel Linux sobre mitigaciones.
  [PENDIENTE: añadir referencias exactas.]

---

## Anexo A. PoC de E2 en hardware (ilustrativo)

- Código y datos históricos, sin cifras en el cuerpo principal.
- Solo muestra que el modelo coincide cualitativamente con un procesador real.
- No es un experimento ni un resultado.
- Ver [`docs/e2-anexo.md`](../docs/e2-anexo.md).

## Anexo B. Ensamblador

- `docs/asm/e3_baseline.asm`: `cmp` + salto condicional, sin `cmov`.
- `docs/asm/e3_lfence.asm`: `cmp` + salto + `lfence`.
- `docs/asm/e3_mask.asm`: `cmp` + `and`, sin salto condicional.
- `docs/asm/e3_sweep.asm`: variantes del barrido.

## Anexo C. Datos y reproducción

- `data/ryzen5pro5675u/20261124-200944/`
- `data/ryzen5pro5675u/20261125-084943/`
- `data/derived/`
- `report/results_summary.md`
- Comandos: `make figures`, `make validate`, `make test`.

---

## Cómo completar este esqueleto

1. Rellenar las celdas `PENDIENTE` con datos reales de otras máquinas.
2. No mezclar la campaña legacy `ryzen5pro5675u_final` con el barrido nuevo.
3. Mantener las dos sesiones del Ryzen separadas en E1 jerárquico.
4. Revisar que cada figura tenga su ruta y que los CSV existan.
5. Actualizar `report/results_summary.md` con `make summary` después de cada
   campaña.
