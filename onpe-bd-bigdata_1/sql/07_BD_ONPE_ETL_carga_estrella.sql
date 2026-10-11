/* =====================================================================
   BD_ONPE - Automatización de la carga del modelo dimensional (ETL en T-SQL)
   Procedimiento almacenado SP_CARGAR_MODELO_ESTRELLA: carga completa de las
   5 dimensiones y de la tabla de hechos H_ASISTENCIA desde el modelo
   relacional 3FN, con transacción, control de errores, reconciliación de
   registros y bitácora en LOG_CARGA_ETL.
   Requiere haber ejecutado 01 a 04 (estructura y datos) y 05 (vistas).
   Se programa con el job del archivo 08_BD_ONPE_job_automatizacion.sql.

   Decisiones de diseño de la carga:
   - Carga completa (full refresh): se borran hechos y dimensiones y se
     vuelven a cargar, de modo que el procedimiento es repetible.
   - D_LOCAL conserva un aula por local (la de menor id_aula), porque la
     dimensión guarda una sola aula y un solo aforo por id_local.
   - H_ASISTENCIA.cantidad = 1 por cada registro de asistencia (granularidad
     del modelo: un miembro de mesa en una capacitación).
   - La carga se considera exitosa solo si los registros de ASISTENCIA y de
     H_ASISTENCIA coinciden; de lo contrario se revierte la transacción.
   ===================================================================== */

USE BD_ONPE;
GO

-- Bitácora de ejecuciones del proceso
IF OBJECT_ID('dbo.LOG_CARGA_ETL', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LOG_CARGA_ETL (
        id_log INT PRIMARY KEY IDENTITY(1,1),
        fecha_inicio DATETIME2 NOT NULL,
        fecha_fin DATETIME2 NULL,
        estado VARCHAR(20) NOT NULL,               -- EN CURSO / EXITOSO / ERROR
        filas_origen_asistencia INT NULL,
        filas_h_asistencia INT NULL,
        mensaje VARCHAR(500) NULL
    );
END
GO

CREATE OR ALTER PROCEDURE dbo.SP_CARGAR_MODELO_ESTRELLA
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_log INT, @origen INT, @destino INT;

    INSERT INTO dbo.LOG_CARGA_ETL (fecha_inicio, estado)
    VALUES (SYSDATETIME(), 'EN CURSO');
    SET @id_log = SCOPE_IDENTITY();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Limpieza: primero los hechos (tienen las claves foráneas)
        DELETE FROM dbo.H_ASISTENCIA;
        DELETE FROM dbo.D_MIEMBRO;
        DELETE FROM dbo.D_CAPACITACION;
        DELETE FROM dbo.D_LOCAL;
        DELETE FROM dbo.D_PROCESO;
        DELETE FROM dbo.D_TIEMPO;
        DBCC CHECKIDENT ('dbo.H_ASISTENCIA', RESEED, 0) WITH NO_INFOMSGS;
        DBCC CHECKIDENT ('dbo.D_TIEMPO', RESEED, 0) WITH NO_INFOMSGS;

        -- 2. Dimensiones
        INSERT INTO dbo.D_PROCESO (id_proceso, nombre_proceso, tipo_proceso, fecha_proceso)
        SELECT id_proceso, nombre, tipo, fecha
        FROM dbo.PROCESO_ELECTORAL;

        INSERT INTO dbo.D_MIEMBRO (id_miembro, dni, nombre_completo, sexo, distrito, provincia, estado_miembro)
        SELECT mm.id_miembro,
               c.dni,
               LTRIM(RTRIM(c.primer_nombre + ' ' + ISNULL(c.segundo_nombre + ' ', '')
                           + c.apellido_paterno + ' ' + c.apellido_materno)),
               c.sexo,
               u.distrito,
               u.provincia,
               mm.estado
        FROM dbo.MIEMBRO_MESA mm
        INNER JOIN dbo.CIUDADANO c ON mm.id_ciudadano = c.id_ciudadano
        INNER JOIN dbo.UBIGEO u ON c.id_ubigeo = u.id_ubigeo;

        INSERT INTO dbo.D_CAPACITACION (id_capacitacion, tipo, estado, descripcion, hora_inicio, hora_fin)
        SELECT cp.id_capacitacion, cp.tipo, cp.estado, j.descripcion, j.hora_inicio, j.hora_fin
        FROM dbo.CAPACITACION cp
        INNER JOIN dbo.JORNADA j ON cp.id_jornada = j.id_jornada;

        INSERT INTO dbo.D_LOCAL (id_local, nombre_local, direccion, referencia, distrito, provincia, aula, aforo)
        SELECT lc.id_local, lc.nombre, lc.direccion, lc.referencia, u.distrito, u.provincia, a.numero, a.aforo
        FROM dbo.LOCAL_CAPACITACION lc
        INNER JOIN dbo.UBIGEO u ON lc.id_ubigeo = u.id_ubigeo
        LEFT JOIN dbo.AULA a
               ON a.id_aula = (SELECT MIN(a2.id_aula) FROM dbo.AULA a2 WHERE a2.id_local = lc.id_local);

        INSERT INTO dbo.D_TIEMPO (fecha, dia, mes, nombre_mes, trimestre, año)
        SELECT f,
               DAY(f),
               MONTH(f),
               CHOOSE(MONTH(f), 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio',
                      'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'),
               DATEPART(QUARTER, f),
               YEAR(f)
        FROM (SELECT DISTINCT fecha AS f FROM dbo.JORNADA) AS fechas;

        -- 3. Tabla de hechos
        INSERT INTO dbo.H_ASISTENCIA (id_miembro, id_capacitacion, id_proceso, id_local, id_tiempo,
                                      estado_asistencia, cantidad)
        SELECT asi.id_miembro,
               asi.id_capacitacion,
               j.id_proceso,
               au.id_local,
               t.id_tiempo,
               asi.estado,
               1
        FROM dbo.ASISTENCIA asi
        INNER JOIN dbo.CAPACITACION cp ON asi.id_capacitacion = cp.id_capacitacion
        INNER JOIN dbo.JORNADA j ON cp.id_jornada = j.id_jornada
        INNER JOIN dbo.AULA au ON cp.id_aula = au.id_aula
        INNER JOIN dbo.D_TIEMPO t ON t.fecha = j.fecha;

        -- 4. Reconciliación: cada asistencia de origen debe estar en los hechos
        SELECT @origen = COUNT(*) FROM dbo.ASISTENCIA;
        SELECT @destino = COUNT(*) FROM dbo.H_ASISTENCIA;
        IF @origen <> @destino
            THROW 50001, 'Reconciliación fallida: los registros de ASISTENCIA y H_ASISTENCIA no coinciden.', 1;

        COMMIT TRANSACTION;

        UPDATE dbo.LOG_CARGA_ETL
        SET fecha_fin = SYSDATETIME(), estado = 'EXITOSO',
            filas_origen_asistencia = @origen, filas_h_asistencia = @destino,
            mensaje = 'Carga completa del modelo en estrella.'
        WHERE id_log = @id_log;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        UPDATE dbo.LOG_CARGA_ETL
        SET fecha_fin = SYSDATETIME(), estado = 'ERROR',
            filas_origen_asistencia = @origen, filas_h_asistencia = @destino,
            mensaje = LEFT(ERROR_MESSAGE(), 500)
        WHERE id_log = @id_log;

        THROW;
    END CATCH
END
GO

-- =====================================================================
-- Ejecución y verificación (tomar captura de estos resultados: evidencia)
-- =====================================================================
EXEC dbo.SP_CARGAR_MODELO_ESTRELLA;
GO

SELECT 'D_PROCESO' AS tabla, COUNT(*) AS filas FROM dbo.D_PROCESO
UNION ALL SELECT 'D_MIEMBRO', COUNT(*) FROM dbo.D_MIEMBRO
UNION ALL SELECT 'D_CAPACITACION', COUNT(*) FROM dbo.D_CAPACITACION
UNION ALL SELECT 'D_LOCAL', COUNT(*) FROM dbo.D_LOCAL
UNION ALL SELECT 'D_TIEMPO', COUNT(*) FROM dbo.D_TIEMPO
UNION ALL SELECT 'H_ASISTENCIA', COUNT(*) FROM dbo.H_ASISTENCIA;

SELECT TOP 5 * FROM dbo.LOG_CARGA_ETL ORDER BY id_log DESC;
GO
