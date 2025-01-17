-- CONSULTAS AVANZADAS USANDO SUBCONSULTAS -- 
/* 1) ¿Cuáles son los empleados cuyo año de experiencia está por encima de los años de experiencia promedio?
Ordenar de menor a mayor según años de experiencia.*/
SELECT 
       ID_Empleado,
	   Años_de_Experiencia
FROM DimEmpleados
WHERE Años_de_Experiencia > (SELECT AVG(Años_de_Experiencia) FROM DimEmpleados)
ORDER BY Años_de_Experiencia;

/* 2) ¿Qué empleados que trabajan de forma remota han trabajado más horas por semana
que el promedio de horas trabajadas por semana de aquellos que trabajan presencial en la oficina. */

SELECT 
       ID_Empleado,
	   Ubicacion_de_Trabajo,
	   Horas_Trabajadas_por_Semana
FROM FactMetricasEmpleados
WHERE Horas_Trabajadas_por_Semana > (
      SELECT AVG(Horas_Trabajadas_por_Semana)
	  FROM FactMetricasEmpleados
	  WHERE Ubicacion_de_Trabajo='Presencial'
)
AND Ubicacion_de_Trabajo='Remoto'
ORDER BY Horas_Trabajadas_por_Semana;

/* 3) Cuáles son los empleados mayores que el promedio de edad y con nivel de estres alto, que trabajan de manera remota.
Finalmente ordenar por edad, de menor a mayor. */

SELECT 
      M.ID_Empleado, 
	  M.Nivel_de_Estres,
	  E.Edad 
FROM FactMetricasEmpleados M
INNER JOIN DimEmpleados E
ON M.ID_Empleado=E.ID_Empleado
WHERE M.Ubicacion_de_Trabajo = 'Remoto'
AND M.Nivel_de_Estres= 'Alto'
AND E.Edad > (
    SELECT AVG(Edad)
	FROM DimEmpleados
	WHERE ID_Empleado IN (
	 SELECT ID_Empleado
	 FROM FactMetricasEmpleados
	 WHERE Nivel_de_Estres='Alto')
)

ORDER BY E.Edad;

/* 4) ¿Quienes tienen acceso a recursos de salud mental pero aún presentan un nivel de aislamiento social superior
al promedio de quienes no tienen acceso? */

SELECT 
      ID_Empleado,
	  Calificacion_de_Aislamiento_Social
FROM FactMetricasEmpleados
WHERE Acceso_a_Recursos_de_Salud_Mental= 'Si' 
AND Calificacion_de_Aislamiento_Social > (
    SELECT AVG(Calificacion_de_Aislamiento_Social)
	FROM FactMetricasEmpleados
	WHERE Acceso_a_Recursos_de_Salud_Mental='No')
ORDER BY Calificacion_de_Aislamiento_Social DESC; 

/* 5) ¿Cuál es es la cantidad de empleados por región, y cuáles son esas regiones? 
Ordenar de mayor a menor los registros según región con mayor cantidad de empleados*/

SELECT 
      COUNT(M.ID_empleado) AS TotalEmpleados,
	  R.Region
FROM FactMetricasEmpleados AS M
LEFT JOIN DimRegiones AS R
ON M.ID_Region=R.ID_Region
GROUP BY R.Region
ORDER BY TotalEmpleados DESC;

/* 6) ¿Cuál es es la cantidad de empleados por rol, y cuáles son esos roles? 
Ordenar de mayor a menor los registros según roles con mayor cantidad de empleados. 
Luego seleccionar solo aquellos roles con más de 700 empleados */
SELECT 
      Ro.Rol,
      COUNT(ID_Empleado) AS PromedioEmpleados
FROM FactMetricasEmpleados AS M
INNER JOIN DimRoles AS Ro
ON M.ID_Rol=Ro.ID_Rol
GROUP BY Ro.Rol
HAVING  COUNT(ID_Empleado) > 700
ORDER BY PromedioEmpleados DESC;

/* 7) ¿Cuál es el promedio de empleados por Intensidad de actividad fisica, y cuáles son esos tipos de intensidad de actividad fisica? 
Ordenar de menor a mayor los registros según promedio de empleados*/
SELECT 
     AF.Actividad_Fisica, 
     AVG(M.ID_Empleado) AS PromedioEmpleado
FROM FactMetricasEmpleados AS M
INNER JOIN DimActividadFisica AS AF
ON M.ID_Actividad_Fisica=AF.ID_Actividad_Fisica
GROUP BY AF.Actividad_Fisica
ORDER BY PromedioEmpleado;

/* 8) ¿Qué porcentaje de empleados tienen una calidad de sueño "pobre" y "buena" segun genero?*/
SELECT 
      E.Genero, 
	  COUNT(CASE WHEN S.Calidad_del_Sueño = 'Pobre' THEN 1 END) * 100.0 /COUNT(E.ID_Empleado) AS Porcentaje_Sueño_Pobre,
	  COUNT(CASE WHEN S.Calidad_del_Sueño = 'Bueno' THEN 1 END) * 100.0 /COUNT(E.ID_Empleado) AS Porcentaje_Sueño_Bueno
FROM DimEmpleados AS E 
INNER JOIN FactMetricasEmpleados AS M ON E.ID_Empleado=M.ID_Empleado
INNER JOIN DimSueño AS S ON M.ID_Sueño=S.ID_Sueño
GROUP BY E.Genero;

/* 9) Según el tipo de trabajo (presencial, híbrido, remoto) ¿Cómo se distribuyen las condiciones de salud existentes?*/
SELECT Ubicacion_de_Trabajo,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Depresion' THEN 1 END) AS Depresion,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Ansiedad' THEN 1 END) AS Ansiedad,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Agotamiento' THEN 1 END) AS Agotamiento,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Ninguna' THEN 1 END) AS Ninguna
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

/* 10) Según el tipo de trabajo (presencial, híbrido, remoto) ¿Cómo es el nivel de estrés de los empleados?*/
SELECT Ubicacion_de_Trabajo,
    COUNT(CASE WHEN Nivel_de_Estres = 'Alto' THEN 1 END) AS Alto,
	COUNT(CASE WHEN Nivel_de_Estres = 'Medio' THEN 1 END) AS Medio,
	COUNT(CASE WHEN Nivel_de_Estres = 'Bajo' THEN 1 END) AS Bajo
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

/* 11) Según el tipo de trabajo (presencial, híbrido, remoto) ¿Cómo es la calidad del sueño de los empleados?*/

SELECT 
    E.Ubicacion_de_Trabajo,
    COUNT(CASE WHEN S.Calidad_del_Sueño = 'Bueno' THEN 1 END) AS Bueno,
    COUNT(CASE WHEN S.Calidad_del_Sueño = 'Promedio' THEN 1 END) AS Promedio,
    COUNT(CASE WHEN S.Calidad_del_Sueño = 'Pobre' THEN 1 END) AS Pobre
FROM FactMetricasEmpleados AS E 
JOIN  DimSueño AS S ON E.ID_Sueño = S.ID_Sueño
GROUP BY E.Ubicacion_de_Trabajo;

/* 12) Según el tipo de trabajo (presencial, híbrido, remoto) ¿Cuál es la frecuencia de actividad física de los empleados?*/
SELECT 
    E.Ubicacion_de_Trabajo,
    COUNT(CASE WHEN A.Actividad_Fisica = 'Diario' THEN 1 END) AS Diario,
    COUNT(CASE WHEN A.Actividad_Fisica = 'Semanal' THEN 1 END) AS Semanal,
    COUNT(CASE WHEN A.Actividad_Fisica = 'Ninguno' THEN 1 END) AS Ninguno
FROM FactMetricasEmpleados AS E 
JOIN  DimActividadFisica AS A ON E.ID_Actividad_Fisica = A.ID_Actividad_Fisica
GROUP BY E.Ubicacion_de_Trabajo;

/* 13) Según el tipo de trabajo (presencial, híbrido, remoto) ¿Cuál es el nivel de satisfacción de los empleados?*/
SELECT E.Ubicacion_de_Trabajo,
    COUNT(CASE WHEN Sa.Satisfaccion_con_Trabajo_Remoto = 'Satisfecho' THEN 1 END) AS Satisfecho,
	COUNT(CASE WHEN Sa.Satisfaccion_con_Trabajo_Remoto = 'Neutral' THEN 1 END) AS Neutral,
	COUNT(CASE WHEN Sa.Satisfaccion_con_Trabajo_Remoto = 'Insatisfecho' THEN 1 END) AS Insatisfecho
FROM FactMetricasEmpleados AS E 
JOIN  DimEmpleados AS Sa ON E.ID_Empleado = Sa.ID_Empleado
WHERE E.Ubicacion_de_Trabajo='Remoto'
GROUP BY E.Ubicacion_de_Trabajo;