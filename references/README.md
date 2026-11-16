# Referencias del proyecto

Material de consulta para el proyecto **Spectre V1**. Estas copias están en el
repositorio para que todos los integrantes trabajen con los mismos documentos.

> **Uso académico.** Los derechos pertenecen a sus autores. El repositorio es
> privado; no redistribuyáis estos archivos fuera del grupo. No los modifiquéis:
> son de solo lectura.

## Contenido

| Archivo | Qué es | Fuente |
|---|---|---|
| `spectre.c.zip` | PoC original de Spectre V1 (`spectre.c`). Es el punto de partida de E2. | https://spectreattack.com/spectre.c |
| `spectre.txt` | Paul Kocher, “Spectre Mitigations in Microsoft's C/C++ Compiler”, 2018. Análisis del coste y los límites de LFENCE. | https://www.paulkocher.com/doc/MicrosoftCompilerSpectreMitigation.html |
| `p0928r1.pdf` | Propuesta P0928R1, “Mitigating Spectre v1 Attacks in C++” (2020). Cubre alternativas de mitigación, incluido el enmascarado/SLH. | https://wg21.link/p0928r1 |
| `usenixsecurity25-zhu-yiming.pdf` | Y. Zhu, W. Huang y Y. Xiong, “Place Protections at the Right Place: Targeted Hardening for Cryptographic Code against Spectre v1”, USENIX Security 2025. | https://www.usenix.org/conference/usenixsecurity25/presentation/zhu-yiming |
| `Understanding-Spectre-v2-and-How-the-Vulnerability-Impact-the-Cloud-Security_Gavin-Guo.pdf` | Documento de apoyo sobre Spectre v2 y su impacto en la seguridad cloud. Contexto, no forma parte del alcance experimental. | — |

## Referencia principal (no incluida)

El artículo original que hay que citar es:

> P. Kocher, D. Genkin, D. Gruss, W. Haas, M. Hamburg, M. Lipp, S. Mangard,
> T. Prescher, M. Schwarz y Y. Yarom, “Spectre Attacks: Exploiting Speculative
> Execution”, IEEE Symposium on Security and Privacy (S&P), 2019.

Disponible en https://spectreattack.com/spectre.pdf. Si queréis, se puede añadir
al repositorio más adelante.

## Cómo usar el PoC

```bash
unzip spectre.c.zip
```

Dentro está `spectre.c`. Para la versión base de E2 hay que **quitar
`_mm_lfence()`** de `victim_function`; la copia original lo lleva activo. Después,
verificad el ensamblador con `objdump -d` antes de medir.
