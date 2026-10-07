/* =====================================================================
   BD_ONPE - Claves foráneas de la tabla de hechos H_ASISTENCIA
   hacia sus 5 dimensiones (esquema en estrella).
   Fuente: scripts DDL del informe (Figuras 3 y 4, evidencia E-06).
   Requiere haber ejecutado 02_BD_ONPE_modelo_dimensional_estrella.sql.
   ===================================================================== */

USE BD_ONPE;
GO

ALTER TABLE H_ASISTENCIA
ADD CONSTRAINT FK_H_ASISTENCIA_MIEMBRO
FOREIGN KEY (id_miembro)
REFERENCES D_MIEMBRO(id_miembro);
GO

ALTER TABLE H_ASISTENCIA
ADD CONSTRAINT FK_H_ASISTENCIA_CAPACITACION
FOREIGN KEY (id_capacitacion)
REFERENCES D_CAPACITACION(id_capacitacion);
GO

ALTER TABLE H_ASISTENCIA
ADD CONSTRAINT FK_H_ASISTENCIA_PROCESO
FOREIGN KEY (id_proceso)
REFERENCES D_PROCESO(id_proceso);
GO

ALTER TABLE H_ASISTENCIA
ADD CONSTRAINT FK_H_ASISTENCIA_LOCAL
FOREIGN KEY (id_local)
REFERENCES D_LOCAL(id_local);
GO

ALTER TABLE H_ASISTENCIA
ADD CONSTRAINT FK_H_ASISTENCIA_TIEMPO
FOREIGN KEY (id_tiempo)
REFERENCES D_TIEMPO(id_tiempo);
GO
