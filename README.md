# Universal Conversion Engine

A full-stack 9-in-1 unit conversion system built around a MIPS Assembly conversion core, a Python Flask bridge, and a React/Tailwind dashboard with a persistent audit log.

## Features

- 9 conversion categories: Temperature, Currency, Length, Volume, Weight, Speed, Energy, Pressure, and Time.
- Dynamic System Log stored in SQLite, with per-record delete and full clear controls.
- Flask API for browser-to-engine communication.
- React/Tailwind dashboard served by Flask.
- Optional MARS execution mode when `MARS_JAR` points to a local MARS simulator jar.

## Project Structure

```text
backend/
  app.py              Flask API, conversion bridge, SQLite audit log
  requirements.txt   Python dependencies
frontend/
  index.html         React/Tailwind dashboard
unit converter/
  UNIT CONVERSION CALCULATOR.asm   MIPS Assembly conversion core
```

## Run The Web App

From the project root:

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000` in your browser.

## Optional MIPS/MARS Mode

The web app works immediately through the Python bridge implementation of the same formulas. To try routing conversions through MARS, set `MARS_JAR` before starting Flask:

```powershell
$env:MARS_JAR = "C:\path\to\Mars.jar"
python app.py
```

Then enable `MIPS mode` in the dashboard. If MARS is unavailable or the simulator output cannot be parsed, the API falls back to the Python bridge so the dashboard remains usable.

## API Endpoints

- `GET /api/categories` returns all categories and conversion options.
- `POST /api/convert` runs a conversion and stores an audit record.
- `GET /api/logs` returns audit history.
- `DELETE /api/logs/<id>` deletes one record.
- `DELETE /api/logs` clears the audit log.

## Assembly Note

The assembly file remains the low-level logic core. Its main menu has been corrected so the visible `10. Exit` option exits the program instead of being rejected by validation.