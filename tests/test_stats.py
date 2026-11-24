"""Pruebas de las funciones estadísticas comunes."""

from __future__ import annotations

import math
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

import common  # noqa: E402


class StatsTest(unittest.TestCase):
    def test_wilson_ci_known_values(self):
        low, high = common.wilson_ci(50, 100)
        self.assertAlmostEqual(low, 0.4038, places=4)
        self.assertAlmostEqual(high, 0.5962, places=4)

    def test_wilson_ci_zero_successes_has_upper_bound(self):
        low, high = common.wilson_ci(0, 2000)
        self.assertEqual(low, 0.0)
        self.assertGreater(high, 0.0)
        self.assertLess(high, 0.003)

    def test_median_ci_is_deterministic_and_contains_median(self):
        values = list(range(1, 31))
        first = common.median_ci(values, n_boot=500, seed=7)
        second = common.median_ci(values, n_boot=500, seed=7)
        self.assertEqual(first, second)
        low, high = first
        self.assertLessEqual(low, common.median(values))
        self.assertGreaterEqual(high, common.median(values))
        self.assertLess(low, high)

    def test_percentile_ci_contains_percentile(self):
        values = list(range(1, 101))
        low, high = common.percentile_ci(values, 95, n_boot=500, seed=11)
        self.assertLessEqual(low, common.p95(values))
        self.assertGreaterEqual(high, common.p95(values))
        self.assertLess(low, high)

    def test_empty_values_return_nan(self):
        self.assertTrue(math.isnan(common.median_ci([])[0]))
        self.assertTrue(math.isnan(common.percentile_ci([], 95)[0]))


if __name__ == "__main__":
    unittest.main()
