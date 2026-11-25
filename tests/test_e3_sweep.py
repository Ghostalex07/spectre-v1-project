"""Pruebas del barrido E3: CSV nuevo/antiguo y estadística por bloques."""

from __future__ import annotations

import csv
import math
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "analysis"))

import common  # noqa: E402
import plot_e3_sweep as sweep  # noqa: E402


def write_csv(path: Path, header: list[str], rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=header)
        writer.writeheader()
        writer.writerows(rows)


def sweep_row(
    variant: str,
    block: int,
    rep: int,
    value: float,
    *,
    work: int = 0,
    mode: str = "inrange",
    array_bytes: int = 4096,
    machine: str = "cpu_a",
) -> dict:
    return {
        "machine_id": machine,
        "session_id": "s1",
        "timestamp": "2026-01-01T00:00:00Z",
        "variant": variant,
        "work_per_iter": str(work),
        "predictability_mode": mode,
        "out_of_range_fraction": "0.000000",
        "array_bytes": str(array_bytes),
        "iterations": "1000",
        "repetition": str(rep),
        "block_id": str(block),
        "total_cycles": str(int(value * 1000)),
        "cycles_per_iter": f"{value:.6f}",
        "seed": "7",
    }


class CsvDetectionTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.data = Path(self.tmp.name)
        self.machine = "cpu_a"
        self.session = "s1"
        self.directory = self.data / self.machine / self.session
        self.directory.mkdir(parents=True)
        self.sweep_path = self.directory / f"e3_sweep_{self.machine}_{self.session}.csv"

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def test_new_sweep_csv_is_detected_and_legacy_is_not(self) -> None:
        write_csv(
            self.sweep_path,
            list(common.E3_SWEEP_COLUMNS),
            [sweep_row("baseline", 0, 0, 3.0)],
        )
        self.assertTrue(common.is_e3_sweep_csv(self.sweep_path))
        self.assertFalse(common.is_e3_legacy_csv(self.sweep_path))

    def test_load_sweep_accepts_explicit_path(self) -> None:
        write_csv(
            self.sweep_path,
            list(common.E3_SWEEP_COLUMNS),
            [sweep_row("baseline", 0, 0, 3.0)],
        )
        rows = sweep.load_sweep(self.machine, path=self.sweep_path)
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["variant"], "baseline")

    def test_load_sweep_skips_mask_from_obsolete_sessions(self) -> None:
        row = sweep_row("mask", 0, 0, 5.0)
        row["session_id"] = "20261124-200944"
        write_csv(
            self.sweep_path,
            list(common.E3_SWEEP_COLUMNS),
            [sweep_row("baseline", 0, 0, 3.0), row],
        )
        rows = sweep.load_sweep(self.machine, path=self.sweep_path)
        self.assertFalse(any(item["variant"] == "mask" for item in rows))
        self.assertTrue(any(item["variant"] == "baseline" for item in rows))

    def test_old_e3_csv_is_detected_and_not_parsed_as_sweep(self) -> None:
        old_path = self.data / self.machine / f"e3_{self.machine}_baseline.csv"
        write_csv(
            old_path,
            list(common.E3_LEGACY_COLUMNS),
            [
                {
                    "machine_id": self.machine,
                    "cpu": "x",
                    "family": "1",
                    "model": "2",
                    "stepping": "3",
                    "microcode": "4",
                    "kernel": "k",
                    "gcc": "g",
                    "flags": "f",
                    "variant": "baseline",
                    "iterations": "1000",
                    "run": "0",
                    "cycles_per_iteration": "3.0",
                    "total_cycles": "3000",
                }
            ],
        )
        self.assertTrue(common.is_e3_legacy_csv(old_path))
        self.assertFalse(common.is_e3_sweep_csv(old_path))

    def test_sweep_paths_find_session_file(self) -> None:
        write_csv(
            self.sweep_path,
            list(common.E3_SWEEP_COLUMNS),
            [sweep_row("baseline", 0, 0, 3.0)],
        )
        paths = common.e3_sweep_paths(
            self.machine, data_dir=self.data, session_id=self.session
        )
        self.assertEqual(paths, [self.sweep_path])


class BlockStatisticsTest(unittest.TestCase):
    def test_block_statistics_median_per_block(self) -> None:
        rows = [
            sweep_row("baseline", 0, 0, 10.0),
            sweep_row("baseline", 0, 1, 12.0),
            sweep_row("baseline", 1, 0, 20.0),
        ]
        stats = common.block_statistics(rows)
        self.assertEqual(sorted(stats), [0, 1])
        self.assertAlmostEqual(stats[0], 11.0)
        self.assertAlmostEqual(stats[1], 20.0)

    def test_paired_block_bootstrap_is_deterministic_and_contains_point(self) -> None:
        baseline = {0: 10.0, 1: 10.0, 2: 10.0}
        variant = {0: 20.0, 1: 20.0, 2: 20.0}
        first = common.paired_block_bootstrap(baseline, variant, n_boot=500, seed=9)
        second = common.paired_block_bootstrap(baseline, variant, n_boot=500, seed=9)
        self.assertEqual(first, second)
        point, low, high = first
        self.assertAlmostEqual(point, 100.0)
        self.assertLessEqual(low, point)
        self.assertGreaterEqual(high, point)

    def test_paired_uses_only_common_blocks(self) -> None:
        baseline = {0: 10.0, 1: 100.0, 2: 10.0}
        variant = {0: 20.0, 1: 20.0}  # el bloque 2 falta en la variante
        point, _, _ = common.paired_block_bootstrap(
            baseline, variant, n_boot=100, seed=1
        )
        # Solo quedan los bloques 0 y 1: mediana base 55, variante 20.
        self.assertAlmostEqual(point, 100 * (20 - 55) / 55)

    def test_empty_blocks_return_nan(self) -> None:
        point, low, high = common.paired_block_bootstrap({}, {})
        self.assertTrue(math.isnan(point))
        self.assertTrue(math.isnan(low))
        self.assertTrue(math.isnan(high))


class OverheadTableTest(unittest.TestCase):
    def test_overhead_is_relative_to_baseline_by_block(self) -> None:
        rows: list[dict] = []
        for block in range(3):
            for rep in range(2):
                rows.append(sweep_row("baseline", block, rep, 10.0))
                rows.append(sweep_row("lfence", block, rep, 20.0))
                rows.append(sweep_row("mask", block, rep, 11.0))
        table = sweep.overhead_table(rows, n_boot=200, seed=3)
        by_variant = {row["variant"]: row for row in table}
        self.assertEqual(by_variant["lfence"]["n_blocks"], 3)
        self.assertAlmostEqual(by_variant["lfence"]["overhead_pct"], 100.0)
        self.assertAlmostEqual(by_variant["mask"]["overhead_pct"], 10.0)
        self.assertAlmostEqual(by_variant["mask"]["slowdown"], 1.1)


class BinarySmokeTest(unittest.TestCase):
    def test_binary_writes_new_header_and_expected_rows(self) -> None:
        binary = ROOT / "bin" / "e3_sweep"
        if not binary.is_file():
            self.skipTest("bin/e3_sweep no está compilado")
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "e3_sweep.csv"
            subprocess.run(
                [
                    str(binary),
                    "--machine-id",
                    "smoke",
                    "--session-id",
                    "s1",
                    "--work",
                    "0,8",
                    "--predictability",
                    "inrange,random_p50",
                    "--array-bytes",
                    "4096,33554432",
                    "--iterations",
                    "50",
                    "--blocks",
                    "2",
                    "--reps",
                    "1",
                    "--warmup",
                    "8",
                    "--out",
                    str(out),
                ],
                check=True,
            )
            with open(out, newline="", encoding="utf-8") as handle:
                rows = list(csv.DictReader(handle))
            self.assertEqual(len(rows), 3 * 2 * 2 * 2 * 2 * 1)
            self.assertTrue(common.is_e3_sweep_csv(out))
            self.assertEqual(
                {row["variant"] for row in rows}, {"baseline", "lfence", "mask"}
            )


if __name__ == "__main__":
    unittest.main()
