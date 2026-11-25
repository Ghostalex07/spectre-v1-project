"""Verificación automática del ensamblador del barrido E3.

Comprueba, sobre `bin/e3_sweep` (y sobre `docs/asm/e3_sweep.asm` si existe):
  - `load_lfence` contiene `lfence`;
  - `load_baseline` tiene un salto condicional en el chequeo y ningún `cmov`;
  - `load_mask` no contiene `lfence` (la máscara es aritmética).
"""

from __future__ import annotations

import re
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BINARY = ROOT / "bin" / "e3_sweep"
ASM_FILE = ROOT / "docs" / "asm" / "e3_sweep.asm"

FUNC_RE = re.compile(r"^[0-9a-f]+ <([^>]+)>:$")
INSN_RE = re.compile(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2}\s+)+\s*([a-z][a-z0-9.]*)")
COND_JUMPS = {
    "ja",
    "jae",
    "jb",
    "jbe",
    "jc",
    "je",
    "jg",
    "jge",
    "jl",
    "jle",
    "jna",
    "jnae",
    "jnb",
    "jnbe",
    "jnc",
    "jne",
    "jng",
    "jnge",
    "jnl",
    "jnle",
    "jno",
    "jnp",
    "jns",
    "jnz",
    "jo",
    "jp",
    "jpe",
    "jpo",
    "js",
    "jz",
}


def split_functions(text: str) -> dict[str, list[str]]:
    functions: dict[str, list[str]] = {}
    current: str | None = None
    for line in text.splitlines():
        match = FUNC_RE.match(line)
        if match:
            current = match.group(1)
            functions.setdefault(current, [])
            continue
        if current is None:
            continue
        functions[current].append(line)
    return functions


def mnemonics(lines: list[str]) -> list[str]:
    out = []
    for line in lines:
        match = INSN_RE.match(line)
        if match:
            out.append(match.group(1))
    return out


def load_text() -> str:
    if BINARY.is_file():
        return subprocess.check_output(
            ["objdump", "-d", "-Mintel", str(BINARY)], text=True
        )
    if ASM_FILE.is_file():
        return ASM_FILE.read_text(encoding="utf-8")
    raise unittest.SkipTest("ni bin/e3_sweep ni docs/asm/e3_sweep.asm existen")


class E3AsmTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.functions = split_functions(load_text())

    def function_body(self, name: str) -> list[str]:
        self.assertIn(name, self.functions, f"no se encontró {name} en el asm")
        return self.functions[name]

    def test_lfence_contains_lfence(self) -> None:
        self.assertIn("lfence", mnemonics(self.function_body("load_lfence")))

    def test_baseline_has_conditional_jump_and_no_cmov(self) -> None:
        ops = mnemonics(self.function_body("load_baseline"))
        self.assertTrue(
            any(op in COND_JUMPS for op in ops),
            f"load_baseline no tiene salto condicional: {ops}",
        )
        self.assertFalse(
            any(op.startswith("cmov") for op in ops),
            f"load_baseline usa cmov: {ops}",
        )

    def test_mask_has_conditional_jump_and_no_lfence(self) -> None:
        ops = mnemonics(self.function_body("load_mask"))
        self.assertTrue(
            any(op in COND_JUMPS for op in ops),
            f"load_mask no tiene salto condicional: {ops}",
        )
        self.assertFalse(
            any(op.startswith("cmov") for op in ops),
            f"load_mask usa cmov: {ops}",
        )
        self.assertNotIn("lfence", ops)


class DocumentedAsmTest(unittest.TestCase):
    def test_docs_asm_matches_rules_when_present(self) -> None:
        if not ASM_FILE.is_file():
            self.skipTest("docs/asm/e3_sweep.asm no está generado")
        functions = split_functions(ASM_FILE.read_text(encoding="utf-8"))
        lfence_ops = mnemonics(functions["load_lfence"])
        baseline_ops = mnemonics(functions["load_baseline"])
        mask_ops = mnemonics(functions["load_mask"])
        self.assertIn("lfence", lfence_ops)
        self.assertTrue(any(op in COND_JUMPS for op in baseline_ops))
        self.assertFalse(any(op.startswith("cmov") for op in baseline_ops))
        self.assertTrue(any(op in COND_JUMPS for op in mask_ops))
        self.assertNotIn("lfence", mask_ops)


if __name__ == "__main__":
    unittest.main()
