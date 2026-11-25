"""Pruebas de análisis multi-máquina con CSV sintéticos."""

from __future__ import annotations

import csv
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

import compare_machines as cm  # noqa: E402


E1_HEADER = [
    "machine_id",
    "cpu",
    "family",
    "model",
    "stepping",
    "microcode",
    "kernel",
    "gcc",
    "flags",
    "mode",
    "sample",
    "cycles",
]
E2_HEADER = [
    "machine_id",
    "cpu",
    "family",
    "model",
    "stepping",
    "microcode",
    "kernel",
    "gcc",
    "flags",
    "variant",
    "threshold",
    "train",
    "run",
    "byte",
    "guess",
    "score1",
    "score2",
    "success",
    "cycles",
]
E3_HEADER = [
    "machine_id",
    "cpu",
    "family",
    "model",
    "stepping",
    "microcode",
    "kernel",
    "gcc",
    "flags",
    "variant",
    "iterations",
    "run",
    "cycles_per_iteration",
    "total_cycles",
]


def write_csv(path: Path, header: list[str], rows: list[dict]) -> None:
    with open(path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=header)
        writer.writeheader()
        writer.writerows(rows)


def row(machine: str, **extra):
    base = {
        "machine_id": machine,
        "cpu": "Test CPU",
        "family": "25",
        "model": "80",
        "stepping": "0",
        "microcode": "0x1",
        "kernel": "test",
        "gcc": "test",
        "flags": "-O2",
    }
    base.update(extra)
    return base


class CompareMachinesTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.data = Path(self.tmp.name)
        machine = "machine_a"
        directory = self.data / machine
        directory.mkdir()

        write_csv(
            directory / f"e1_{machine}.csv",
            E1_HEADER,
            [
                row(machine, mode="hit", sample=0, cycles=20),
                row(machine, mode="hit", sample=1, cycles=20),
                row(machine, mode="miss", sample=0, cycles=100),
                row(machine, mode="miss", sample=1, cycles=100),
            ],
        )
        write_csv(
            directory / f"e2_{machine}_baseline.csv",
            E2_HEADER,
            [
                row(
                    machine,
                    variant="baseline",
                    threshold=60,
                    train=5,
                    run=0,
                    byte=0,
                    guess=83,
                    score1=10,
                    score2=1,
                    success=1,
                    cycles="",
                ),
                row(
                    machine,
                    variant="baseline",
                    threshold=60,
                    train=5,
                    run=0,
                    byte=1,
                    guess=0,
                    score1=1,
                    score2=10,
                    success=0,
                    cycles="",
                ),
            ],
        )
        write_csv(
            directory / f"e2_{machine}_lfence.csv",
            E2_HEADER,
            [
                row(
                    machine,
                    variant="lfence",
                    threshold=60,
                    train=5,
                    run=0,
                    byte=0,
                    guess=1,
                    score1=2,
                    score2=1,
                    success=0,
                    cycles="",
                ),
                row(
                    machine,
                    variant="lfence",
                    threshold=60,
                    train=5,
                    run=0,
                    byte=1,
                    guess=1,
                    score1=3,
                    score2=1,
                    success=0,
                    cycles="",
                ),
            ],
        )
        write_csv(
            directory / f"e3_{machine}_baseline.csv",
            E3_HEADER,
            [
                row(
                    machine,
                    variant="baseline",
                    iterations=100,
                    run=0,
                    cycles_per_iteration=10,
                    total_cycles=1000,
                ),
                row(
                    machine,
                    variant="baseline",
                    iterations=100,
                    run=1,
                    cycles_per_iteration=10,
                    total_cycles=1000,
                ),
            ],
        )
        write_csv(
            directory / f"e3_{machine}_lfence.csv",
            E3_HEADER,
            [
                row(
                    machine,
                    variant="lfence",
                    iterations=100,
                    run=0,
                    cycles_per_iteration=20,
                    total_cycles=2000,
                ),
                row(
                    machine,
                    variant="lfence",
                    iterations=100,
                    run=1,
                    cycles_per_iteration=20,
                    total_cycles=2000,
                ),
            ],
        )

    def tearDown(self):
        self.tmp.cleanup()

    def test_discovers_machine_with_data(self):
        self.assertEqual(cm.discover_machines(self.data), ["machine_a"])

    def test_discovers_machine_with_session_e1(self):
        machine = "machine_b"
        session = self.data / machine / "session_a"
        session.mkdir(parents=True)
        write_csv(
            session / f"e1_{machine}.csv",
            E1_HEADER,
            [
                row(machine, mode="hit", sample=0, cycles=30),
                row(machine, mode="hit", sample=1, cycles=30),
                row(machine, mode="miss", sample=0, cycles=200),
                row(machine, mode="miss", sample=1, cycles=200),
            ],
        )

        self.assertIn(machine, cm.discover_machines(self.data))
        summary = cm.summarize_machine(self.data, machine)
        self.assertEqual(summary["e1"]["suggested_threshold"], 115)
        self.assertIn("session_a", summary["e1"]["path"])

    def test_ignores_legacy_final_machine_by_default(self):
        machine = "machine_final"
        directory = self.data / machine
        directory.mkdir()
        write_csv(
            directory / f"e1_{machine}.csv",
            E1_HEADER,
            [
                row(machine, mode="hit", sample=0, cycles=20),
                row(machine, mode="miss", sample=0, cycles=100),
            ],
        )

        self.assertNotIn(machine, cm.discover_machines(self.data))
        self.assertIn(machine, cm.discover_machines(self.data, include_legacy=True))

    def test_summarizes_e1_e2_e3(self):
        summary = cm.summarize_machine(self.data, "machine_a")
        self.assertEqual(summary["e1"]["suggested_threshold"], 60)
        self.assertEqual(summary["e2"]["baseline"]["successes"], 1)
        self.assertEqual(summary["e2"]["baseline"]["total"], 2)
        self.assertAlmostEqual(summary["e2"]["baseline"]["rate"], 0.5)
        self.assertAlmostEqual(summary["e2"]["lfence"]["rate"], 0.0)
        self.assertAlmostEqual(summary["e3"]["lfence"]["pct"], 100.0)
        self.assertAlmostEqual(summary["e3"]["lfence"]["slowdown"], 2.0)


if __name__ == "__main__":
    unittest.main()
