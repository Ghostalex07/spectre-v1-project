/* Coste del temporizador: mide el intervalo vacío entre dos rdtscp con las
 * mismas barreras que E1 jerárquico, pero sin carga de datos.
 *
 * No se resta de las latencias de E1: se publica como una distribución aparte
 * para que el lector decida cuánto pesa en los tamaños pequeños. */

#include "common.h"

#include <errno.h>
#include <sched.h>
#include <time.h>

#define DEFAULT_SAMPLES 100000u
#define DEFAULT_REPS 3u
#define DEFAULT_WARMUP 1000u

static void usage(const char *prog) {
    fprintf(stderr,
            "Uso: %s [opciones]\n"
            "  --machine-id ID     Identificador del equipo (o MACHINE_ID)\n"
            "  --session-id ID     Sesión de medida (o SESSION_ID; defecto manual)\n"
            "  --samples N         Muestras por repetición (defecto 100000)\n"
            "  --reps N            Repeticiones (defecto 3)\n"
            "  --warmup N          Intervalos de calentamiento descartados (1000)\n"
            "  --out FILE          CSV de salida (defecto stdout)\n"
            "  --help              Muestra esta ayuda\n",
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

static void iso_timestamp(char *out, size_t size) {
    time_t now = time(NULL);
    struct tm tm;
    if (gmtime_r(&now, &tm) == NULL || strftime(out, size, "%Y-%m-%dT%H:%M:%SZ",
                                                &tm) == 0) {
        snprintf(out, size, "unknown");
    }
}

/* Misma secuencia de barreras que chase_cycles() en e1_hierarchy.c, sin la
 * carga dependiente intermedia. */
static uint64_t empty_interval(void) {
    lfence();
    uint64_t t0 = rdtscp();
    lfence();
    uint64_t t1 = rdtscp();
    return t1 - t0;
}

int main(int argc, char **argv) {
    const char *machine_id = NULL;
    const char *session_id = getenv("SESSION_ID");
    const char *out_path = NULL;
    unsigned long long samples = DEFAULT_SAMPLES;
    unsigned long long reps = DEFAULT_REPS;
    unsigned long long warmup = DEFAULT_WARMUP;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--machine-id") == 0 && i + 1 < argc) {
            machine_id = argv[++i];
        } else if (strcmp(argv[i], "--session-id") == 0 && i + 1 < argc) {
            session_id = argv[++i];
        } else if (strcmp(argv[i], "--samples") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &samples) != 0) {
                fprintf(stderr, "error: --samples no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--reps") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &reps) != 0) {
                fprintf(stderr, "error: --reps no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--warmup") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &warmup) != 0) {
                fprintf(stderr, "error: --warmup no es un número válido\n");
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

    if (samples == 0 || reps == 0) {
        fprintf(stderr, "error: --samples y --reps deben ser > 0\n");
        return 2;
    }

    const char *session = (session_id && *session_id) ? session_id : "manual";
    char timestamp[32];
    iso_timestamp(timestamp, sizeof timestamp);
    int cpu = sched_getcpu();

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

    fputs("machine_id,session_id,timestamp,repetition,sample,cpu_pinned,"
          "cycles\n",
          out);

    for (unsigned long long rep = 0; rep < reps; rep++) {
        for (unsigned long long i = 0; i < warmup; i++) (void)empty_interval();
        for (unsigned long long i = 0; i < samples; i++) {
            uint64_t cycles = empty_interval();
            csv_write_quoted(out, mi.machine_id);
            fputc(',', out);
            csv_write_quoted(out, session);
            fputc(',', out);
            csv_write_quoted(out, timestamp);
            fprintf(out, ",%llu,%llu,%d,%llu\n", rep, i, cpu,
                    (unsigned long long)cycles);
        }
    }

    if (out != stdout) fclose(out);
    return 0;
}
