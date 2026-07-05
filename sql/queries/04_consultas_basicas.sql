-- CONSULTAS BASICAS --

-- SELECT, SELECT DISTINCT, WHERE

-- 1) Roles disponibles
SELECT * FROM DimRoles;

-- 2) Niveles de estres distintos
SELECT DISTINCT Nivel_de_Estres
FROM FactMetricasEmpleados;

-- 3) Condiciones de salud mental distintas
SELECT DISTINCT Condicion_de_Salud_Mental
FROM FactMetricasEmpleados;

-- 4) Empleados con estres alto
SELECT ID_Empleado, Nivel_de_Estres
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres = 'Alto';

-- COUNT y GROUP BY

-- 5) Cantidad con estres alto
SELECT COUNT(ID_Empleado) AS Cantidad_Empleados
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres = 'Alto';

-- 6) Cantidad con depresion
SELECT COUNT(ID_Empleado) AS Total_Empleados
FROM FactMetricasEmpleados
WHERE Condicion_de_Salud_Mental = 'Depresion';

-- 7) Cantidad en trabajo remoto
SELECT COUNT(ID_Empleado) AS Cantidad_Empleados_Trabajo_Remoto
FROM FactMetricasEmpleados
WHERE Ubicacion_de_Trabajo = 'Remoto';

-- 8) Conteo por modalidad de trabajo
SELECT Ubicacion_de_Trabajo, COUNT(ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

-- 9) Presencial y remoto, ordenado por total
SELECT Ubicacion_de_Trabajo, COUNT(ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados
WHERE Ubicacion_de_Trabajo IN ('Remoto', 'Presencial')
GROUP BY Ubicacion_de_Trabajo
ORDER BY TotalEmpleados DESC;

-- 10) Conteo por edad
SELECT Edad, COUNT(ID_Empleado) AS TotalEmpleadosporEdad
FROM DimEmpleados
GROUP BY Edad
ORDER BY TotalEmpleadosporEdad DESC;

-- AVG

-- 11) Promedio de anos de experiencia
SELECT AVG(Anos_de_Experiencia) AS Promedio_AnosExperiencia
FROM DimEmpleados;

-- 12) Promedio de edad
SELECT AVG(Edad) AS PromedioEdad
FROM DimEmpleados;

-- 13) Promedio de edad por genero
SELECT Genero, AVG(Edad) AS PromedioEdad
FROM DimEmpleados
GROUP BY Genero
ORDER BY PromedioEdad;

-- MIN y MAX

-- 14) Edad minima y maxima
SELECT MIN(Edad) AS EmpleadoMenorEdad, MAX(Edad) AS EmpleadoMayorEdad
FROM DimEmpleados;

-- HAVING

-- 15) Anos de experiencia con mas de 150 empleados
SELECT COUNT(ID_Empleado) AS TotalEmpleados, Anos_de_Experiencia
FROM DimEmpleados
GROUP BY Anos_de_Experiencia
HAVING COUNT(ID_Empleado) > 150
ORDER BY TotalEmpleados DESC;

-- 16) Horas semanales superiores a 48
SELECT COUNT(ID_Empleado) AS CantidadEmpleados, Horas_Trabajadas_por_Semana
FROM FactMetricasEmpleados
GROUP BY Horas_Trabajadas_por_Semana
HAVING Horas_Trabajadas_por_Semana > 48
ORDER BY CantidadEmpleados DESC;

-- OPERADORES RELACIONALES

-- 17) Experiencia mayor a 10 anos
SELECT COUNT(ID_Empleado) AS Empleados_Mas10Anos_Experiencia
FROM DimEmpleados
WHERE Anos_de_Experiencia > 10;

-- 18) Experiencia menor o igual a 3 anos
SELECT COUNT(ID_Empleado) AS CantidadEmpleados_3Anos_Experiencia
FROM DimEmpleados
WHERE Anos_de_Experiencia <= 3;

-- 19) Porcentaje con experiencia <= 3 anos
SELECT
    COUNT(ID_Empleado) AS CantidadEmpleados_3Anos_Experiencia,
    (COUNT(ID_Empleado) * 100.0 / 5000) AS Porcentaje_3Anos_Experiencia
FROM DimEmpleados
WHERE Anos_de_Experiencia <= 3;

-- 20) Empleados con 48 horas semanales
SELECT COUNT(ID_Empleado) AS Empleados_Trabajan_48hs_Semanales
FROM FactMetricasEmpleados
WHERE Horas_Trabajadas_por_Semana = 48;

-- 21) Aislamiento social distinto de 1, 2 y 3
SELECT COUNT(ID_Empleado) AS TotalEmpleados_AislamientoSocial
FROM FactMetricasEmpleados
WHERE Calificacion_de_Aislamiento_Social NOT IN (1, 2, 3);

-- OPERADORES LOGICOS

-- 22) Estres alto o medio
SELECT ID_Empleado, Nivel_de_Estres
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres IN ('Alto', 'Medio');

-- 23) Estres alto y ansiedad
SELECT COUNT(ID_Empleado) AS CantidadEmpleados, Nivel_de_Estres, Condicion_de_Salud_Mental
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres = 'Alto' AND Condicion_de_Salud_Mental = 'Ansiedad'
GROUP BY Nivel_de_Estres, Condicion_de_Salud_Mental;

-- 24) Experiencia de 2, 5 o 10 anos
SELECT ID_Empleado, Anos_de_Experiencia
FROM DimEmpleados
WHERE Anos_de_Experiencia IN (2, 5, 10)
ORDER BY Anos_de_Experiencia DESC;

-- 25) Aislamiento NOT IN (1, 2, 3)
SELECT COUNT(ID_Empleado) AS TotalEmpleados_distinto_123
FROM FactMetricasEmpleados
WHERE Calificacion_de_Aislamiento_Social NOT IN (1, 2, 3);

-- LIKE

-- 26) Insatisfechos con trabajo remoto (comienza con In)
SELECT ID_Empleado, Satisfaccion_con_Trabajo_Remoto
FROM DimEmpleados
WHERE Satisfaccion_con_Trabajo_Remoto LIKE 'In%';

-- 27) Condiciones que terminan en dad (Ansiedad)
SELECT ID_Empleado, Condicion_de_Salud_Mental
FROM FactMetricasEmpleados
WHERE Condicion_de_Salud_Mental LIKE '%dad';

-- BETWEEN

-- 28) Entre 10 y 15 reuniones virtuales
SELECT ID_Empleado, Numero_de_Reuniones_Virtuales
FROM FactMetricasEmpleados
WHERE Numero_de_Reuniones_Virtuales BETWEEN 10 AND 15
ORDER BY Numero_de_Reuniones_Virtuales DESC;

-- 29) Edad entre 25 y 35
SELECT COUNT(ID_Empleado) AS TotalEmpleados_25a35_Anos
FROM DimEmpleados
WHERE Edad BETWEEN 25 AND 35;

-- FUNCIONES DE TEXTO

-- 30) Primeros 3 caracteres de productividad
SELECT ID_Empleado, LEFT(Cambio_en_Productividad, 3) AS Primeros_3_Caracteres
FROM FactMetricasEmpleados;

-- 31) Ultimos 4 caracteres de productividad
SELECT ID_Empleado, RIGHT(Cambio_en_Productividad, 4) AS Ultimos_4_Caracteres
FROM FactMetricasEmpleados;

-- 32) Concatenar edad y genero
SELECT CONCAT(Edad, ' - ', Genero) AS Edad_Genero
FROM DimEmpleados;

-- 33) Reemplazar caracter en satisfaccion
SELECT REPLACE(Satisfaccion_con_Trabajo_Remoto, 'o', 'a') AS NuevoCaracter
FROM DimEmpleados;

-- 34) Genero en mayuscula
SELECT ID_Empleado, UPPER(Genero) AS Genero_Mayuscula
FROM DimEmpleados;

-- 35) Genero en minuscula
SELECT ID_Empleado, LOWER(Genero) AS Genero_Minuscula
FROM DimEmpleados;

-- Verificacion final de tablas
SELECT * FROM FactMetricasEmpleados;
SELECT * FROM DimSueno;
SELECT * FROM DimRoles;
SELECT * FROM DimRegiones;
SELECT * FROM DimIndustrias;
SELECT * FROM DimEmpleados;
SELECT * FROM DimActividadFisica;
