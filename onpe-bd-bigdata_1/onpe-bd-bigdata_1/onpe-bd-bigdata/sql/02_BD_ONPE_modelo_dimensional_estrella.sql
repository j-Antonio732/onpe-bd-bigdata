/* =====================================================================
   BD_ONPE - Modelo dimensional (esquema en estrella) - SQL Server
   Tabla de hechos: H_ASISTENCIA
   Dimensiones: D_MIEMBRO, D_CAPACITACION, D_LOCAL, D_TIEMPO, D_PROCESO
   Granularidad: un registro de asistencia de un miembro de mesa en una
   capacitación específica, con un proceso electoral, un local y una fecha.
   Fuente: scripts DDL del informe (Figuras 3 y 4, evidencia E-06, 3.4.2).
   Requiere haber ejecutado 01_BD_ONPE_modelo_relacional_3FN.sql.
   ===================================================================== */

USE BD_ONPE;
GO

CREATE TABLE D_TIEMPO (
    id_tiempo INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    dia INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre INT NOT NULL,
    año INT NOT NULL
);
GO

CREATE TABLE D_PROCESO (
    id_proceso INT PRIMARY KEY,
    nombre_proceso VARCHAR(100) NOT NULL,
    tipo_proceso VARCHAR(50) NOT NULL,
    fecha_proceso DATE NOT NULL
);
GO

CREATE TABLE D_MIEMBRO (
    id_miembro INT PRIMARY KEY,
    dni CHAR(8) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    sexo CHAR(1),
    distrito VARCHAR(100),
    provincia VARCHAR(100),
    estado_miembro VARCHAR(20)
);
GO

CREATE TABLE D_CAPACITACION (
    id_capacitacion INT PRIMARY KEY,
    tipo VARCHAR(50),
    estado VARCHAR(20),
    descripcion VARCHAR(255),
    hora_inicio TIME,
    hora_fin TIME
);
GO

CREATE TABLE D_LOCAL (
    id_local INT PRIMARY KEY,
    nombre_local VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    referencia VARCHAR(150),
    distrito VARCHAR(100),
    provincia VARCHAR(100),
    aula VARCHAR(10),
    aforo INT
);
GO

CREATE TABLE H_ASISTENCIA (
    id_asistencia INT PRIMARY KEY IDENTITY(1,1),
    id_miembro INT NOT NULL,
    id_capacitacion INT NOT NULL,
    id_proceso INT NOT NULL,
    id_local INT NOT NULL,
    id_tiempo INT NOT NULL,
    estado_asistencia VARCHAR(20),
    cantidad INT NOT NULL
);
GO
