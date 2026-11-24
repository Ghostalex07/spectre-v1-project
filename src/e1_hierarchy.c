/* E1 jerárquico: latencia de pointer chasing frente al tamaño del working set.
 *
 * El buffer contiene nodos de una línea (64 B por defecto). Cada nodo guarda
 * un puntero al siguiente y la cadena es un único ciclo generado con Sattolo.
 * Así se recorre todo el working set sin accesos especulativos útiles y el
 * compilador no puede eliminar las cargas dependientes.
 */

#include "common.h"

#include <errno.h>
#include <limits.h>
#include <sched.h>
#include <strings.h>
#include <sys/mman.h>
#include <time.h>

#define DEFAULT_MIN_BYTES 4096u
#define DEFAULT_MAX_BYTES (256u * 1024u * 1024u)
#define DEFAULT_NODE_SIZE 64u
#define DEFAULT_HOPS 1000000u
#define DEFAULT_REPS 30u
#define DEFAULT_SEED 23901u

static volatile uintptr_t sink;

typedef struct {
    size_t *values;
    size_t count;
    size_t capacity;
} size_list;

static void usage(const char *prog) {
    fprintf(stderr,
            "Uso: %s [opciones]\n"
            "  --machine-id ID       Identificador del equipo (o MACHINE_ID)\n"
            "  --session-id ID       Sesión de medida (o SESSION_ID; defecto manual)\n"
            "  --sizes LISTA         Tamaños en bytes separados por comas (admite K/M/G)\n"
            "  --working-set BYTES   Un único tamaño de working set\n"
            "  --min-bytes BYTES     Inicio del barrido por defecto (4 KiB)\n"
            "  --max-bytes BYTES     Fin del barrido por defecto (256 MiB)\n"
            "  --node-size BYTES     Tamaño de nodo, múltiplo de 64 (defecto 64)\n"
            "  --hops N              Cargas medidas por repetición (defecto 1000000)\n"
            "  --reps N              Repeticiones por tamaño (defecto 30)\n"
            "  --warmup-passes N     Pasadas completas antes de medir (defecto 1)\n"
            "  --seed N              Semilla de Sattolo (defecto 23901)\n"
            "  --hugepage            Pide MADV_HUGEPAGE (sin privilegios)\n"
            "  --out FILE            CSV de salida (defecto stdout)\n"
            "  --dump-permutation    Imprime la permutación de un único tamaño y sale\n"
            "  --help                Muestra esta ayuda\n",
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

static int parse_size(const char *s, size_t *out) {
    if (!s || !*s) return -1;
    errno = 0;
    char *end = NULL;
    unsigned long long value = strtoull(s, &end, 10);
    if (errno != 0 || end == s) return -1;

    unsigned long long multiplier = 1;
    if (*end != '\0') {
        if (strcasecmp(end, "b") == 0) {
            multiplier = 1;
        } else if (strcasecmp(end, "k") == 0 ||
                   strcasecmp(end, "kib") == 0) {
            multiplier = 1024ull;
        } else if (strcasecmp(end, "m") == 0 ||
                   strcasecmp(end, "mib") == 0) {
            multiplier = 1024ull * 1024ull;
        } else if (strcasecmp(end, "g") == 0 ||
                   strcasecmp(end, "gib") == 0) {
            multiplier = 1024ull * 1024ull * 1024ull;
        } else {
            return -1;
        }
    }
    if (value > (unsigned long long)SIZE_MAX / multiplier) return -1;
    *out = (size_t)(value * multiplier);
    return 0;
}

static int size_list_add(size_list *list, size_t value) {
    if (list->count == list->capacity) {
        size_t new_capacity = list->capacity ? list->capacity * 2 : 64;
        size_t *values = realloc(list->values, new_capacity * sizeof *values);
        if (!values) return -1;
        list->values = values;
        list->capacity = new_capacity;
    }
    list->values[list->count++] = value;
    return 0;
}

static int compare_size(const void *a, const void *b) {
    size_t x = *(const size_t *)a;
    size_t y = *(const size_t *)b;
    return (x > y) - (x < y);
}

/* Ordena y elimina duplicados in situ. */
static void size_list_sort_unique(size_list *list) {
    if (list->count == 0) return;
    qsort(list->values, list->count, sizeof *list->values, compare_size);
    size_t write = 1;
    for (size_t i = 1; i < list->count; i++) {
        if (list->values[i] != list->values[write - 1])
            list->values[write++] = list->values[i];
    }
    list->count = write;
}

/* Barrido logarítmico con potencias de dos y puntos intermedios 1,5·2^k. */
static int default_sizes(size_list *list, size_t min_bytes, size_t max_bytes) {
    if (min_bytes > max_bytes) return -1;
    for (unsigned int k = 12; k < 63; k++) {
        if ((1ull << k) > (unsigned long long)max_bytes) break;
        size_t low = (size_t)1 << k;
        if (low >= min_bytes && size_list_add(list, low) != 0) return -1;
        size_t mid = low + low / 2;
        if (mid <= max_bytes && mid >= min_bytes &&
            size_list_add(list, mid) != 0) {
            return -1;
        }
    }
    size_list_sort_unique(list);
    return list->count ? 0 : -1;
}

static int parse_size_list(const char *text, size_list *list) {
    char *copy = strdup(text);
    if (!copy) return -1;
    int rc = 0;
    char *save = NULL;
    for (char *token = strtok_r(copy, ",", &save); token;
         token = strtok_r(NULL, ",", &save)) {
        size_t value = 0;
        if (parse_size(token, &value) != 0 || value == 0 ||
            size_list_add(list, value) != 0) {
            rc = -1;
            break;
        }
    }
    free(copy);
    if (rc != 0) return -1;
    size_list_sort_unique(list);
    return list->count ? 0 : -1;
}

/* Sattolo: cada iteración elige j < i, de modo que la permutación resultante
 * tiene un único ciclo. Es la diferencia clave con Fisher-Yates (j <= i). */
static void sattolo_permutation(size_t *perm, size_t n, unsigned int seed) {
    for (size_t i = 0; i < n; i++) perm[i] = i;
    unsigned int state = seed;
    for (size_t i = n - 1; i > 0; i--) {
        size_t j = (size_t)(rand_r(&state) % i);
        size_t tmp = perm[i];
        perm[i] = perm[j];
        perm[j] = tmp;
    }
}

static void link_chain(uint8_t *buffer, size_t nodes, size_t node_size,
                       const size_t *perm) {
    for (size_t i = 0; i < nodes; i++) {
        uintptr_t next = (uintptr_t)(buffer + perm[i] * node_size);
        memcpy(buffer + i * node_size, &next, sizeof next);
    }
}

/* Recorre el ciclo completo; así todo el working set pasa por caché antes de
 * la medida y no se confunde el primer acceso con un fallo de capacidad. */
static void warm_chain(void *head, size_t nodes, unsigned int passes) {
    for (unsigned int pass = 0; pass < passes; pass++) {
        uintptr_t p = (uintptr_t)head;
        for (size_t i = 0; i < nodes; i++)
            p = *(volatile uintptr_t *)p;
        sink = p;
    }
}

/* Misma secuencia de barreras que src/e1_cache.c: lfence antes y después de
 * rdtscp. Las cargas dependientes impiden que el compilador las pliegue. */
static uint64_t chase_cycles(void *head, size_t hops) {
    uintptr_t p = (uintptr_t)head;

    lfence();
    uint64_t t0 = rdtscp();
    for (size_t i = 0; i < hops; i++)
        p = *(volatile uintptr_t *)p;
    lfence();
    uint64_t t1 = rdtscp();
    sink = p;
    return t1 - t0;
}

static void iso_timestamp(char *out, size_t size) {
    time_t now = time(NULL);
    struct tm tm;
    if (gmtime_r(&now, &tm) == NULL || strftime(out, size, "%Y-%m-%dT%H:%M:%SZ",
                                                &tm) == 0) {
        snprintf(out, size, "unknown");
    }
}

static int dump_permutation(size_t working_set, size_t node_size,
                            unsigned int seed) {
    if (working_set < 2 * node_size || working_set % node_size != 0) {
        fprintf(stderr,
                "error: --working-set debe ser múltiplo de --node-size y "
                "contener al menos dos nodos\n");
        return 2;
    }
    size_t nodes = working_set / node_size;
    size_t *perm = malloc(nodes * sizeof *perm);
    if (!perm) {
        fprintf(stderr, "error: no se pudo reservar la permutación\n");
        return 1;
    }
    sattolo_permutation(perm, nodes, seed);
    for (size_t i = 0; i < nodes; i++) printf("%zu\n", perm[i]);
    free(perm);
    return 0;
}

int main(int argc, char **argv) {
    const char *machine_id = NULL;
    const char *session_id = getenv("SESSION_ID");
    const char *out_path = NULL;
    const char *sizes_text = NULL;
    size_t working_set = 0;
    size_t min_bytes = DEFAULT_MIN_BYTES;
    size_t max_bytes = DEFAULT_MAX_BYTES;
    size_t node_size = DEFAULT_NODE_SIZE;
    unsigned long long hops = DEFAULT_HOPS;
    unsigned long long reps = DEFAULT_REPS;
    unsigned long long warmup_passes = 1;
    unsigned long long seed = DEFAULT_SEED;
    int hugepage = 0;
    int dump_perm = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--machine-id") == 0 && i + 1 < argc) {
            machine_id = argv[++i];
        } else if (strcmp(argv[i], "--session-id") == 0 && i + 1 < argc) {
            session_id = argv[++i];
        } else if (strcmp(argv[i], "--sizes") == 0 && i + 1 < argc) {
            sizes_text = argv[++i];
        } else if (strcmp(argv[i], "--working-set") == 0 && i + 1 < argc) {
            if (parse_size(argv[++i], &working_set) != 0) {
                fprintf(stderr, "error: --working-set no es válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--min-bytes") == 0 && i + 1 < argc) {
            if (parse_size(argv[++i], &min_bytes) != 0) {
                fprintf(stderr, "error: --min-bytes no es válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--max-bytes") == 0 && i + 1 < argc) {
            if (parse_size(argv[++i], &max_bytes) != 0) {
                fprintf(stderr, "error: --max-bytes no es válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--node-size") == 0 && i + 1 < argc) {
            if (parse_size(argv[++i], &node_size) != 0) {
                fprintf(stderr, "error: --node-size no es válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--hops") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &hops) != 0) {
                fprintf(stderr, "error: --hops no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--reps") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &reps) != 0) {
                fprintf(stderr, "error: --reps no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--warmup-passes") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &warmup_passes) != 0) {
                fprintf(stderr, "error: --warmup-passes no es válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--seed") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &seed) != 0) {
                fprintf(stderr, "error: --seed no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--hugepage") == 0) {
            hugepage = 1;
        } else if (strcmp(argv[i], "--out") == 0 && i + 1 < argc) {
            out_path = argv[++i];
        } else if (strcmp(argv[i], "--dump-permutation") == 0) {
            dump_perm = 1;
        } else {
            fprintf(stderr, "error: opción desconocida o incompleta: %s\n",
                    argv[i]);
            usage(argv[0]);
            return 2;
        }
    }

    if (seed > UINT_MAX) {
        fprintf(stderr, "error: --seed debe caber en unsigned int\n");
        return 2;
    }
    if (node_size < 64 || node_size % 64 != 0) {
        fprintf(stderr, "error: --node-size debe ser múltiplo de 64\n");
        return 2;
    }
    if (dump_perm) {
        if (working_set == 0) {
            fprintf(stderr, "error: --dump-permutation requiere --working-set\n");
            return 2;
        }
        return dump_permutation((size_t)working_set, (size_t)node_size,
                                (unsigned int)seed);
    }

    if (hops == 0 || reps == 0 || warmup_passes == 0) {
        fprintf(stderr,
                "error: --hops, --reps y --warmup-passes deben ser > 0\n");
        return 2;
    }

    size_list sizes = {0};
    if (sizes_text) {
        if (parse_size_list(sizes_text, &sizes) != 0) {
            fprintf(stderr, "error: --sizes contiene un valor no válido\n");
            return 2;
        }
    } else if (working_set != 0) {
        if (size_list_add(&sizes, (size_t)working_set) != 0) {
            fprintf(stderr, "error: no se pudo preparar el tamaño\n");
            return 2;
        }
    } else if (default_sizes(&sizes, (size_t)min_bytes, (size_t)max_bytes) !=
               0) {
        fprintf(stderr, "error: no se pudo generar el barrido de tamaños\n");
        return 2;
    }

    for (size_t i = 0; i < sizes.count; i++) {
        if (sizes.values[i] < 2 * (size_t)node_size ||
            sizes.values[i] % node_size != 0 ||
            (sizes.values[i] / (size_t)node_size) < 2) {
            fprintf(stderr,
                    "error: el tamaño %zu B debe ser múltiplo de %zu B y "
                    "contener al menos dos nodos\n",
                    sizes.values[i], node_size);
            free(sizes.values);
            return 2;
        }
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
            free(sizes.values);
            return 1;
        }
    }

    fputs("machine_id,session_id,timestamp,working_set_bytes,node_size_bytes,"
          "hops,repetition,total_cycles,cycles_per_load,seed,cpu_pinned,"
          "hugepage\n",
          out);

    machine_info mi;
    machine_info_init(&mi, machine_id);

    for (size_t s = 0; s < sizes.count; s++) {
        size_t bytes = sizes.values[s];
        size_t nodes = bytes / (size_t)node_size;
        uint8_t *buffer = NULL;
        if (posix_memalign((void **)&buffer, 64, bytes) != 0) {
            fprintf(stderr, "error: no se pudo reservar %zu B alineados\n",
                    bytes);
            if (out != stdout) fclose(out);
            free(sizes.values);
            return 1;
        }
        memset(buffer, 0, bytes);

        const char *hugepage_status = "none";
        if (hugepage) {
            hugepage_status = madvise(buffer, bytes, MADV_HUGEPAGE) == 0
                                  ? "madvise"
                                  : "madvise-failed";
        }

        size_t *perm = malloc(nodes * sizeof *perm);
        if (!perm) {
            fprintf(stderr, "error: no se pudo reservar la permutación\n");
            free(buffer);
            if (out != stdout) fclose(out);
            free(sizes.values);
            return 1;
        }
        sattolo_permutation(perm, nodes, (unsigned int)seed);
        link_chain(buffer, nodes, (size_t)node_size, perm);
        free(perm);

        for (size_t rep = 0; rep < reps; rep++) {
            warm_chain(buffer, nodes, (unsigned int)warmup_passes);
            uint64_t total = chase_cycles(buffer, (size_t)hops);
            double per_load = (double)total / (double)hops;
            csv_write_quoted(out, mi.machine_id);
            fputc(',', out);
            csv_write_quoted(out, session);
            fputc(',', out);
            csv_write_quoted(out, timestamp);
            fprintf(out, ",%zu,%zu,%llu,%zu,%llu,%.6f,%llu,%d,%s\n", bytes,
                    node_size, hops, rep, (unsigned long long)total, per_load,
                    seed, cpu, hugepage_status);
        }

        free(buffer);
    }

    if (out != stdout) fclose(out);
    free(sizes.values);
    return 0;
}
