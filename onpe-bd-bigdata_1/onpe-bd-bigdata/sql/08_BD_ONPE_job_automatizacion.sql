/* =====================================================================
   BD_ONPE - Programación automática de la carga del modelo en estrella
   Crea un job de SQL Server Agent que ejecuta SP_CARGAR_MODELO_ESTRELLA
   todos los días a las 02:00.
   Requiere haber ejecutado 07_BD_ONPE_ETL_carga_estrella.sql.

   Nota: SQL Server Agent no está disponible en la edición Express. En ese
   caso se puede programar el mismo procedimiento con el Programador de
   tareas de Windows usando sqlcmd:
     sqlcmd -S <servidor> -d BD_ONPE -E -Q "EXEC dbo.SP_CARGAR_MODELO_ESTRELLA"
   ===================================================================== */

USE msdb;
GO

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'ONPE_Carga_Modelo_Estrella')
    EXEC msdb.dbo.sp_delete_job @job_name = N'ONPE_Carga_Modelo_Estrella';
GO

EXEC msdb.dbo.sp_add_job
    @job_name = N'ONPE_Carga_Modelo_Estrella',
    @enabled = 1,
    @description = N'Carga diaria del modelo dimensional (dimensiones y H_ASISTENCIA) de BD_ONPE.';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'ONPE_Carga_Modelo_Estrella',
    @step_name = N'Ejecutar SP_CARGAR_MODELO_ESTRELLA',
    @subsystem = N'TSQL',
    @database_name = N'BD_ONPE',
    @command = N'EXEC dbo.SP_CARGAR_MODELO_ESTRELLA;',
    @on_success_action = 1,   -- terminar con éxito
    @on_fail_action = 2;      -- terminar con error

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'Diario_0200',
    @freq_type = 4,            -- diario
    @freq_interval = 1,        -- cada 1 día
    @active_start_time = 020000;

EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'ONPE_Carga_Modelo_Estrella',
    @schedule_name = N'Diario_0200';

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'ONPE_Carga_Modelo_Estrella';
GO

-- Verificación: ejecutar el job a demanda y revisar la bitácora
-- EXEC msdb.dbo.sp_start_job @job_name = N'ONPE_Carga_Modelo_Estrella';
-- SELECT TOP 5 * FROM BD_ONPE.dbo.LOG_CARGA_ETL ORDER BY id_log DESC;
-- EXEC msdb.dbo.sp_help_jobhistory @job_name = N'ONPE_Carga_Modelo_Estrella';
GO
