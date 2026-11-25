/* E3 barrido de sensibilidad.
 *
 * Mide el coste del chequeo de límites de Spectre V1 con tres variantes
 * (baseline, lfence y mask) en función de:
 *
 *   - W: trabajo dependiente del dato cargado (0, 1, 2, 4, ..., 64).
 *   - predictibilidad: todos los índices en rango (`inrange`) o una fracción
 *     de índices fuera de rango generada al azar (`random_pX`, X = 1, 10, 50).
 *   - tamaño del array de datos (al menos un tamaño que quepa en L1 y otro
 *     mayor que L3).
 *
 * Los índices se generan completos ANTES de medir, con una semilla que queda
 * registrada en el CSV. Las variantes se intercalan en bloques: en cada bloque
 * y repetición se mide cada variante en un orden aleatorio derivado de la
 * misma semilla. Antes de cada medida se ejecuta un calentamiento.
 *
 * No hay secretos, ni Flush+Reload, ni lógica de ataque: solo se mide coste.
 */

#include "common.h"

#include <errno.h>
#include <limits.h>
#include <sched.h>
#include <strings.h>
#include <time.h>

#define DEFAULT_WORK "0,1,2,4,8,16,32,64"
#define DEFAULT_PRED "inrange,random_p1,random_p10,random_p50"
#define DEFAULT_ARRAYS "4096,67108864"
#define DEFAULT_ITERATIONS 200000ULL
#define DEFAULT_BLOCKS 15ULL
#define DEFAULT_REPS 3ULL
#define DEFAULT_SEED 20261124ULL
#define DEFAULT_WARMUP 256ULL

#define VARIANT_COUNT 3

static volatile uint8_t e3_sink;

typedef unsigned long long ull;

typedef struct {
    const char *name;
    unsigned char (*load)(const uint8_t *, size_t, size_t);
} variant_spec;

typedef struct {
    ull *values;
    size_t count;
    size_t capacity;
} ull_list;

typedef struct {
    size_t *values;
    size_t count;
    size_t capacity;
} size_list;

typedef struct {
    char name[32];
    int percent; /* 0 para inrange; 1, 10 o 50 para random_pX */
} pred_mode;

typedef struct {
    pred_mode *values;
    size_t count;
    size_t capacity;
} pred_list;

static void usage(const char *prog) {
    fprintf(stderr,
            "Uso: %s [opciones]\n"
            "  --machine-id ID        Identificador del equipo (o MACHINE_ID)\n"
            "  --session-id ID        Sesión de medida (o SESSION_ID; defecto manual)\n"
            "  --work LISTA           Trabajo W separado por comas (defecto %s)\n"
            "  --predictability LISTA inrange,random_p1,random_p10,random_p50 (defecto %s)\n"
            "  --array-bytes LISTA    Tamaños de array separados por comas (defecto %s)\n"
            "  --iterations N         Iteraciones por medida (defecto %llu)\n"
            "  --blocks N             Bloques aleatorizados (defecto %llu)\n"
            "  --reps N               Repeticiones por bloque (defecto %llu)\n"
            "  --seed N               Semilla de índices y orden (defecto %llu)\n"
            "  --warmup N             Llamadas de calentamiento (defecto %llu)\n"
            "  --out FILE             CSV de salida (defecto stdout)\n"
            "  --help                 Muestra esta ayuda\n",
            prog, DEFAULT_WORK, DEFAULT_PRED, DEFAULT_ARRAYS,
            DEFAULT_ITERATIONS, DEFAULT_BLOCKS, DEFAULT_REPS, DEFAULT_SEED,
            DEFAULT_WARMUP);
}

static int parse_ull(const char *s, ull *out) {
    if (!s || !*s) return -1;
    errno = 0;
    char *end = NULL;
    ull v = strtoull(s, &end, 10);
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

static int ull_list_add(ull_list *list, ull value) {
    if (list->count == list->capacity) {
        size_t new_capacity = list->capacity ? list->capacity * 2 : 16;
        ull *values = realloc(list->values, new_capacity * sizeof *values);
        if (!values) return -1;
        list->values = values;
        list->capacity = new_capacity;
    }
    list->values[list->count++] = value;
    return 0;
}

static int size_list_add(size_list *list, size_t value) {
    if (list->count == list->capacity) {
        size_t new_capacity = list->capacity ? list->capacity * 2 : 16;
        size_t *values = realloc(list->values, new_capacity * sizeof *values);
        if (!values) return -1;
        list->values = values;
        list->capacity = new_capacity;
    }
    list->values[list->count++] = value;
    return 0;
}

static int pred_list_add(pred_list *list, const char *text) {
    pred_mode mode;
    if (strcmp(text, "inrange") == 0) {
        snprintf(mode.name, sizeof mode.name, "inrange");
        mode.percent = 0;
    } else if (strncmp(text, "random_p", 8) == 0) {
        ull value = 0;
        if (parse_ull(text + 8, &value) != 0 || value == 0 || value > 100) {
            return -1;
        }
        snprintf(mode.name, sizeof mode.name, "random_p%llu", value);
        mode.percent = (int)value;
    } else {
        return -1;
    }
    if (list->count == list->capacity) {
        size_t new_capacity = list->capacity ? list->capacity * 2 : 8;
        pred_mode *values =
            realloc(list->values, new_capacity * sizeof *values);
        if (!values) return -1;
        list->values = values;
        list->capacity = new_capacity;
    }
    list->values[list->count++] = mode;
    return 0;
}

static int parse_work_list(const char *text, ull_list *list) {
    char *copy = strdup(text);
    if (!copy) return -1;
    int rc = 0;
    char *save = NULL;
    for (char *token = strtok_r(copy, ",", &save); token;
         token = strtok_r(NULL, ",", &save)) {
        ull value = 0;
        if (parse_ull(token, &value) != 0 || value > 1000000ULL ||
            ull_list_add(list, value) != 0) {
            rc = -1;
            break;
        }
    }
    free(copy);
    return rc == 0 && list->count ? 0 : -1;
}

static int parse_pred_list(const char *text, pred_list *list) {
    char *copy = strdup(text);
    if (!copy) return -1;
    int rc = 0;
    char *save = NULL;
    for (char *token = strtok_r(copy, ",", &save); token;
         token = strtok_r(NULL, ",", &save)) {
        if (pred_list_add(list, token) != 0) {
            rc = -1;
            break;
        }
    }
    free(copy);
    return rc == 0 && list->count ? 0 : -1;
}

static int parse_size_list(const char *text, size_list *list) {
    char *copy = strdup(text);
    if (!copy) return -1;
    int rc = 0;
    char *save = NULL;
    for (char *token = strtok_r(copy, ",", &save); token;
         token = strtok_r(NULL, ",", &save)) {
        size_t value = 0;
        if (parse_size(token, &value) != 0 || value < 64 ||
            size_list_add(list, value) != 0) {
            rc = -1;
            break;
        }
    }
    free(copy);
    return rc == 0 && list->count ? 0 : -1;
}

/* splitmix64: PRNG pequeño y determinista para índices y orden de bloques. */
static inline ull splitmix64_next(ull *state) {
    ull z = (*state += 0x9e3779b97f4a7c15ULL);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
    z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
    return z ^ (z >> 31);
}

static void iso_timestamp(char *out, size_t size) {
    time_t now = time(NULL);
    struct tm tm;
    if (gmtime_r(&now, &tm) == NULL ||
        strftime(out, size, "%Y-%m-%dT%H:%M:%SZ", &tm) == 0) {
        snprintf(out, size, "unknown");
    }
}

/* Trabajo dependiente del valor cargado. El resultado acaba en e3_sink
 * (volatile), así que el compilador no puede eliminarlo. */
static inline unsigned dependent_work(uint8_t value, unsigned work) {
    unsigned acc = (unsigned)value + 0x9e3779b9u;
    for (unsigned i = 0; i < work; i++)
        acc = acc * 1664525u + 1013904223u;
    return acc;
}

/* Las tres cargas van en funciones noinline separadas para que el
 * desensamblado de cada variante se pueda revisar por separado. */

__attribute__((noinline))
static uint8_t load_baseline(const uint8_t *array, size_t x, size_t limit) {
    if (x < limit) return array[x];
    return 0;
}

__attribute__((noinline))
static uint8_t load_lfence(const uint8_t *array, size_t x, size_t limit) {
    if (x < limit) {
        lfence();
        return array[x];
    }
    return 0;
}

/* array_index_nospec dentro de la comprobación: si x está fuera de rango no
 * se accede; si está dentro, mask = todos los bits a 1 e idx = x. El `cmp` y
 * el `sbb` van en ensamblador para que el compilador no deduzca que la rama es
 * verdadera y elimine el `and`; sin esa barrera, `array[x & mask]` se
 * optimiza a `array[x]` y la mitigación desaparece en la ruta transitoria. */
__attribute__((noinline))
static uint8_t load_mask(const uint8_t *array, size_t x, size_t limit) {
    if (x < limit) {
        size_t mask;
        __asm__ __volatile__(
            "cmp %2, %1\n\t"
            "sbb %0, %0"
            : "=r"(mask)
            : "r"(x), "r"(limit)
            : "cc");
        return array[x & mask];
    }
    return 0;
}

static const variant_spec variants[VARIANT_COUNT] = {
    {"baseline", load_baseline},
    {"lfence", load_lfence},
    {"mask", load_mask},
};

static void run_baseline(const uint8_t *array, const size_t *indices, size_t n,
                         size_t limit, unsigned work) {
    for (size_t i = 0; i < n; i++) {
        uint8_t value = load_baseline(array, indices[i], limit);
        e3_sink ^= (uint8_t)dependent_work(value, work);
    }
}

static void run_lfence(const uint8_t *array, const size_t *indices, size_t n,
                       size_t limit, unsigned work) {
    for (size_t i = 0; i < n; i++) {
        uint8_t value = load_lfence(array, indices[i], limit);
        e3_sink ^= (uint8_t)dependent_work(value, work);
    }
}

static void run_mask(const uint8_t *array, const size_t *indices, size_t n,
                     size_t limit, unsigned work) {
    for (size_t i = 0; i < n; i++) {
        uint8_t value = load_mask(array, indices[i], limit);
        e3_sink ^= (uint8_t)dependent_work(value, work);
    }
}

typedef void (*run_fn)(const uint8_t *, const size_t *, size_t, size_t,
                       unsigned);

static const run_fn run_variant[VARIANT_COUNT] = {
    run_baseline,
    run_lfence,
    run_mask,
};

/* Genera todos los índices antes de medir. Los de fuera de rango caen en
 * [limit, 2*limit), que está reservado para que un acceso especulativo no
 * toque memoria no mapeada. Devuelve la fracción real fuera de rango. */
static double generate_indices(size_t *indices, size_t iterations, size_t limit,
                               const pred_mode *mode, ull seed) {
    ull state = seed;
    size_t out_of_range = 0;
    for (size_t i = 0; i < iterations; i++) {
        ull r = splitmix64_next(&state);
        int out = mode->percent > 0 && (int)(r % 100ULL) < mode->percent;
        ull slot = splitmix64_next(&state) % (ull)limit;
        if (out) {
            out_of_range++;
            indices[i] = limit + (size_t)slot;
        } else {
            indices[i] = (size_t)slot;
        }
    }
    return iterations ? (double)out_of_range / (double)iterations : 0.0;
}

static void shuffle_variants(int *order, int n, ull *state) {
    for (int i = 0; i < n; i++) order[i] = i;
    for (int i = n - 1; i > 0; i--) {
        int j = (int)(splitmix64_next(state) % (ull)(i + 1));
        int tmp = order[i];
        order[i] = order[j];
        order[j] = tmp;
    }
}

static uint64_t measure(const uint8_t *array, const size_t *indices,
                        size_t iterations, size_t limit, unsigned work,
                        int variant) {
    lfence();
    uint64_t t0 = rdtscp();
    run_variant[variant](array, indices, iterations, limit, work);
    lfence();
    uint64_t t1 = rdtscp();
    return t1 - t0;
}

int main(int argc, char **argv) {
    const char *machine_id = NULL;
    const char *session_id = getenv("SESSION_ID");
    const char *out_path = NULL;
    const char *work_text = DEFAULT_WORK;
    const char *pred_text = DEFAULT_PRED;
    const char *arrays_text = DEFAULT_ARRAYS;
    ull iterations = DEFAULT_ITERATIONS;
    ull blocks = DEFAULT_BLOCKS;
    ull reps = DEFAULT_REPS;
    ull seed = DEFAULT_SEED;
    ull warmup = DEFAULT_WARMUP;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--machine-id") == 0 && i + 1 < argc) {
            machine_id = argv[++i];
        } else if (strcmp(argv[i], "--session-id") == 0 && i + 1 < argc) {
            session_id = argv[++i];
        } else if (strcmp(argv[i], "--work") == 0 && i + 1 < argc) {
            work_text = argv[++i];
        } else if (strcmp(argv[i], "--predictability") == 0 && i + 1 < argc) {
            pred_text = argv[++i];
        } else if (strcmp(argv[i], "--array-bytes") == 0 && i + 1 < argc) {
            arrays_text = argv[++i];
        } else if (strcmp(argv[i], "--iterations") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &iterations) != 0) {
                fprintf(stderr, "error: --iterations no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--blocks") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &blocks) != 0) {
                fprintf(stderr, "error: --blocks no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--reps") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &reps) != 0) {
                fprintf(stderr, "error: --reps no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--seed") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &seed) != 0) {
                fprintf(stderr, "error: --seed no es un número válido\n");
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

    if (iterations == 0 || iterations > (ull)SIZE_MAX / sizeof(size_t)) {
        fprintf(stderr, "error: --iterations debe ser > 0 y razonable\n");
        return 2;
    }
    if (blocks == 0 || blocks > INT_MAX || reps == 0 || reps > INT_MAX) {
        fprintf(stderr, "error: --blocks y --reps deben ser > 0 y caber en int\n");
        return 2;
    }
    if (warmup == 0) warmup = 1;

    ull_list work_list = {0};
    pred_list pred_list = {0};
    size_list array_list = {0};
    if (parse_work_list(work_text, &work_list) != 0) {
        fprintf(stderr, "error: --work contiene un valor no válido\n");
        return 2;
    }
    if (parse_pred_list(pred_text, &pred_list) != 0) {
        fprintf(stderr,
                "error: --predictability debe ser inrange o random_pX "
                "(X entre 1 y 100)\n");
        free(work_list.values);
        return 2;
    }
    if (parse_size_list(arrays_text, &array_list) != 0) {
        fprintf(stderr, "error: --array-bytes contiene un valor no válido\n");
        free(work_list.values);
        free(pred_list.values);
        return 2;
    }

    const char *session = (session_id && *session_id) ? session_id : "manual";
    char timestamp[32];
    iso_timestamp(timestamp, sizeof timestamp);
    int cpu = sched_getcpu();

    machine_info mi;
    machine_info_init(&mi, machine_id);

    FILE *out = stdout;
    if (out_path && strcmp(out_path, "-") != 0) {
        out = fopen(out_path, "w");
        if (!out) {
            fprintf(stderr, "error: no se pudo abrir %s: %s\n", out_path,
                    strerror(errno));
            free(work_list.values);
            free(pred_list.values);
            free(array_list.values);
            return 1;
        }
    }

    fputs("machine_id,session_id,timestamp,variant,flags,work_per_iter,"
          "predictability_mode,out_of_range_fraction,array_bytes,iterations,"
          "repetition,block_id,total_cycles,cycles_per_iter,seed,pinned_cpu\n",
          out);

    size_t combo_index = 0;
    int status = 0;
    for (size_t p = 0; p < pred_list.count && status == 0; p++) {
        const pred_mode *mode = &pred_list.values[p];
        for (size_t a = 0; a < array_list.count && status == 0; a++) {
            size_t limit = array_list.values[a];
            if (limit > SIZE_MAX / 2) {
                fprintf(stderr, "error: array demasiado grande: %zu\n", limit);
                status = 2;
                break;
            }
            size_t total_bytes = limit * 2;

            uint8_t *array = NULL;
            if (posix_memalign((void **)&array, 64, total_bytes) != 0 ||
                !array) {
                fprintf(stderr, "error: no se pudo reservar %zu B\n",
                        total_bytes);
                status = 1;
                break;
            }
            for (size_t i = 0; i < total_bytes; i++)
                array[i] = (uint8_t)((i * 131u + 7u) & 0xffu);

            size_t *indices = malloc((size_t)iterations * sizeof *indices);
            if (!indices) {
                fprintf(stderr, "error: no se pudieron reservar los índices\n");
                free(array);
                status = 1;
                break;
            }
            double oor = generate_indices(indices, (size_t)iterations, limit,
                                          mode, seed);

            for (size_t w = 0; w < work_list.count && status == 0; w++) {
                ull work = work_list.values[w];
                ull order_state = seed ^ 0x9e3779b97f4a7c15ULL ^
                                  ((ull)(combo_index + 1) * 0xbf58476d1ce4e5b9ULL);
                for (ull block = 0; block < blocks && status == 0; block++) {
                    for (ull rep = 0; rep < reps; rep++) {
                        int order[VARIANT_COUNT];
                        shuffle_variants(order, VARIANT_COUNT, &order_state);
                        for (int k = 0; k < VARIANT_COUNT; k++) {
                            int v = order[k];
                            ull warm = warmup < iterations ? warmup : iterations;
                            run_variant[v](array, indices, (size_t)warm, limit,
                                           (unsigned)work);
                            uint64_t total = measure(
                                array, indices, (size_t)iterations, limit,
                                (unsigned)work, v);
                            double cpi =
                                (double)total / (double)iterations;

                            csv_write_quoted(out, mi.machine_id);
                            fputc(',', out);
                            csv_write_quoted(out, session);
                            fputc(',', out);
                            csv_write_quoted(out, timestamp);
                            fprintf(out, ",%s,", variants[v].name);
                            csv_write_quoted(out, mi.flags);
                            fprintf(out,
                                    ",%llu,%s,%.6f,%zu,%llu,%llu,%llu,"
                                    "%llu,%.6f,%llu,%d\n",
                                    work, mode->name, oor,
                                    limit, iterations, rep, block,
                                    (unsigned long long)total, cpi, seed, cpu);
                        }
                    }
                }
                combo_index++;
            }

            free(indices);
            free(array);
        }
    }

    if (out != stdout) fclose(out);
    free(work_list.values);
    free(pred_list.values);
    free(array_list.values);
    return status;
}
