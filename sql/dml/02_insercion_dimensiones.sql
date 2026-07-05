-- INSERCION MANUAL DE TABLAS DIMENSION (CATALOGOS PEQUENOS) --

INSERT INTO DimActividadFisica (ID_Actividad_Fisica, Actividad_Fisica)
VALUES
    (1, 'Semanal'),
    (2, 'Ninguno'),
    (3, 'Diario');

INSERT INTO DimSueno (ID_Sueno, Calidad_del_Sueno)
VALUES
    (1, 'Bueno'),
    (2, 'Pobre'),
    (3, 'Promedio');

INSERT INTO DimIndustrias (ID_Industria, Industria)
VALUES
    (1, 'Atencion Sanitaria'),
    (2, 'IT'),
    (3, 'Educacion'),
    (4, 'Finanzas'),
    (5, 'Consultoria'),
    (6, 'Manufactura'),
    (7, 'Comercio Minorista');

INSERT INTO DimRoles (ID_Rol, Rol)
VALUES
    (1, 'HR'),
    (2, 'Data Scientist'),
    (3, 'Software Engineer'),
    (4, 'Sales'),
    (5, 'Marketing'),
    (6, 'Designer'),
    (7, 'Project Manager');

INSERT INTO DimRegiones (ID_Region, Region)
VALUES
    (1, 'Europa'),
    (2, 'Asia'),
    (3, 'America del Norte'),
    (4, 'America del Sur'),
    (5, 'Oceania'),
    (6, 'Africa');

-- Verificacion de carga
SELECT * FROM DimActividadFisica;
SELECT * FROM DimSueno;
SELECT * FROM DimIndustrias;
SELECT * FROM DimRoles;
SELECT * FROM DimRegiones;
