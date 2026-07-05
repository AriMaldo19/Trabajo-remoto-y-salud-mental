# -*- coding: utf-8 -*-
import json
import sqlite3
from pathlib import Path

root = Path(__file__).resolve().parents[1]
rows = json.loads((root / "data" / "raw" / "Impact_of_Remote_Work_on_Mental_Health.json").read_text(encoding="utf-8"))
conn = sqlite3.connect(root / "data" / "processed" / "TrabajoRemoto_SaludMental.db")

checks = [
    ("Total registros", len(rows), conn.execute("SELECT COUNT(*) FROM DimEmpleados").fetchone()[0]),
    ("Remoto", sum(1 for r in rows if r["Work_Location"] == "Remote"),
     conn.execute("SELECT COUNT(*) FROM FactMetricasEmpleados WHERE Ubicacion_de_Trabajo='Remoto'").fetchone()[0]),
    ("Estres alto", sum(1 for r in rows if r["Stress_Level"] == "High"),
     conn.execute("SELECT COUNT(*) FROM FactMetricasEmpleados WHERE Nivel_de_Estres='Alto'").fetchone()[0]),
]

for label, raw, db in checks:
    ok = "OK" if raw == db else "DIFERENCIA"
    print(f"{label}: JSON={raw} | BD={db} | {ok}")

conn.close()
