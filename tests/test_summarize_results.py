"""Pruebas del resumen Markdown de resultados."""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

import summarize_results  # noqa: E402


def sample_row(**overrides: str) -> dict[str, str]:
    row = {
        "machine_id": "cpu_a",
        "cpu": "CPU A",
        "family": "25",
        "model": "80",
        "stepping": "0",
        "microcode": "0x1",
        "kernel": "6.8",
        "gcc": "11.4",
        "threshold": "138",
        "hit_median": "46.0",
        "hit_median_low": "45.8",
        "hit_median_high": "46.2",
        "miss_median": "276.0",
        "miss_median_low": "275.0",
        "miss_median_high": "277.0",
        "e2_baseline_rate": "1.0",
        "e2_baseline_rate_low": "0.995",
        "e2_baseline_rate_high": "1.0",
        "e2_lfence_rate": "0.0",
        "e2_lfence_rate_low": "0.0",
        "e2_lfence_rate_high": "0.002",
        "e2_mask_rate": "0.0",
        "e2_mask_rate_low": "0.0",
        "e2_mask_rate_high": "0.002",
        "e3_baseline_cycles": "3.3",
        "e3_baseline_median_low": "3.2",
        "e3_baseline_median_high": "3.4",
        "e3_lfence_cycles": "13.3",
        "e3_lfence_median_low": "13.2",
        "e3_lfence_median_high": "13.4",
        "e3_mask_cycles": "3.4",
        "e3_mask_median_low": "3.3",
        "e3_mask_median_high": "3.5",
        "e3_lfence_pct": "300.0",
        "e3_mask_pct": "1.3",
    }
    row.update(overrides)
    return row


class SummarizeResultsTest(unittest.TestCase):
    def test_renders_machine_and_metrics(self) -> None:
        text = summarize_results.render_summary(
            [sample_row()], "Resumen de prueba", include_e2=True
        )
        self.assertIn("# Resumen de prueba", text)
        self.assertIn("`cpu_a`", text)
        self.assertIn("138", text)
        self.assertIn("1.000 [0.995, 1.000]", text)
        self.assertIn("+300.0%", text)
        self.assertIn("+1.3%", text)

    def test_e2_is_omitted_by_default(self) -> None:
        text = summarize_results.render_summary([sample_row()], "Resumen")
        self.assertNotIn("## E2", text)
        self.assertIn("## E3", text)

    def test_single_machine_warns_about_coverage(self) -> None:
        text = summarize_results.render_summary([sample_row()], "Resumen")
        self.assertIn("una sola microarquitectura", text)

    def test_missing_values_render_as_na(self) -> None:
        row = sample_row(
            e2_lfence_rate="",
            e2_lfence_rate_low="",
            e2_lfence_rate_high="",
            e3_mask_pct="",
        )
        text = summarize_results.render_summary([row], "Resumen")
        self.assertIn("n/a", text)

    def test_two_machines_do_not_emit_single_machine_warning(self) -> None:
        rows = [sample_row(), sample_row(machine_id="cpu_b")]
        text = summarize_results.render_summary(rows, "Resumen")
        self.assertNotIn("una sola microarquitectura", text)

    def test_duplicate_cpu_is_not_counted_as_diversity(self) -> None:
        rows = [sample_row(), sample_row(machine_id="cpu_a_final")]
        text = summarize_results.render_summary(rows, "Resumen")
        self.assertIn("Microarquitecturas distintas: **1**", text)
        self.assertIn("no equipos", text)


if __name__ == "__main__":
    unittest.main()
