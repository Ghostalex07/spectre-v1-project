#include "spectre.h"

#include <errno.h>
#include <limits.h>

static void usage(const char *prog) {
    fprintf(stderr,
            "Uso: %s [opciones]\n"
            "  --machine-id ID   Identificador del equipo (o MACHINE_ID)\n"
            "  --iterations N    Iteraciones por repetición (por defecto 10000000)\n"
            "  --reps N          Repeticiones (por defecto 30)\n"
            "  --out FILE        CSV de salida (por defecto stdout)\n"
            "  --help            Muestra esta ayuda\n",
            prog);
}

static int parse_ull(const char *s, unsigned long long *out) {
    if (!s || !*s) return -1;
    errno = 0;
    char *end = NULL;
    unsigned long long v = strtoull(s, &end, 10);
    if (errno != 0 || !end || *end != '\0') return -1;
    *out = v;
    return 0;
}

int main(int argc, char **argv) {
    const char *machine_id = NULL;
    const char *out_path = NULL;
    unsigned long long iterations = 10000000ULL;
    unsigned long long reps = 30;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--machine-id") == 0 && i + 1 < argc) {
            machine_id = argv[++i];
        } else if (strcmp(argv[i], "--iterations") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &iterations) != 0) {
                fprintf(stderr, "error: --iterations no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--reps") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &reps) != 0) {
                fprintf(stderr, "error: --reps no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--out") == 0 && i + 1 < argc) {
            out_path = argv[++i];
        } else {
            fprintf(stderr, "error: opción desconocida o incompleta: %s\n",
                    argv[i]);
            usage(argv[0]);
            return 2;
        }
    }

    if (iterations == 0 || iterations > (unsigned long long)SIZE_MAX) {
        fprintf(stderr, "error: --iterations debe ser mayor que 0\n");
        return 2;
    }
    if (reps == 0 || reps > INT_MAX) {
        fprintf(stderr, "error: --reps debe ser > 0 y caber en int\n");
        return 2;
    }

    FILE *out = stdout;
    if (out_path && strcmp(out_path, "-") != 0) {
        out = fopen(out_path, "w");
        if (!out) {
            fprintf(stderr, "error: no se pudo abrir %s: %s\n", out_path,
                    strerror(errno));
            return 1;
        }
    }

    machine_info mi;
    machine_info_init(&mi, machine_id);

    static const size_t indices[ARRAY1_SIZE] = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    };

    for (size_t i = 0; i < sizeof array2; i++)
        array2[i] = 1;

    for (int i = 0; i < 1000; i++)
        victim_function(indices[i & (ARRAY1_SIZE - 1)]);
    lfence();

    fputs("machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,"
          "variant,iterations,run,cycles_per_iteration,total_cycles\n",
          out);

    for (int run = 0; run < (int)reps; run++) {
        lfence();
        uint64_t t0 = rdtscp();
        for (unsigned long long i = 0; i < iterations; i++)
            victim_function(indices[i & (ARRAY1_SIZE - 1)]);
        lfence();
        uint64_t t1 = rdtscp();

        uint64_t total = t1 - t0;
        double cpi = (double)total / (double)iterations;

        machine_info_write_prefix(out, &mi);
        fprintf(out, "%s,%llu,%d,%.3f,%llu\n", VARIANT_NAME, iterations, run,
                cpi, (unsigned long long)total);
    }

    if (out != stdout) fclose(out);
    return 0;
}
