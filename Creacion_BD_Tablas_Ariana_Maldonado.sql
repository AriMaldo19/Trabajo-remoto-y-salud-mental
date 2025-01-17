-- CREACI�N BASE DE DATOS --

-- Creaci�n de la Base de Datos: TrabajoRemoto_SaludMental. 
CREATE DATABASE TrabajoRemoto_SaludMental;

-- POSICIONARSE EN BD ADECUADA -- 
-- Posicionamiento sobre la Base de Datos. 
USE TrabajoRemoto_SaludMental;

-- CREACI�N DE TABLAS -- 
-- Creaci�n de Tabla: DimActividadFisica.
CREATE TABLE DimActividadFisica (
ID_Actividad_Fisica INT NOT NULL PRIMARY KEY,
Actividad_Fisica VARCHAR(50) NOT NULL   -- Semanal, Ninguno, Diario 
);

-- Creaci�n de Tabla: DimSue�o.
CREATE TABLE DimSue�o (
ID_Sue�o INT NOT NULL PRIMARY KEY,
Calidad_del_Sue�o VARCHAR(50) NOT NULL   -- Bueno, Pobre, Promedio 
); 

-- Creaci�n de Tabla: DimIndustrias.
CREATE TABLE DimIndustrias (
ID_Industria INT NOT NULL PRIMARY KEY,
Industria VARCHAR(50) NOT NULL   -- Atencion Sanitaria, IT, Educaci�n, Finanzas, Consultoria, Manufactura, Comercio Minorista
);

-- Creaci�n de Tabla: DimRoles.
CREATE TABLE DimRoles (
ID_Rol INT NOT NULL PRIMARY KEY,
Rol VARCHAR(50) NOT NULL   -- HR, Data Scientist, Software Engineer, Sales, Marketing, Designer, Project Manager
); 

-- Creaci�n de Tabla: DimRegiones.
CREATE TABLE DimRegiones (
ID_Region INT NOT NULL PRIMARY KEY,
Region VARCHAR(50) NOT NULL   -- Europa, Asia, America del Norte, America del Sur, Oceania, Africa
);

-- Creaci�n de Tabla: DimEmpleados.
CREATE TABLE DimEmpleados (
ID_Empleado INT NOT NULL PRIMARY KEY,
Edad INT NOT NULL, 
Genero VARCHAR(50) NOT NULL,
A�os_de_Experiencia INT NOT NULL,
Satisfaccion_con_Trabajo_Remoto VARCHAR(50) NOT NULL     -- Satisfecho, Insatisfecho, Neutral 
); 

-- Creaci�n de Tabla: FactMetricasEmpleados. 
CREATE TABLE FactMetricasEmpleados (
ID_Metrica INT NOT NULL PRIMARY KEY,
Ubicacion_de_Trabajo VARCHAR(50) NOT NULL,
Horas_Trabajadas_por_Semana INT NOT NULL,
Numero_de_Reuniones_Virtuales INT NOT NULL, 
Calificacion_Equilibrio_Vida_Laboral INT NOT NULL, 
Nivel_de_Estres VARCHAR(50) NOT NULL,
Condicion_de_Salud_Mental VARCHAR(50) NOT NULL,
Acceso_a_Recursos_de_Salud_Mental VARCHAR(2) NOT NULL,
Cambio_en_Productividad VARCHAR(50) NOT NULL, 
Calificacion_de_Aislamiento_Social INT NOT NULL,
ApoyoEmpresa_para_TrabajoRemoto INT NOT NULL,
ID_Empleado INT NOT NULL,
ID_Region INT NOT NULL,
ID_Rol INT NOT NULL,
ID_Industria INT NOT NULL,
ID_Sue�o INT NOT NULL, 
ID_Actividad_Fisica INT NOT NULL, 
FOREIGN KEY (ID_Empleado) REFERENCES DimEmpleados(ID_Empleado),
FOREIGN KEY (ID_Region) REFERENCES DimRegiones(ID_Region),
FOREIGN KEY (ID_Rol) REFERENCES DimRoles(ID_Rol),
FOREIGN KEY (ID_Industria) REFERENCES DimIndustrias(ID_Industria),
FOREIGN KEY (ID_Sue�o) REFERENCES DimSue�o(ID_Sue�o), 
FOREIGN KEY (ID_Actividad_Fisica) REFERENCES DimActividadFisica(ID_Actividad_Fisica)
); 


