"""Pruebas de la comparativa extendida: frecuencia y agregación de mesetas."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

import compare_extended as ce  # noqa: E402


class FrequencyTest(unittest.TestCase):
    def test_parse_cpu_mhz_from_env(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "env.txt"
            path.write_text(
                "processor\t: 0\ncpu MHz\t\t: 2470.329\n",
                encoding="utf-8",
            )
            self.assertAlmostEqual(ce.env_frequency_mhz(path), 2470.329, places=3)

    def test_parse_cur_freq_khz_when_mhz_missing(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "env.txt"
            path.write_text(
                "cpu3: governor=powersave\ncpu3: cur_freq_khz=4291952\n",
                encoding="utf-8",
            )
            self.assertAlmostEqual(ce.env_frequency_mhz(path), 4291.952, places=3)


class AggregationTest(unittest.TestCase):
    def test_two_sessions_are_not_aggregated(self) -> None:
        ok, reason = ce.should_aggregate([2400.0, 2500.0])
        self.assertFalse(ok)
        self.assertIn("3", reason)

    def test_frequency_spread_above_ten_percent_blocks_aggregation(self) -> None:
        ok, reason = ce.should_aggregate([2400.0, 4300.0, 4250.0])
        self.assertFalse(ok)
        self.assertIn("frecuencia", reason)

    def test_three_sessions_with_similar_frequency_are_aggregated(self) -> None:
        ok, reason = ce.should_aggregate([4200.0, 4290.0, 4250.0])
        self.assertTrue(ok, reason)


if __name__ == "__main__":
    unittest.main()
