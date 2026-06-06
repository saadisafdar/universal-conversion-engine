from __future__ import annotations

import os
import re
import sqlite3
import subprocess
from datetime import datetime, timezone

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.abspath(os.path.join(BASE_DIR, os.pardir))
MARS_JAR = os.path.join(BASE_DIR, "Mars4_5.jar")
ASM_FILE = os.path.join(ROOT_DIR, "unit converter", "UNIT CONVERSION CALCULATOR.asm")
DB_FILE = os.path.join(BASE_DIR, "conversions.db")
STATIC_DIR = os.path.join(ROOT_DIR, "frontend")

app = Flask(__name__, static_folder=STATIC_DIR, static_url_path="")
CORS(app)


CATALOG = [
    {
        "id": 1,
        "label": "Temperature",
        "conversions": [
            {"id": 1, "label": "Celsius to Fahrenheit"},
            {"id": 2, "label": "Fahrenheit to Celsius"},
            {"id": 3, "label": "Celsius to Kelvin"},
            {"id": 4, "label": "Kelvin to Celsius"},
            {"id": 5, "label": "Fahrenheit to Kelvin"},
            {"id": 6, "label": "Kelvin to Fahrenheit"},
        ],
    },
    {
        "id": 2,
        "label": "Currency",
        "conversions": [
            {"id": 1, "label": "USD to Euro"},
            {"id": 2, "label": "Euro to USD"},
            {"id": 3, "label": "USD to GBP"},
            {"id": 4, "label": "GBP to USD"},
            {"id": 5, "label": "Euro to GBP"},
            {"id": 6, "label": "GBP to Euro"},
        ],
    },
    {
        "id": 3,
        "label": "Length",
        "conversions": [
            {"id": 1, "label": "Millimeters to Meters"},
            {"id": 2, "label": "Meters to Millimeters"},
            {"id": 3, "label": "Centimeters to Meters"},
            {"id": 4, "label": "Meters to Centimeters"},
            {"id": 5, "label": "Meters to Feet"},
            {"id": 6, "label": "Feet to Meters"},
            {"id": 7, "label": "Meters to Inches"},
            {"id": 8, "label": "Inches to Meters"},
            {"id": 9, "label": "Kilometers to Miles"},
            {"id": 10, "label": "Miles to Kilometers"},
        ],
    },
    {
        "id": 4,
        "label": "Volume",
        "conversions": [
            {"id": 1, "label": "Milliliters to Liters"},
            {"id": 2, "label": "Liters to Milliliters"},
            {"id": 3, "label": "Liters to Gallons"},
            {"id": 4, "label": "Gallons to Liters"},
            {"id": 5, "label": "Milliliters to Fluid Ounces"},
            {"id": 6, "label": "Fluid Ounces to Milliliters"},
            {"id": 7, "label": "Liters to Cubic Meters"},
            {"id": 8, "label": "Cubic Meters to Liters"},
            {"id": 9, "label": "Cups to Milliliters"},
            {"id": 10, "label": "Milliliters to Cups"},
        ],
    },
    {
        "id": 5,
        "label": "Weight",
        "conversions": [
            {"id": 1, "label": "Milligrams to Grams"},
            {"id": 2, "label": "Grams to Milligrams"},
            {"id": 3, "label": "Grams to Kilograms"},
            {"id": 4, "label": "Kilograms to Grams"},
            {"id": 5, "label": "Kilograms to Pounds"},
            {"id": 6, "label": "Pounds to Kilograms"},
            {"id": 7, "label": "Grams to Ounces"},
            {"id": 8, "label": "Ounces to Grams"},
            {"id": 9, "label": "Pounds to Ounces"},
            {"id": 10, "label": "Ounces to Pounds"},
            {"id": 11, "label": "Kilograms to Stones"},
        ],
    },
    {
        "id": 6,
        "label": "Speed",
        "conversions": [
            {"id": 1, "label": "Meters/Second to Kilometers/Hour"},
            {"id": 2, "label": "Kilometers/Hour to Meters/Second"},
            {"id": 3, "label": "Miles/Hour to Kilometers/Hour"},
            {"id": 4, "label": "Kilometers/Hour to Miles/Hour"},
            {"id": 5, "label": "Feet/Second to Meters/Second"},
            {"id": 6, "label": "Meters/Second to Miles/Hour"},
            {"id": 7, "label": "Miles/Hour to Meters/Second"},
        ],
    },
    {
        "id": 7,
        "label": "Energy",
        "conversions": [
            {"id": 1, "label": "Joules to Calories"},
            {"id": 2, "label": "Calories to Joules"},
            {"id": 3, "label": "Kilowatt-hours to Joules"},
            {"id": 4, "label": "Joules to Kilowatt-hours"},
            {"id": 5, "label": "Watt-hours to Joules"},
            {"id": 6, "label": "Joules to Watt-hours"},
            {"id": 7, "label": "BTU to Joules"},
            {"id": 8, "label": "Joules to BTU"},
            {"id": 9, "label": "Electronvolts to Joules"},
            {"id": 10, "label": "Joules to Electronvolts"},
        ],
    },
    {
        "id": 8,
        "label": "Pressure",
        "conversions": [
            {"id": 1, "label": "Pascals to Atmospheres"},
            {"id": 2, "label": "Atmospheres to Pascals"},
            {"id": 3, "label": "Pascals to Bar"},
            {"id": 4, "label": "Bar to Pascals"},
            {"id": 5, "label": "Torr to Atmospheres"},
            {"id": 6, "label": "Atmospheres to Torr"},
            {"id": 7, "label": "PSI to Pascals"},
            {"id": 8, "label": "Pascals to PSI"},
        ],
    },
    {
        "id": 9,
        "label": "Time",
        "conversions": [
            {"id": 1, "label": "Seconds to Minutes"},
            {"id": 2, "label": "Minutes to Seconds"},
            {"id": 3, "label": "Minutes to Hours"},
            {"id": 4, "label": "Hours to Minutes"},
            {"id": 5, "label": "Hours to Days"},
            {"id": 6, "label": "Days to Hours"},
            {"id": 7, "label": "Days to Seconds"},
            {"id": 8, "label": "Seconds to Days"},
        ],
    },
    {
        "id": 10,
        "label": "Data Storage",
        "conversions": [
            {"id": 1, "label": "Bytes to Kilobytes"},
            {"id": 2, "label": "Kilobytes to Bytes"},
            {"id": 3, "label": "Kilobytes to Megabytes"},
            {"id": 4, "label": "Megabytes to Kilobytes"},
            {"id": 5, "label": "Megabytes to Gigabytes"},
            {"id": 6, "label": "Gigabytes to Megabytes"},
            {"id": 7, "label": "Gigabytes to Terabytes"},
            {"id": 8, "label": "Terabytes to Gigabytes"},
            {"id": 9, "label": "Bytes to Megabytes"},
            {"id": 10, "label": "Terabytes to Bytes"},
        ],
    },
    {
        "id": 11,
        "label": "Area",
        "conversions": [
            {"id": 1, "label": "Square Meters to Square Feet"},
            {"id": 2, "label": "Square Feet to Square Meters"},
            {"id": 3, "label": "Square Meters to Acres"},
            {"id": 4, "label": "Acres to Square Meters"},
            {"id": 5, "label": "Hectares to Acres"},
            {"id": 6, "label": "Acres to Hectares"},
            {"id": 7, "label": "Square Meters to Hectares"},
            {"id": 8, "label": "Hectares to Square Meters"},
        ],
    },
    {
        "id": 12,
        "label": "Angle",
        "conversions": [
            {"id": 1, "label": "Degrees to Radians"},
            {"id": 2, "label": "Radians to Degrees"},
        ],
    },
]


VALID_CONVERSIONS = {
    category["id"]: {conversion["id"] for conversion in category["conversions"]}
    for category in CATALOG
}


def init_db() -> None:
    os.makedirs(BASE_DIR, exist_ok=True)
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


def get_db() -> sqlite3.Connection:
    db = sqlite3.connect(DB_FILE)
    db.row_factory = sqlite3.Row
    return db


def row_to_dict(row: sqlite3.Row) -> dict:
    return dict(row)


def parse_numeric_result(stdout: str) -> float:
    matches = re.findall(r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[Ee][-+]?\d+)?", stdout)
    if not matches:
        raise RuntimeError("MARS did not return a numeric result.")
    return float(matches[-1])


def run_mips_engine(category_id: int, conversion_id: int, input_value: float) -> float:
    if not os.path.exists(MARS_JAR):
        raise FileNotFoundError(f"MARS simulator not found: {MARS_JAR}")
    if not os.path.exists(ASM_FILE):
        raise FileNotFoundError(f"MIPS source not found: {ASM_FILE}")

    process = subprocess.Popen(
        ["java", "-jar", MARS_JAR, "nc", ASM_FILE],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )

    stdin_payload = f"{category_id}\n{conversion_id}\n{input_value}\n"
    try:
        stdout, stderr = process.communicate(stdin_payload, timeout=45)
    except subprocess.TimeoutExpired:
        process.kill()
        process.communicate()
        raise

    if process.returncode != 0:
        raise RuntimeError(stderr.strip() or stdout.strip() or "MARS exited with an error.")

    return parse_numeric_result(stdout.strip())


def read_conversion_payload() -> tuple[int, int, float]:
    payload = request.get_json(force=True) or {}
    category_id = int(payload.get("category_id", payload.get("category")))
    conversion_id = int(payload.get("conversion_id", payload.get("conversion")))
    input_value = float(payload.get("input_value", payload.get("value")))

    if category_id not in VALID_CONVERSIONS:
        raise ValueError("Unknown category_id.")
    if conversion_id not in VALID_CONVERSIONS[category_id]:
        raise ValueError("Unknown conversion_id for selected category.")

    return category_id, conversion_id, input_value


@app.get("/")
def index():
    return send_from_directory(STATIC_DIR, "index.html")


@app.get("/categories")
@app.get("/api/categories")
def categories():
    return jsonify(CATALOG)


@app.get("/logs")
@app.get("/api/logs")
def logs():
    with get_db() as db:
        rows = db.execute("SELECT * FROM conversions ORDER BY id DESC").fetchall()
    return jsonify([row_to_dict(row) for row in rows])


@app.post("/convert")
@app.post("/api/convert")
def convert():
    try:
        category_id, conversion_id, input_value = read_conversion_payload()
        result = run_mips_engine(category_id, conversion_id, input_value)
    except subprocess.TimeoutExpired:
        return jsonify({"error": "MARS conversion timed out. Check that the assembly file exits after one calculation."}), 504
    except (TypeError, ValueError) as exc:
        return jsonify({"error": str(exc)}), 400
    except Exception as exc:
        return jsonify({"error": str(exc)}), 500

    created_at = datetime.now(timezone.utc).isoformat()
    with get_db() as db:
        cursor = db.execute(
            """
            INSERT INTO conversions (created_at, category, conversion, input_value, rate, result, engine)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (created_at, str(category_id), str(conversion_id), input_value, None, result, "mips-mars"),
        )
        db.commit()
        row = db.execute("SELECT * FROM conversions WHERE id = ?", (cursor.lastrowid,)).fetchone()

    return jsonify(row_to_dict(row)), 201


@app.delete("/logs/<int:log_id>")
@app.delete("/api/logs/<int:log_id>")
def delete_log(log_id: int):
    with get_db() as db:
        db.execute("DELETE FROM conversions WHERE id = ?", (log_id,))
        db.commit()
    return "", 204


@app.delete("/logs")
@app.delete("/api/logs")
def clear_logs():
    with get_db() as db:
        db.execute("DELETE FROM conversions")
        db.commit()
    return "", 204


init_db()


if __name__ == "__main__":
    app.run(debug=False, use_reloader=False, port=int(os.getenv("PORT", "5000")))
