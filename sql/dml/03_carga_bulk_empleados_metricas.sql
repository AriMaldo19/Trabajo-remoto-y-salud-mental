-- CARGA MASIVA DESDE CSV (PREPARADOS EN EXCEL / data/processed) --
-- SQL Server requiere ruta absoluta. Ejemplo:
-- C:\Users\USUARIO\Desktop\Proyectos\Proyecto-TrabajoRemoto-SaludMental\data\processed\CSV_Metricas_Empleados.csv

BULK INSERT TrabajoRemoto_SaludMental.dbo.FactMetricasEmpleados
FROM 'C:\Users\USUARIO\Desktop\Proyectos\Proyecto-TrabajoRemoto-SaludMental\data\processed\CSV_Metricas_Empleados.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT COUNT(*) AS Total_FactMetricasEmpleados FROM FactMetricasEmpleados;

BULK INSERT TrabajoRemoto_SaludMental.dbo.DimEmpleados
FROM 'C:\Users\USUARIO\Desktop\Proyectos\Proyecto-TrabajoRemoto-SaludMental\data\processed\CSV_Empleados.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT COUNT(*) AS Total_DimEmpleados FROM DimEmpleados;
