"""Pruebas del validador de fichas de entorno."""

from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "analysis"))

import validate_data  # noqa: E402


class ValidateDataTest(unittest.TestCase):
    def test_legacy_root_without_env_only_warns(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            machine = root / "cpu_a"
            machine.mkdir()
            (machine / "e1_cpu_a.csv").write_text(
                "mode,sample,cycles\n", encoding="utf-8"
            )
            errors, warnings = validate_data.validate(root)
            self.assertTrue(warnings)
            self.assertFalse(errors)

    def test_session_without_env_is_error(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            session = root / "cpu_a" / "2026-01-01_120000"
            session.mkdir(parents=True)
            (session / "e1_cpu_a.csv").write_text(
                "mode,sample,cycles\n", encoding="utf-8"
            )
            errors, warnings = validate_data.validate(root)
            self.assertTrue(errors)

    def test_session_with_env_is_ok(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            session = root / "cpu_a" / "2026-01-01_120000"
            session.mkdir(parents=True)
            (session / "e1_cpu_a.csv").write_text(
                "mode,sample,cycles\n", encoding="utf-8"
            )
            (session / "env_cpu_a.txt").write_text("cpu: test\n", encoding="utf-8")
            errors, warnings = validate_data.validate(root)
            self.assertEqual(errors, [])
            self.assertEqual(warnings, [])


if __name__ == "__main__":
    unittest.main()
