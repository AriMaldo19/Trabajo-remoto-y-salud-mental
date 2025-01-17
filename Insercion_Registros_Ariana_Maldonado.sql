-- INSERTAR REGISTROS EN CADA UNA DE LAS TABLAS -- 
-- Insertar datos en Tabla: DimActividadFisica.
INSERT INTO DimActividadFisica (ID_Actividad_Fisica, Actividad_Fisica)
VALUES
     (1, 'Semanal'),
     (2, 'Ninguno'),
	 (3, 'Diario'); 

-- Insertar datos en Tabla: DimSueño.
INSERT INTO DimSueño (ID_Sueño, Calidad_del_Sueño)
VALUES 
     (1, 'Bueno'),
	 (2, 'Pobre'),
	 (3, 'Promedio');

-- Insertar datos en Tabla: DimIndustrias.
INSERT INTO DimIndustrias (ID_Industria, Industria)
VALUES
     (1, 'Atencion Sanitaria'),
	 (2, 'IT'),
	 (3, 'Educacion'),
	 (4, 'Finanzas'),
	 (5, 'Consultoria'),
	 (6, 'Manufactura'),
	 (7, 'Comercio Minorista'); 

-- Insertar datos en Tabla: DimRoles.
INSERT INTO DimRoles (ID_Rol, Rol)
VALUES
     (1, 'HR'),
	 (2, 'Data Scientist'),
	 (3, 'Software Engineer'),
	 (4, 'Sales'),
	 (5, 'Marketing'),
	 (6, 'Designer'),
	 (7, 'Project Manager');

-- Insertar datos en Tabla: DimRegiones.
INSERT INTO DimRegiones (ID_Region, Region)
VALUES 
    (1, 'Europa'),
	(2, 'Asia'),
	(3, 'America del Norte'),
	(4, 'America del Sur'),
	(5, 'Oceania'),
	(6, 'Africa')

-- SELECCIONAR CADA UNA DE LAS TABLAS CON REGISTROS INSERTADOS -- CORROBORAR QUE LOS DATOS SE HAYAN CARGADO CORRECTAMENTE. 
-- Selección de Tabla: DimActividadFisica.
SELECT * FROM DimActividadFisica;

-- Selección de Tabla: DimSueño.
SELECT * FROM DimSueño;

-- Selección de Tabla: DimIndustrias.
SELECT * FROM DimIndustrias;

-- Selección de Tabla: DimRoles.
SELECT * FROM DimRoles;

-- Selección de Tabla: DimRegiones.
SELECT * FROM DimRegiones;


