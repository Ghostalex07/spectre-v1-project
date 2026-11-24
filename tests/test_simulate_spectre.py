import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

from simulate_spectre import Predictor, simulate_byte, timeline  # noqa: E402


class SimulateSpectreTest(unittest.TestCase):
    def test_predictor_learns_taken_and_mispredicts_out_of_bounds(self):
        p = Predictor()
        for _ in range(5):
            p.observe(True)
        self.assertTrue(p.predict_taken())
        p.observe(False)
        self.assertFalse(p.predict_taken() is False)  # sigue prediciendo taken tras una sola corrección

    def test_baseline_recovers_secret_and_lfence_does_not(self):
        base = simulate_byte(ord("A"), attempts=30, train=5, variant="baseline")
        lfence = simulate_byte(ord("A"), attempts=30, train=5, variant="lfence")
        mask = simulate_byte(ord("A"), attempts=30, train=5, variant="mask")
        self.assertTrue(base["success"])
        self.assertEqual(base["guess"], ord("A"))
        self.assertFalse(lfence["success"])
        self.assertFalse(mask["success"])

    def test_timeline_marks_transient_access_only_in_baseline(self):
        base = timeline(ord("A"), variant="baseline", train=5)
        lfence = timeline(ord("A"), variant="lfence", train=5)
        self.assertTrue(any(event["transient"] for event in base))
        self.assertFalse(any(event["transient"] for event in lfence))


if __name__ == "__main__":
    unittest.main()
