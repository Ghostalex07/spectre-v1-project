#ifndef SPECTRE_COMMON_H
#define SPECTRE_COMMON_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/utsname.h>
#include <unistd.h>

#ifndef COMPILE_FLAGS
#define COMPILE_FLAGS "unknown"
#endif

typedef struct {
    char machine_id[64];
    char cpu[128];
    char family[32];
    char model[32];
    char stepping[32];
    char microcode[32];
    char kernel[128];
    char gcc[64];
    char flags[128];
} machine_info;

/* RDTSCP lee el contador de tiempo y espera a que las instrucciones
 * anteriores se hayan ejecutado. El clobber de memoria impide que el
 * compilador mueva accesos a través de la medida. */
static inline uint64_t rdtscp(void) {
    uint32_t lo, hi;
    __asm__ __volatile__("rdtscp" : "=a"(lo), "=d"(hi) : : "rcx", "memory");
    return ((uint64_t)hi << 32) | lo;
}

static inline void clflush(volatile void *p) {
    __asm__ __volatile__("clflush (%0)" : : "r"(p) : "memory");
}

static inline void mfence(void) {
    __asm__ __volatile__("mfence" : : : "memory");
}

static inline void lfence(void) {
    __asm__ __volatile__("lfence" : : : "memory");
}

static inline uint8_t read_u8(volatile uint8_t *p) {
    uint8_t v = *p;
    __asm__ __volatile__("" : : : "memory");
    return v;
}

/* Lee un campo de /proc/cpuinfo. Devuelve 0 si lo encuentra. */
static int read_cpuinfo_field(const char *key, char *out, size_t out_sz) {
    FILE *f = fopen("/proc/cpuinfo", "r");
    if (!f) return -1;

    char line[512];
    size_t key_len = strlen(key);
    while (fgets(line, sizeof line, f)) {
        if (strncmp(line, key, key_len) != 0) continue;
        char *p = line + key_len;
        while (*p == ' ' || *p == '\t') p++;
        if (*p != ':') continue;
        p++;
        while (*p == ' ' || *p == '\t') p++;

        char *end = p + strlen(p);
        while (end > p && (end[-1] == '\n' || end[-1] == '\r' ||
                           end[-1] == ' ' || end[-1] == '\t')) {
            *--end = '\0';
        }
        snprintf(out, out_sz, "%s", p);
        fclose(f);
        return 0;
    }
    fclose(f);
    return -1;
}

static void machine_info_init(machine_info *mi, const char *machine_id) {
    memset(mi, 0, sizeof *mi);

    const char *id = machine_id;
    if (!id || !*id) id = getenv("MACHINE_ID");
    if (!id || !*id) id = "unknown";
    snprintf(mi->machine_id, sizeof mi->machine_id, "%s", id);

    if (read_cpuinfo_field("model name", mi->cpu, sizeof mi->cpu) != 0)
        snprintf(mi->cpu, sizeof mi->cpu, "unknown");
    if (read_cpuinfo_field("cpu family", mi->family, sizeof mi->family) != 0)
        snprintf(mi->family, sizeof mi->family, "unknown");
    if (read_cpuinfo_field("model", mi->model, sizeof mi->model) != 0)
        snprintf(mi->model, sizeof mi->model, "unknown");
    if (read_cpuinfo_field("stepping", mi->stepping, sizeof mi->stepping) != 0)
        snprintf(mi->stepping, sizeof mi->stepping, "unknown");
    if (read_cpuinfo_field("microcode", mi->microcode, sizeof mi->microcode) != 0)
        snprintf(mi->microcode, sizeof mi->microcode, "unknown");

    struct utsname u;
    if (uname(&u) == 0)
        snprintf(mi->kernel, sizeof mi->kernel, "%s", u.release);
    else
        snprintf(mi->kernel, sizeof mi->kernel, "unknown");

    snprintf(mi->gcc, sizeof mi->gcc, "%s", __VERSION__);
    snprintf(mi->flags, sizeof mi->flags, "%s", COMPILE_FLAGS);
}

/* Escribe un campo CSV entre comillas, duplicando las comillas internas. */
static void csv_write_quoted(FILE *f, const char *s) {
    fputc('"', f);
    for (; *s; s++) {
        if (*s == '"') fputc('"', f);
        if (*s == '\n' || *s == '\r') {
            fputc(' ', f);
        } else {
            fputc(*s, f);
        }
    }
    fputc('"', f);
}

/* Escribe la cabecera común de máquina y deja la coma final. */
static inline void machine_info_write_prefix(FILE *f, const machine_info *mi) {
    csv_write_quoted(f, mi->machine_id);
    fputc(',', f);
    csv_write_quoted(f, mi->cpu);
    fputc(',', f);
    csv_write_quoted(f, mi->family);
    fputc(',', f);
    csv_write_quoted(f, mi->model);
    fputc(',', f);
    csv_write_quoted(f, mi->stepping);
    fputc(',', f);
    csv_write_quoted(f, mi->microcode);
    fputc(',', f);
    csv_write_quoted(f, mi->kernel);
    fputc(',', f);
    csv_write_quoted(f, mi->gcc);
    fputc(',', f);
    csv_write_quoted(f, mi->flags);
    fputc(',', f);
}

#endif
