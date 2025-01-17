-- ELABORACIÓN DE CONSULAS BÁSICAS A PARTIR DE PREGUNTAS --

-- USO DE SELECT - SELECT DISTINCT - WHERE -- 

-- 1) ¿Cuales son los roles disponibles en la base de datos?
SELECT * FROM DimRoles;

-- 2) ¿Cuales son los distintos niveles de estres existentes entre los empleados?
SELECT DISTINCT Nivel_de_Estres
FROM FactMetricasEmpleados;

-- 3) ¿Cuáles son las diferentes condiciones de salud mental existentes entre los empleados?
SELECT DISTINCT Condicion_de_Salud_Mental
FROM FactMetricasEmpleados;

-- 4) ¿Qué empleados tienen un nivel de estres alto?
SELECT 
        ID_Empleado,
        Nivel_de_Estres
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto';


-- USO DE FUNCIONES DE AGREGACIÓN -- USO DE GROUP BY -- 

-- COUNT (Cantidad)

-- 5) ¿Cuántos empleados tienen un nivel de estres alto?
SELECT COUNT(ID_Empleado) AS Cantidad_Empleados
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto';

-- 6) ¿Qué cantidad de empleados padecen depresión?
SELECT COUNT(ID_Empleado) AS Total_Empleados
FROM FactMetricasEmpleados
WHERE Condicion_de_Salud_Mental='Depresion';

-- 7) ¿Cuantos empleados trabajan de manera remota?
SELECT 
      COUNT(ID_Empleado) AS Cantidad_Empleados_Trabajo_Remoto
FROM FactMetricasEmpleados
WHERE Ubicacion_de_Trabajo='Remoto';

-- 8) ¿Cuantos empleados trabajan de manera presencial, remota e híbrida?
SELECT 
     Ubicacion_de_Trabajo, 
	 COUNT(ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

-- 9) ¿Cuántos empleados trabajan de manera presencial y remota? Ordenar de mayor a menor, según total de empleados. 
SELECT 
     Ubicacion_de_Trabajo, 
	 COUNT(ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados
WHERE Ubicacion_de_Trabajo= 'Remoto' OR  Ubicacion_de_Trabajo='Presencial'
GROUP BY Ubicacion_de_Trabajo
ORDER BY TotalEmpleados DESC;

-- 10) ¿Cuantos empleados existen según edad? Ordenar de mayor a menor según cantidad de empleados. 
SELECT 
      Edad,
      COUNT(ID_Empleado) AS TotalEmpleadosporEdad
FROM DimEmpleados
GROUP BY Edad
ORDER BY TotalEmpleadosporEdad DESC;

-- AVG (Promedio)

-- 11) ¿Cuál es el promedio de años de experiencia de los empleados?
SELECT 
      AVG(Años_de_Experiencia) AS Promedio_AñosExperiencia
FROM DimEmpleados;

-- 12) ¿Cuál es el promedio de edad de los empleados?
SELECT
      AVG(Edad) AS PromedioEdad
FROM DimEmpleados;

-- 13) ¿Cuál es el promedio de edad según género? Ordenar de menor a mayor promedio de edad--
SELECT 
     Genero, 
	 AVG(Edad) AS PromedioEdad
FROM DimEmpleados
GROUP BY Genero
ORDER BY PromedioEdad;

-- MIN (Mínimo) 
-- MAX (Máximo) 

-- 14) ¿Que edad tiene el empleado de menor edad y el empleado de mayor edad?
SELECT MIN(Edad) AS EmpleadoMenorEdad, 
       MAX(Edad) AS EmpleadoMayorEdad
FROM DimEmpleados;

-- USO DE HAVING -- 

-- 15) ¿Qué niveles de experiencia tienen más de 150 empleados? Ordenar de mayor a menor según total de empleados. 
SELECT 
	   COUNT(ID_Empleado) AS TotalEmpleados,
	   Años_de_Experiencia
FROM DimEmpleados
GROUP BY Años_de_Experiencia
HAVING COUNT(ID_Empleado) > 150
ORDER BY TotalEmpleados DESC;

-- 16) ¿Qué niveles de experiencia tienen más de 150 empleados? Ordenar de mayor a menor según total de empleados. 
SELECT 
	   COUNT(ID_Empleado) AS TotalEmpleados,
	   Años_de_Experiencia
FROM DimEmpleados
GROUP BY Años_de_Experiencia
HAVING COUNT(ID_Empleado) > 150
ORDER BY TotalEmpleados DESC;

-- 17) ¿Cuántos empleados tienen horas trabajadas por semana superiores a 40 , agrupados por ID de empleados, y cuáles son esos empleados? Ordenar de Mayor a Menor por Cantidad de empleados. 
SELECT 
       COUNT(ID_Empleado) AS CantidadEmpleados,
	   Horas_Trabajadas_por_Semana
FROM FactMetricasEmpleados
GROUP BY Horas_Trabajadas_por_Semana
HAVING Horas_Trabajadas_por_Semana > 48
ORDER BY CantidadEmpleados DESC;


-- USO DE OPERADORES RELACIONALES --

-- > (Mayor)

-- 18) ¿Cuántos empleados tienen un nivel de experiencia mayor a 10 años?
SELECT 
      COUNT(ID_Empleado) AS Empleados_Más10años_Experiencia
FROM DimEmpleados
WHERE Años_de_Experiencia > 10;

-- <= (Menor o Igual)

-- 19) ¿Cuántos empleados tienen 3 o menos años de experiencia?
SELECT 
     COUNT(ID_Empleado) AS CantidadEmpleados_3años_Experiencia
FROM DimEmpleados
WHERE Años_de_Experiencia <= 3;

-- 19.1) ¿Cuál sería el porcentaje de empleados con experiencia igual o menor a 3 años, en relación al total de encuestados?
SELECT 
    COUNT (ID_Empleado) AS CantidadEmpleados_3años_Experiencia,
   (COUNT(ID_Empleado) * 100 / 5000) AS Porcentaje_3años_Experiencia
FROM DimEmpleados
WHERE Años_de_Experiencia <= 3;


-- = (Igual)

-- 20) ¿Cuántos empleados trabajan 48hs semanales?
SELECT
      COUNT(ID_Empleado) AS Empleados_Trabajan_48hs_Semanales
FROM FactMetricasEmpleados
WHERE Horas_Trabajadas_por_Semana = 48;

-- != (Diferente) 

-- 21) ¿Cuántos empleados presetan una calificación de aislamiento social diferente a 1, 2 y 3?
SELECT
     COUNT(ID_Empleado) AS TotalEmpleados_AislamientoSocial
FROM FactMetricasEmpleados
WHERE Calificacion_de_Aislamiento_Social != 1 AND Calificacion_de_Aislamiento_Social !=2 AND Calificacion_de_Aislamiento_Social !=3;


-- USO DE OPERADORES LÓGICOS --

-- OR 

-- 22) ¿Qué empleados tienen un nivel de estrés alto o medio?
SELECT 
      ID_Empleado,
	  Nivel_de_Estres
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto' OR Nivel_de_Estres='Medio';

-- AND

-- 23) ¿Qué cantidad de empleados tienen niveles altos de estrés y ansiedad?
SELECT 
      COUNT(ID_Empleado) AS CantidadEmpleados,
	  Nivel_de_Estres,
	  Condicion_de_Salud_Mental
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto' AND Condicion_de_Salud_Mental='Ansiedad'
GROUP BY Nivel_de_Estres, Condicion_de_Salud_Mental;

-- IN

-- 24)¿Qué empleados tienen 2, 5, 10 años de experiencia trabajando?
SELECT 
     ID_Empleado,
	 Años_de_Experiencia
FROM DimEmpleados
WHERE Años_de_Experiencia IN (2,5,10)
ORDER BY Años_de_Experiencia DESC;

-- NOT IN

-- 25) ¿Cuántos empleados tienen una calficación del nivel de aislamiento diferente a 1, 2 y 3?
SELECT 
      COUNT(ID_Empleado) AS TotalEmpleados_distinto_123
FROM FactMetricasEmpleados
WHERE Calificacion_de_Aislamiento_Social NOT IN (1, 2, 3);

-- LIKE

-- 26) ¿Cuáles son los empleados que se encuentran instasifechos con su trabajo? -- que comience con "IN" --
SELECT 
      ID_Empleado,
	  Satisfaccion_con_Trabajo_Remoto
FROM DimEmpleados
WHERE Satisfaccion_con_Trabajo_Remoto LIKE 'In%';

-- 27) ¿Cuales son los empleados que se encuentran con ansiedad? -- que termine con "DAD"--
SELECT 
      ID_Empleado,
	  Condicion_de_Salud_Mental
FROM FactMetricasEmpleados 
WHERE Condicion_de_Salud_Mental LIKE '%dad';

-- BETWEEN 

-- 28) ¿Qué empleados tienen entre 10 y 15 reuniones semanales? Ordenar de mayor a menor según cantidad de reuniones. 
SELECT 
     ID_Empleado, 
	 Numero_de_Reuniones_Virtuales
FROM FactMetricasEmpleados
WHERE Numero_de_Reuniones_Virtuales BETWEEN 10 AND 15
ORDER BY Numero_de_Reuniones_Virtuales DESC;

-- 29) ¿Cuántos empleados tienen una edad entre 25 y 35 años?
SELECT 
      COUNT(ID_Empleado) AS TotalEmpleados_25a35_Años
FROM DimEmpleados
WHERE Edad BETWEEN 25 AND 35;

-- USO DE FUNCIONES ESCALARES -- CARACTERES O CADENA

-- LEFT (Extrae caracteres iniciando desde el lado izquierdo)

-- 30) ¿Cuáles son los primeros 3 caracteres del campo "cambio en productividad"?
SELECT 
      ID_Empleado,
	  LEFT (Cambio_en_Productividad, 3) AS Primeros_3_Caracteres
FROM FactMetricasEmpleados;

-- RIGHT (Extrae caracteres iniciando desde el lado derecho) 

-- 31) ¿Cuáles son los 4 últimos caracteres del campo "cambio en productividad"?
SELECT 
      ID_Empleado,
	  RIGHT(Cambio_en_Productividad, 4) AS Ultimos_4_Caracteres
FROM FactMetricasEmpleados;

-- CONCAT (Permite unir campos o caracteres)

-- 32) ¿Cómo se pueden concatenar los campos edad y género de los empleados para que se encuentren dentro de un mismo campo?
SELECT 
      CONCAT(Edad, ' - ', Genero) AS Edad_Genero
FROM DimEmpleados; 

-- REPLACE (Permite reemplazar caracteres en un campo)

-- 33) ¿Cómo se pueden reemplazar todas las instancias de un carácter específico en el campo "satisfacción de trabajo remoto? en este caso cambiar el último caracter "o" por "a".  
SELECT 
      REPLACE(Satisfaccion_con_Trabajo_Remoto, 'o', 'a') AS NuevoCaracter
FROM DimEmpleados; 

-- UPPER (Convierte todos los valores a mayúscula) 

-- 34) ¿Cómo se puede convertir todos los registros del campo "género" en mayúscula?
SELECT 
     ID_Empleado,
	 UPPER(Genero) AS Genero_Mayuscula
FROM DimEmpleados;

-- LOWER (Convierte todos los valores a minúscula)

-- 35) ¿Cómo se puede convertir todos los registros del campo "género" en minúscula?
SELECT 
      ID_Empleado,
	  LOWER(Genero) AS Genero_Minuscula
FROM DimEmpleados;


SELECT * FROM [dbo].[FactMetricasEmpleados]
SELECT * FROM [dbo].[DimSueño]
SELECT * FROM [dbo].[DimRoles]
SELECT * FROM [dbo].[DimRegiones]
SELECT * FROM [dbo].[DimIndustrias]
SELECT * FROM [dbo].[DimEmpleados]
SELECT * FROM [dbo].[DimActividadFisica]

