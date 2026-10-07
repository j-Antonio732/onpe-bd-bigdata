/* =====================================================================
   BD_ONPE - Datos iniciales (INSERT) - SQL Server
   Carga de ejemplo: 20 ubigeos, 20 ciudadanos, 10 miembros de mesa,
   10 capacitadores, 5 procesos, 5 jornadas, 20 locales, 20 aulas,
   10 capacitaciones, 10 asistencias, 20 materiales y 10 distribuciones.
   Requiere haber ejecutado 01_BD_ONPE_modelo_relacional_3FN.sql.
   Fuente: script del equipo (BD_ONPE_VISTAS.sql, evidencia E-01 / E-06).
   ===================================================================== */

USE BD_ONPE;
GO

-- =====================================================
-- TABLA UBIGEO
-- =====================================================

INSERT INTO UBIGEO (distrito, provincia)
VALUES
('Miraflores','Lima'),
('San Isidro','Lima'),
('Surco','Lima'),
('La Molina','Lima'),
('Los Olivos','Lima'),
('Comas','Lima'),
('Ate','Lima'),
('San Miguel','Lima'),
('Lince','Lima'),
('Barranco','Lima'),
('Pueblo Libre','Lima'),
('Jesus Maria','Lima'),
('Magdalena','Lima'),
('Callao','Callao'),
('Bellavista','Callao'),
('Ventanilla','Callao'),
('Trujillo','Trujillo'),
('Piura','Piura'),
('Cusco','Cusco'),
('Arequipa','Arequipa');

-- =====================================================
-- TABLA CIUDADANO
-- =====================================================

INSERT INTO CIUDADANO
(dni,primer_nombre,segundo_nombre,apellido_paterno,
apellido_materno,fecha_nacimiento,sexo,estado_civil,id_ubigeo)
VALUES
('70000001','Carlos','Alberto','Ramirez','Soto','1990-01-15','M','Soltero',1),
('70000002','Maria','Fernanda','Lopez','Quispe','1992-03-20','F','Casada',2),
('70000003','Jose','Luis','Torres','Diaz','1988-07-11','M','Soltero',3),
('70000004','Ana','Lucia','Fernandez','Rojas','1995-02-10','F','Soltera',4),
('70000005','Luis','Miguel','Vargas','Castillo','1991-09-18','M','Casado',5),
('70000006','Patricia','Elena','Morales','Salas','1993-06-22','F','Soltera',6),
('70000007','Jorge','Antonio','Paredes','Mendoza','1987-05-14','M','Casado',7),
('70000008','Rosa','Milagros','Cruz','Huaman','1994-12-01','F','Soltera',8),
('70000009','Miguel','Angel','Reyes','Flores','1989-08-30','M','Divorciado',9),
('70000010','Lucia','Beatriz','Gutierrez','Navarro','1996-10-25','F','Soltera',10),
('70000011','Pedro','Enrique','Chavez','Ruiz','1990-04-13','M','Casado',11),
('70000012','Sandra','Patricia','Ortega','Silva','1992-11-17','F','Soltera',12),
('70000013','Ricardo','Ivan','Mendoza','Rios','1985-03-08','M','Casado',13),
('70000014','Claudia','Rocio','Herrera','Campos','1997-01-09','F','Soltera',14),
('70000015','Fernando','Jose','Valdez','Perez','1991-07-29','M','Soltero',15),
('70000016','Daniela','Lucero','Acosta','Vega','1993-02-18','F','Casada',16),
('70000017','Andres','Felipe','Ramos','Cordero','1986-09-15','M','Divorciado',17),
('70000018','Veronica','Isabel','Sanchez','Mejia','1994-05-12','F','Soltera',18),
('70000019','Martin','Eduardo','Navarro','Benites','1990-06-27','M','Casado',19),
('70000020','Paola','Andrea','Garcia','Rivas','1995-08-06','F','Soltera',20);

-- =====================================================
-- TABLA MIEMBRO_MESA
-- =====================================================

INSERT INTO MIEMBRO_MESA (id_ciudadano, estado)
VALUES
(1,'ACTIVO'),
(2,'PENDIENTE'),
(3,'ACTIVO'),
(4,'INACTIVO'),
(5,'ACTIVO'),
(6,'PENDIENTE'),
(7,'ACTIVO'),
(8,'INACTIVO'),
(9,'ACTIVO'),
(10,'PENDIENTE');

-- =====================================================
-- TABLA CAPACITADOR
-- =====================================================

INSERT INTO CAPACITADOR (id_ciudadano)
VALUES
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20);

-- =====================================================
-- TABLA PROCESO_ELECTORAL
-- =====================================================

INSERT INTO PROCESO_ELECTORAL (nombre,tipo,fecha)
VALUES
('Elecciones Regionales 2026','Regional','2026-01-15'),
('Elecciones Municipales 2026','Municipal','2026-02-10'),
('Elecciones Generales 2026','General','2026-03-20'),
('Consulta Popular 2026','Consulta','2026-04-05'),
('Elecciones Complementarias','Municipal','2026-05-18');

-- =====================================================
-- TABLA JORNADA
-- =====================================================

INSERT INTO JORNADA
(id_proceso,fecha,hora_inicio,hora_fin,descripcion)
VALUES
(1,'2026-01-10','08:00','12:00','Capacitacion Regional Lima'),
(2,'2026-02-05','09:00','13:00','Capacitacion Municipal Norte'),
(3,'2026-03-15','08:30','12:30','Capacitacion General Centro'),
(4,'2026-04-01','10:00','14:00','Consulta Popular Sur'),
(5,'2026-05-10','08:00','11:00','Capacitacion Complementaria');

-- =====================================================
-- TABLA LOCAL_CAPACITACION
-- =====================================================

INSERT INTO LOCAL_CAPACITACION
(nombre,direccion,referencia,id_ubigeo)
VALUES
('Colegio San Martin','Av. Arequipa 120','Frente al parque',1),
('IEP Santa Rosa','Av. Colonial 455','Costado del mercado',2),
('Universidad Nacional','Av. Universitaria 890','Puerta principal',3),
('Municipalidad Surco','Jr. Lima 450','Frente a plaza',4),
('Colegio Los Angeles','Av. Peru 700','Cerca al hospital',5),
('Colegio Mariano Melgar','Av. Central 300','Al costado de la iglesia',6),
('IEP Santa Maria','Av. Norte 550','Frente al estadio',7),
('Instituto Tecnologico Lima','Av. Industrial 100','Zona comercial',8),
('Colegio Cristo Rey','Av. Sur 280','Frente a la comisaria',9),
('Colegio San Pedro','Jr. Libertad 600','Cerca al mercado',10),
('Colegio Nuestra Señora','Av. Grau 750','Frente al banco',11),
('Colegio Peruano','Av. Los Heroes 480','A media cuadra del parque',12),
('Instituto Nacional','Av. Tacna 310','Frente a la plaza',13),
('Colegio Callao','Av. La Marina 800','Cerca al puerto',14),
('IEP Bellavista','Av. Faucett 210','Costado de la municipalidad',15),
('Colegio Ventanilla','Av. Gambetta 430','Zona norte',16),
('Colegio Trujillo','Av. España 950','Centro civico',17),
('Colegio Piura','Av. Sanchez Cerro 510','Frente al mall',18),
('Colegio Cusco','Av. Sol 650','Centro historico',19),
('Colegio Arequipa','Av. Ejercito 770','Cerca a la plaza',20);

-- =====================================================
-- TABLA AULA
-- =====================================================

INSERT INTO AULA (id_local,numero,aforo)
VALUES
(1,'A101',35),
(2,'A102',40),
(3,'B201',30),
(4,'B202',45),
(5,'C301',50),
(6,'C302',35),
(7,'D401',40),
(8,'D402',55),
(9,'E501',60),
(10,'E502',30),
(11,'F601',45),
(12,'F602',50),
(13,'G701',40),
(14,'G702',35),
(15,'H801',60),
(16,'H802',30),
(17,'I901',45),
(18,'I902',50),
(19,'J1001',40),
(20,'J1002',35);

-- =====================================================
-- TABLA CAPACITACION
-- =====================================================

INSERT INTO CAPACITACION
(id_jornada,id_aula,id_capacitador,tipo,estado)
VALUES
(1,1,1,'Presencial','Programado'),
(1,2,2,'Virtual','En Curso'),
(2,3,3,'Presencial','Finalizado'),
(2,4,4,'Virtual','Programado'),
(3,5,5,'Presencial','En Curso'),
(3,6,6,'Virtual','Finalizado'),
(4,7,7,'Presencial','Programado'),
(4,8,8,'Virtual','En Curso'),
(5,9,9,'Presencial','Finalizado'),
(5,10,10,'Virtual','Programado');

-- =====================================================
-- TABLA ASISTENCIA
-- =====================================================

INSERT INTO ASISTENCIA
(id_miembro,id_capacitacion,estado)
VALUES
(1,1,'Asistio'),
(2,2,'Tardanza'),
(3,3,'Falto'),
(4,4,'Asistio'),
(5,5,'Asistio'),
(6,6,'Tardanza'),
(7,7,'Falto'),
(8,8,'Asistio'),
(9,9,'Tardanza'),
(10,10,'Asistio');

-- =====================================================
-- TABLA MATERIAL_CAPACITACION
-- =====================================================

INSERT INTO MATERIAL_CAPACITACION
(nombre,stock)
VALUES
('Manual Electoral',300),
('Guia ONPE',250),
('Lapiceros Azules',500),
('Credenciales',150),
('Folletos Informativos',400),
('Cartillas Electorales',320),
('Afiches Educativos',280),
('Formatos de Registro',200),
('Separatas',350),
('Cuadernos de Trabajo',290),
('Papel Bond',600),
('Folders',180),
('USB Informativos',90),
('Stickers ONPE',220),
('Sobres Oficiales',310),
('Tinta Impresora',75),
('Archivadores',140),
('Lapices',420),
('Marcadores',160),
('Banners Informativos',50);

-- =====================================================
-- TABLA DISTRIBUCION_MATERIAL
-- =====================================================

INSERT INTO DISTRIBUCION_MATERIAL
(id_material,id_capacitacion,cantidad,fecha_entrega)
VALUES
(1,1,30,'2026-01-10'),
(2,2,25,'2026-01-11'),
(3,3,50,'2026-01-12'),
(4,4,20,'2026-01-13'),
(5,5,40,'2026-01-14'),
(6,6,35,'2026-01-15'),
(7,7,28,'2026-01-16'),
(8,8,18,'2026-01-17'),
(9,9,45,'2026-01-18'),
(10,10,32,'2026-01-19');
