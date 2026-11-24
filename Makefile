CC ?= gcc
CFLAGS ?= -O2 -std=c11 -Wall -Wextra -Wno-unused-parameter
LDFLAGS ?=
BIN := bin

# Evita que GCC convierta el chequeo de límites en cmov. La variante base
# necesita un salto condicional real para que el predictor pueda fallar.
E2_CFLAGS := $(CFLAGS) -fno-if-conversion -fno-if-conversion2

# Guarda los flags usados en la columna flags de los CSV.
FLAGS_DEF := -DCOMPILE_FLAGS='"$(CFLAGS)"'

E2_TARGETS := $(BIN)/e2_baseline $(BIN)/e2_lfence $(BIN)/e2_mask
E2_O0_TARGETS := $(BIN)/e2_baseline_O0 $(BIN)/e2_lfence_O0 $(BIN)/e2_mask_O0
E3_TARGETS := $(BIN)/e3_baseline $(BIN)/e3_lfence $(BIN)/e3_mask
E3_SWEEP_TARGET := $(BIN)/e3_sweep
ASM_DIR := docs/asm

# Control a -O0. No se usa para la comparación principal, pero sirve para
# comprobar que la vulnerabilidad no es un artefacto de la optimización.
E2_O0_CFLAGS := -O0 -std=c11 -Wall -Wextra -Wno-unused-parameter -fno-if-conversion -fno-if-conversion2
E2_O0_FLAGS_DEF := -DCOMPILE_FLAGS='"$(E2_O0_CFLAGS)"'

.PHONY: all clean smoke test asm simulate summary summary-e2 print-cflags

all: $(BIN)/e1_cache $(BIN)/e1_hierarchy $(BIN)/e1_timer \
	$(E2_TARGETS) $(E2_O0_TARGETS) $(E3_TARGETS) $(E3_SWEEP_TARGET)

$(BIN):
	mkdir -p $(BIN)

$(BIN)/e1_cache: src/e1_cache.c src/common.h | $(BIN)
	$(CC) $(CFLAGS) $(FLAGS_DEF) -o $@ src/e1_cache.c $(LDFLAGS)

$(BIN)/e1_hierarchy: src/e1_hierarchy.c src/common.h | $(BIN)
	$(CC) $(CFLAGS) $(FLAGS_DEF) -o $@ src/e1_hierarchy.c $(LDFLAGS)

$(BIN)/e1_timer: src/e1_timer.c src/common.h | $(BIN)
	$(CC) $(CFLAGS) $(FLAGS_DEF) -o $@ src/e1_timer.c $(LDFLAGS)

print-cflags:
	@echo '$(CFLAGS)'

$(BIN)/e2_baseline: src/e2_spectre.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -DVARIANT_BASELINE -o $@ src/e2_spectre.c $(LDFLAGS)

$(BIN)/e2_lfence: src/e2_spectre.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -DVARIANT_LFENCE -o $@ src/e2_spectre.c $(LDFLAGS)

$(BIN)/e2_mask: src/e2_spectre.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -DVARIANT_MASK -o $@ src/e2_spectre.c $(LDFLAGS)

$(BIN)/e2_baseline_O0: src/e2_spectre.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_O0_CFLAGS) $(E2_O0_FLAGS_DEF) -DVARIANT_BASELINE -o $@ src/e2_spectre.c $(LDFLAGS)

$(BIN)/e2_lfence_O0: src/e2_spectre.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_O0_CFLAGS) $(E2_O0_FLAGS_DEF) -DVARIANT_LFENCE -o $@ src/e2_spectre.c $(LDFLAGS)

$(BIN)/e2_mask_O0: src/e2_spectre.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_O0_CFLAGS) $(E2_O0_FLAGS_DEF) -DVARIANT_MASK -o $@ src/e2_spectre.c $(LDFLAGS)

$(BIN)/e3_baseline: src/e3_mitigations.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -DVARIANT_BASELINE -o $@ src/e3_mitigations.c $(LDFLAGS)

$(BIN)/e3_lfence: src/e3_mitigations.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -DVARIANT_LFENCE -o $@ src/e3_mitigations.c $(LDFLAGS)

$(BIN)/e3_mask: src/e3_mitigations.c src/spectre.h src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -DVARIANT_MASK -o $@ src/e3_mitigations.c $(LDFLAGS)

# Barrido de sensibilidad E3: contiene las tres variantes y las intercala por
# bloques. Se compila con los mismos flags que evitan el cmov en el chequeo.
$(BIN)/e3_sweep: src/e3_sweep.c src/common.h | $(BIN)
	$(CC) $(E2_CFLAGS) $(FLAGS_DEF) -o $@ src/e3_sweep.c $(LDFLAGS)

# Desensamblado de referencia para revisar el chequeo de límites.
asm: all | $(BIN)
	mkdir -p $(ASM_DIR)
	objdump -d -Mintel $(BIN)/e3_sweep > $(ASM_DIR)/e3_sweep.asm
	objdump -d -Mintel $(BIN)/e3_baseline > $(ASM_DIR)/e3_baseline.asm
	objdump -d -Mintel $(BIN)/e3_lfence > $(ASM_DIR)/e3_lfence.asm
	objdump -d -Mintel $(BIN)/e3_mask > $(ASM_DIR)/e3_mask.asm
	@echo "desensamblado en $(ASM_DIR)/"

clean:
	rm -rf $(BIN)

smoke: all
	./scripts/smoke.sh

test: all
	python3 -m unittest discover -s tests -v

simulate:
	python3 analysis/simulate_spectre.py \
		--out data/simulation/spectre_model.csv \
		--figure figures/simulation_spectre.png

summary:
	python3 analysis/compare_machines.py
	python3 analysis/summarize_results.py

summary-e2:
	python3 analysis/compare_machines.py --with-e2
	python3 analysis/summarize_results.py --include-e2-hardware
