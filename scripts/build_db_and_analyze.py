# -*- coding: utf-8 -*-
"""Carga el dataset, crea la BD normalizada y genera resultados para el README."""

from __future__ import annotations

import json
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_FILE = ROOT / "data" / "raw" / "Impact_of_Remote_Work_on_Mental_Health.json"
DB_FILE = ROOT / "data" / "processed" / "TrabajoRemoto_SaludMental.db"
OUTPUT_FILE = ROOT / "docs" / "RESULTADOS_Y_ANALISIS.md"

INDUSTRY_MAP = {
    "Healthcare": "Atencion Sanitaria",
    "IT": "IT",
    "Education": "Educacion",
    "Finance": "Finanzas",
    "Consulting": "Consultoria",
    "Manufacturing": "Manufactura",
    "Retail": "Comercio Minorista",
}

REGION_MAP = {
    "Europe": "Europa",
    "Asia": "Asia",
    "North America": "America del Norte",
    "South America": "America del Sur",
    "Oceania": "Oceania",
    "Africa": "Africa",
}

LOCATION_MAP = {"Remote": "Remoto", "Hybrid": "Hibrido", "Onsite": "Presencial"}
STRESS_MAP = {"High": "Alto", "Medium": "Medio", "Low": "Bajo"}
CONDITION_MAP = {
    "Depression": "Depresion",
    "Anxiety": "Ansiedad",
    "Burnout": "Agotamiento",
    "None": "Ninguna",
}
SLEEP_MAP = {"Good": "Bueno", "Poor": "Pobre", "Average": "Promedio"}
ACTIVITY_MAP = {"Weekly": "Semanal", "None": "Ninguno", "Daily": "Diario"}
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


def load_rows() -> list[dict]:
    with DATA_FILE.open(encoding="utf-8") as handle:
        return json.load(handle)


def create_schema(conn: sqlite3.Connection) -> None:
    conn.executescript(
        """
        DROP TABLE IF EXISTS FactMetricasEmpleados;
        DROP TABLE IF EXISTS DimEmpleados;
        DROP TABLE IF EXISTS DimRegiones;
        DROP TABLE IF EXISTS DimRoles;
        DROP TABLE IF EXISTS DimIndustrias;
        DROP TABLE IF EXISTS DimSueno;
        DROP TABLE IF EXISTS DimActividadFisica;

        CREATE TABLE DimActividadFisica (
            ID_Actividad_Fisica INTEGER PRIMARY KEY,
            Actividad_Fisica TEXT NOT NULL
        );
        CREATE TABLE DimSueno (
            ID_Sueno INTEGER PRIMARY KEY,
            Calidad_del_Sueno TEXT NOT NULL
        );
        CREATE TABLE DimIndustrias (
            ID_Industria INTEGER PRIMARY KEY,
            Industria TEXT NOT NULL
        );
        CREATE TABLE DimRoles (
            ID_Rol INTEGER PRIMARY KEY,
            Rol TEXT NOT NULL
        );
        CREATE TABLE DimRegiones (
            ID_Region INTEGER PRIMARY KEY,
            Region TEXT NOT NULL
        );
        CREATE TABLE DimEmpleados (
            ID_Empleado INTEGER PRIMARY KEY,
            Edad INTEGER NOT NULL,
            Genero TEXT NOT NULL,
            Anos_de_Experiencia INTEGER NOT NULL,
            Satisfaccion_con_Trabajo_Remoto TEXT NOT NULL
        );
        CREATE TABLE FactMetricasEmpleados (
            ID_Metrica INTEGER PRIMARY KEY,
            Ubicacion_de_Trabajo TEXT NOT NULL,
            Horas_Trabajadas_por_Semana INTEGER NOT NULL,
            Numero_de_Reuniones_Virtuales INTEGER NOT NULL,
            Calificacion_Equilibrio_Vida_Laboral INTEGER NOT NULL,
            Nivel_de_Estres TEXT NOT NULL,
            Condicion_de_Salud_Mental TEXT NOT NULL,
            Acceso_a_Recursos_de_Salud_Mental TEXT NOT NULL,
            Cambio_en_Productividad TEXT NOT NULL,
            Calificacion_de_Aislamiento_Social INTEGER NOT NULL,
            ApoyoEmpresa_para_TrabajoRemoto INTEGER NOT NULL,
            ID_Empleado INTEGER NOT NULL,
            ID_Region INTEGER NOT NULL,
            ID_Rol INTEGER NOT NULL,
            ID_Industria INTEGER NOT NULL,
            ID_Sueno INTEGER NOT NULL,
            ID_Actividad_Fisica INTEGER NOT NULL
        );
        """
    )


def populate_lookup_tables(conn: sqlite3.Connection, rows: list[dict]) -> dict[str, dict[str, int]]:
    lookups: dict[str, dict[str, int]] = {
        "activity": {},
        "sleep": {},
        "industry": {},
        "role": {},
        "region": {},
    }

    def register(table: str, value: str) -> int:
        bucket = lookups[table]
        if value not in bucket:
            bucket[value] = len(bucket) + 1
        return bucket[value]

    for row in rows:
        register("activity", ACTIVITY_MAP[row["Physical_Activity"]])
        register("sleep", SLEEP_MAP[row["Sleep_Quality"]])
        register("industry", INDUSTRY_MAP[row["Industry"]])
        register("role", row["Job_Role"])
        register("region", REGION_MAP[row["Region"]])

    conn.executemany(
        "INSERT INTO DimActividadFisica VALUES (?, ?)",
        [(idx, name) for name, idx in sorted(lookups["activity"].items(), key=lambda item: item[1])],
    )
    conn.executemany(
        "INSERT INTO DimSueno VALUES (?, ?)",
        [(idx, name) for name, idx in sorted(lookups["sleep"].items(), key=lambda item: item[1])],
    )
    conn.executemany(
        "INSERT INTO DimIndustrias VALUES (?, ?)",
        [(idx, name) for name, idx in sorted(lookups["industry"].items(), key=lambda item: item[1])],
    )
    conn.executemany(
        "INSERT INTO DimRoles VALUES (?, ?)",
        [(idx, name) for name, idx in sorted(lookups["role"].items(), key=lambda item: item[1])],
    )
    conn.executemany(
        "INSERT INTO DimRegiones VALUES (?, ?)",
        [(idx, name) for name, idx in sorted(lookups["region"].items(), key=lambda item: item[1])],
    )
    return lookups


def populate_fact_tables(conn: sqlite3.Connection, rows: list[dict], lookups: dict[str, dict[str, int]]) -> None:
    employees = []
    metrics = []

    for index, row in enumerate(rows, start=1):
        employees.append(
            (
                index,
                row["Age"],
                row["Gender"],
                row["Years_of_Experience"],
                SATISFACTION_MAP[row["Satisfaction_with_Remote_Work"]],
            )
        )
        metrics.append(
            (
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
                lookups["region"][REGION_MAP[row["Region"]]],
                lookups["role"][row["Job_Role"]],
                lookups["industry"][INDUSTRY_MAP[row["Industry"]]],
                lookups["sleep"][SLEEP_MAP[row["Sleep_Quality"]]],
                lookups["activity"][ACTIVITY_MAP[row["Physical_Activity"]]],
            )
        )

    conn.executemany(
        """
        INSERT INTO DimEmpleados
        (ID_Empleado, Edad, Genero, Anos_de_Experiencia, Satisfaccion_con_Trabajo_Remoto)
        VALUES (?, ?, ?, ?, ?)
        """,
        employees,
    )
    conn.executemany(
        "INSERT INTO FactMetricasEmpleados VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        metrics,
    )


def query_table(conn: sqlite3.Connection, sql: str) -> tuple[list[str], list[tuple]]:
    cursor = conn.execute(sql)
    columns = [description[0] for description in cursor.description]
    return columns, cursor.fetchall()


def format_markdown_table(columns: list[str], rows: list[tuple], limit: int = 10) -> str:
    shown = rows[:limit]
    header = "| " + " | ".join(columns) + " |"
    divider = "| " + " | ".join("---" for _ in columns) + " |"
    body = "\n".join("| " + " | ".join(str(value) for value in row) + " |" for row in shown)
    suffix = ""
    if len(rows) > limit:
        suffix = f"\n\n*Mostrando {limit} de {len(rows)} filas.*"
    return "\n".join([header, divider, body]) + suffix


def scalar(conn: sqlite3.Connection, sql: str):
    return conn.execute(sql).fetchone()[0]


def build_report(conn: sqlite3.Connection) -> str:
    total = scalar(conn, "SELECT COUNT(*) FROM DimEmpleados")
    avg_age = scalar(conn, "SELECT ROUND(AVG(Edad), 1) FROM DimEmpleados")
    avg_exp = scalar(conn, "SELECT ROUND(AVG(Anos_de_Experiencia), 1) FROM DimEmpleados")
    high_stress = scalar(
        conn, "SELECT COUNT(*) FROM FactMetricasEmpleados WHERE Nivel_de_Estres = 'Alto'"
    )
    remote = scalar(
        conn, "SELECT COUNT(*) FROM FactMetricasEmpleados WHERE Ubicacion_de_Trabajo = 'Remoto'"
    )

    sections: list[str] = [
        "# Resultados y analisis del proyecto",
        "",
        "Documento generado automaticamente a partir del dataset de 5.000 empleados.",
        "",
        "## Resumen ejecutivo",
        "",
        f"- **Total de registros analizados:** {total:,}",
        f"- **Edad promedio:** {avg_age} anos",
        f"- **Experiencia promedio:** {avg_exp} anos",
        f"- **Empleados con estres alto:** {high_stress:,} ({high_stress / total * 100:.1f}%)",
        f"- **Empleados en modalidad remota:** {remote:,} ({remote / total * 100:.1f}%)",
        "",
        "### Hallazgos principales",
        "",
    ]

    location_cols, location_rows = query_table(
        conn,
        """
        SELECT Ubicacion_de_Trabajo,
               COUNT(*) AS Total,
               ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM FactMetricasEmpleados), 1) AS Porcentaje
        FROM FactMetricasEmpleados
        GROUP BY Ubicacion_de_Trabajo
        ORDER BY Total DESC
        """,
    )
    sections.extend(
        [
            "1. La muestra esta balanceada entre modalidades de trabajo.",
            format_markdown_table(location_cols, location_rows),
            "",
        ]
    )

    stress_cols, stress_rows = query_table(
        conn,
        """
        SELECT Ubicacion_de_Trabajo,
               SUM(CASE WHEN Nivel_de_Estres = 'Alto' THEN 1 ELSE 0 END) AS Estres_Alto,
               SUM(CASE WHEN Nivel_de_Estres = 'Medio' THEN 1 ELSE 0 END) AS Estres_Medio,
               SUM(CASE WHEN Nivel_de_Estres = 'Bajo' THEN 1 ELSE 0 END) AS Estres_Bajo
        FROM FactMetricasEmpleados
        GROUP BY Ubicacion_de_Trabajo
        ORDER BY Estres_Alto DESC
        """,
    )
    sections.extend(
        [
            "2. El estres alto se distribuye de forma relativamente pareja entre modalidades.",
            format_markdown_table(stress_cols, stress_rows),
            "",
        ]
    )

    health_cols, health_rows = query_table(
        conn,
        """
        SELECT Ubicacion_de_Trabajo,
               SUM(CASE WHEN Condicion_de_Salud_Mental = 'Depresion' THEN 1 ELSE 0 END) AS Depresion,
               SUM(CASE WHEN Condicion_de_Salud_Mental = 'Ansiedad' THEN 1 ELSE 0 END) AS Ansiedad,
               SUM(CASE WHEN Condicion_de_Salud_Mental = 'Agotamiento' THEN 1 ELSE 0 END) AS Agotamiento,
               SUM(CASE WHEN Condicion_de_Salud_Mental = 'Ninguna' THEN 1 ELSE 0 END) AS Ninguna
        FROM FactMetricasEmpleados
        GROUP BY Ubicacion_de_Trabajo
        ORDER BY Ubicacion_de_Trabajo
        """,
    )
    sections.extend(
        [
            "3. Depresion, ansiedad y agotamiento son las condiciones mas frecuentes en las tres modalidades.",
            format_markdown_table(health_cols, health_rows),
            "",
        ]
    )

    sleep_cols, sleep_rows = query_table(
        conn,
        """
        SELECT E.Genero,
               ROUND(SUM(CASE WHEN S.Calidad_del_Sueno = 'Pobre' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Porc_Sueno_Pobre,
               ROUND(SUM(CASE WHEN S.Calidad_del_Sueno = 'Bueno' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS Porc_Sueno_Bueno
        FROM DimEmpleados E
        INNER JOIN FactMetricasEmpleados M ON E.ID_Empleado = M.ID_Empleado
        INNER JOIN DimSueno S ON M.ID_Sueno = S.ID_Sueno
        GROUP BY E.Genero
        ORDER BY Porc_Sueno_Pobre DESC
        """,
    )
    sections.extend(
        [
            "4. La calidad del sueno varia levemente por genero.",
            format_markdown_table(sleep_cols, sleep_rows),
            "",
        ]
    )

    region_cols, region_rows = query_table(
        conn,
        """
        SELECT R.Region, COUNT(*) AS TotalEmpleados
        FROM FactMetricasEmpleados M
        LEFT JOIN DimRegiones R ON M.ID_Region = R.ID_Region
        GROUP BY R.Region
        ORDER BY TotalEmpleados DESC
        """,
    )
    sections.extend(
        [
            "5. Oceania y Africa concentran la mayor cantidad de registros.",
            format_markdown_table(region_cols, region_rows),
            "",
        ]
    )

    isolation_with_access = scalar(
        conn,
        """
        SELECT COUNT(*)
        FROM FactMetricasEmpleados
        WHERE Acceso_a_Recursos_de_Salud_Mental = 'Si'
          AND Calificacion_de_Aislamiento_Social >
              (SELECT AVG(Calificacion_de_Aislamiento_Social)
               FROM FactMetricasEmpleados
               WHERE Acceso_a_Recursos_de_Salud_Mental = 'No')
        """,
    )
    sections.extend(
        [
            "## Consultas avanzadas destacadas",
            "",
            "### Acceso a recursos vs. aislamiento social",
            "",
            f"Hay **{isolation_with_access:,} empleados** con acceso a recursos de salud mental pero con aislamiento social por encima del promedio de quienes no tienen acceso.",
            "",
        ]
    )

    remote_hours_cols, remote_hours_rows = query_table(
        conn,
        """
        SELECT COUNT(*) AS Empleados_Remotos
        FROM FactMetricasEmpleados
        WHERE Ubicacion_de_Trabajo = 'Remoto'
          AND Horas_Trabajadas_por_Semana >
              (SELECT AVG(Horas_Trabajadas_por_Semana)
               FROM FactMetricasEmpleados
               WHERE Ubicacion_de_Trabajo = 'Presencial')
        """,
    )
    sections.extend(
        [
            "### Horas trabajadas: remoto vs. presencial",
            "",
            format_markdown_table(remote_hours_cols, remote_hours_rows),
            "",
        ]
    )

    satisfaction_cols, satisfaction_rows = query_table(
        conn,
        """
        SELECT Ubicacion_de_Trabajo,
               SUM(CASE WHEN D.Satisfaccion_con_Trabajo_Remoto = 'Satisfecho' THEN 1 ELSE 0 END) AS Satisfecho,
               SUM(CASE WHEN D.Satisfaccion_con_Trabajo_Remoto = 'Neutral' THEN 1 ELSE 0 END) AS Neutral,
               SUM(CASE WHEN D.Satisfaccion_con_Trabajo_Remoto = 'Insatisfecho' THEN 1 ELSE 0 END) AS Insatisfecho
        FROM FactMetricasEmpleados M
        JOIN DimEmpleados D ON M.ID_Empleado = D.ID_Empleado
        GROUP BY Ubicacion_de_Trabajo
        ORDER BY Ubicacion_de_Trabajo
        """,
    )
    sections.extend(
        [
            "### Satisfaccion con el trabajo remoto por modalidad",
            "",
            format_markdown_table(satisfaction_cols, satisfaction_rows),
            "",
        ]
    )

    basic_examples = [
        (
            "Conteo por modalidad de trabajo",
            """
            SELECT Ubicacion_de_Trabajo, COUNT(*) AS TotalEmpleados
            FROM FactMetricasEmpleados
            GROUP BY Ubicacion_de_Trabajo
            ORDER BY TotalEmpleados DESC
            """,
        ),
        (
            "Empleados con estres alto y ansiedad",
            """
            SELECT COUNT(*) AS Cantidad
            FROM FactMetricasEmpleados
            WHERE Nivel_de_Estres = 'Alto'
              AND Condicion_de_Salud_Mental = 'Ansiedad'
            """,
        ),
        (
            "Promedio de edad por genero",
            """
            SELECT Genero, ROUND(AVG(Edad), 1) AS PromedioEdad
            FROM DimEmpleados
            GROUP BY Genero
            ORDER BY PromedioEdad
            """,
        ),
    ]

    sections.extend(
        [
            "## Consultas basicas: muestra representativa",
            "",
            "Las 35 consultas basicas demuestran dominio tecnico de SQL. En portfolio basta documentar ejemplos representativos.",
            "",
        ]
    )

    for title, sql in basic_examples:
        cols, rows = query_table(conn, sql)
        sections.extend([f"### {title}", "", format_markdown_table(cols, rows), ""])

    sections.extend(
        [
            "## Conclusiones",
            "",
            "- El trabajo remoto no concentra por si solo todos los indicadores negativos.",
            "- Estres, salud mental y sueno pobre son frecuentes en toda la muestra.",
            "- Tener acceso a recursos de salud mental no elimina el aislamiento social.",
            "- Las politicas de bienestar deben considerar horas, sueno y soporte percibido.",
            "",
            "## Recomendaciones",
            "",
            "1. Monitorear horas trabajadas en modalidad remota e hibrida.",
            "2. Complementar recursos de salud mental con acciones contra el aislamiento.",
            "3. Segmentar intervenciones por region y rol.",
            "4. Medir satisfaccion y productividad de forma periodica.",
        ]
    )

    return "\n".join(sections)


def main() -> None:
    rows = load_rows()
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    if DB_FILE.exists():
        DB_FILE.unlink()

    conn = sqlite3.connect(DB_FILE)
    try:
        create_schema(conn)
        lookups = populate_lookup_tables(conn, rows)
        populate_fact_tables(conn, rows, lookups)
        conn.commit()
        report = build_report(conn)
    finally:
        conn.close()

    OUTPUT_FILE.write_text(report, encoding="utf-8")
    print(f"Base de datos: {DB_FILE}")
    print(f"Informe: {OUTPUT_FILE}")
    print(f"Registros cargados: {len(rows)}")


if __name__ == "__main__":
    main()
