"""Pruebas de E1 jerárquico: Sattolo, CSV nuevo y compatibilidad antigua."""

from __future__ import annotations

import csv
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "analysis"))

import common  # noqa: E402
import plot_e1_hierarchy as hierarchy  # noqa: E402


def write_csv(path: Path, header: list[str], rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=header)
        writer.writeheader()
        writer.writerows(rows)


def hierarchy_row(size: int, rep: int, value: float, **extra: str) -> dict:
    row = {
        "machine_id": "cpu_a",
        "session_id": "s1",
        "timestamp": "2026-01-01T00:00:00Z",
        "working_set_bytes": str(size),
        "node_size_bytes": "64",
        "hops": "1000",
        "repetition": str(rep),
        "total_cycles": str(int(value * 1000)),
        "cycles_per_load": f"{value:.6f}",
        "seed": "23901",
        "hugepage": "none",
    }
    row.update(extra)
    return row


class SattoloTest(unittest.TestCase):
    def test_c_permutation_is_a_single_cycle(self) -> None:
        binary = ROOT / "bin" / "e1_hierarchy"
        if not binary.is_file():
            self.skipTest("bin/e1_hierarchy no está compilado")
        output = subprocess.check_output(
            [
                str(binary),
                "--working-set",
                "4096",
                "--seed",
                "7",
                "--dump-permutation",
            ],
            text=True,
        )
        permutation = [int(value) for value in output.split()]
        nodes = 4096 // 64
        self.assertEqual(sorted(permutation), list(range(nodes)))
        seen = set()
        current = 0
        for _ in range(nodes):
            self.assertNotIn(current, seen)
            seen.add(current)
            current = permutation[current]
        self.assertEqual(current, 0)
        self.assertEqual(len(seen), nodes)


class CsvParsingTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.data = Path(self.tmp.name)
        self.machine = "cpu_a"
        self.session = "s1"
        self.directory = self.data / self.machine / self.session
        self.directory.mkdir(parents=True)
        self.path = self.directory / f"e1_hierarchy_{self.machine}.csv"

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def test_new_hierarchy_csv_is_parsed(self) -> None:
        write_csv(
            self.path,
            list(common.HIERARCHY_COLUMNS),
            [
                hierarchy_row(4096, 0, 3.0),
                hierarchy_row(4096, 1, 5.0),
                hierarchy_row(8192, 0, 4.0),
            ],
        )
        self.assertTrue(common.is_hierarchy_csv(self.path))
        rows = hierarchy.load_hierarchy(self.path)
        groups = hierarchy.group_by_size(rows)
        self.assertEqual(sorted(groups), [4096, 8192])
        self.assertAlmostEqual(hierarchy.median(groups[4096]), 4.0)

    def test_old_e1_csv_is_rejected_as_hierarchy(self) -> None:
        old_path = self.data / self.machine / f"e1_{self.machine}.csv"
        write_csv(
            old_path,
            [
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
            ],
            [{"machine_id": self.machine, "mode": "hit", "sample": "0", "cycles": "4"}],
        )
        self.assertFalse(common.is_hierarchy_csv(old_path))
        with self.assertRaises(ValueError):
            hierarchy.load_hierarchy(old_path)

    def test_find_e1_path_keeps_old_structure(self) -> None:
        old_path = self.data / self.machine / f"e1_{self.machine}.csv"
        write_csv(
            old_path,
            [
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
            ],
            [{"machine_id": self.machine, "mode": "hit", "sample": "0", "cycles": "4"}],
        )
        found = common.find_e1_path(self.machine, data_dir=self.data)
        self.assertEqual(found, old_path)

    def test_find_data_file_prefers_requested_session(self) -> None:
        write_csv(
            self.path,
            list(common.HIERARCHY_COLUMNS),
            [hierarchy_row(4096, 0, 3.0)],
        )
        found = common.find_data_file(
            self.machine,
            f"e1_hierarchy_{self.machine}.csv",
            data_dir=self.data,
            session_id=self.session,
        )
        self.assertEqual(found, self.path)


class PlateauTest(unittest.TestCase):
    def test_cache_env_uses_per_instance_l1_l2(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "env_cpu.txt"
            path.write_text(
                "L1d cache: 192 KiB (6 instances)\n"
                "L2 cache: 3 MiB (6 instances)\n"
                "L3 cache: 16 MiB (1 instance)\n",
                encoding="utf-8",
            )
            cache = hierarchy.parse_cache_env(path)
        self.assertEqual(cache["L1d"], 32 * 1024)
        self.assertEqual(cache["L2"], 512 * 1024)
        self.assertEqual(cache["L3"], 16 * 1024 * 1024)

    def test_plateau_uses_25_to_75_percent_and_bootstrap(self) -> None:
        rows = [
            hierarchy_row(4096, 0, 3.0),
            hierarchy_row(8192, 0, 4.0),
            hierarchy_row(16384, 0, 5.0),
            hierarchy_row(32768, 0, 100.0),
        ]
        cache = {"L1d": 32768}
        blocks = hierarchy.build_plateaus("cpu_a", rows, cache, n_boot=200, seed=1)
        l1 = next(block for block in blocks if block["level"] == "L1d")
        self.assertEqual(l1["status"], "ok")
        self.assertEqual(l1["n_points"], 2)
        self.assertEqual(l1["range_low_bytes"], 8192)
        self.assertEqual(l1["range_high_bytes"], 24576)
        self.assertAlmostEqual(l1["cycles_per_load"], 4.5)
        self.assertLessEqual(l1["ci_low"], l1["cycles_per_load"])
        self.assertGreaterEqual(l1["ci_high"], l1["cycles_per_load"])

        missing = next(block for block in blocks if block["level"] == "L2")
        self.assertEqual(missing["status"], "sin-ficha")
        memory = next(block for block in blocks if block["level"] == "memoria")
        self.assertEqual(memory["status"], "ok")
        self.assertAlmostEqual(memory["cycles_per_load"], 100.0)


if __name__ == "__main__":
    unittest.main()
