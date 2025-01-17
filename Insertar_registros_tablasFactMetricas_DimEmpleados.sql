-- INSERTAR REGISTROS EN LA TABLA: FACTMETRICASEMPLEADOS
BULK INSERT TrabajoRemoto_SaludMental.dbo.FactMetricasEmpleados
FROM 'C:\Users\USUARIO\Desktop\PROYECTO SQL Ari\CSV Metricas Empleados.csv'
WITH (
    FIELDTERMINATOR = ';',    -- Separador de columnas (usa ';' si ese es el delimitador)
    ROWTERMINATOR = '\n',     -- Separador de filas
    FIRSTROW = 2              -- Salta el encabezado si lo hay (empezando desde la fila 2)
);

-- SELECCIONAR LA TABLA PARA VER SI LOS REGISTROS SE INSERTARON CORRECTAMENTE --- 
SELECT * FROM FactMetricasEmpleados;


-- INSERTAR REGISTROS EN LA TABLA: DIMEMPLEADOS
BULK INSERT TrabajoRemoto_SaludMental.dbo.DimEmpleados
FROM 'C:\Users\USUARIO\Desktop\PROYECTO SQL Ari\CSV Empleados.csv'
WITH (
    FIELDTERMINATOR = ';',    -- Separador de columnas (usa ';' si ese es el delimitador)
    ROWTERMINATOR = '\n',     -- Separador de filas
    FIRSTROW = 2              -- Salta el encabezado si lo hay (empezando desde la fila 2)
);

-- SELECCIONAR LA TABLA PARA VER SI LOS REGISTROS SE INSERTARON CORRECTAMENTE --- 
SELECT * FROM DimEmpleados;


