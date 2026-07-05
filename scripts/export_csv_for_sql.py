# -*- coding: utf-8 -*-
"""Genera los CSV procesados listos para BULK INSERT en SQL Server."""

from __future__ import annotations

import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW_FILE = ROOT / "data" / "raw" / "Impact_of_Remote_Work_on_Mental_Health.json"
PROCESSED_DIR = ROOT / "data" / "processed"
EMPLEADOS_CSV = PROCESSED_DIR / "CSV_Empleados.csv"
METRICAS_CSV = PROCESSED_DIR / "CSV_Metricas_Empleados.csv"

INDUSTRY_MAP = {
    "Healthcare": ("Atencion Sanitaria", 1),
    "IT": ("IT", 2),
    "Education": ("Educacion", 3),
    "Finance": ("Finanzas", 4),
    "Consulting": ("Consultoria", 5),
    "Manufacturing": ("Manufactura", 6),
    "Retail": ("Comercio Minorista", 7),
}

REGION_MAP = {
    "Europe": ("Europa", 1),
    "Asia": ("Asia", 2),
    "North America": ("America del Norte", 3),
    "South America": ("America del Sur", 4),
    "Oceania": ("Oceania", 5),
    "Africa": ("Africa", 6),
}

ROLE_MAP = {
    "HR": 1,
    "Data Scientist": 2,
    "Software Engineer": 3,
    "Sales": 4,
    "Marketing": 5,
    "Designer": 6,
    "Project Manager": 7,
}

SLEEP_MAP = {"Good": 1, "Poor": 2, "Average": 3}
ACTIVITY_MAP = {"Weekly": 1, "None": 2, "Daily": 3}
LOCATION_MAP = {"Remote": "Remoto", "Hybrid": "Hibrido", "Onsite": "Presencial"}
STRESS_MAP = {"High": "Alto", "Medium": "Medio", "Low": "Bajo"}
CONDITION_MAP = {
    "Depression": "Depresion",
    "Anxiety": "Ansiedad",
    "Burnout": "Agotamiento",
    "None": "Ninguna",
}
SATISFACTION_MAP = {
    "Satisfied": "Satisfecho",
    "Neutral": "Neutral",
    "Unsatisfied": "Insatisfecho",
}
ACCESS_MAP = {"Yes": "Si", "No": "No"}
PRODUCTIVITY_MAP = {
    "Increase": "Aumento",
    "Decrease": "Disminucion",
    "No Change": "Sin Cambio",
}


def main() -> None:
    rows = json.loads(RAW_FILE.read_text(encoding="utf-8"))
    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

    empleados_header = [
        "ID_Empleado",
        "Edad",
        "Genero",
        "Anos_de_Experiencia",
        "Satisfaccion_con_Trabajo_Remoto",
    ]
    metricas_header = [
        "ID_Metrica",
        "Ubicacion_de_Trabajo",
        "Horas_Trabajadas_por_Semana",
        "Numero_de_Reuniones_Virtuales",
        "Calificacion_Equilibrio_Vida_Laboral",
        "Nivel_de_Estres",
        "Condicion_de_Salud_Mental",
        "Acceso_a_Recursos_de_Salud_Mental",
        "Cambio_en_Productividad",
        "Calificacion_de_Aislamiento_Social",
        "ApoyoEmpresa_para_TrabajoRemoto",
        "ID_Empleado",
        "ID_Region",
        "ID_Rol",
        "ID_Industria",
        "ID_Sueno",
        "ID_Actividad_Fisica",
    ]

    with EMPLEADOS_CSV.open("w", encoding="utf-8", newline="") as emp_file, METRICAS_CSV.open(
        "w", encoding="utf-8", newline=""
    ) as met_file:
        emp_writer = csv.writer(emp_file, delimiter=";")
        met_writer = csv.writer(met_file, delimiter=";")
        emp_writer.writerow(empleados_header)
        met_writer.writerow(metricas_header)

        for index, row in enumerate(rows, start=1):
            emp_writer.writerow(
                [
                    index,
                    row["Age"],
                    row["Gender"],
                    row["Years_of_Experience"],
                    SATISFACTION_MAP[row["Satisfaction_with_Remote_Work"]],
                ]
            )
            met_writer.writerow(
                [
                    index,
                    LOCATION_MAP[row["Work_Location"]],
                    row["Hours_Worked_Per_Week"],
                    row["Number_of_Virtual_Meetings"],
                    row["Work_Life_Balance_Rating"],
                    STRESS_MAP[row["Stress_Level"]],
                    CONDITION_MAP[row["Mental_Health_Condition"]],
                    ACCESS_MAP[row["Access_to_Mental_Health_Resources"]],
                    PRODUCTIVITY_MAP[row["Productivity_Change"]],
                    row["Social_Isolation_Rating"],
                    row["Company_Support_for_Remote_Work"],
                    index,
                    REGION_MAP[row["Region"]][1],
                    ROLE_MAP[row["Job_Role"]],
                    INDUSTRY_MAP[row["Industry"]][1],
                    SLEEP_MAP[row["Sleep_Quality"]],
                    ACTIVITY_MAP[row["Physical_Activity"]],
                ]
            )

    print(f"Generado: {EMPLEADOS_CSV}")
    print(f"Generado: {METRICAS_CSV}")
    print(f"Filas exportadas: {len(rows)}")


if __name__ == "__main__":
    main()
