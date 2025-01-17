-- CREACIÓN BASE DE DATOS --

-- Creación de la Base de Datos: TrabajoRemoto_SaludMental. 
CREATE DATABASE TrabajoRemoto_SaludMental;

-- POSICIONARSE EN BD ADECUADA -- 
-- Posicionamiento sobre la Base de Datos. 
USE TrabajoRemoto_SaludMental;

-- CREACIÓN DE TABLAS -- 
-- Creación de Tabla: DimActividadFisica.
CREATE TABLE DimActividadFisica (
ID_Actividad_Fisica INT NOT NULL PRIMARY KEY,
Actividad_Fisica VARCHAR(50) NOT NULL   -- Semanal, Ninguno, Diario 
);

-- Creación de Tabla: DimSueño.
CREATE TABLE DimSueño (
ID_Sueño INT NOT NULL PRIMARY KEY,
Calidad_del_Sueño VARCHAR(50) NOT NULL   -- Bueno, Pobre, Promedio 
); 

-- Creación de Tabla: DimIndustrias.
CREATE TABLE DimIndustrias (
ID_Industria INT NOT NULL PRIMARY KEY,
Industria VARCHAR(50) NOT NULL   -- Atencion Sanitaria, IT, Educación, Finanzas, Consultoria, Manufactura, Comercio Minorista
);

-- Creación de Tabla: DimRoles.
CREATE TABLE DimRoles (
ID_Rol INT NOT NULL PRIMARY KEY,
Rol VARCHAR(50) NOT NULL   -- HR, Data Scientist, Software Engineer, Sales, Marketing, Designer, Project Manager
); 

-- Creación de Tabla: DimRegiones.
CREATE TABLE DimRegiones (
ID_Region INT NOT NULL PRIMARY KEY,
Region VARCHAR(50) NOT NULL   -- Europa, Asia, America del Norte, America del Sur, Oceania, Africa
);

-- Creación de Tabla: DimEmpleados.
CREATE TABLE DimEmpleados (
ID_Empleado INT NOT NULL PRIMARY KEY,
Edad INT NOT NULL, 
Genero VARCHAR(50) NOT NULL,
Años_de_Experiencia INT NOT NULL,
Satisfaccion_con_Trabajo_Remoto VARCHAR(50) NOT NULL     -- Satisfecho, Insatisfecho, Neutral 
); 

-- Creación de Tabla: FactMetricasEmpleados. 
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
ID_Sueño INT NOT NULL, 
ID_Actividad_Fisica INT NOT NULL, 
FOREIGN KEY (ID_Empleado) REFERENCES DimEmpleados(ID_Empleado),
FOREIGN KEY (ID_Region) REFERENCES DimRegiones(ID_Region),
FOREIGN KEY (ID_Rol) REFERENCES DimRoles(ID_Rol),
FOREIGN KEY (ID_Industria) REFERENCES DimIndustrias(ID_Industria),
FOREIGN KEY (ID_Sueño) REFERENCES DimSueño(ID_Sueño), 
FOREIGN KEY (ID_Actividad_Fisica) REFERENCES DimActividadFisica(ID_Actividad_Fisica)
); 


