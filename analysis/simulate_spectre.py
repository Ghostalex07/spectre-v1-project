#!/usr/bin/env python3
"""Modelo conceptual de Spectre V1.

Esto **no ejecuta especulación real ni ataca hardware**. Simula, con reglas
explícitas, la secuencia que describe el paper: entrenamiento del predictor,
malpredicción del chequeo de límites, acceso transitorio y rastro en caché.

Sirve para explicar el mecanismo y para comparar conceptualmente `baseline`,
`lfence` y `mask`. Los resultados de hardware, si se miden, van aparte en
`data/<machine_id>/` y se interpretan como evidencia empírica, no como prueba
universal.
"""

from __future__ import annotations

import argparse
import csv
import random
from pathlib import Path

ARRAY1_SIZE = 16
ARRAY1 = list(range(1, ARRAY1_SIZE + 1))  # array1[0..15] = 1..16
DEFAULT_SECRET = "Spectre V1 test secret 0123456789ABCDEF!"
DEFAULT_OUT = "data/simulation/spectre_model.csv"


class Predictor:
    """Predictor de 2 bits muy simplificado.

    El chequeo `if (x < array1_size)` se predice como "tomado" (cuerpo de la
    función) cuando el contador está en 2 o 3. El entrenamiento con índices
    válidos lo satura; el ataque fuera de rango lo corrige después de la
    ejecución transitoria.
    """

    def __init__(self) -> None:
        self.counter = 0

    def predict_taken(self) -> bool:
        return self.counter >= 2

    def observe(self, taken: bool) -> None:
        if taken:
            self.counter = min(3, self.counter + 1)
        else:
            self.counter = max(0, self.counter - 1)


def _secret_line(secret: bytes, x: int) -> int:
    index = x - ARRAY1_SIZE
    if 0 <= index < len(secret):
        return secret[index]
    return 0


def _access(x: int, variant: str, secret: bytes) -> tuple[bool, int | None]:
    """Devuelve (es_transitorio, linea_de_array2)."""
    in_bounds = x < ARRAY1_SIZE
    if in_bounds:
        return False, ARRAY1[x]
    if variant == "lfence":
        return False, None
    if variant == "mask":
        # mask = -(x < size) = 0; idx = x & 0 = 0; array1[0] = 1.
        return True, ARRAY1[0]
    # baseline: el acceso fuera de rango se ejecuta de forma transitoria.
    return True, _secret_line(secret, x)


def _victim(
    x: int,
    predictor: Predictor,
    variant: str,
    secret: bytes,
    cache: set[int],
) -> dict:
    actual_taken = x < ARRAY1_SIZE
    predicted_taken = predictor.predict_taken()
    transient, line = _access(x, variant, secret) if predicted_taken else (False, None)

    # La arquitectura solo actualiza la caché si el acceso es arquitectónico.
    # El modelo transitorio añade la línea si la predicción fue "tomado" y la
    # variante no la bloquea.
    if actual_taken:
        cache.add(ARRAY1[x])
    elif predicted_taken and line is not None:
        cache.add(line)

    predictor.observe(actual_taken)
    return {
        "x": x,
        "predicted_taken": predicted_taken,
        "actual_taken": actual_taken,
        "transient": transient,
        "line": line,
    }


def timeline(secret_byte: int, variant: str = "baseline", train: int = 5) -> list[dict]:
    """Traza un ataque a un byte, sin ejecutar hardware."""
    secret = bytes([secret_byte])
    predictor = Predictor()
    cache: set[int] = set()
    events: list[dict] = []

    training_x = 0
    for _ in range(train):
        events.append(
            {
                "phase": "train",
                **_victim(training_x, predictor, variant, secret, cache),
            }
        )

    events.append(
        {
            "phase": "attack",
            **_victim(ARRAY1_SIZE + 0, predictor, variant, secret, cache),
        }
    )
    return events


def simulate_byte(
    secret_byte: int,
    attempts: int = 200,
    train: int = 5,
    variant: str = "baseline",
) -> dict:
    """Simula `attempts` ataques al mismo byte y devuelve la votación."""
    if variant not in {"baseline", "lfence", "mask"}:
        raise ValueError(f"variant no válida: {variant}")
    secret = bytes([secret_byte])
    scores = [0] * 256
    transient_count = 0

    for attempt in range(attempts):
        predictor = Predictor()
        cache: set[int] = set()
        training_x = attempt % ARRAY1_SIZE

        for _ in range(train):
            _victim(training_x, predictor, variant, secret, cache)

        event = _victim(ARRAY1_SIZE + 0, predictor, variant, secret, cache)
        if event["transient"]:
            transient_count += 1
        for line in cache:
            if 0 <= line < 256:
                scores[line] += 1

    order = sorted(range(256), key=lambda i: scores[i], reverse=True)
    guess = order[0]
    score1 = scores[guess]
    score2 = scores[order[1]] if len(order) > 1 else 0
    return {
        "variant": variant,
        "byte": 0,
        "secret_byte": secret_byte,
        "secret_char": _display_char(secret_byte),
        "guess": guess,
        "guess_char": _display_char(guess),
        "score1": score1,
        "score2": score2,
        "success": int(guess == secret_byte),
        "transient": int(transient_count > 0),
        "scores": scores,
    }


def simulate_secret(
    secret: str,
    attempts: int = 200,
    train: int = 5,
    variant: str = "baseline",
) -> list[dict]:
    results = []
    for byte in secret.encode("utf-8"):
        result = simulate_byte(byte, attempts=attempts, train=train, variant=variant)
        results.append(result)
    return results


def _display_char(value: int) -> str:
    if 32 <= value < 127:
        return chr(value)
    return f"\\x{value:02x}"


def write_csv(results: list[dict], path: str) -> None:
    fields = [
        "variant",
        "byte",
        "secret_byte",
        "secret_char",
        "guess",
        "guess_char",
        "score1",
        "score2",
        "success",
        "transient",
    ]
    out = Path(path)
    out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for row in results:
            writer.writerow({field: row[field] for field in fields})


def write_figure(
    secret: str,
    attempts: int,
    train: int,
    path: str,
) -> None:
    import matplotlib

    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    variants = ["baseline", "lfence", "mask"]
    fig, axes = plt.subplots(1, 3, figsize=(13, 4), sharey=True)
    for ax, variant in zip(axes, variants):
        row = simulate_byte(
            ord(secret[0]), attempts=attempts, train=train, variant=variant
        )
        scores = row["scores"]
        top = sorted(range(256), key=lambda i: scores[i], reverse=True)[:12]
        top = [i for i in top if scores[i] > 0]
        ax.bar([str(i) for i in top], [scores[i] for i in top], color="#4c78a8")
        ax.set_title(variant)
        ax.set_xlabel("línea de array2")
        ax.tick_params(axis="x", rotation=60, labelsize=7)
        ax.grid(axis="y", alpha=0.25)
    axes[0].set_ylabel("aciertos de caché (modelo)")
    fig.suptitle(
        f"Modelo conceptual de Spectre V1 — primer byte {secret[0]!r} — "
        f"{attempts} intentos"
    )
    fig.tight_layout()
    out = Path(path)
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out, dpi=160)
    print(f"figura: {out}")


def print_timeline(secret_byte: int, variant: str, train: int) -> None:
    print(f"--- timeline: variant={variant}, byte={secret_byte} ---")
    print(f"{'fase':8} {'x':>3} {'pred':>5} {'real':>5} {'trans':>5} {'linea':>5}")
    for event in timeline(secret_byte, variant=variant, train=train):
        line = "-" if event["line"] is None else str(event["line"])
        print(
            f"{event['phase']:8} {event['x']:3d} "
            f"{str(event['predicted_taken']):>5} "
            f"{str(event['actual_taken']):>5} "
            f"{str(event['transient']):>5} {line:>5}"
        )
    print()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--secret", default=DEFAULT_SECRET)
    parser.add_argument("--attempts", type=int, default=200)
    parser.add_argument("--train", type=int, default=5)
    parser.add_argument(
        "--variant",
        choices=["all", "baseline", "lfence", "mask"],
        default="all",
    )
    parser.add_argument("--out", default=DEFAULT_OUT)
    parser.add_argument("--figure", default="")
    parser.add_argument("--timeline", action="store_true")
    args = parser.parse_args()

    if args.attempts <= 0 or args.train <= 0:
        raise SystemExit("--attempts y --train deben ser positivos")

    variants = (
        ["baseline", "lfence", "mask"] if args.variant == "all" else [args.variant]
    )

    if args.timeline:
        for variant in variants:
            print_timeline(ord(args.secret[0]), variant, args.train)

    results = []
    for variant in variants:
        results.extend(
            simulate_secret(
                args.secret,
                attempts=args.attempts,
                train=args.train,
                variant=variant,
            )
        )

    write_csv(results, args.out)
    print(f"CSV: {args.out}")
    for variant in variants:
        rows = [row for row in results if row["variant"] == variant]
        ok = sum(row["success"] for row in rows)
        print(f"{variant:9} {ok}/{len(rows)} bytes correctos (modelo)")

    if args.figure:
        write_figure(args.secret, args.attempts, args.train, args.figure)


if __name__ == "__main__":
    main()
