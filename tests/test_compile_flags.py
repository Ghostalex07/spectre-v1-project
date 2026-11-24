"""Los CSV de E3 deben registrar las flags reales de compilación."""

from __future__ import annotations

import csv
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class CompileFlagsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        subprocess.run(
            ["make", "-s", "bin/e3_baseline", "bin/e3_sweep"],
            cwd=ROOT,
            check=True,
        )
        cls.expected = subprocess.check_output(
            ["make", "-s", "print-e3-cflags"],
            cwd=ROOT,
            text=True,
        ).strip()

    def _flags_from_csv(self, path: Path) -> str:
        with open(path, newline="", encoding="utf-8") as handle:
            row = next(csv.DictReader(handle))
        return row["flags"]

    def test_e3_baseline_records_effective_flags(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "e3.csv"
            subprocess.run(
                [
                    str(ROOT / "bin" / "e3_baseline"),
                    "--machine-id",
                    "flags-test",
                    "--iterations",
                    "10",
                    "--reps",
                    "1",
                    "--out",
                    str(out),
                ],
                check=True,
                stdout=subprocess.DEVNULL,
            )
            self.assertEqual(self._flags_from_csv(out), self.expected)
            self.assertIn("-fno-if-conversion", self.expected)

    def test_e3_sweep_records_effective_flags(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "sweep.csv"
            subprocess.run(
                [
                    str(ROOT / "bin" / "e3_sweep"),
                    "--machine-id",
                    "flags-test",
                    "--work",
                    "0",
                    "--predictability",
                    "inrange",
                    "--array-bytes",
                    "4096",
                    "--iterations",
                    "10",
                    "--blocks",
                    "1",
                    "--reps",
                    "1",
                    "--seed",
                    "1",
                    "--out",
                    str(out),
                ],
                check=True,
                stdout=subprocess.DEVNULL,
            )
            self.assertEqual(self._flags_from_csv(out), self.expected)
            self.assertIn("-fno-if-conversion", self.expected)


if __name__ == "__main__":
    unittest.main()
