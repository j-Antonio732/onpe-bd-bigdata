/* =====================================================================
   BD_ONPE - Pruebas de manipulación de datos (UPDATE / DELETE / INSERT)
   y consultas sobre las vistas.
   Requiere haber ejecutado 01, 04 y 05.
   Nota: algunas sentencias son pruebas de integridad referencial y se
   espera que SQL Server las rechace por violación de clave foránea:
     - DELETE de CIUDADANO 1, CAPACITACION 1 y UBIGEO 1 (tienen registros
       hijos que los referencian).
     - INSERT de CIUDADANO con id_ubigeo = 99 (no existe en UBIGEO).
   Fuente: script del equipo (BD_ONPE_DATOS_VISTAS.sql, evidencia E-06).
   ===================================================================== */

-- =====================================================
-- ACTUALIZACION TABLA CIUDADANO
-- =====================================================
UPDATE CIUDADANO
SET estado_civil = 'Soltero'
WHERE id_ciudadano = 1;

SELECT * FROM VW_CIUDADANOS;

-- =====================================================
-- ELIMINACION TABLA CIUDADANO
-- =====================================================
DELETE FROM CIUDADANO
WHERE id_ciudadano = 1;

DELETE FROM CAPACITACION
WHERE id_capacitacion = 1;
-- =====================================================
-- INSERTAR TABLA CIUDADANO
-- =====================================================
INSERT INTO CIUDADANO
(dni, primer_nombre, segundo_nombre, apellido_paterno,
apellido_materno, fecha_nacimiento, sexo, estado_civil, id_ubigeo)
VALUES
('74859621', 'Luis', 'Miguel', 'Rojas',
'Perez', '1998-10-10', 'M', 'Soltero', 1);

INSERT INTO CIUDADANO
(dni, primer_nombre, segundo_nombre, apellido_paterno,
apellido_materno, fecha_nacimiento, sexo, estado_civil, id_ubigeo)
VALUES
('09741049', 'Mario', 'Jose', 'Lopez',
'Torres', '1999-01-01', 'M', 'Soltero', 99);

-- =====================================================
-- ELIMINACION DE UBIGEO
-- =====================================================
DELETE FROM UBIGEO
WHERE id_ubigeo = 1;

-- =====================================================
-- ACTULIZACION DE DATOS DE TABLA
-- =====================================================
UPDATE MATERIAL_CAPACITACION
SET stock = 800
WHERE id_material = 1;

UPDATE MIEMBRO_MESA
SET estado = 'ACTIVO'
WHERE estado = 'PENDIENTE';

-- =====================================================
-- SELECCION DE VISTAS CON DATOS
-- =====================================================
SELECT *
FROM VW_CAPACITACIONES
WHERE fecha = '2026-01-10';

SELECT *
FROM VW_CIUDADANOS
WHERE distrito = 'Miraflores';

-- =====================================================
-- CUANTOS MIEMBROS ESTAN ACTIVOS
-- =====================================================
SELECT COUNT(*) AS total_activos
FROM MIEMBRO_MESA
WHERE estado = 'ACTIVO';

-- =====================================================
-- CANTIDAD DE MATERIALES
-- =====================================================
SELECT
    SUM(cantidad) AS total_materiales
FROM DISTRIBUCION_MATERIAL;

-- =====================================================
-- MIEMBRO DE MESA Y SU ESTADO
-- =====================================================
SELECT
    c.primer_nombre,
    c.apellido_paterno,
    mm.estado
FROM CIUDADANO c
INNER JOIN MIEMBRO_MESA mm
ON c.id_ciudadano = mm.id_ciudadano;

-- =====================================================
-- LOCAL DE CAPACITACION
-- =====================================================
SELECT
    pe.nombre AS proceso,
    lc.nombre AS local,
    a.numero AS aula,
    c.primer_nombre + ' ' + c.apellido_paterno AS capacitador
FROM CAPACITACION cp
INNER JOIN JORNADA j
ON cp.id_jornada = j.id_jornada
INNER JOIN PROCESO_ELECTORAL pe
ON j.id_proceso = pe.id_proceso
INNER JOIN AULA a
ON cp.id_aula = a.id_aula
INNER JOIN LOCAL_CAPACITACION lc
ON a.id_local = lc.id_local
INNER JOIN CAPACITADOR cap
ON cp.id_capacitador = cap.id_capacitador
INNER JOIN CIUDADANO c
ON cap.id_ciudadano = c.id_ciudadano;

-- =====================================================
-- SELECCION DE VISTAS CON DATOS
-- =====================================================
SELECT name
FROM sys.views;

SELECT * FROM VW_CIUDADANOS;
SELECT * FROM VW_MIEMBROS_MESA;
SELECT * FROM VW_ASISTENCIA;
SELECT * FROM VW_CAPACITACIONES;
SELECT * FROM VW_DISTRIBUCION_MATERIAL;
