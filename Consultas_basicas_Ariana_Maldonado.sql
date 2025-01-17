-- ELABORACI�N DE CONSULAS B�SICAS A PARTIR DE PREGUNTAS --

-- USO DE SELECT - SELECT DISTINCT - WHERE -- 

-- 1) �Cuales son los roles disponibles en la base de datos?
SELECT * FROM DimRoles;

-- 2) �Cuales son los distintos niveles de estres existentes entre los empleados?
SELECT DISTINCT Nivel_de_Estres
FROM FactMetricasEmpleados;

-- 3) �Cu�les son las diferentes condiciones de salud mental existentes entre los empleados?
SELECT DISTINCT Condicion_de_Salud_Mental
FROM FactMetricasEmpleados;

-- 4) �Qu� empleados tienen un nivel de estres alto?
SELECT 
        ID_Empleado,
        Nivel_de_Estres
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto';


-- USO DE FUNCIONES DE AGREGACI�N -- USO DE GROUP BY -- 

-- COUNT (Cantidad)

-- 5) �Cu�ntos empleados tienen un nivel de estres alto?
SELECT COUNT(ID_Empleado) AS Cantidad_Empleados
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto';

-- 6) �Qu� cantidad de empleados padecen depresi�n?
SELECT COUNT(ID_Empleado) AS Total_Empleados
FROM FactMetricasEmpleados
WHERE Condicion_de_Salud_Mental='Depresion';

-- 7) �Cuantos empleados trabajan de manera remota?
SELECT 
      COUNT(ID_Empleado) AS Cantidad_Empleados_Trabajo_Remoto
FROM FactMetricasEmpleados
WHERE Ubicacion_de_Trabajo='Remoto';

-- 8) �Cuantos empleados trabajan de manera presencial, remota e h�brida?
SELECT 
     Ubicacion_de_Trabajo, 
	 COUNT(ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

-- 9) �Cu�ntos empleados trabajan de manera presencial y remota? Ordenar de mayor a menor, seg�n total de empleados. 
SELECT 
     Ubicacion_de_Trabajo, 
	 COUNT(ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados
WHERE Ubicacion_de_Trabajo= 'Remoto' OR  Ubicacion_de_Trabajo='Presencial'
GROUP BY Ubicacion_de_Trabajo
ORDER BY TotalEmpleados DESC;

-- 10) �Cuantos empleados existen seg�n edad? Ordenar de mayor a menor seg�n cantidad de empleados. 
SELECT 
      Edad,
      COUNT(ID_Empleado) AS TotalEmpleadosporEdad
FROM DimEmpleados
GROUP BY Edad
ORDER BY TotalEmpleadosporEdad DESC;

-- AVG (Promedio)

-- 11) �Cu�l es el promedio de a�os de experiencia de los empleados?
SELECT 
      AVG(A�os_de_Experiencia) AS Promedio_A�osExperiencia
FROM DimEmpleados;

-- 12) �Cu�l es el promedio de edad de los empleados?
SELECT
      AVG(Edad) AS PromedioEdad
FROM DimEmpleados;

-- 13) �Cu�l es el promedio de edad seg�n g�nero? Ordenar de menor a mayor promedio de edad--
SELECT 
     Genero, 
	 AVG(Edad) AS PromedioEdad
FROM DimEmpleados
GROUP BY Genero
ORDER BY PromedioEdad;

-- MIN (M�nimo) 
-- MAX (M�ximo) 

-- 14) �Que edad tiene el empleado de menor edad y el empleado de mayor edad?
SELECT MIN(Edad) AS EmpleadoMenorEdad, 
       MAX(Edad) AS EmpleadoMayorEdad
FROM DimEmpleados;

-- USO DE HAVING -- 

-- 15) �Qu� niveles de experiencia tienen m�s de 150 empleados? Ordenar de mayor a menor seg�n total de empleados. 
SELECT 
	   COUNT(ID_Empleado) AS TotalEmpleados,
	   A�os_de_Experiencia
FROM DimEmpleados
GROUP BY A�os_de_Experiencia
HAVING COUNT(ID_Empleado) > 150
ORDER BY TotalEmpleados DESC;

-- 16) �Qu� niveles de experiencia tienen m�s de 150 empleados? Ordenar de mayor a menor seg�n total de empleados. 
SELECT 
	   COUNT(ID_Empleado) AS TotalEmpleados,
	   A�os_de_Experiencia
FROM DimEmpleados
GROUP BY A�os_de_Experiencia
HAVING COUNT(ID_Empleado) > 150
ORDER BY TotalEmpleados DESC;

-- 17) �Cu�ntos empleados tienen horas trabajadas por semana superiores a 40 , agrupados por ID de empleados, y cu�les son esos empleados? Ordenar de Mayor a Menor por Cantidad de empleados. 
SELECT 
       COUNT(ID_Empleado) AS CantidadEmpleados,
	   Horas_Trabajadas_por_Semana
FROM FactMetricasEmpleados
GROUP BY Horas_Trabajadas_por_Semana
HAVING Horas_Trabajadas_por_Semana > 48
ORDER BY CantidadEmpleados DESC;


-- USO DE OPERADORES RELACIONALES --

-- > (Mayor)

-- 18) �Cu�ntos empleados tienen un nivel de experiencia mayor a 10 a�os?
SELECT 
      COUNT(ID_Empleado) AS Empleados_M�s10a�os_Experiencia
FROM DimEmpleados
WHERE A�os_de_Experiencia > 10;

-- <= (Menor o Igual)

-- 19) �Cu�ntos empleados tienen 3 o menos a�os de experiencia?
SELECT 
     COUNT(ID_Empleado) AS CantidadEmpleados_3a�os_Experiencia
FROM DimEmpleados
WHERE A�os_de_Experiencia <= 3;

-- 19.1) �Cu�l ser�a el porcentaje de empleados con experiencia igual o menor a 3 a�os, en relaci�n al total de encuestados?
SELECT 
    COUNT (ID_Empleado) AS CantidadEmpleados_3a�os_Experiencia,
   (COUNT(ID_Empleado) * 100 / 5000) AS Porcentaje_3a�os_Experiencia
FROM DimEmpleados
WHERE A�os_de_Experiencia <= 3;


-- = (Igual)

-- 20) �Cu�ntos empleados trabajan 48hs semanales?
SELECT
      COUNT(ID_Empleado) AS Empleados_Trabajan_48hs_Semanales
FROM FactMetricasEmpleados
WHERE Horas_Trabajadas_por_Semana = 48;

-- != (Diferente) 

-- 21) �Cu�ntos empleados presetan una calificaci�n de aislamiento social diferente a 1, 2 y 3?
SELECT
     COUNT(ID_Empleado) AS TotalEmpleados_AislamientoSocial
FROM FactMetricasEmpleados
WHERE Calificacion_de_Aislamiento_Social != 1 AND Calificacion_de_Aislamiento_Social !=2 AND Calificacion_de_Aislamiento_Social !=3;


-- USO DE OPERADORES L�GICOS --

-- OR 

-- 22) �Qu� empleados tienen un nivel de estr�s alto o medio?
SELECT 
      ID_Empleado,
	  Nivel_de_Estres
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto' OR Nivel_de_Estres='Medio';

-- AND

-- 23) �Qu� cantidad de empleados tienen niveles altos de estr�s y ansiedad?
SELECT 
      COUNT(ID_Empleado) AS CantidadEmpleados,
	  Nivel_de_Estres,
	  Condicion_de_Salud_Mental
FROM FactMetricasEmpleados
WHERE Nivel_de_Estres='Alto' AND Condicion_de_Salud_Mental='Ansiedad'
GROUP BY Nivel_de_Estres, Condicion_de_Salud_Mental;

-- IN

-- 24)�Qu� empleados tienen 2, 5, 10 a�os de experiencia trabajando?
SELECT 
     ID_Empleado,
	 A�os_de_Experiencia
FROM DimEmpleados
WHERE A�os_de_Experiencia IN (2,5,10)
ORDER BY A�os_de_Experiencia DESC;

-- NOT IN

-- 25) �Cu�ntos empleados tienen una calficaci�n del nivel de aislamiento diferente a 1, 2 y 3?
SELECT 
      COUNT(ID_Empleado) AS TotalEmpleados_distinto_123
FROM FactMetricasEmpleados
WHERE Calificacion_de_Aislamiento_Social NOT IN (1, 2, 3);

-- LIKE

-- 26) �Cu�les son los empleados que se encuentran instasifechos con su trabajo? -- que comience con "IN" --
SELECT 
      ID_Empleado,
	  Satisfaccion_con_Trabajo_Remoto
FROM DimEmpleados
WHERE Satisfaccion_con_Trabajo_Remoto LIKE 'In%';

-- 27) �Cuales son los empleados que se encuentran con ansiedad? -- que termine con "DAD"--
SELECT 
      ID_Empleado,
	  Condicion_de_Salud_Mental
FROM FactMetricasEmpleados 
WHERE Condicion_de_Salud_Mental LIKE '%dad';

-- BETWEEN 

-- 28) �Qu� empleados tienen entre 10 y 15 reuniones semanales? Ordenar de mayor a menor seg�n cantidad de reuniones. 
SELECT 
     ID_Empleado, 
	 Numero_de_Reuniones_Virtuales
FROM FactMetricasEmpleados
WHERE Numero_de_Reuniones_Virtuales BETWEEN 10 AND 15
ORDER BY Numero_de_Reuniones_Virtuales DESC;

-- 29) �Cu�ntos empleados tienen una edad entre 25 y 35 a�os?
SELECT 
      COUNT(ID_Empleado) AS TotalEmpleados_25a35_A�os
FROM DimEmpleados
WHERE Edad BETWEEN 25 AND 35;

-- USO DE FUNCIONES ESCALARES -- CARACTERES O CADENA

-- LEFT (Extrae caracteres iniciando desde el lado izquierdo)

-- 30) �Cu�les son los primeros 3 caracteres del campo "cambio en productividad"?
SELECT 
      ID_Empleado,
	  LEFT (Cambio_en_Productividad, 3) AS Primeros_3_Caracteres
FROM FactMetricasEmpleados;

-- RIGHT (Extrae caracteres iniciando desde el lado derecho) 

-- 31) �Cu�les son los 4 �ltimos caracteres del campo "cambio en productividad"?
SELECT 
      ID_Empleado,
	  RIGHT(Cambio_en_Productividad, 4) AS Ultimos_4_Caracteres
FROM FactMetricasEmpleados;

-- CONCAT (Permite unir campos o caracteres)

-- 32) �C�mo se pueden concatenar los campos edad y g�nero de los empleados para que se encuentren dentro de un mismo campo?
SELECT 
      CONCAT(Edad, ' - ', Genero) AS Edad_Genero
FROM DimEmpleados; 

-- REPLACE (Permite reemplazar caracteres en un campo)

-- 33) �C�mo se pueden reemplazar todas las instancias de un car�cter espec�fico en el campo "satisfacci�n de trabajo remoto? en este caso cambiar el �ltimo caracter "o" por "a".  
SELECT 
      REPLACE(Satisfaccion_con_Trabajo_Remoto, 'o', 'a') AS NuevoCaracter
FROM DimEmpleados; 

-- UPPER (Convierte todos los valores a may�scula) 

-- 34) �C�mo se puede convertir todos los registros del campo "g�nero" en may�scula?
SELECT 
     ID_Empleado,
	 UPPER(Genero) AS Genero_Mayuscula
FROM DimEmpleados;

-- LOWER (Convierte todos los valores a min�scula)

-- 35) �C�mo se puede convertir todos los registros del campo "g�nero" en min�scula?
SELECT 
      ID_Empleado,
	  LOWER(Genero) AS Genero_Minuscula
FROM DimEmpleados;


SELECT * FROM [dbo].[FactMetricasEmpleados]
SELECT * FROM [dbo].[DimSue�o]
SELECT * FROM [dbo].[DimRoles]
SELECT * FROM [dbo].[DimRegiones]
SELECT * FROM [dbo].[DimIndustrias]
SELECT * FROM [dbo].[DimEmpleados]
SELECT * FROM [dbo].[DimActividadFisica]

