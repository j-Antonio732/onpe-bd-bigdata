/* =====================================================================
   BD_ONPE - Modelo relacional normalizado (3FN) - SQL Server
   Proyecto: Diseño de Base de Datos para el Sistema Electoral de la ONPE
   Contenido: 12 tablas con claves primarias, foráneas e IDENTITY.
   Orden de ejecución: este archivo primero, luego 02 y 03.
   Fuente: script DDL del trabajo del grupo (evidencia E-06, sección 3.4.2).
   ===================================================================== */

CREATE DATABASE BD_ONPE;
GO

USE BD_ONPE;
GO

CREATE TABLE UBIGEO (
    id_ubigeo INT PRIMARY KEY IDENTITY(1,1),
    distrito VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL
);

CREATE TABLE CIUDADANO (
    id_ciudadano INT PRIMARY KEY IDENTITY(1,1),
    dni CHAR(8) NOT NULL UNIQUE,
    primer_nombre VARCHAR(50) NOT NULL,
    segundo_nombre VARCHAR(50),
    apellido_paterno VARCHAR(50) NOT NULL,
    apellido_materno VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    estado_civil VARCHAR(20),
    id_ubigeo INT NOT NULL,
    FOREIGN KEY (id_ubigeo) REFERENCES UBIGEO(id_ubigeo)
);

CREATE TABLE MIEMBRO_MESA (
    id_miembro INT PRIMARY KEY IDENTITY(1,1),
    id_ciudadano INT UNIQUE NOT NULL,
    estado VARCHAR(20),
    FOREIGN KEY (id_ciudadano) REFERENCES CIUDADANO(id_ciudadano)
);

CREATE TABLE CAPACITADOR (
    id_capacitador INT PRIMARY KEY IDENTITY(1,1),
    id_ciudadano INT UNIQUE NOT NULL,
    FOREIGN KEY (id_ciudadano) REFERENCES CIUDADANO(id_ciudadano)
);

CREATE TABLE PROCESO_ELECTORAL (
    id_proceso INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL
);

CREATE TABLE JORNADA (
    id_jornada INT PRIMARY KEY IDENTITY(1,1),
    id_proceso INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    descripcion VARCHAR(255),
    FOREIGN KEY (id_proceso) REFERENCES PROCESO_ELECTORAL(id_proceso)
);

CREATE TABLE LOCAL_CAPACITACION (
    id_local INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    referencia VARCHAR(150),
    id_ubigeo INT NOT NULL,
    FOREIGN KEY (id_ubigeo) REFERENCES UBIGEO(id_ubigeo)
);

CREATE TABLE AULA (
    id_aula INT PRIMARY KEY IDENTITY(1,1),
    id_local INT NOT NULL,
    numero VARCHAR(10) NOT NULL,
    aforo INT NOT NULL,
    FOREIGN KEY (id_local) REFERENCES LOCAL_CAPACITACION(id_local)
);

CREATE TABLE CAPACITACION (
    id_capacitacion INT PRIMARY KEY IDENTITY(1,1),
    id_jornada INT NOT NULL,
    id_aula INT NOT NULL,
    id_capacitador INT NOT NULL,
    tipo VARCHAR(50),
    estado VARCHAR(20),
    FOREIGN KEY (id_jornada) REFERENCES JORNADA(id_jornada),
    FOREIGN KEY (id_aula) REFERENCES AULA(id_aula),
    FOREIGN KEY (id_capacitador) REFERENCES CAPACITADOR(id_capacitador)
);

CREATE TABLE ASISTENCIA (
    id_miembro INT NOT NULL,
    id_capacitacion INT NOT NULL,
    estado VARCHAR(20),
    PRIMARY KEY (id_miembro, id_capacitacion),
    FOREIGN KEY (id_miembro) REFERENCES MIEMBRO_MESA(id_miembro),
    FOREIGN KEY (id_capacitacion) REFERENCES CAPACITACION(id_capacitacion)
);

CREATE TABLE MATERIAL_CAPACITACION (
    id_material INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE DISTRIBUCION_MATERIAL (
    id_distribucion INT PRIMARY KEY IDENTITY(1,1),
    id_material INT NOT NULL,
    id_capacitacion INT NOT NULL,
    cantidad INT NOT NULL,
    fecha_entrega DATE,
    FOREIGN KEY (id_material) REFERENCES MATERIAL_CAPACITACION(id_material),
    FOREIGN KEY (id_capacitacion) REFERENCES CAPACITACION(id_capacitacion)
);
