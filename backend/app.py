from __future__ import annotations

import os
import re
import sqlite3
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Callable

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS


ROOT = Path(__file__).resolve().parents[1]
ASM_FILE = ROOT / "unit converter" / "UNIT CONVERSION CALCULATOR.asm"
DB_FILE = ROOT / "backend" / "conversions.db"
STATIC_DIR = ROOT / "frontend"

app = Flask(__name__, static_folder=str(STATIC_DIR), static_url_path="")
CORS(app)


def linear(factor: float, op: str = "mul") -> Callable[[float, float | None], float]:
    if op == "div":
        return lambda value, _rate=None: value / factor
    return lambda value, _rate=None: value * factor


def add(amount: float) -> Callable[[float, float | None], float]:
    return lambda value, _rate=None: value + amount


def currency(op: str = "mul") -> Callable[[float, float | None], float]:
    def convert(value: float, rate: float | None = None) -> float:
        if rate is None or rate <= 0:
            raise ValueError("A positive conversion rate is required for currency conversions.")
        return value / rate if op == "div" else value * rate

    return convert


CATEGORIES = {
    "temperature": {
        "label": "Temperature",
        "menu": 1,
        "conversions": {
            "c_to_f": {"label": "Celsius to Fahrenheit", "menu": 1, "fn": lambda v, _r=None: (v * 1.8) + 32},
            "f_to_c": {"label": "Fahrenheit to Celsius", "menu": 2, "fn": lambda v, _r=None: (v - 32) * 0.5555556},
            "k_to_f": {"label": "Kelvin to Fahrenheit", "menu": 3, "fn": lambda v, _r=None: ((v - 273.15) * 1.8) + 32},
            "c_to_k": {"label": "Celsius to Kelvin", "menu": 4, "fn": add(273.15)},
            "f_to_k": {"label": "Fahrenheit to Kelvin", "menu": 5, "fn": lambda v, _r=None: ((v - 32) * 0.5555556) + 273.15},
        },
    },
    "currency": {
        "label": "Currency",
        "menu": 2,
        "requires_rate": True,
        "conversions": {
            "usd_to_eur": {"label": "USD to Euro", "menu": 1, "fn": currency("mul")},
            "eur_to_usd": {"label": "Euro to USD", "menu": 2, "fn": currency("div")},
            "usd_to_gbp": {"label": "USD to GBP", "menu": 3, "fn": currency("mul")},
            "eur_to_gbp": {"label": "Euro to GBP", "menu": 4, "fn": currency("mul")},
            "gbp_to_usd": {"label": "GBP to USD", "menu": 5, "fn": currency("mul")},
        },
    },
    "length": {
        "label": "Length",
        "menu": 3,
        "conversions": {
            "m_to_ft": {"label": "Meters to Feet", "menu": 1, "fn": linear(3.28084)},
            "ft_to_m": {"label": "Feet to Meters", "menu": 2, "fn": linear(3.28084, "div")},
            "m_to_yd": {"label": "Meters to Yards", "menu": 3, "fn": linear(1.09361)},
            "yd_to_m": {"label": "Yards to Meters", "menu": 4, "fn": linear(1.09361, "div")},
            "m_to_in": {"label": "Meters to Inches", "menu": 5, "fn": linear(39.3701)},
        },
    },
    "volume": {
        "label": "Volume",
        "menu": 4,
        "conversions": {
            "l_to_gal": {"label": "Liters to Gallons", "menu": 1, "fn": linear(0.264172)},
            "gal_to_l": {"label": "Gallons to Liters", "menu": 2, "fn": linear(0.264172, "div")},
            "ml_to_oz": {"label": "Milliliters to Ounces", "menu": 3, "fn": linear(0.033814)},
            "oz_to_ml": {"label": "Ounces to Milliliters", "menu": 4, "fn": linear(0.033814, "div")},
            "l_to_m3": {"label": "Liters to Cubic Meters", "menu": 5, "fn": linear(1000.0, "div")},
        },
    },
    "weight": {
        "label": "Weight",
        "menu": 5,
        "conversions": {
            "kg_to_lb": {"label": "Kilograms to Pounds", "menu": 1, "fn": linear(2.20462)},
            "lb_to_kg": {"label": "Pounds to Kilograms", "menu": 2, "fn": linear(2.20462, "div")},
            "g_to_oz": {"label": "Grams to Ounces", "menu": 3, "fn": linear(0.033814)},
            "oz_to_g": {"label": "Ounces to Grams", "menu": 4, "fn": linear(0.033814, "div")},
            "kg_to_st": {"label": "Kilograms to Stones", "menu": 5, "fn": linear(0.157473)},
        },
    },
    "speed": {
        "label": "Speed",
        "menu": 6,
        "conversions": {
            "ms_to_kmh": {"label": "Meters/Second to Kilometers/Hour", "menu": 1, "fn": linear(3.6)},
            "kmh_to_ms": {"label": "Kilometers/Hour to Meters/Second", "menu": 2, "fn": linear(3.6, "div")},
            "mph_to_kmh": {"label": "Miles/Hour to Kilometers/Hour", "menu": 3, "fn": linear(1.60934)},
            "kmh_to_mph": {"label": "Kilometers/Hour to Miles/Hour", "menu": 4, "fn": linear(1.60934, "div")},
            "fps_to_ms": {"label": "Feet/Second to Meters/Second", "menu": 5, "fn": linear(0.3048)},
        },
    },
    "energy": {
        "label": "Energy",
        "menu": 7,
        "conversions": {
            "j_to_cal": {"label": "Joules to Calories", "menu": 1, "fn": linear(4.184, "div")},
            "cal_to_j": {"label": "Calories to Joules", "menu": 2, "fn": linear(4.184)},
            "kwh_to_j": {"label": "Kilowatt-hours to Joules", "menu": 3, "fn": linear(3600000.0)},
            "j_to_kwh": {"label": "Joules to Kilowatt-hours", "menu": 4, "fn": linear(3600000.0, "div")},
            "cal_to_kj": {"label": "Calories to Kilojoules", "menu": 5, "fn": lambda v, _r=None: (v * 4.184) / 1000.0},
        },
    },
    "pressure": {
        "label": "Pressure",
        "menu": 8,
        "conversions": {
            "pa_to_atm": {"label": "Pascals to Atmospheres", "menu": 1, "fn": linear(101325.0, "div")},
            "atm_to_pa": {"label": "Atmospheres to Pascals", "menu": 2, "fn": linear(101325.0)},
            "pa_to_bar": {"label": "Pascals to Bar", "menu": 3, "fn": linear(100000.0, "div")},
            "bar_to_pa": {"label": "Bar to Pascals", "menu": 4, "fn": linear(100000.0)},
            "torr_to_atm": {"label": "Torr to Atmospheres", "menu": 5, "fn": linear(760.0, "div")},
        },
    },
    "time": {
        "label": "Time",
        "menu": 9,
        "conversions": {
            "sec_to_min": {"label": "Seconds to Minutes", "menu": 1, "fn": linear(60.0, "div")},
            "min_to_sec": {"label": "Minutes to Seconds", "menu": 2, "fn": linear(60.0)},
            "min_to_hour": {"label": "Minutes to Hours", "menu": 3, "fn": linear(60.0, "div")},
            "hour_to_day": {"label": "Hours to Days", "menu": 4, "fn": linear(24.0, "div")},
            "day_to_hour": {"label": "Days to Hours", "menu": 5, "fn": linear(24.0)},
        },
    },
}


def init_db() -> None:
    DB_FILE.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(DB_FILE) as db:
        db.execute(
            """
            CREATE TABLE IF NOT EXISTS conversions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                created_at TEXT NOT NULL,
                category TEXT NOT NULL,
                conversion TEXT NOT NULL,
                input_value REAL NOT NULL,
                rate REAL,
                result REAL NOT NULL,
                engine TEXT NOT NULL
            )
            """
        )


def row_to_dict(row: sqlite3.Row) -> dict:
    return dict(row)


def get_db() -> sqlite3.Connection:
    db = sqlite3.connect(DB_FILE)
    db.row_factory = sqlite3.Row
    return db


def public_categories() -> list[dict]:
    payload = []
    for key, data in CATEGORIES.items():
        payload.append(
            {
                "id": key,
                "label": data["label"],
                "requiresRate": bool(data.get("requires_rate")),
                "conversions": [
                    {"id": conv_key, "label": conv["label"]}
                    for conv_key, conv in data["conversions"].items()
                ],
            }
        )
    return payload


def convert_python(category_id: str, conversion_id: str, value: float, rate: float | None) -> float:
    try:
        converter = CATEGORIES[category_id]["conversions"][conversion_id]["fn"]
    except KeyError as exc:
        raise ValueError("Unknown category or conversion.") from exc
    return float(converter(value, rate))


def convert_with_mars(category_id: str, conversion_id: str, value: float, rate: float | None) -> float:
    mars_jar = os.getenv("MARS_JAR")
    if not mars_jar:
        raise RuntimeError("MARS_JAR is not configured.")

    category = CATEGORIES[category_id]
    conversion = category["conversions"][conversion_id]
    inputs = [str(category["menu"]), str(conversion["menu"])]
    if category.get("requires_rate"):
        inputs.append(str(rate))
    inputs.extend([str(value), "0"])

    completed = subprocess.run(
        ["java", "-jar", mars_jar, "nc", str(ASM_FILE)],
        input="\n".join(inputs) + "\n",
        capture_output=True,
        text=True,
        timeout=10,
        check=True,
    )
    match = re.search(r"The result is:\s*([-+]?\d+(?:\.\d+)?)", completed.stdout)
    if not match:
        raise RuntimeError("MARS output did not contain a parseable result.")
    return float(match.group(1))


def calculate(category_id: str, conversion_id: str, value: float, rate: float | None, prefer_mips: bool) -> tuple[float, str]:
    if prefer_mips:
        try:
            return convert_with_mars(category_id, conversion_id, value, rate), "mips-mars"
        except Exception:
            pass
    return convert_python(category_id, conversion_id, value, rate), "python-api"


@app.get("/")
def index():
    return send_from_directory(STATIC_DIR, "index.html")


@app.get("/api/categories")
def categories():
    return jsonify(public_categories())


@app.get("/api/logs")
def logs():
    with get_db() as db:
        rows = db.execute("SELECT * FROM conversions ORDER BY id DESC").fetchall()
    return jsonify([row_to_dict(row) for row in rows])


@app.post("/api/convert")
def convert():
    payload = request.get_json(force=True)
    try:
        category_id = str(payload["category"])
        conversion_id = str(payload["conversion"])
        value = float(payload["value"])
        rate = payload.get("rate")
        rate = None if rate in ("", None) else float(rate)
        result, engine = calculate(category_id, conversion_id, value, rate, bool(payload.get("preferMips")))
    except (KeyError, TypeError, ValueError) as exc:
        return jsonify({"error": str(exc)}), 400

    created_at = datetime.now(timezone.utc).isoformat()
    with get_db() as db:
        cursor = db.execute(
            """
            INSERT INTO conversions (created_at, category, conversion, input_value, rate, result, engine)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (created_at, category_id, conversion_id, value, rate, result, engine),
        )
        db.commit()
        row = db.execute("SELECT * FROM conversions WHERE id = ?", (cursor.lastrowid,)).fetchone()

    return jsonify(row_to_dict(row)), 201


@app.delete("/api/logs/<int:log_id>")
def delete_log(log_id: int):
    with get_db() as db:
        db.execute("DELETE FROM conversions WHERE id = ?", (log_id,))
        db.commit()
    return "", 204


@app.delete("/api/logs")
def clear_logs():
    with get_db() as db:
        db.execute("DELETE FROM conversions")
        db.commit()
    return "", 204


init_db()


if __name__ == "__main__":
    app.run(debug=True, port=int(os.getenv("PORT", "5000")))
