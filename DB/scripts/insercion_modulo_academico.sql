/* Inserción de datos */
-- no olvidar: secure-file-priv = "C:\Users\HUERTAS\Documents\College\Bases de datos\avance3"
SET GLOBAL local_infile=1;
use academico;
/* Sedes UNAL */
insert into sede (sed_nombre,sed_id) values
('Amazonía',1125),
('Bogotá',1101),
('Caribe',1126),
('La Paz',9933),
('Manizales',1103),
('Medellín',1102),
('Orinoquía',1124),
('Palmira',1104),
('Tumaco',9920);

/* Facultades UNAL */
LOAD DATA LOCAL INFILE 'C:/Users/HUERTAS/Documents/College/Bases de datos/avance3/Facultades.tsv'
INTO TABLE facultad
CHARACTER SET utf8mb4
FIELDS TERMINATED BY '\t' -- Si es un archivo CSV (valores separados por comas)
LINES TERMINATED BY '\n' -- Puede variar según el formato del archivo
IGNORE 1 ROWS;

/* Departamentos UNAL */
LOAD DATA LOCAL INFILE 'C:/Users/HUERTAS/Documents/College/Bases de datos/avance3/departamentos.csv'
INTO TABLE departamento
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' -- Si es un archivo CSV (valores separados por comas)
LINES TERMINATED BY '\n' -- Puede variar según el formato del archivo
IGNORE 1 ROWS;

/* Programas UNAL */
LOAD DATA LOCAL INFILE 'C:/Users/HUERTAS/Documents/College/Bases de datos/avance3/Programas_creditos.csv'
INTO TABLE programa
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' -- Si es un archivo CSV (valores separados por comas)
LINES TERMINATED BY '\n' -- Puede variar según el formato del archivo
IGNORE 1 ROWS
SET dep_id = NULLIF(dep_id,'NULL');	

/* Asignaturas UNAL */
LOAD DATA LOCAL INFILE 'C:/Users/HUERTAS/Documents/College/Bases de datos/avance3/Asignaturas.csv'
INTO TABLE asignatura
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' -- Si es un archivo CSV (valores separados por comas)
LINES TERMINATED BY '\n' -- Puede variar según el formato del archivo
IGNORE 1 ROWS;

/* Mallas UNAL */
LOAD DATA LOCAL INFILE 'C:/Users/HUERTAS/Documents/College/Bases de datos/avance3/Mallas.csv'
INTO TABLE malla
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' -- Si es un archivo CSV (valores separados por comas)
LINES TERMINATED BY '\n' -- Puede variar según el formato del archivo
IGNORE 1 ROWS;
update malla SET malla_obligatorio = IF(malla_obligatorio = '0',NULL,malla_obligatorio) where malla_componente in ('NIVELACION','TESIS','TESIS-TRAB.FINAL','ACTIVIDADES ACADÉMIC','LIBRE ELECCIÓN','ELECTIVA DE PREGRADO','TRABAJO DE GRADO');

-- Después de haber insertado asignaturas del excel

-- Insertar personas
INSERT INTO persona (per_documento_identidad, per_nombre, per_apellidos, per_sexo_biologico, per_correo_personal, per_telefono_cel, per_telefono, per_fecha_nacimiento, per_nacionalidad)
VALUES
(1585639711, 'Florentino', 'Lobo Lloret', 'Masculino', 'flobol@gmail.com', 3538386264, 8313100, '1966-04-26', 'Colombiano'),
(1274589181, 'Ester', 'Piñol Giner', 'Femenino', 'epinolg@gmail.com', 3458863530, 5796468, '1968-01-18', 'Colombiano'),
(1036948741, 'Horacio', 'Bermejo Bernad', 'Masculino', 'hbermejob@gmail.com', 3415270138, 6453958, '1981-01-16', 'Colombiano'),
(1483100791, 'Alcides', 'Macias Puig', 'Masculino', 'amaciasp@gmail.com', 3765399624, 1934633, '1975-12-28', 'Colombiano'),
(1229529841, 'Victoria', 'Garmendia Duque', 'Femenino', 'vgarmendiad@gmail.com', 3280342902, 8593134, '1990-04-29', 'Colombiano'),
(1166452691, 'Gilberto', 'Gimeno Garcés', 'Masculino', 'ggimenog@gmail.com', 3820913962, 8537263, '1988-06-24', 'Colombiano'),
(1312490201, 'Marcia', 'Meléndez Cañellas', 'Femenino', 'mmelendezc@gmail.com', 3256339705, 1113591, '1969-08-16', 'Colombiano'),
(1152629821, 'Camila', 'Urrutia Barrera', 'Femenino', 'currutiab@gmail.com', 3817872547, 4948036, '2006-11-02', 'Colombiano'),
(1293226521, 'Filomena', 'Suarez Cornejo', 'Femenino', 'fsuarezc@gmail.com', 3859248371, 8228759, '1998-06-16', 'Colombiano'),
(1409728951, 'Susana', 'Escobar Arroyo', 'Femenino', 'sescobara@gmail.com', 3413453517, 3383645, '1996-04-14', 'Colombiano'),
(1711327451, 'Heriberto', 'Serna Abascal', 'Masculino', 'hsernaa@gmail.com', 3712403933, 1661963, '2003-11-27', 'Colombiano'),
(1979128351, 'Teresita', 'Benitez Pereira', 'Femenino', 'tbenitezp@gmail.com', 3189080482, 7941657, '1998-05-05', 'Colombiano'),
(1132725791, 'Azeneth', 'Martín Toledo', 'Femenino', 'amartint@gmail.com', 3674095056, 5236012, '1990-06-05', 'Alemán'),
(1075980751, 'Jordán', 'Alonso Salmerón', 'Masculino', 'jalonsos@gmail.com', 3746841411, 2261038, '1991-07-09', 'Colombiano'),
(1475577711, 'Noé', 'Aguilera Gisbert', 'Masculino', 'naguilerag@gmail.com', 3551560804, 2463573, '1992-11-24', 'Colombiano'),
(1497912021, 'Pepito', 'Díez Fuster', 'Masculino', 'pdiezf@gmail.com', 3596496754, 7271560, '1989-09-02', 'Colombiano'),
(1525659481, 'Chucho', 'Trujillo Jordán', 'Masculino', 'ctrujilloj@gmail.com', 3219775875, 8864974, '1980-09-01', 'Colombiano'),
(1862667381, 'Pía', 'Palomares Company', 'Femenino', 'ppalomaresc@gmail.com', 3507537013, 8130875, '1970-03-02', 'Colombiano'),
(1551090981, 'Reyes', 'Paz Sarmiento', 'Masculino', 'rpazs@gmail.com', 3388214098, 7169192, '1993-01-31', 'Colombiano'),
(1073829021, 'Nicanor', 'Montserrat Gallo', 'Masculino', 'nmontserratg@gmail.com', 3403064883, 3650439, '1969-08-25', 'Colombiano'),
(1654153341, 'Ainara', 'Marí Grande', 'Femenino', 'amarig@gmail.com', 3487476828, 9074926, '1988-06-10', 'Colombiano'),
(1411641411, 'Tomás', 'Montes Marin', 'Masculino', 'tmontesm@gmail.com', 3294472886, 8958859, '1975-08-14', 'Colombiano'),
(1364518241, 'Lino', 'Manzano Bellido', 'Masculino', 'lmanzanob@gmail.com', 3646238810, 6973664, '1982-08-15', 'Colombiano'),
(1478483361, 'Marianela', 'Fiol González', 'Femenino', 'mfiolg@gmail.com', 3218479376, 8023092, '1983-11-26', 'Colombiano'),
(1866709691, 'Jose Luis', 'Calleja Puig', 'Masculino', 'jlcallejap@gmail.com', 3853083972, 7627289, '1968-09-06', 'Mexicano'),
(1585773951, 'Aarón', 'Aranda Balaguer', 'Masculino', 'aarandab@gmail.com', 3463036928, 9741120, '1978-01-30', 'Colombiano'),
(1615619781, 'Lázaro', 'Arregui Esteve', 'Masculino', 'larreguie@gmail.com', 3214045462, 2753828, '1985-08-17', 'Colombiano'),
(1000342596, 'Jorge', 'Muñiz Nguema', 'Masculino', 'jmunizn@gmail.com', 3058877295, 5467854, '2000-01-15', 'Colombiano'), -- estudiante posgrado
(1001369006, 'Antonio', 'Nieto Ortiz', 'Masculino', 'anietoo@gmail.com', 3165998672, 9899231, '1970-04-02', 'Ecuatoriano'), -- profesor posgrado
(1000990767, 'Arnaud', 'Sartre', 'Masculino', 'asartre@gmail.com', 3159230012, 9131670, '1980-05-06', 'Francés'), -- profesor electivas 2024279 y 2021140
(1003989343, 'Héctor Hugo', 'Jiménez Carvajal', 'Masculino', 'hhjimenezc@gmail.com', 3054499823, 6134778, '1984-01-01', 'Panameño'); -- profesor electiva 2028643

-- Insertar residencias
INSERT INTO residencia (res_ciudad, res_calle, res_numero, res_codigo_postal, res_estrato)
VALUES
('Medellín', 'Avenida 33', '65', 110121, 2),
('Soacha', 'Calle 13', '264', 111171, 4),
('Chía', 'Carrera 10', '1b-21', 111156, 2),
('Soacha', 'Carrera 8', '24-60', 110931, 4),
('Bogotá', 'Calle 183', '187 sur', 111111, 3),
('Bogotá', 'Avenida Alsacia', '234', 110571, 3),
('Bogotá', 'Calle 53', '167 sur', 110511, 1),
('Bogotá', 'Avenida Jiménez', '237 - 31', 110621, 5),
('Bogotá', 'Avenida Pepe Sierra', '178 sur - 10', 110211, 2),
('Bogotá', 'Calle 53', '74 - 45', 111321, 5),
('Bogotá', 'Avenida Suba', '110 sur - 20', 111041, 6),
('Bogotá', 'Avenida Carrera 68', '133 - 17', 110111, 1),
('Bogotá', 'Avenida Eldorado', '231 - 33', 111176, 2),
('Bogotá', 'Avenida Alsacia', '138 sur - 93', 111921, 1),
('Bogotá', 'Avenida Longitudinal de Occidente', '155 sur - 108', 111011, 1),
('Bogotá', 'Carrera Séptima', '31 - 22', 110441, 1),
('Bogotá', 'Calle 80', '6 sur - 30', 110141, 6),
('Bogotá', 'Avenida Eldorado', '175 sur - 14', 110221, 6),
('Bogotá', 'Avenida Quiroga', '91 sur - 32', 110551, 5),
('Bogotá', 'Calle 170', '93 - 25', 110821, 1),
('Bogotá', 'Avenida Ferrocarril de Occidente', '163 sur - 40', 111631, 4),
('Bogotá', 'Avenida Las Torres', '7 - 5', 111161, 4),
('Bogotá', 'Calle 183', '43 sur - 18', 110741, 1),
('Bogotá', 'Carrera 15', '138 sur - 67', 111321, 4),
('Bogotá', 'Avenida Alsacia', '151 sur - 8', 110621, 2),
('Bogotá', 'Autopista Norte', '134 - 40', 110120, 4);

-- Insertar vinculados
INSERT INTO vinculado (vin_codigo, vin_usuario, vin_contrasena, vin_correo_institucional, per_documento_identidad)
VALUES
(5748194673, 'currutiab', 'JFDhtr78', 'currutiab@unal.edu.co', 1152629821),
(2093571865, 'fsuarezc', 'SWEqaz09', 'fsuarezc@unal.edu.co', 1293226521),
(9247685031, 'sescobara', 'XDRvbn54', 'sescobara@unal.edu.co', 1409728951),
(6845239170, 'hsernaa', 'HGYjkl32', 'hsernaa@unal.edu.co', 1711327451),
(1567394820, 'tbenitezp', 'KLOpoi98', 'tbenitezp@unal.edu.co', 1979128351),
(8902751463, 'amartint', 'FGHmnb16', 'amartint@unal.edu.co', 1132725791),
(4367912850, 'jalonsos', 'DSWqwe43', 'jalonsos@unal.edu.co', 1075980751),
(7236908451, 'naguilerag', 'RTYjkl20', 'naguilerag@unal.edu.co', 1475577711),
(3579120468, 'pdiezf', 'CVBghj78', 'pdiezf@unal.edu.co', 1497912021),
(6127849305, 'ctrujilloj', 'PLKsdf56', 'ctrujilloj@unal.edu.co', 1525659481),
(9370548216, 'ppalomaresc', 'ZXCvbn34', 'ppalomaresc@unal.edu.co', 1862667381),
(4012985673, 'rpazs', 'QWErty12', 'rpazs@unal.edu.co', 1551090981),
(8651372940, 'nmontserratg', 'UIOjkl76', 'nmontserratg@unal.edu.co', 1073829021),
(5297461830, 'amarig', 'BNMmnb98', 'amarig@unal.edu.co', 1654153341),
(2934870516, 'tmontesm', 'LKJpoi65', 'tmontesm@unal.edu.co', 1411641411),
(7685412093, 'lmanzanob', 'YUIqwe43', 'lmanzanob@unal.edu.co', 1364518241),
(1456203798, 'mfiolg', 'WERvbn87', 'mfiolg@unal.edu.co', 1478483361),
(9056123847, 'jlcallejap', 'ASDghj21', 'jlcallejap@unal.edu.co', 1866709691),
(3487906215, 'aarandab', 'FGHsdf09', 'aarandab@unal.edu.co', 1585773951),
(6874132950, 'larreguie', 'QAZrty76', 'larreguie@unal.edu.co', 1615619781),
(3855655832, 'jmunizn', 'QOWlsw21', 'jmunizn@unal.edu.co', 1000342596), -- estudiante posgrado
(1222453212, 'anietoo', 'POSwlk84', 'anietoo@unal.edu.co', 1001369006), -- profesor posgrado
(1534636797, 'asartre', 'AKSmrl21', 'asartre@unal.edu.co', 1000990767), -- profesor electivas 2024279 y 2021140
(9234012312, 'hhjimenezc', 'LLOqwq93', 'hhjimenezc@unal.edu.co', 1003989343); -- profesor electiva 2028643
-- Insertar estudiantes
INSERT INTO estudiante (est_etnia, est_situacion_militar, per_documento_identidad, res_id, est_admision_esp)
VALUES
(null, 0, 1152629821, 8, 1),
('Afrodescendiente', 0, 1293226521, 10, 0),
('Afrodescendiente', 0, 1409728951, 10, 0),
(null, 0, 1711327451, 11, 1),
(null, 0, 1979128351, 12, 0),
('Afrodescendiente', 1, 1000342596, 26, 0);

-- Insertar profesores
INSERT INTO profesor (per_documento_identidad, pro_num_oficina, pro_grupo_investigacion)
VALUES
(1132725791, 101, 'MIDAS'),
(1075980751, 102, null),
(1475577711, 103, null),
(1497912021, 104, 'CIM@LAB'),
(1525659481, 201, 'MIDAS'),
(1862667381, 202, 'MIDAS'),
(1551090981, 203, 'GISTIC'),
(1073829021, 204, 'ALIFE'),
(1654153341, 301, 'COMPLEXUS'),
(1411641411, 302, 'COMPLEXUS'),
(1364518241, 303, 'CIM@LAB'),
(1478483361, 304, 'CIM@LAB'),
(1615619781, 403, 'COMPLEXUS'),
(1001369006, 102, null),
(1000990767, 501, null), -- profesor electivas 2024279 y 2021140
(1003989343, 502, null), -- profesor electiva 2028643
(1866709691, 200, null),
(1585773951, 100, null);

-- Insertar historias académicas
INSERT INTO historia_academica (his_codigo, his_ano, his_semestre, his_PAPA, his_PAPPI, his_creditos_cancelados, his_avance, per_documento_identidad, his_programa_principal, his_evaluacion_docente, his_matricula_cursante, his_estudiante_activo, his_pago_matricula, pro_id, his_traslado)
VALUES
(9120, 2022, 1, 0, 0, 2, 0, 1152629821, 1, 1, 1, 1, 1, '2879', 0),
(9120, 2022, 2, 0, 0, 0, 19.2, 1152629821, 1, 1, 2, 1, 1, '2879', 0),
(9120, 2023, 1, 0, 0, 6, 41.0, 1152629821, 1, 1, 3, 1, 1, '2879', 0),
(9121, 2023, 1, null, null, 1, 0, 1152629821, 0, 1, 1, 1, 0, '2546', 0),
(6547, 2022, 1, 0, 0, 1, 0, 1293226521, 1, 0, 1, 1, 0, '2879', 0),
(6547, 2022, 2, 0, 0, 6, 15.0, 1293226521, 1, 1, 2, 1, 0, '2879', 0),
(6547, 2023, 1, 0, 0, 1, 23.3, 1293226521, 1, 0, 3, 1, 0, '2879', 0),
(9104, 2022, 1, 0, 0, 2, 0, 1409728951, 1, 0, 1, 1, 1, '2879', 0),
(3862, 2022, 2, 0, 0, 0, 0, 1711327451, 1, 1, 1, 1, 0, '2879', 0),
(1739, 2023, 1, 0, 0, 0, 0, 1979128351, 1, 0, 1, 1, 1, '2879', 0),
(8111, 2023, 1, 0, 0, 0, 0, 1000342596, 1, 1, 1, 1, 1, '2580', 0);

-- Insertar grupos
INSERT INTO grupo (gru_numero, gru_cupos, asi_codigo) VALUES
(1, 50, '1000004-B'),
(2, 45, '1000004-B'),
(1, 35, '2025975'),
(2, 40, '2025975'),
(1, 30, '2015734'),
(2, 25, '2015734'),
(1, 50, '2016703'),
(2, 50, '2016703'),
(1, 50, '1000019-B'),
(2, 45, '1000019-B'),
(1, 35, '1000005-B'),
(2, 40, '1000005-B'),
(1, 30, '1000003-B'),
(2, 25, '1000003-B'),
(1, 50, '2016375'),
(2, 50, '2016375'),
(1, 50, '1000013-B'),
(2, 45, '1000013-B'),
(1, 35, '1000006-B'),
(2, 40, '1000006-B'),
(1, 30, '2025963'),
(2, 25, '2025963'),
(1, 50, '2016353'),
(2, 45, '2016353'),
(1, 35, '2016698'),
(2, 40, '2016698'),
(1, 30, '1000017-B'),
(2, 25, '1000017-B'),
(1, 50, '2015703'),
(2, 50, '2015703'),
(1, 50, '2016699'),
(2, 45, '2016699'),
(1, 35, '2016697'),
(2, 40, '2016697'),
(1, 30, '2015811'),
(2, 25, '2015811'),
(1, 50, '2026805'),
(2, 45, '2026805'),
(1, 30, '2015162'),
(2, 25, '2015162'),
(1, 50, '2015555'),
(2, 45, '2015555'),
(1, 15, '2020905'),
(1, 60, 2024279), -- electiva
(1, 60, 2021140), -- electiva
(2, 60, 2021140), -- electiva
(1, 55, 2028643), -- electiva
(2, 50, 2028643); -- electiva

-- Insertar prerrequisitos para los semestres 1, 2, 3 y 4 de ingeniería de sistemas y computación
INSERT INTO prerrequisito (asi_codigo_pre, pro_id, asi_codigo) VALUES
('1000004-B', '2879', '1000005-B'),
('1000004-B', '2879', '1000019-B'),
('1000004-B', '2879', '1000003-B'),
('1000004-B', '2879', '1000007-B'),
('2025975', '2879', '2016698'),
('2015734', '2879', '2016375'),
('1000019-B', '2879', '1000017-B'),
('1000005-B', '2879', '1000006-B'),
('1000005-B', '2879', '2015162'),
('1000005-B', '2879', '1000013-B'),
('1000005-B', '2879', '2015703'),
('1000005-B', '2879', '1000017-B'),
('1000003-B', '2879', '2025963'),
('2016375', '2879', '2016699'),
('2016375', '2879', '2016353'),
('1000013-B', '2879', '2025970'),
('1000013-B', '2879', '2025986'),
('1000006-B', '2879', '2025970'),
('1000006-B', '2879', '2015970'),
('2025963', '2879', '2025964'),
('2025963', '2879', '2015174'),
('2016353', '2879', '2016701'),
('2016353', '2879', '2016053'),
('2016353', '2879', '2025982'),
('2016698', '2879', '2025967'),
('2016698', '2879', '2016492'),
('2016698', '2879', '2016707'),
('1000017-B', '2879', '2025967'),
('2015703', '2879', '2016028'),
('2015703', '2879', '2015702'),
('2016699', '2879', '2016701'),
('2016699', '2879', '2025966'),
('2016699', '2879', '2016696'),
('2016697', '2879', '2025967'),
('2016697', '2879', '2016492'),
('2016697', '2879', '2016707'),
('2015162', '2879', '2025970'),
('2015162', '2879', '2015970'),
('2015555', '2879', '1000007-B'),
('2015555', '2879', '2025963'),
('2015555', '2879', '2015184');
INSERT INTO prerrequisito (asi_codigo_pre, pro_id, asi_codigo) VALUES
('1000003-B', '2879', '1000013-B');
-- Insertar prerrequisitos para el semestre 1 de ingeniería industrial
INSERT INTO prerrequisito (asi_codigo_pre, pro_id, asi_codigo) VALUES
('2026805', '2546', '2026488'),
('2026805', '2546', '2016592'),
('2026805', '2546', '2016615'),
('1000004-B', '2546', '1000017-B'),
('1000004-B', '2546', '1000003-B'),
('1000004-B', '2546', '1000005-B'),
('1000004-B', '2546', '2026488'),
('1000004-B', '2546', '2016592'),
('1000004-B', '2546', '2016017'),
('2015734', '2546', '2016375');


-- Insertar paquetes de asignaturas para cálculo diferencial y álgebra lineal:
INSERT INTO agrupacion_asignaturas VALUES (DEFAULT); SET @primer_paquete_id = LAST_INSERT_ID();
INSERT INTO asignatura_asociada (id, asi_codigo) VALUES (@primer_paquete_id, '1000004-B'); INSERT INTO asignatura_asociada (id, asi_codigo) VALUES (@primer_paquete_id, '2015162');
INSERT INTO agrupacion_asignaturas VALUES (DEFAULT); SET @segundo_paquete_id = LAST_INSERT_ID();
INSERT INTO asignatura_asociada (id, asi_codigo) VALUES (@segundo_paquete_id, '1000003-B'); INSERT INTO asignatura_asociada (id, asi_codigo) VALUES (@segundo_paquete_id, '2015555');

-- Insertar información de grupos
INSERT INTO grupo_info (gru_numero, asi_codigo, per_documento_identidad, gru_pro_componente, info_edificio, info_salon, info_fecha, info_hora_inicio, info_hora_final) VALUES
-- Ingeniería de sistemas y computación
-- Cálculo diferencial
(1, '1000004-B', 1132725791, 'magistral', 454, '401', 'lunes', '07:00', '09:00'),
(1, '1000004-B', 1132725791, 'magistral', 454, '401', 'miércoles', '07:00', '09:00'),

(2, '1000004-B', 1132725791, 'magistral', 454, '402', 'martes', '07:00', '09:00'),
(2, '1000004-B', 1132725791, 'magistral', 454, '402', 'jueves', '07:00', '09:00'),

-- Introducción a la ingeniería de sistemas y computación
(1, '2025975', 1075980751, 'magistral', 454, '401', 'lunes', '09:00', '11:00'),
(1, '2025975', 1075980751, 'magistral', 454, '401', 'miércoles', '09:00', '11:00'),

(2, '2025975', 1075980751, 'magistral', 454, '402', 'martes', '09:00', '11:00'),
(2, '2025975', 1075980751, 'magistral', 454, '402', 'jueves', '09:00', '11:00'),

-- Programación de computadores
(1, '2015734', 1075980751, 'magistral', 454, '401', 'lunes', '11:00', '13:00'),
(1, '2015734', 1075980751, 'magistral', 454, '401', 'miércoles', '11:00', '13:00'),

(2, '2015734', 1075980751, 'magistral', 454, '402', 'martes', '11:00', '13:00'),
(2, '2015734', 1075980751, 'magistral', 454, '402', 'jueves', '11:00', '13:00'),

-- Pensamiento sistémico
(1, '2016703', 1475577711, 'magistral', 454, '401', 'lunes', '14:00', '16:00'),
(1, '2016703', 1475577711, 'magistral', 454, '401', 'miércoles', '14:00', '16:00'),

(2, '2016703', 1475577711, 'magistral', 454, '402', 'martes', '14:00', '16:00'),
(2, '2016703', 1475577711, 'magistral', 454, '402', 'jueves', '14:00', '16:00'),

-- Fundamentos de mecánica
(1, '1000019-B', 1497912021, 'magistral', 404, '201', 'lunes', '07:00', '09:00'),

(2, '1000019-B', 1497912021, 'magistral', 404, '202', 'martes', '07:00', '09:00'),

(1, '1000019-B', 1497912021, 'taller', 404, '201', 'lunes', '09:00', '11:00'),

(2, '1000019-B', 1497912021, 'taller', 404, '202', 'martes', '09:00', '11:00'),

(1, '1000019-B', 1525659481, 'laboratorio', 404, '201', 'viernes', '07:00', '09:00'),

(2, '1000019-B', 1525659481, 'laboratorio', 404, '202', 'viernes', '09:00', '11:00'),

-- Cálculo integral
(1, '1000005-B', 1132725791, 'magistral', 453, '301', 'lunes', '09:00', '11:00'),
(1, '1000005-B', 1132725791, 'magistral', 453, '301', 'miércoles', '09:00', '11:00'),

(2, '1000005-B', 1132725791, 'magistral', 453, '302', 'martes', '09:00', '11:00'),
(2, '1000005-B', 1132725791, 'magistral', 453, '302', 'jueves', '09:00', '11:00'),

-- Álgebra lineal
(1, '1000003-B', 1497912021, 'magistral', null, 'virtual', 'lunes', '11:00', '13:00'),
(1, '1000003-B', 1497912021, 'magistral', null, 'virtual', 'miércoles', '11:00', '13:00'),

(2, '1000003-B', 1497912021, 'magistral', null, 'virtual', 'martes', '11:00', '13:00'),
(2, '1000003-B', 1497912021, 'magistral', null, 'virtual', 'jueves', '11:00', '13:00'),

-- Programación orientada a objetos
(1, '2016375', 1862667381, 'magistral', 454, 403, 'jueves', '11:00', '13:00'),
(1, '2016375', 1862667381, 'magistral', 454, 403, 'viernes', '11:00', '13:00'),

(2, '2016375', 1075980751, 'magistral', 454, 402, 'jueves', '11:00', '13:00'),
(2, '2016375', 1075980751, 'magistral', 454, 402, 'viernes', '11:00', '13:00'),

-- Probabilidad y estadística fundamental
(1, '1000013-B', 1551090981, 'magistral', 453, 101, 'lunes', '14:00', '16:00'),
(1, '1000013-B', 1551090981, 'magistral', 453, 101, 'jueves', '14:00', '16:00'),

(2, '1000013-B', 1551090981, 'magistral', 453, 102, 'martes', '14:00', '16:00'),
(2, '1000013-B', 1551090981, 'magistral', 453, 102, 'jueves', '14:00', '16:00'),

-- Cálculo en varias variables
(1, '1000006-B', 1073829021, 'magistral', 453, 'auditorio A', 'lunes', '14:00', '16:00'),
(1, '1000006-B', 1073829021, 'magistral', 453, 'auditorio A', 'miércoles', '14:00', '16:00'),

(2, '1000006-B', 1132725791, 'magistral', 453, 'auditorio B', 'lunes', '14:00', '16:00'),
(2, '1000006-B', 1132725791, 'magistral', 453, 'auditorio B', 'miércoles', '14:00', '16:00'),

-- Matemáticas discretas I
(1, '2025963', 1654153341, 'magistral', 401, '301', 'lunes', '16:00', '18:00'),
(1, '2025963', 1654153341, 'magistral', 401, '302', 'miércoles', '16:00', '18:00'),

(2, '2025963', 1075980751, 'magistral', 401, '301', 'lunes', '16:00', '18:00'),
(2, '2025963', 1075980751, 'magistral', 401, '302', 'miércoles', '16:00', '18:00'),

-- Bases de datos
(1, '2016353', 1411641411, 'magistral', 454, '403', 'martes', '16:00', '18:00'),
(1, '2016353', 1411641411, 'magistral', 454, '403', 'jueves', '16:00', '18:00'),

(2, '2016353', 1654153341, 'magistral', 454, '403', 'martes', '16:00', '18:00'),
(2, '2016353', 1654153341, 'magistral', 454, '403', 'jueves', '16:00', '18:00'),

-- Elementos de computadores
(1, '2016698', 1364518241, 'magistral', 406, '101', 'sábado', '07:00', '11:00'),

(2, '2016698', 1364518241, 'magistral', 406, '101', 'sábado', '14:00', '18:00'),

-- Fundamentos de electricidad y magnetismo
(1, '1000017-B', 1478483361, 'magistral', 404, '203', 'lunes', '07:00', '09:00'),

(2, '1000017-B', 1478483361, 'magistral', 404, '204', 'martes', '07:00', '09:00'),

(1, '1000017-B', 1478483361, 'taller', 404, '203', 'lunes', '09:00', '11:00'),

(2, '1000017-B', 1478483361, 'taller', 404, '204', 'martes', '09:00', '11:00'),

(1, '1000017-B', 1866709691, 'laboratorio', 404, '203', 'viernes', '07:00', '09:00'),

(2, '1000017-B', 1866709691, 'laboratorio', 404, '204', 'viernes', '09:00', '11:00'),

-- Ingeniería económica
(1, '2015703', 1866709691, 'magistral', 453, 'auditorio C', 'martes', '11:00', '13:00'),
(1, '2015703', 1866709691, 'magistral', 453, 'auditorio C', 'jueves', '11:00', '13:00'),

(2, '2015703', 1866709691, 'magistral', 453, 'auditorio C', 'jueves', '07:00', '09:00'),
(2, '2015703', 1866709691, 'magistral', 453, 'auditorio C', 'viernes', '07:00', '09:00'),

-- Estructuras de datos
(1, '2016699', 1585773951, 'magistral', 454, '403', 'lunes', '11:00', '13:00'),
(1, '2016699', 1585773951, 'magistral', 454, '403', 'miércoles', '11:00', '13:00'),

(2, '2016699', 1862667381, 'magistral', 454, '403', 'sábado', '07:00', '11:00'),

-- Arquitectura de computadores
(1, '2016697', 1364518241, 'magistral', 406, '102', 'lunes', '14:00', '16:00'),
(1, '2016697', 1364518241, 'magistral', 406, '102', 'miércoles', '14:00', '16:00'),

(2, '2016697', 1364518241, 'magistral', 406, '102', 'martes', '14:00', '16:00'),
(2, '2016697', 1364518241, 'magistral', 406, '102', 'jueves', '14:00', '16:00'),

-- Ingeniería industrial
-- Sociología especial: industrial y del trabajo
(1, '2015811', 1615619781, 'magistral', 401, '304', 'lunes', '11:00', '13:00'),
(1, '2015811', 1615619781, 'magistral', 401, '304', 'miércoles', '11:00', '13:00'),

(2, '2015811', 1615619781, 'magistral', 401, '304', 'lunes', '14:00', '16:00'),
(2, '2015811', 1615619781, 'magistral', 401, '304', 'miércoles', '14:00', '16:00'),

-- Introducción a la ingeniería industrial
(1, '2026805', 1615619781, 'magistral', 453, 'auditorio A', 'lunes', '07:00', '09:00'),
(1, '2026805', 1615619781, 'magistral', 453, 'auditorio A', 'miércoles', '07:00', '09:00'),

(2, '2026805', 1615619781, 'magistral', 453, 'auditorio A', 'martes', '07:00', '09:00'),
(2, '2026805', '1615619781', 'magistral', 453, 'auditorio A', 'jueves', '07:00', '09:00'),

-- Equivalentes
-- Calculo vectorial
(1, '2015162', 1073829021, 'magistral', 453, 'auditorio B', 'lunes', '11:00', '13:00'),
(1, '2015162', 1073829021, 'magistral', 453, 'auditorio B', 'miércoles', '11:00', '13:00'),

(2, '2015162', 1073829021, 'magistral', 453, 'auditorio B', 'lunes', '09:00', '11:00'),
(2, '2015162', 1073829021, 'magistral', 453, 'auditorio B', 'miércoles', '09:00', '11:00'),

-- Álgebra lineal básica
(1, '2015555', 1497912021, 'magistral', null, 'virtual', 'lunes', '11:00', '13:00'),
(1, '2015555', 1497912021, 'magistral', null, 'virtual', 'miércoles', '11:00', '13:00'),

(2, '2015555', 1475577711, 'magistral', null, 'virtual', 'martes', '11:00', '13:00'),
(2, '2015555', 1475577711, 'magistral', null, 'virtual', 'jueves', '11:00', '13:00'),

-- Posgrado: Seminario de Estructura I (2020905)
(1, 2020905, 1001369006, 'magistral', 215, '207', 'lunes', '09:00', '11:00'),
(1, 2020905, 1001369006, 'magistral', 215, '207', 'miércoles', '09:00', '11:00'),

-- INSERT INTO grupo_info (gru_numero, asi_codigo, per_documento_identidad, gru_pro_componente, info_edificio, info_salon, info_fecha, info_hora_inicio, info_hora_final) VALUES
-- Electiva: Agujeros negros y máquinas del tiempo
(1, 2024279, 1000990767, 'magistral', 454, 'Auditorio', 'viernes', '09:00', '12:00'),
-- Electiva: Astronomía para todos
(1, 2021140, 1000990767, 'magistral', 454, 'Auditorio', 'lunes', '07:00', '09:00'),
(1, 2021140, 1000990767, 'magistral', 454, 'Auditorio', 'miércoles', '07:00', '09:00'),
(2, 2021140, 1000990767, 'magistral', 454, 'Auditorio', 'lunes', '09:00', '11:00'),
(2, 2021140, 1000990767, 'magistral', 454, 'Auditorio', 'miércoles', '09:00', '11:00'),
-- Electiva: Cátedra Pinsus Julio Carrizosa
(1, 2028643, 1003989343, 'magistral', 454, 'Auditorio A', 'sábado', '09:00', '11:00'),
(2, 2028643, 1003989343, 'magistral', 454, 'Auditorio A', 'sábado', '11:00', '01:00');
-- ----------------------------------------------------------------------------------------------
-- Generar cita de inscripción:
INSERT INTO cita_ins_can (cit_fecha) VALUES ('2023-02-01 12:00:00');
INSERT INTO cita_ins_can (cit_fecha) VALUES ('2023-06-12 20:00:00');

-- Cita de inscripción asociada a las historias:
INSERT INTO cita_por_historia_academica (cit_fecha, his_codigo, his_semestre, his_ano) VALUES 
('2023-02-01 12:00', 9120, 1, 2022),
('2023-02-01 12:00', 9120, 2, 2022),
('2023-02-01 12:00', 9120, 1, 2023),
('2023-02-01 12:00', 9121, 1, 2023),
('2023-02-01 12:00', 6547, 1, 2022),
('2023-02-01 12:00', 6547, 2, 2022),
('2023-02-01 12:00', 6547, 1, 2023),
('2023-02-01 12:00', 8111, 1, 2023);

-- Para el estudiante 1152629821:
-- Inscripción para el semestre 2022 1
INSERT INTO inscripcion (ins_cancelacion, ins_influencia_creditos, gru_numero, asi_codigo, his_codigo, his_semestre, his_ano, cit_fecha)
VALUES
(0, 1, 1, '1000004-B', 9120, 1, 2022, '2023-02-01 12:00:00'),
(0, 1, 1, '2025975', 9120, 1, 2022, '2023-02-01 12:00:00'),

-- Inscripción para el semestre 2022 2
(0, 1, 1, '1000019-B', 9120, 2, 2022, '2023-02-01 12:00:00'),
(0, 1, 2, '1000005-B', 9120, 2, 2022, '2023-02-01 12:00:00'),

-- Inscripción para el semestre 2023 1
(0, 1, 2, '1000013-B', 9120, 1, 2023, '2023-02-01 12:00:00'),
(0, 1, 1, '1000006-B', 9120, 1, 2023, '2023-02-01 12:00:00'),

-- Inscripción para el semestre 2023 1 (segunda carrera)
(0, 1, 2, '2015811', 9121, 1, 2023, '2023-02-01 12:00:00'),
(0, 1, 1, '2026805', 9121, 1, 2023, '2023-02-01 12:00:00');

-- Para el estudiante 1293226521:
-- Inscripción para el semestre 2022 1
INSERT INTO inscripcion (ins_cancelacion, ins_influencia_creditos, gru_numero, asi_codigo, his_codigo, his_semestre, his_ano, cit_fecha)
VALUES
(0, 1, 2, '2015734', 6547, 1, 2022, '2023-02-01 12:00:00'),
(0, 1, 1, '2016703', 6547, 1, 2022, '2023-02-01 12:00:00'),

-- Inscripción para el semestre 2022 2
(0, 1, 1, '1000003-B', 6547, 2, 2022, '2023-02-01 12:00:00'),
(0, 1, 2, '2016375', 6547, 2, 2022, '2023-02-01 12:00:00'),

-- Inscripción para el semestre 2023 1
(0, 1, 2, '2016353', 6547, 1, 2023, '2023-02-01 12:00:00'),
(0, 1, 1, '2016698', 6547, 1, 2023, '2023-02-01 12:00:00');

-- Para el estudiante de posgrado 1000342596:
INSERT INTO inscripcion (ins_cancelacion, ins_influencia_creditos, gru_numero, asi_codigo, his_codigo, his_semestre, his_ano, cit_fecha)
VALUES
(0, 1, 1, '2020905', 8111, 1, 2023, '2023-02-01 12:00:00');

-------------------------------------------------------------------
-- Calificaciones para el estudiante 1152629821
-- Semestre 2022 1
INSERT INTO calificacion (cal_primer_corte, cal_segundo_corte, cal_tercer_corte, cal_final, cal_aprobado, pro_documento_identidad, asi_codigo, his_codigo, his_semestre, his_ano)
VALUES
(4.5, 4.7, 4.6, 4.6, 1, 1132725791, '1000004-B', 9120, 1, 2022),
(3.8, 4.0, 4.2, 4.0, 1, 1075980751, '2025975', 9120, 1, 2022),
-- Semestre 2022 2
(3.9, 4.2, 4.1, 4.1, 1, 1497912021, '1000019-B', 9120, 2, 2022),
(4.6, 4.8, 4.7, 4.7, 1, 1132725791, '1000005-B', 9120, 2, 2022);

-- Calificaciones para el estudiante 1293226521
-- Semestre 2022 1
INSERT INTO calificacion (cal_primer_corte, cal_segundo_corte, cal_tercer_corte, cal_final, cal_aprobado, pro_documento_identidad, asi_codigo, his_codigo, his_semestre, his_ano)
VALUES
(4.2, 4.1, 4.0, 4.1, 1, 1075980751, '2015734', 6547, 1, 2022),
(3.5, 3.8, 3.7, 3.7, 1, 1475577711, '2016703', 6547, 1, 2022),
-- Semestre 2022 2
(3.7, 3.9, 3.8, 3.8, 1, 1497912021, '1000003-B', 6547, 2, 2022),
(4.1, 4.4, 4.3, 4.3, 1, 1075980751, '2016375', 6547, 2, 2022);

-- Calificaciones para el estudiante de posgrado 1000342596
INSERT INTO calificacion (cal_primer_corte, cal_segundo_corte, cal_tercer_corte, cal_final, cal_aprobado, pro_documento_identidad, asi_codigo, his_codigo, his_semestre, his_ano)
VALUES
(4.2, 4.5, 4.0, 4.2, 1, 1001369006, '2020905', 8111, 1, 2023);


-- Crear calendario académico
-- Sede Bogotá 2023 1
INSERT INTO calendario_academico (cal_ano, cal_semestre, sed_id, acuerdo) 
VALUES (2023, 1, 1101, 'Acuerdo 019 de 2022 (Acta 26 del 12 de diciembre de 2022)');

-- Semestre 2023 1
INSERT INTO evento (fecha, actividad, responsable, cal_id, cal_ano, cal_semestre)
VALUES 
('2023-02-01', 'Inicio de inscripción de asignaturas', 'Admitido', 1, 2023, 1),
('2023-02-03', 'Fin de inscripción de asignaturas', 'Admitido', 1, 2023, 1),
('2023-06-02', 'Inicio de adición y cancelación de asignaturas sin pérdida de créditos', 'Estudiante', 1, 2023, 1),
('2023-02-17', 'Fin de adición y cancelación de asignaturas sin pérdida de créditos', 'Estudiante', 1, 2023, 1),
('2023-03-24', 'Última semana de cancelación de asignaturas con pérdida de créditos', 'Estudiante', 1, 2023, 1);

-- Insertar responsables
INSERT INTO responsable (per_documento_identidad)
VALUES (1585639711),
       (1274589181),
       (1036948741),
       (1483100791),
       (1229529841),
       (1166452691),
       (1312490201);

-- Asignar responsables a estudiantes
INSERT INTO estudiante_has_responsable (est_per_documento_identidad, res_per_documento_identidad)
VALUES (1152629821 , 1585639711),
       (1293226521 , 1274589181),
       (1409728951 , 1036948741),
       (1711327451 , 1483100791),
       (1979128351 , 1229529841),
       (1000342596 , 1166452691),
       (1000342596 , 1312490201);