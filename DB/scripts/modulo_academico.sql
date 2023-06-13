-- -----------------------------------------------------
-- Schema academico
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS academico ;

-- -----------------------------------------------------
-- Schema academico
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS academico DEFAULT CHARACTER SET utf8 ;
USE academico ;

-- -----------------------------------------------------
-- Table persona
-- -----------------------------------------------------
DROP TABLE IF EXISTS persona ;

CREATE TABLE IF NOT EXISTS persona (
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Número de identificación de cada individuo',
  per_nombre VARCHAR(45) NOT NULL COMMENT 'Nombre de la persona',
  per_apellidos VARCHAR(45) NOT NULL COMMENT 'Apellido de la persona',
  per_sexo_biologico VARCHAR(15) NOT NULL COMMENT 'Sexo biológico de la persona, es una cadena de texto.',
  per_correo_personal VARCHAR(45) NOT NULL COMMENT 'Correo personal de la persona registrada. No es nulo ya que para el tema del registro es necesario al menos un correo.',
  per_telefono_cel BIGINT(10) NULL COMMENT 'Teléfono celular y personal de cada persona. Es un dato nulo ya que no es estrictamente necesario tener uno para el registro.',
  per_telefono BIGINT(10) NULL COMMENT 'Telefono fijo correspondiente al individuo. Es un dato nulo ya que no es estrictamente necesario tener uno para el registro.',
  per_fecha_nacimiento DATE NOT NULL COMMENT 'Fecha de nacimiento de la persona.',
  per_nacionalidad VARCHAR(25) NOT NULL COMMENT 'Nacionalidad de la persona.',
  PRIMARY KEY (per_documento_identidad));


-- -----------------------------------------------------
-- Table vinculado
-- -----------------------------------------------------
DROP TABLE IF EXISTS vinculado ;

CREATE TABLE IF NOT EXISTS vinculado (
  vin_codigo BIGINT(10) NOT NULL COMMENT 'Código que identifica a la persona frente a la institución educativa.',
  vin_usuario VARCHAR(20) NOT NULL COMMENT 'Usuario de acceso a las plataformas de servicios de la universidad.',
  vin_contrasena VARCHAR(45) NOT NULL COMMENT 'Contraseña de acceso a las plataformas de servicios de la universidad.',
  vin_correo_institucional VARCHAR(45) NOT NULL COMMENT 'Correo institucional del individuo.',
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para poder identificar a la persona vinculada. En este caso, corresponde al documento de identidad.',
  PRIMARY KEY (per_documento_identidad),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES persona (per_documento_identidad));


-- -----------------------------------------------------
-- Table responsable
-- -----------------------------------------------------
DROP TABLE IF EXISTS responsable ;

CREATE TABLE IF NOT EXISTS responsable (
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para poder identificar a la persona vinculada. En este caso, corresponde al documento de identidad.',
  PRIMARY KEY (per_documento_identidad),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES persona (per_documento_identidad));


-- -----------------------------------------------------
-- Table profesor
-- -----------------------------------------------------
DROP TABLE IF EXISTS profesor ;

CREATE TABLE IF NOT EXISTS profesor (
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para poder identificar al docente. En este caso, corresponde al documento de identidad.',
  pro_num_oficina INT NULL COMMENT 'Indica el número de oficina del docente.',
  pro_grupo_investigacion VARCHAR(45) NULL COMMENT 'Indica el nombre del grupo de investigación al cual está asociado el docente.',
  PRIMARY KEY (per_documento_identidad),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES vinculado (per_documento_identidad));


-- -----------------------------------------------------
-- Table residencia
-- -----------------------------------------------------
DROP TABLE IF EXISTS residencia ;

CREATE TABLE IF NOT EXISTS residencia (
  res_id INT AUTO_INCREMENT NOT NULL COMMENT 'Llave artificial para identificar la residencia.',
  res_ciudad VARCHAR(17) NOT NULL COMMENT 'Cadena de carácteres para identificar la ciudad de residencia.',
  res_calle VARCHAR(45) NOT NULL COMMENT 'Cadena de carácteres para identificar la calle de residencia.',
  res_numero VARCHAR(35) NOT NULL COMMENT 'Cadena de carácteres para identificar el numero asociado a la calle de residencia.',
  res_codigo_postal INT NOT NULL COMMENT 'Código postal asociado a la localidad de residencia.',
  res_estrato INT NOT NULL COMMENT 'Estrato asociado a la localidad de la residencia del estudiante.',
  PRIMARY KEY (res_id));


-- -----------------------------------------------------
-- Table estudiante
-- -----------------------------------------------------
DROP TABLE IF EXISTS estudiante ;

CREATE TABLE IF NOT EXISTS estudiante (
  est_etnia VARCHAR(20) NULL DEFAULT 'No informado' COMMENT 'Cadena de carácteres para identificar la etnia del estudiante.',
  est_situacion_militar TINYINT(1) NOT NULL COMMENT 'Indica si la situación militar ya fue solucionada o no.',
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para poder identificar al estudiante. En este caso, corresponde al documento de identidad.',
  res_id INT NOT NULL COMMENT 'Llave artificial para identificar la residencia del vinculado.',
  est_admision_esp TINYINT(1) NOT NULL COMMENT 'Indica si el estudiante corresponde a algún grupo especial de admisión, información relevante en algunos trámites universitarios.',
  est_nivelacion_mat TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Booleano para indicar si el estudiante necesita nivelación en el componente de matemáticas.',
  est_nivelacion_lecto TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Booleano para indicar si el estudiante necesita nivelación en el componente de lecto-escritura.',
  est_nivelacion_ingles TINYINT(1) NULL COMMENT 'Valor que indica el nivel de inglés del que parte el estudiante, en caso de ser 5, no necesita nivelación de idiomas.',	
  PRIMARY KEY (per_documento_identidad),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES vinculado (per_documento_identidad),
  FOREIGN KEY (res_id)
  REFERENCES residencia (res_id));
  
  -- -----------------------------------------------------
-- Table estudiante_has_tutor
-- -----------------------------------------------------
DROP TABLE IF EXISTS estudiante_has_tutor ;

CREATE TABLE IF NOT EXISTS estudiante_has_tutor (
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para identificar al estudiante por documento de identidad.',
  prof_per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para identificar al responsable del estudiante por documento de identidad.',
  PRIMARY KEY (per_documento_identidad, prof_per_documento_identidad),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES estudiante (per_documento_identidad),
  FOREIGN KEY (prof_per_documento_identidad)
  REFERENCES profesor (per_documento_identidad));
  


-- -----------------------------------------------------
-- Table estudiante_has_responsable
-- -----------------------------------------------------
DROP TABLE IF EXISTS estudiante_has_responsable ;

CREATE TABLE IF NOT EXISTS estudiante_has_responsable (
  est_per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para identificar al estudiante por documento de identidad.',
  res_per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para identificar al responsable del estudiante por documento de identidad.',
  PRIMARY KEY (est_per_documento_identidad, res_per_documento_identidad),
  FOREIGN KEY (est_per_documento_identidad)
  REFERENCES estudiante (per_documento_identidad),
  FOREIGN KEY (res_per_documento_identidad)
  REFERENCES responsable (per_documento_identidad));


-- -----------------------------------------------------
-- Table sede
-- -----------------------------------------------------
DROP TABLE IF EXISTS sede ;

CREATE TABLE IF NOT EXISTS sede (
  sed_id INT NOT NULL COMMENT 'Id de la sede como llave artificial.',
  sed_nombre VARCHAR(30) NOT NULL COMMENT 'Nombre de la sede.',
  PRIMARY KEY (sed_id));


-- -----------------------------------------------------
-- Table facultad
-- -----------------------------------------------------
DROP TABLE IF EXISTS facultad ;

CREATE TABLE IF NOT EXISTS facultad (
  fac_nombre VARCHAR(50) NOT NULL COMMENT 'Nombre de la facultad.',
  fac_id INT NOT NULL COMMENT 'Id de la facultad como llave artificial.',
  fac_correo VARCHAR(45) NULL COMMENT 'Correo de la facultad en caso de que exista.',
  sed_id INT NOT NULL COMMENT 'Id de la sede a la que pertenece la facultad.',
  PRIMARY KEY (fac_id),
  FOREIGN KEY (sed_id)
  REFERENCES sede (sed_id));


-- -----------------------------------------------------
-- Table departamento
-- -----------------------------------------------------
DROP TABLE IF EXISTS departamento ;

CREATE TABLE IF NOT EXISTS departamento (
  dep_nombre VARCHAR(75) NOT NULL COMMENT 'Nombre del departamento.',
  dep_id INT NOT NULL COMMENT 'Id del departamento como llave artificial.',
  dep_correo VARCHAR(45) NULL COMMENT 'Correo asociado al departamento en caso de que exista.',
  fac_id INT NOT NULL COMMENT 'Id de la facultad a la que pertenece el departamento.',
  PRIMARY KEY (dep_id),
  FOREIGN KEY (fac_id)
  REFERENCES facultad (fac_id));


-- -----------------------------------------------------
-- Table programa
-- -----------------------------------------------------
DROP TABLE IF EXISTS programa ;

CREATE TABLE IF NOT EXISTS programa (
  pro_nombre VARCHAR(75) NOT NULL COMMENT 'Nombre del programa.',
  pro_creditos_exigidos INT NOT NULL COMMENT 'Créditos exigidos por el programa.',
  pro_grado_de_licenciatura VARCHAR(22) NOT NULL COMMENT 'Grado de licenciatura asociado al programa.',
  sed_id INT NOT NULL COMMENT 'Id de la sede que oferta el programa.',
  pro_id VARCHAR(4) NOT NULL COMMENT 'Id del programa como llave artificial.',
  dep_id INT NULL COMMENT 'Id del departamento al que pertenece el programa.',
  pro_cre_DOp INT NOT NULL COMMENT 'Créditos exigidos por el programa de tipología disciplinar optativa.',
  pro_cre_DOb INT NOT NULL COMMENT 'Créditos exigidos por el programa de tipología disciplinar obligatoria.',
  pro_cre_FOp INT NOT NULL COMMENT 'Créditos exigidos por el programa de tipología fundamental optativa.',
  pro_cre_FOb INT NOT NULL COMMENT 'Créditos exigidos por el programa de tipología fundamental obligatoria.',
  pro_cre_LE INT NOT NULL COMMENT 'Créditos exigidos por el programa de libre elección.',
  pro_cre_Grado INT NOT NULL COMMENT 'Créditos exigidos por el programa para el Trabajo de grado.',
  PRIMARY KEY (pro_id),
  FOREIGN KEY (sed_id)
  REFERENCES sede (sed_id),
  FOREIGN KEY (dep_id)
  REFERENCES departamento (dep_id));


-- -----------------------------------------------------
-- Table asignatura
-- -----------------------------------------------------
DROP TABLE IF EXISTS asignatura ;

CREATE TABLE IF NOT EXISTS asignatura (
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Código asociado a la asignatura.',
  asi_nombre VARCHAR(90) NOT NULL COMMENT 'Nombre de la asignatura.',
  asi_creditos INT NOT NULL COMMENT 'Número de créditos asignados a la asignatura.',
  PRIMARY KEY (asi_codigo));
  
  -- -----------------------------------------------------
-- Table agrupacion_asignaturas
-- -----------------------------------------------------
DROP TABLE IF EXISTS agrupacion_asignaturas ;

CREATE TABLE IF NOT EXISTS agrupacion_asignaturas (
  id INT AUTO_INCREMENT NOT NULL COMMENT 'Id del paquete de asignaturas asociadas.',
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Table asignatura_asociada
-- -----------------------------------------------------
DROP TABLE IF EXISTS asignatura_asociada ;

CREATE TABLE IF NOT EXISTS asignatura_asociada (
  id INT NOT NULL COMMENT 'Id del paquete de asignaturas asociadas.',
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Código de la asignatura que pertenece al paquete.',
  PRIMARY KEY (id,asi_codigo),
  FOREIGN KEY (asi_codigo)
  REFERENCES asignatura (asi_codigo));
  
  
-- -----------------------------------------------------
-- Table malla
-- -----------------------------------------------------
DROP TABLE IF EXISTS malla ;

CREATE TABLE IF NOT EXISTS malla (
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Código de la asignatura asociada al plan de estudios del programa.',
  malla_obligatorio TINYINT(1) NULL COMMENT 'Booleano para identificar si la asignatura es obligatoria, o no.',
  malla_componente VARCHAR(20) NOT NULL COMMENT 'Componente de la asignatura asociada al programa.',
  pro_id VARCHAR(4) NOT NULL COMMENT 'Id del programa asociado a la malla.',
  PRIMARY KEY (asi_codigo, pro_id),
  FOREIGN KEY (asi_codigo)
  REFERENCES asignatura (asi_codigo),
  FOREIGN KEY (pro_id)
  REFERENCES programa (pro_id));


-- -----------------------------------------------------
-- Table prerrequisito
-- -----------------------------------------------------
DROP TABLE IF EXISTS prerrequisito ;

CREATE TABLE IF NOT EXISTS prerrequisito (
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Código de la asignatura a consultar.',
  pro_id VARCHAR(4) NOT NULL COMMENT 'Id del programa asociado a la malla.',
  asi_codigo_pre VARCHAR(10) NOT NULL COMMENT 'Código de la asignatura que es prerrequisito de la consultada.',
  PRIMARY KEY (asi_codigo, pro_id, asi_codigo_pre),
  FOREIGN KEY (asi_codigo , pro_id)
  REFERENCES malla (asi_codigo , pro_id),
  FOREIGN KEY (asi_codigo_pre)
  REFERENCES malla (asi_codigo));


-- -----------------------------------------------------
-- Table grupo
-- -----------------------------------------------------
DROP TABLE IF EXISTS grupo ;

CREATE TABLE IF NOT EXISTS grupo (
  gru_numero INT NOT NULL COMMENT 'Número asociado al grupo.',
  gru_cupos INT NOT NULL COMMENT 'Cupos disponibles en el grupo.',
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Llave foránea del código de la asignatura a la cual está asociado el grupo.',
  PRIMARY KEY (gru_numero, asi_codigo),
  FOREIGN KEY (asi_codigo)
  REFERENCES asignatura (asi_codigo));


-- -----------------------------------------------------
-- Table grupo_info
-- -----------------------------------------------------
DROP TABLE IF EXISTS grupo_info ;

CREATE TABLE IF NOT EXISTS grupo_info (
  gru_numero INT NOT NULL COMMENT 'Número asociado al grupo.',
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Llave foránea del código de la asignatura a la cual está asociado el grupo.',
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Documento del profesor asignado al grupo.',
  gru_pro_componente VARCHAR(20) NOT NULL DEFAULT 'magistral' COMMENT 'Componente del profesor asignado al grupo.',
  info_edificio INT NULL COMMENT 'Número del edificio donde se dará el espacio.',
  info_salon VARCHAR(15) NOT NULL COMMENT 'Número del salón donde se dará el espacio.',
  info_fecha VARCHAR(9) NOT NULL COMMENT 'Día de la semana en que será usado el horario.',
  info_hora_inicio VARCHAR(5) NOT NULL COMMENT 'Hora de inicio en que será usado el espacio.',
  info_hora_final VARCHAR(5) NOT NULL COMMENT 'Hora de finalización de uso del espacio.',
  PRIMARY KEY (gru_numero, asi_codigo, info_fecha,info_hora_inicio),
  FOREIGN KEY (gru_numero , asi_codigo)
  REFERENCES grupo (gru_numero , asi_codigo),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES profesor (per_documento_identidad));


-- -----------------------------------------------------
-- Table cita_ins_can
-- -----------------------------------------------------
DROP TABLE IF EXISTS cita_ins_can ;

CREATE TABLE IF NOT EXISTS cita_ins_can (
  cit_fecha DATETIME NOT NULL COMMENT 'Fecha en la que fue asignada la cita de cancelación e inscripción de grupos.',
  PRIMARY KEY (cit_fecha));


-- -----------------------------------------------------
-- Table historia_academica
-- -----------------------------------------------------
DROP TABLE IF EXISTS historia_academica ;

CREATE TABLE IF NOT EXISTS historia_academica (
  his_codigo INT NOT NULL COMMENT 'Código que identifica la historia académica',
  his_ano INT NOT NULL COMMENT 'Año correspondiente a los datos de la historia académica.',
  his_semestre INT NOT NULL COMMENT 'Semestre correspondiente a los datos de la historia académica.',
  his_PAPA DOUBLE DEFAULT 0 COMMENT 'P.A.P.A del estudiante asociado a la historia académica.',
  his_PAPPI DOUBLE DEFAULT 0 COMMENT 'P.A.P.P.I del estudiante asociado a la historia académica.',
  his_creditos_cancelados INT DEFAULT 0 COMMENT 'Número de créditos cancelados por el estudiante asociado a la historia académica y por parte del programa asociado a la historia.',
  his_avance DOUBLE DEFAULT 0 COMMENT 'Porcentaje de avance del estudiante en el programa asociado a la historia académica.',
  per_documento_identidad BIGINT(10) NOT NULL COMMENT 'Llave foranea para identificar al estudiante por documento de identidad.',
  his_programa_principal TINYINT(1) DEFAULT 1 NOT NULL COMMENT 'Atributo para identitifcar si la historia está asociada al programa principal del estudiante.',
  his_evaluacion_docente TINYINT(1) DEFAULT 1 NOT NULL COMMENT 'Este atributo indica si el estudiante realizó la evaluación docente.',
  his_matricula_cursante INT DEFAULT 1 NOT NULL COMMENT 'Número de la matrícula que se encuentra cursando el estudiante asociado a la historia.',
  his_estudiante_activo TINYINT(1) DEFAULT 1 NOT NULL COMMENT 'Booleano para indicar si el estudiante se encuentra activo en el semestre asociado a la historia.',
  his_pago_matricula TINYINT(1) DEFAULT 1 NOT NULL COMMENT 'Atributo booleano asociado al pago de matricula de la historia correspondiente.',
  pro_id VARCHAR(4) NOT NULL COMMENT 'Id del programa que está cursando el estudiante asociado a la historia.',
  his_traslado TINYINT(1) NULL DEFAULT null COMMENT 'Booleano que indica si existe algún traslado y si fue efectuado en el periodo asociado a la historia.',
  PRIMARY KEY (his_codigo, his_semestre, his_ano),
  FOREIGN KEY (per_documento_identidad)
  REFERENCES estudiante (per_documento_identidad),
  FOREIGN KEY (pro_id)
  REFERENCES programa (pro_id));


-- -----------------------------------------------------
-- Table cita_por_historia_academica
-- -----------------------------------------------------
DROP TABLE IF EXISTS cita_por_historia_academica ;

CREATE TABLE IF NOT EXISTS cita_por_historia_academica (
  cit_fecha DATETIME NOT NULL COMMENT 'Llave foránea para identificar la fecha, incluida la hora, de la cita de inscripción.',
  his_codigo INT NOT NULL COMMENT 'Código de la historia académica a la cual fue asignada la cita de inscripción.',
  his_semestre INT NOT NULL COMMENT 'Semestre en que fue asignada la cita de inscripción.',
  his_ano INT NOT NULL COMMENT 'Año en que fue asignada la cita de inscripción.',
  PRIMARY KEY (his_codigo, his_semestre, his_ano, cit_fecha),
  FOREIGN KEY (cit_fecha)
  REFERENCES cita_ins_can (cit_fecha),
  FOREIGN KEY (his_codigo , his_semestre , his_ano)
  REFERENCES historia_academica (his_codigo , his_semestre , his_ano));


-- -----------------------------------------------------
-- Table inscripcion
-- -----------------------------------------------------
DROP TABLE IF EXISTS inscripcion ;

CREATE TABLE IF NOT EXISTS inscripcion (
  ins_cancelacion TINYINT(1) DEFAULT 0 NOT NULL COMMENT 'Indica si el proceso está siendo de cancelación del grupo.',
  ins_influencia_creditos TINYINT(1) DEFAULT 1 NOT NULL COMMENT 'Indica si la acción tiene influencia en los créditos o fue realizada en los plazos de adición y cancelación de grupos.',
  gru_numero INT NULL COMMENT 'Llave foránea que indica el número del grupo que está siendo inscrito o cancelado.',
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Llave foránea que indica la asignatura del grupo que está siendo inscrito o cancelado.',
  his_codigo INT NOT NULL COMMENT 'Código de la historia académica por la cual se registró la inscripción.',
  his_semestre INT NOT NULL COMMENT 'Semestre en que fue realizada la inscripción.',
  his_ano INT NOT NULL COMMENT 'Año en que fue realizada la inscripción.',
  cit_fecha DATETIME NULL COMMENT 'Fecha en la que fue realizada la inscripción.',
  PRIMARY KEY (asi_codigo, his_codigo, his_semestre, his_ano),
  FOREIGN KEY (gru_numero , asi_codigo)
  REFERENCES grupo (gru_numero , asi_codigo),
  FOREIGN KEY (his_codigo , his_semestre , his_ano , cit_fecha)
  REFERENCES cita_por_historia_academica (his_codigo , his_semestre , his_ano , cit_fecha));


-- -----------------------------------------------------
-- Table calificacion
-- -----------------------------------------------------
DROP TABLE IF EXISTS calificacion ;

CREATE TABLE IF NOT EXISTS calificacion (
  cal_primer_corte FLOAT NULL COMMENT 'Calificación del primer corte.',
  cal_segundo_corte FLOAT NULL COMMENT 'Calificación del segundo corte.',
  cal_tercer_corte FLOAT NULL COMMENT 'Calificación del tercer corte.',
  cal_final FLOAT NULL COMMENT 'Calificación final.',	
  cal_aprobado TINYINT(1) NOT NULL COMMENT 'Booleano que indica la aprobación o no.',
  pro_documento_identidad BIGINT(10) NULL COMMENT 'Llave foránea para identificar el profesor que asignó la calificación',
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Código de la asignatura a la cual se le asigna la calificación.',
  his_codigo INT NOT NULL COMMENT 'Código de la historia del estudiante al cual se le asigna la calificación.',
  his_semestre INT NOT NULL COMMENT 'Semestre en que se cursó la asignatura y se asignó la calificación correspondiente.',
  his_ano INT NOT NULL COMMENT 'Año en que se cursó la asignatura y se asignó la calificación correspondiente.',
  cal_modalidad VARCHAR(15) NOT NULL DEFAULT 'Ordinaria' COMMENT 'Modalidad en que se está asignando la calificación de la asignatura.',
  cal_fecha DATETIME NOT NULL COMMENT 'Fecha en la que el docente ingresó la calificación.',
  PRIMARY KEY (asi_codigo, his_codigo, his_semestre, his_ano),
  FOREIGN KEY (pro_documento_identidad)
  REFERENCES profesor (per_documento_identidad),
  FOREIGN KEY (asi_codigo , his_codigo , his_semestre , his_ano)
  REFERENCES inscripcion (asi_codigo , his_codigo , his_semestre , his_ano));


-- -----------------------------------------------------
-- Table ceremonia_grado
-- -----------------------------------------------------
DROP TABLE IF EXISTS ceremonia_grado ;

CREATE TABLE IF NOT EXISTS ceremonia_grado (
  cere_fecha DATETIME NOT NULL COMMENT 'Fecha en la que se realiza la ceremonia de grado.',
  fac_id INT NOT NULL COMMENT 'Id asociado a la facultad que ofrece la ceremonia de grado.',
  cere_grado_de_licenciatura VARCHAR(20) NOT NULL COMMENT 'Grado de licenciatura de la ceremonia respectiva.',
  cere_lugar VARCHAR(60) NOT NULL COMMENT 'Auditorio donde se realiza la ceremonia de grado.',
  sed_id INT NOT NULL COMMENT 'Id asociado a la sede donde se organiza la ceremonia de grado.',
  cere_id INT NOT NULL AUTO_INCREMENT COMMENT 'Id de la ceremonia, llave artificial autoincremental.',
  PRIMARY KEY (cere_id),
  FOREIGN KEY (sed_id)
  REFERENCES sede (sed_id),
  FOREIGN KEY (fac_id)
  REFERENCES facultad (fac_id));


-- -----------------------------------------------------
-- Table solicitud_inscripcion_grado
-- -----------------------------------------------------
DROP TABLE IF EXISTS solicitud_inscripcion_grado ;

CREATE TABLE IF NOT EXISTS solicitud_inscripcion_grado (
  sol_id INT NOT NULL AUTO_INCREMENT COMMENT 'Llave artificial para identificar la solicitud realizada.',
  his_codigo INT NOT NULL COMMENT 'Código de la historia académica asociada a la solicitud.',
  sol_fecha DATE NOT NULL COMMENT 'Fecha en que se realiza la solicitud.',
  sol_aprobacion TINYINT(1) NULL COMMENT 'Booleano que indica el estado de la solicitud.',
  cere_id INT NULL COMMENT 'Id de la ceremonia asociada a la solicitud en caso de ser aprobada.',
  sol_modalidad_grado VARCHAR(20) NOT NULL DEFAULT 'Ceremonia de grado' COMMENT 'Determina la modalidad solicitada por el estudiante para realizar su proceso de grado.',
  sol_pago_derecho_grado TINYINT(1) NOT NULL COMMENT 'Atributo booleano para indicar el pago de los derechos de admisión para la ceremonia correspondiente.',
  PRIMARY KEY (sol_id),
  FOREIGN KEY (his_codigo)
  REFERENCES historia_academica (his_codigo),
  FOREIGN KEY (cere_id)
  REFERENCES ceremonia_grado (cere_id));
  
  
  -- -----------------------------------------------------
-- Table solicitud_sobrecupo
-- -----------------------------------------------------
DROP TABLE IF EXISTS solicitud_sobrecupo ;

CREATE TABLE IF NOT EXISTS solicitud_sobrecupo (
  sol_id INT NOT NULL AUTO_INCREMENT COMMENT 'Llave artificial para identificar la solicitud realizada.',
  his_codigo INT NOT NULL COMMENT 'Código de la historia académica asociada a la solicitud.',
  his_semestre INT NOT NULL COMMENT 'Semestre en que se realizó la solicitud.',
  his_ano INT NOT NULL COMMENT 'año en que se realizó la solicitud.',
  gru_numero INT NULL COMMENT 'Grupo al que quiere solicitar el sobrecupo.',
  asi_codigo VARCHAR(10) NOT NULL COMMENT 'Asignatura al que quiere solicitar el sobrecupo.',
  sol_aprobacion TINYINT(1) NULL DEFAULT NULL COMMENT 'Booleano que indica el estado de la solicitud.',
  sol_prioridad_inscripcion TINYINT(1) NULL DEFAULT 1 COMMENT 'Booleano que indica si al ser aprobada la solicitud se dará prioridad sobre las que tiene inscritas el estudiante.',
  PRIMARY KEY (sol_id),
  FOREIGN KEY (his_codigo,his_semestre,his_ano)
  REFERENCES cita_por_historia_academica (his_codigo,his_semestre,his_ano),
  FOREIGN KEY (gru_numero,asi_codigo)
  REFERENCES grupo (gru_numero,asi_codigo));
  
   -- -----------------------------------------------------
-- Table calendario_academico
-- --------------------------------------------------------
DROP TABLE IF EXISTS calendario_academico;

CREATE TABLE IF NOT EXISTS calendario_academico (
    cal_id INT NOT NULL AUTO_INCREMENT COMMENT "Llave artificial para identificar el calendario académico.",
    cal_ano INT NOT NULL COMMENT "Año al que corresponde el calendario académico.",
    cal_semestre INT NOT NULL COMMENT "Semestre al que corresponde el calendario académico.",
    sed_id INT NOT NULL COMMENT "Sede a la que está asociado el calendario académico.",
    acuerdo VARCHAR(255) COMMENT "Acuerdo en el que fue establecido el calendario académico",
    PRIMARY KEY (cal_id, cal_ano, cal_semestre),
    FOREIGN KEY (sed_id)
    REFERENCES sede (sed_id)
);


   -- -----------------------------------------------------
-- Table evento
-- -----------------------------------------------------
DROP TABLE IF EXISTS evento;

CREATE TABLE IF NOT EXISTS evento (
    fecha DATE NOT NULL COMMENT "Fecha en que se realiza el evento mencionado.",
    actividad VARCHAR(255) NOT NULL COMMENT "Descripción de la actividad que se va a realizar.",
    responsable VARCHAR(45) NOT NULL COMMENT "Entidad responsable de la ejecución del evento mencionado",
    cal_id INT NOT NULL COMMENT "Id asociado a la llave artificial del calendario académico al que pertenece el evento.",
    cal_ano INT NOT NULL COMMENT "Año al que corresponde el calendario académico que contiene el evento.",
    cal_semestre INT NOT NULL COMMENT "Semestre al que corresponde el calendario académico que contiene el evento.",
    PRIMARY KEY (fecha),
    FOREIGN KEY (cal_id, cal_ano, cal_semestre)
    REFERENCES calendario_academico (cal_id, cal_ano, cal_semestre)
);
  
SET SQL_SAFE_UPDATES = 0;