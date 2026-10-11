/* =====================================================================
   BD_ONPE - Vistas de consulta - SQL Server
   VW_CIUDADANOS, VW_MIEMBROS_MESA, VW_CAPACITACIONES, VW_ASISTENCIA y
   VW_DISTRIBUCION_MATERIAL.
   Requiere haber ejecutado 01 y 04.
   Fuente: script del equipo (BD_ONPE_CODS.sql, evidencia E-06).
   ===================================================================== */

USE BD_ONPE
GO
-- =====================================================
-- CREACION DE VISTAS
-- =====================================================
CREATE VIEW VW_CIUDADANOS
AS
SELECT
    c.id_ciudadano,
    c.dni,
    c.primer_nombre,
    c.segundo_nombre,
    c.apellido_paterno,
    c.apellido_materno,
    c.fecha_nacimiento,
    c.sexo,
    c.estado_civil,
    u.distrito,
    u.provincia
FROM CIUDADANO c
INNER JOIN UBIGEO u
ON c.id_ubigeo = u.id_ubigeo;
GO

SELECT * FROM VW_CIUDADANOS;

CREATE VIEW VW_MIEMBROS_MESA
AS
SELECT
    mm.id_miembro,
    c.dni,
    c.primer_nombre + ' ' + c.apellido_paterno AS nombre_completo,
    mm.estado,
    u.distrito,
    u.provincia
FROM MIEMBRO_MESA mm
INNER JOIN CIUDADANO c
ON mm.id_ciudadano = c.id_ciudadano
INNER JOIN UBIGEO u
ON c.id_ubigeo = u.id_ubigeo;
GO

SELECT * FROM VW_MIEMBROS_MESA;

CREATE VIEW VW_CAPACITACIONES
AS
SELECT
    cp.id_capacitacion,
    pe.nombre AS proceso_electoral,
    j.fecha,
    j.hora_inicio,
    j.hora_fin,
    lc.nombre AS local_capacitacion,
    a.numero AS aula,
    a.aforo,
    c.primer_nombre + ' ' + c.apellido_paterno AS capacitador,
    cp.tipo,
    cp.estado
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
GO

SELECT * FROM VW_CAPACITACIONES;

CREATE VIEW VW_ASISTENCIA
AS
SELECT
    asi.id_capacitacion,
    c.dni,
    c.primer_nombre + ' ' + c.apellido_paterno AS miembro_mesa,
    asi.estado
FROM ASISTENCIA asi
INNER JOIN MIEMBRO_MESA mm
ON asi.id_miembro = mm.id_miembro
INNER JOIN CIUDADANO c
ON mm.id_ciudadano = c.id_ciudadano;
GO

SELECT * FROM VW_ASISTENCIA;

CREATE VIEW VW_DISTRIBUCION_MATERIAL
AS
SELECT
    dm.id_distribucion,
    mc.nombre AS material,
    dm.cantidad,
    dm.fecha_entrega,
    cp.id_capacitacion
FROM DISTRIBUCION_MATERIAL dm
INNER JOIN MATERIAL_CAPACITACION mc
ON dm.id_material = mc.id_material
INNER JOIN CAPACITACION cp
ON dm.id_capacitacion = cp.id_capacitacion;
GO

SELECT * FROM VW_DISTRIBUCION_MATERIAL;

SELECT
    estado,
    COUNT(*) AS total
FROM MIEMBRO_MESA
GROUP BY estado;
