"""Pruebas de IQR y bootstrap del cociente de medianas."""

from __future__ import annotations

import math
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

import common  # noqa: E402


class StatsExtraTest(unittest.TestCase):
    def test_iqr_known_values(self) -> None:
        self.assertAlmostEqual(common.iqr([1, 2, 3, 4, 5]), 2.0)

    def test_iqr_empty_is_nan(self) -> None:
        self.assertTrue(math.isnan(common.iqr([])))

    def test_median_ratio_ci_contains_observed_ratio(self) -> None:
        numerator = [10.0, 10.2, 9.8, 10.1, 9.9]
        denominator = [2.0, 2.1, 1.9, 2.0, 2.05]
        ratio, low, high = common.median_ratio_ci(
            numerator, denominator, n_boot=2000, seed=7
        )
        self.assertAlmostEqual(ratio, 5.0, places=1)
        self.assertLess(low, ratio)
        self.assertGreater(high, ratio)
        self.assertLessEqual(low, high)

    def test_median_ratio_ci_is_reproducible(self) -> None:
        numerator = [10.0, 10.2, 9.8, 10.1, 9.9]
        denominator = [2.0, 2.1, 1.9, 2.0, 2.05]
        first = common.median_ratio_ci(numerator, denominator, n_boot=500, seed=3)
        second = common.median_ratio_ci(numerator, denominator, n_boot=500, seed=3)
        self.assertEqual(first, second)

    def test_median_ratio_ci_empty_is_nan(self) -> None:
        ratio, low, high = common.median_ratio_ci([], [2.0])
        self.assertTrue(math.isnan(ratio))
        self.assertTrue(math.isnan(low))
        self.assertTrue(math.isnan(high))


if __name__ == "__main__":
    unittest.main()
