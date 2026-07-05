-- CONSULTAS AVANZADAS --

/* 1) Empleados con experiencia por encima del promedio */
SELECT ID_Empleado, Anos_de_Experiencia
FROM DimEmpleados
WHERE Anos_de_Experiencia > (SELECT AVG(Anos_de_Experiencia) FROM DimEmpleados)
ORDER BY Anos_de_Experiencia;

/* 2) Remotos con mas horas que el promedio presencial */
SELECT ID_Empleado, Ubicacion_de_Trabajo, Horas_Trabajadas_por_Semana
FROM FactMetricasEmpleados
WHERE Horas_Trabajadas_por_Semana > (
    SELECT AVG(Horas_Trabajadas_por_Semana)
    FROM FactMetricasEmpleados
    WHERE Ubicacion_de_Trabajo = 'Presencial'
)
AND Ubicacion_de_Trabajo = 'Remoto'
ORDER BY Horas_Trabajadas_por_Semana;

/* 3) Remotos con estres alto y edad mayor al promedio de quienes tienen estres alto */
SELECT M.ID_Empleado, M.Nivel_de_Estres, E.Edad
FROM FactMetricasEmpleados M
INNER JOIN DimEmpleados E ON M.ID_Empleado = E.ID_Empleado
WHERE M.Ubicacion_de_Trabajo = 'Remoto'
  AND M.Nivel_de_Estres = 'Alto'
  AND E.Edad > (
      SELECT AVG(Edad)
      FROM DimEmpleados
      WHERE ID_Empleado IN (
          SELECT ID_Empleado
          FROM FactMetricasEmpleados
          WHERE Nivel_de_Estres = 'Alto'
      )
  )
ORDER BY E.Edad;

/* 4) Acceso a recursos pero aislamiento superior al promedio de quienes no tienen acceso */
SELECT ID_Empleado, Calificacion_de_Aislamiento_Social
FROM FactMetricasEmpleados
WHERE Acceso_a_Recursos_de_Salud_Mental = 'Si'
  AND Calificacion_de_Aislamiento_Social > (
      SELECT AVG(Calificacion_de_Aislamiento_Social)
      FROM FactMetricasEmpleados
      WHERE Acceso_a_Recursos_de_Salud_Mental = 'No'
  )
ORDER BY Calificacion_de_Aislamiento_Social DESC;

/* 5) Cantidad de empleados por region */
SELECT COUNT(M.ID_Empleado) AS TotalEmpleados, R.Region
FROM FactMetricasEmpleados AS M
LEFT JOIN DimRegiones AS R ON M.ID_Region = R.ID_Region
GROUP BY R.Region
ORDER BY TotalEmpleados DESC;

/* 6) Roles con mas de 700 empleados */
SELECT Ro.Rol, COUNT(M.ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados AS M
INNER JOIN DimRoles AS Ro ON M.ID_Rol = Ro.ID_Rol
GROUP BY Ro.Rol
HAVING COUNT(M.ID_Empleado) > 700
ORDER BY TotalEmpleados DESC;

/* 7) Cantidad de empleados por tipo de actividad fisica */
SELECT AF.Actividad_Fisica, COUNT(M.ID_Empleado) AS TotalEmpleados
FROM FactMetricasEmpleados AS M
INNER JOIN DimActividadFisica AS AF ON M.ID_Actividad_Fisica = AF.ID_Actividad_Fisica
GROUP BY AF.Actividad_Fisica
ORDER BY TotalEmpleados;

/* 8) Porcentaje de sueno pobre y bueno por genero */
SELECT
    E.Genero,
    COUNT(CASE WHEN S.Calidad_del_Sueno = 'Pobre' THEN 1 END) * 100.0 / COUNT(E.ID_Empleado) AS Porcentaje_Sueno_Pobre,
    COUNT(CASE WHEN S.Calidad_del_Sueno = 'Bueno' THEN 1 END) * 100.0 / COUNT(E.ID_Empleado) AS Porcentaje_Sueno_Bueno
FROM DimEmpleados AS E
INNER JOIN FactMetricasEmpleados AS M ON E.ID_Empleado = M.ID_Empleado
INNER JOIN DimSueno AS S ON M.ID_Sueno = S.ID_Sueno
GROUP BY E.Genero;

/* 9) Condiciones de salud mental por modalidad de trabajo */
SELECT
    Ubicacion_de_Trabajo,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Depresion' THEN 1 END) AS Depresion,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Ansiedad' THEN 1 END) AS Ansiedad,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Agotamiento' THEN 1 END) AS Agotamiento,
    COUNT(CASE WHEN Condicion_de_Salud_Mental = 'Ninguna' THEN 1 END) AS Ninguna
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

/* 10) Nivel de estres por modalidad de trabajo */
SELECT
    Ubicacion_de_Trabajo,
    COUNT(CASE WHEN Nivel_de_Estres = 'Alto' THEN 1 END) AS Alto,
    COUNT(CASE WHEN Nivel_de_Estres = 'Medio' THEN 1 END) AS Medio,
    COUNT(CASE WHEN Nivel_de_Estres = 'Bajo' THEN 1 END) AS Bajo
FROM FactMetricasEmpleados
GROUP BY Ubicacion_de_Trabajo;

/* 11) Calidad del sueno por modalidad de trabajo */
SELECT
    E.Ubicacion_de_Trabajo,
    COUNT(CASE WHEN S.Calidad_del_Sueno = 'Bueno' THEN 1 END) AS Bueno,
    COUNT(CASE WHEN S.Calidad_del_Sueno = 'Promedio' THEN 1 END) AS Promedio,
    COUNT(CASE WHEN S.Calidad_del_Sueno = 'Pobre' THEN 1 END) AS Pobre
FROM FactMetricasEmpleados AS E
JOIN DimSueno AS S ON E.ID_Sueno = S.ID_Sueno
GROUP BY E.Ubicacion_de_Trabajo;

/* 12) Actividad fisica por modalidad de trabajo */
SELECT
    E.Ubicacion_de_Trabajo,
    COUNT(CASE WHEN A.Actividad_Fisica = 'Diario' THEN 1 END) AS Diario,
    COUNT(CASE WHEN A.Actividad_Fisica = 'Semanal' THEN 1 END) AS Semanal,
    COUNT(CASE WHEN A.Actividad_Fisica = 'Ninguno' THEN 1 END) AS Ninguno
FROM FactMetricasEmpleados AS E
JOIN DimActividadFisica AS A ON E.ID_Actividad_Fisica = A.ID_Actividad_Fisica
GROUP BY E.Ubicacion_de_Trabajo;

/* 13) Satisfaccion con trabajo remoto por modalidad de trabajo */
SELECT
    E.Ubicacion_de_Trabajo,
    COUNT(CASE WHEN Sa.Satisfaccion_con_Trabajo_Remoto = 'Satisfecho' THEN 1 END) AS Satisfecho,
    COUNT(CASE WHEN Sa.Satisfaccion_con_Trabajo_Remoto = 'Neutral' THEN 1 END) AS Neutral,
    COUNT(CASE WHEN Sa.Satisfaccion_con_Trabajo_Remoto = 'Insatisfecho' THEN 1 END) AS Insatisfecho
FROM FactMetricasEmpleados AS E
JOIN DimEmpleados AS Sa ON E.ID_Empleado = Sa.ID_Empleado
GROUP BY E.Ubicacion_de_Trabajo
ORDER BY E.Ubicacion_de_Trabajo;
