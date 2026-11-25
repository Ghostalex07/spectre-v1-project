# Anexo E2 — PoC en hardware (ilustrativo)

Durante la fase de validación del proyecto se desarrolló una prueba de concepto
de Spectre V1 en hardware, dentro de un único proceso y en máquinas propias.

Siguiendo la indicación del profesor, **E2 no es un experimento ni un resultado
del trabajo**. El mecanismo de explotación se aborda en el cuerpo principal
únicamente desde:

- el análisis documental (Kocher et al. y el ensamblador del ejemplo);
- la simulación conceptual (`analysis/simulate_spectre.py`).

La PoC en hardware **se conserva como anexo ilustrativo**: sirve solo para
mostrar que lo que describe el modelo coincide cualitativamente con lo que
ocurre en un procesador real. Está subordinada al análisis documental y al
modelo; no se usa para medir eficacia, no produce resultados principales y no
se cita como evidencia cuantitativa.

Este documento no presenta cifras ni instrucciones de uso. El código y los datos
de validación se conservan únicamente como material histórico.
