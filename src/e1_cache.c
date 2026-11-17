#include "common.h"

#include <errno.h>
#include <limits.h>

static void usage(const char *prog) {
    fprintf(stderr,
            "Uso: %s [opciones]\n"
            "  --machine-id ID   Identificador del equipo (o MACHINE_ID)\n"
            "  --mode MODO       hit, miss o both (por defecto both)\n"
            "  --samples N       Muestras por modo (por defecto 10000)\n"
            "  --buffer-mb N     Tamaño del buffer en MiB (por defecto 64)\n"
            "  --seed N          Semilla del generador (por defecto 23901)\n"
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

static int run_mode(FILE *out, const machine_info *mi, const char *mode,
                    size_t samples, uint8_t *buffer, size_t n_lines,
                    unsigned int seed) {
    unsigned int state = seed;

    for (size_t i = 0; i < samples; i++) {
        size_t line = (size_t)(rand_r(&state) % n_lines);
        volatile uint8_t *p = buffer + line * 64;

        if (strcmp(mode, "miss") == 0) {
            clflush(p);
            mfence();
        } else {
            (void)*p;
            mfence();
        }

        lfence();
        uint64_t t0 = rdtscp();
        uint8_t value = *p;
        lfence();
        uint64_t t1 = rdtscp();
        (void)value;

        machine_info_write_prefix(out, mi);
        fprintf(out, "%s,%zu,%llu\n", mode, i,
                (unsigned long long)(t1 - t0));
    }
    return 0;
}

int main(int argc, char **argv) {
    const char *machine_id = NULL;
    const char *mode = "both";
    const char *out_path = NULL;
    unsigned long long samples = 10000;
    unsigned long long buffer_mb = 64;
    unsigned long long seed = 23901;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--machine-id") == 0 && i + 1 < argc) {
            machine_id = argv[++i];
        } else if (strcmp(argv[i], "--mode") == 0 && i + 1 < argc) {
            mode = argv[++i];
        } else if (strcmp(argv[i], "--samples") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &samples) != 0) {
                fprintf(stderr, "error: --samples no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--buffer-mb") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &buffer_mb) != 0) {
                fprintf(stderr, "error: --buffer-mb no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--seed") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &seed) != 0) {
                fprintf(stderr, "error: --seed no es un número válido\n");
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

    if (samples == 0 || samples > (unsigned long long)SIZE_MAX) {
        fprintf(stderr, "error: --samples debe ser mayor que 0\n");
        return 2;
    }
    if (buffer_mb == 0 || buffer_mb > 4096) {
        fprintf(stderr, "error: --buffer-mb debe estar entre 1 y 4096\n");
        return 2;
    }
    if (strcmp(mode, "hit") != 0 && strcmp(mode, "miss") != 0 &&
        strcmp(mode, "both") != 0) {
        fprintf(stderr, "error: --mode debe ser hit, miss o both\n");
        return 2;
    }
    if (seed > UINT_MAX) {
        fprintf(stderr, "error: --seed debe caber en unsigned int\n");
        return 2;
    }

    size_t buffer_size = (size_t)buffer_mb * 1024u * 1024u;
    uint8_t *buffer = NULL;
    if (posix_memalign((void **)&buffer, 64, buffer_size) != 0) {
        fprintf(stderr, "error: no se pudo reservar %zu bytes alineados\n",
                buffer_size);
        return 1;
    }
    memset(buffer, 1, buffer_size);
    size_t n_lines = buffer_size / 64;

    FILE *out = stdout;
    if (out_path && strcmp(out_path, "-") != 0) {
        out = fopen(out_path, "w");
        if (!out) {
            fprintf(stderr, "error: no se pudo abrir %s: %s\n", out_path,
                    strerror(errno));
            free(buffer);
            return 1;
        }
    }

    machine_info mi;
    machine_info_init(&mi, machine_id);

    fputs("machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,"
          "mode,sample,cycles\n",
          out);

    if (strcmp(mode, "hit") == 0 || strcmp(mode, "both") == 0) {
        if (run_mode(out, &mi, "hit", (size_t)samples, buffer, n_lines,
                     (unsigned int)seed) != 0) {
            if (out != stdout) fclose(out);
            free(buffer);
            return 1;
        }
    }
    if (strcmp(mode, "miss") == 0 || strcmp(mode, "both") == 0) {
        if (run_mode(out, &mi, "miss", (size_t)samples, buffer, n_lines,
                     (unsigned int)seed) != 0) {
            if (out != stdout) fclose(out);
            free(buffer);
            return 1;
        }
    }

    if (out != stdout) fclose(out);
    free(buffer);
    return 0;
}
