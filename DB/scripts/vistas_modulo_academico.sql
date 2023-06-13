USE academico;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Vista que relaciona las sedes, con sus facultades y programas disponibles
DROP VIEW IF EXISTS vw_fac_pro_sed;
CREATE VIEW vw_fac_pro_sed AS SELECT sed_id,sed_nombre, fac_id, fac_nombre, fac_correo, departamento.dep_id, dep_nombre, dep_correo, 
pro_id, pro_nombre, pro_grado_de_licenciatura, pro_creditos_exigidos, pro_cre_DOp AS disciplinar_optativos, 
pro_cre_DOb AS disciplinar_obligatorios, pro_cre_FOp AS fundamental_optativos, pro_cre_FOb AS fundamental_obligatorios,
pro_cre_LE AS libre_eleccion, pro_cre_Grado AS trabajo_grado
FROM (programa NATURAL JOIN sede) LEFT JOIN departamento ON(departamento.dep_id=programa.dep_id) NATURAL JOIN facultad;


-- Vista que relaciona cada programa con las asignaturas que hacen parte de este
DROP VIEW IF EXISTS vw_pro_asignatura;
CREATE VIEW vw_pro_asignatura AS SELECT pro_id, pro_nombre, pro_grado_de_licenciatura, asi_codigo, asi_nombre, asi_creditos,
malla_obligatorio, malla_componente FROM programa NATURAL JOIN malla NATURAL JOIN asignatura;

-- Vista que relaciona las asignaturas que tienen prerrequisitos
DROP VIEW IF EXISTS vw_asignatura_prereq;
CREATE VIEW vw_asignatura_prereq AS 
SELECT pro_id, pro_nombre, asi1.asi_codigo AS asig_consul_codigo, asi1.asi_nombre AS asig_consul_nombre, asi1.asi_creditos AS as_con_creditos,
asi2.asi_codigo AS asig_prerreq_codigo, asi2.asi_nombre AS asig_prerreq_nombre, asi2.asi_creditos AS as_pre_creditos FROM prerrequisito JOIN (asignatura AS asi1) 
ON (prerrequisito.asi_codigo=asi1.asi_codigo) JOIN (asignatura_asociada AS as_aso1)ON (as_aso1.asi_codigo=prerrequisito.asi_codigo_pre)
JOIN agrupacion_asignaturas ON (as_aso1.id=agrupacion_asignaturas.id) JOIN (asignatura_asociada AS as_aso2) ON 
(as_aso2.id=agrupacion_asignaturas.id) JOIN (asignatura AS asi2) ON (as_aso2.asi_codigo=asi2.asi_codigo) NATURAL JOIN programa;

-- Vista que muestra todos los estudiantes activos
DROP VIEW IF EXISTS vw_estudiantes_act;
CREATE VIEW vw_estudiantes_act AS
SELECT DISTINCT es.per_documento_identidad , es.per_nombre, es.per_apellidos, es.per_sexo_biologico, es.per_correo_personal, es.per_telefono_cel, 
es.per_telefono, es.per_fecha_nacimiento, es.per_nacionalidad, est_etnia, est_situacion_militar, res_ciudad, res_calle, res_numero, res_codigo_postal,
res_estrato, est_admision_esp, res.per_documento_identidad AS responsable_doc_id, res.per_nombre AS responsable_nombre, res.per_apellidos AS responsable_apellidos, 
res.per_sexo_biologico AS responsable_sexo_biologico FROM ((persona AS res) RIGHT JOIN responsable ON (res.per_documento_identidad=responsable.per_documento_identidad)) 
RIGHT JOIN (estudiante_has_responsable RIGHT JOIN ((persona AS es) NATURAL JOIN 
(estudiante NATURAL JOIN (historia_academica NATURAL JOIN programa))) ON (es.per_documento_identidad=estudiante_has_responsable.est_per_documento_identidad)) 
ON (res.per_documento_identidad=estudiante_has_responsable.res_per_documento_identidad) NATURAL JOIN residencia WHERE
his_estudiante_activo=1;

-- Vista que muestra cada estudiante con su historia académica
DROP VIEW IF EXISTS vw_historia_academica;
CREATE VIEW vw_historia_academica AS
SELECT his_codigo, his_ano, his_semestre, pro_id, pro_nombre, pro_grado_de_licenciatura, per_documento_identidad, per_nombre, per_apellidos, est_admision_esp, 
est_nivelacion_mat, est_nivelacion_lecto, est_nivelacion_ingles, his_PAPA, his_PAPPI,
his_creditos_cancelados, his_avance, his_programa_principal, his_evaluacion_docente, his_matricula_cursante, his_estudiante_activo, his_pago_matricula
his_traslado FROM (persona NATURAL JOIN (historia_academica NATURAL JOIN estudiante)) NATURAL JOIN programa;

-- Vista que muestra cada grupo, los estudiantes que hacen parte y su nota final en el grupo. Muestra calificaciones agrupadas por grupos.
DROP VIEW IF EXISTS vw_calificacion_grupo;
CREATE VIEW vw_calificacion_grupo AS
SELECT grupo.gru_numero, asignatura.asi_codigo, asignatura.asi_nombre, grupo_info.gru_pro_componente, profesor.per_documento_identidad
AS profe_id, pro.per_nombre AS profe_nombre, pro.per_apellidos AS profe_apellidos, profesor.pro_num_oficina, historia_academica.his_codigo,
estudiante.per_documento_identidad AS estu_id, est.per_nombre AS estu_nombre, est.per_apellidos AS estu_apellidos, calificacion.cal_primer_corte,
calificacion.cal_segundo_corte, calificacion.cal_tercer_corte, calificacion.cal_final, calificacion.cal_aprobado, calificacion.cal_modalidad, 
calificacion.his_semestre, calificacion.his_ano
FROM ((grupo JOIN grupo_info ON (grupo.gru_numero=grupo_info.gru_numero)) JOIN asignatura ON (asignatura.asi_codigo=grupo_info.asi_codigo)) 
JOIN profesor ON (grupo_info.per_documento_identidad=profesor.per_documento_identidad) JOIN (persona AS pro)
ON (profesor.per_documento_identidad=pro.per_documento_identidad) JOIN inscripcion ON (grupo.gru_numero=inscripcion.gru_numero) 
JOIN historia_academica ON(inscripcion.his_codigo=historia_academica.his_codigo) JOIN estudiante ON 
(historia_academica.per_documento_identidad=estudiante.per_documento_identidad) JOIN (persona AS est) ON 
(estudiante.per_documento_identidad=est.per_documento_identidad) JOIN calificacion ON (historia_academica.his_codigo=calificacion.his_codigo) 
WHERE (inscripcion.ins_cancelacion=0 AND calificacion.asi_codigo=grupo_info.asi_codigo) ORDER BY gru_numero ASC;

-- Vista que muestra cada estudiante, con las asignaturas que está cursando y su calificación final en cada una
DROP VIEW IF EXISTS vw_calificacion_asig;
CREATE VIEW vw_calificacion_asig AS
SELECT per_documento_identidad, per_nombre, per_apellidos, historia_academica.his_codigo, historia_academica.his_ano, historia_academica.his_semestre,
asignatura.asi_codigo, asi_nombre, asi_creditos, cal_primer_corte, cal_segundo_corte, cal_tercer_corte, cal_final, cal_aprobado, cal_modalidad
FROM (((persona NATURAL JOIN estudiante) NATURAL JOIN historia_academica) JOIN calificacion ON (historia_academica.his_codigo=calificacion.his_codigo)) NATURAL JOIN asignatura;

-- Vista que muestra los docentes activos de acuerdo a los grupos activos
DROP VIEW IF EXISTS vw_docentes_act;
CREATE VIEW vw_docentes_act AS
SELECT DISTINCT per_documento_identidad, per_nombre, per_apellidos, per_sexo_biologico, per_correo_personal, per_telefono_cel, 
per_telefono, per_fecha_nacimiento, per_nacionalidad, pro_num_oficina, pro_grupo_investigacion
FROM persona NATURAL JOIN (grupo NATURAL JOIN (profesor NATURAL JOIN grupo_info));

-- Vista que muestra la cita de inscripción de cada estudiante
DROP VIEW IF EXISTS vw_cita_inscrip;
CREATE VIEW vw_cita_inscrip AS
SELECT per_documento_identidad, per_nombre, per_apellidos, historia_academica.his_codigo, historia_academica.his_ano, historia_academica.his_semestre, cit_fecha
FROM ((cita_por_historia_academica NATURAL JOIN historia_academica) NATURAL JOIN estudiante) NATURAL JOIN persona;

-- Vista que muestra todos los estudiantes de pregrado
DROP VIEW IF EXISTS vw_estudiantes_pregrado;
CREATE VIEW vw_estudiantes_pregrado AS
SELECT DISTINCT per_documento_identidad, per_nombre, per_apellidos, per_sexo_biologico, per_correo_personal, per_telefono_cel, 
per_telefono, per_fecha_nacimiento, per_nacionalidad, est_etnia, est_situacion_militar, res_ciudad, res_calle, 
res_numero, est_admision_esp FROM persona NATURAL JOIN (estudiante NATURAL JOIN (historia_academica NATURAL JOIN programa)) 
NATURAL JOIN residencia WHERE pro_grado_de_licenciatura LIKE 'Pregrado';

-- Vista que muestra todos los estudiantes de posgrado
DROP VIEW IF EXISTS vw_estudiantes_posgrado;
CREATE VIEW vw_estudiantes_posgrado AS
SELECT DISTINCT per_documento_identidad, per_nombre, per_apellidos, per_sexo_biologico, per_correo_personal, per_telefono_cel, 
per_telefono, per_fecha_nacimiento, per_nacionalidad, est_etnia, est_situacion_militar, res_ciudad, res_calle, 
res_numero, est_admision_esp FROM persona NATURAL JOIN (estudiante NATURAL JOIN (historia_academica NATURAL JOIN programa))
NATURAL JOIN residencia WHERE pro_grado_de_licenciatura LIKE 'Posgrado';

-- Vista que muestra los estudiantes de doble titulación de acuerdo a si tienen historias con programas distintos al programa principal
DROP VIEW IF EXISTS vw_estudiantes_doble;
CREATE VIEW vw_estudiantes_doble AS
SELECT per_documento_identidad, per_nombre, per_apellidos, per_sexo_biologico, per_correo_personal, per_telefono_cel, 
per_telefono, per_fecha_nacimiento, per_nacionalidad, est_etnia, est_situacion_militar, res_ciudad, res_calle, 
res_numero, est_admision_esp FROM estudiante NATURAL JOIN historia_academica NATURAL JOIN programa NATURAL JOIN residencia 
NATURAL JOIN persona WHERE his_programa_principal=0;

-- Vista que muestra los estudiantes no activos que se encuentran en reserva de cupo
DROP VIEW IF EXISTS vw_estudiantes_reserva;
CREATE VIEW vw_estudiantes_reserva AS
SELECT DISTINCT es.per_documento_identidad , es.per_nombre, es.per_apellidos, es.per_sexo_biologico, es.per_correo_personal, es.per_telefono_cel, 
es.per_telefono, es.per_fecha_nacimiento, es.per_nacionalidad, est_etnia, est_situacion_militar, res_ciudad, res_calle, res_numero, res_codigo_postal,
res_estrato, est_admision_esp, res.per_documento_identidad AS responsable_doc_id, res.per_nombre AS responsable_nombre, res.per_apellidos AS responsable_apellidos, 
res.per_sexo_biologico AS responsable_sexo_biologico FROM ((persona AS res) RIGHT JOIN responsable ON (res.per_documento_identidad=responsable.per_documento_identidad)) 
RIGHT JOIN (estudiante_has_responsable RIGHT JOIN ((persona AS es) NATURAL JOIN 
(estudiante NATURAL JOIN (historia_academica NATURAL JOIN programa))) ON (es.per_documento_identidad=estudiante_has_responsable.est_per_documento_identidad)) 
ON (res.per_documento_identidad=estudiante_has_responsable.res_per_documento_identidad) NATURAL JOIN residencia WHERE
his_estudiante_activo=0;

-- Vista para consultar las ceremonias de grado con facultad y sede asociadas
DROP VIEW IF EXISTS vw_ceremonia_grado;
CREATE VIEW vw_ceremonia_grado AS
SELECT cere_id, cere_fecha, cere_grado_de_licenciatura, fac_id, fac_nombre, sed_id, sed_nombre FROM 
ceremonia_grado NATURAL JOIN sede NATURAL JOIN facultad;

-- Vista para consultar las solicitudes de inscripción a grado y los estudiantes asociados
DROP VIEW IF EXISTS vw_solicitud_inscripcion_grado;
CREATE VIEW vw_solicitud_inscripcion_grado AS
SELECT sol_id, sol_fecha, sol_aprobacion, sol_modalidad_grado, sol_pago_derecho_grado, cere_id,
cere_fecha, his_codigo, per_documento_identidad, per_nombre, per_apellidos, pro_id, pro_nombre FROM
solicitud_inscripcion_grado NATURAL JOIN ceremonia_grado NATURAL JOIN historia_academica NATURAL JOIN
programa NATURAL JOIN persona;

-- Vista para consultar los datos personales de un estudiante
DROP VIEW IF EXISTS vw_datos_personales_estudiante;
CREATE VIEW vw_datos_personales_estudiante AS
SELECT p_estudiante.per_documento_identidad AS es_documento_identidad, p_estudiante.per_nombre AS es_nombre, 
p_estudiante.per_apellidos AS es_apellidos, p_estudiante.per_sexo_biologico, p_estudiante.per_correo_personal, p_estudiante.per_telefono_cel,p_estudiante.per_telefono, 
p_estudiante.per_fecha_nacimiento, p_estudiante.per_nacionalidad, est_etnia, est_situacion_militar,
res_ciudad, res_calle, res_numero,res_estrato,res_codigo_postal, est_admision_esp, vin_codigo, vin_usuario, vin_contrasena, 
vin_correo_institucional, p_responsable.per_documento_identidad AS res_documento_identidad, 
p_responsable.per_nombre AS res_nombre, p_responsable.per_apellidos AS res_apellidos
FROM ((((persona AS p_estudiante) NATURAL JOIN estudiante) NATURAL JOIN residencia) NATURAL JOIN vinculado) LEFT JOIN 
estudiante_has_responsable ON (p_estudiante.per_documento_identidad=estudiante_has_responsable.est_per_documento_identidad)
LEFT JOIN (persona AS p_responsable) ON (p_responsable.per_documento_identidad=estudiante_has_responsable.res_per_documento_identidad);

-- Vista para consultar los datos personales de un profesor
DROP VIEW IF EXISTS vw_datos_personales_profesor;
CREATE VIEW vw_datos_personales_profesor AS
SELECT * FROM persona NATURAL JOIN profesor NATURAL JOIN vinculado;

-- Vista para usar el buscador de cursos
DROP VIEW IF EXISTS vw_buscador_cursos;
CREATE VIEW vw_buscador_cursos AS 
SELECT asi_codigo AS codigo, asi_nombre AS asignatura, asi_creditos AS creditos, 
CONCAT(malla_componente," ", coalesce(obligatorio(malla_obligatorio),'')) AS tipologia, pro_id AS programa FROM asignatura
NATURAL JOIN malla;

-- Vista que muestra las asignaturas y los grupos disponibles por cada una
DROP VIEW IF EXISTS vw_asignatura_grupos;
CREATE VIEW vw_asignatura_grupos AS
SELECT asignatura.asi_nombre AS asignatura, grupo_info.gru_pro_componente AS componente, grupo.gru_numero AS grupo, 
grupo.gru_cupos AS cupos, CONCAT(grupo_info.info_edificio, " - ", grupo_info.info_salon,' ', GROUP_CONCAT(CONCAT(grupo_info.info_fecha, " ", grupo_info.info_hora_inicio, "-", grupo_info.info_hora_final) SEPARATOR '\r\n')) 
AS espacio FROM grupo NATURAL JOIN grupo_info NATURAL JOIN asignatura 
GROUP BY asignatura.asi_nombre,grupo_info.gru_pro_componente,(grupo_info.gru_numero) ORDER BY asi_nombre,gru_numero;

-- Vista que muestra la cantidad de grupos y cupos disponibles por asignatura
DROP VIEW IF EXISTS vw_grupos_disponibles;
CREATE VIEW vw_grupos_disponibles AS
SELECT asi_nombre as nombre,asignatura.asi_codigo as codigo,asi_creditos AS creditos,
CONCAT(malla_componente," ", COALESCE(obligatorio(malla_obligatorio),'')) AS tipo, COUNT(grupo.gru_numero) AS grupos_disponibles,
SUM(grupo.gru_cupos) AS cupos_disponibles
FROM asignatura NATURAL JOIN malla left JOIN grupo on (malla.asi_codigo = grupo.asi_codigo)
GROUP BY asi_nombre, asignatura.asi_codigo, asi_creditos, malla_componente, malla_obligatorio;

-- Vista para el buscador de cursos con grupos
DROP VIEW IF EXISTS vw_grupos_disponibles2;
CREATE VIEW vw_grupos_disponibles2 AS
SELECT DISTINCT asi_codigo as codigo,asignatura.asi_nombre AS asignatura, grupo_info.gru_pro_componente AS componente, grupo.gru_numero AS grupo, 
grupo.gru_cupos AS cupos, CONCAT(grupo_info.info_edificio, " - ", grupo_info.info_salon,' ', GROUP_CONCAT(CONCAT(grupo_info.info_fecha, " ", grupo_info.info_hora_inicio, "-", grupo_info.info_hora_final) SEPARATOR '\r\n')) AS espacio,
concat(persona.per_nombre,' ',persona.per_apellidos) AS profesor FROM grupo NATURAL JOIN grupo_info NATURAL JOIN asignatura NATURAL JOIN profesor NATURAL JOIN persona 
GROUP BY asignatura.asi_nombre,(grupo_info.gru_numero) ORDER BY asi_nombre,gru_numero;

-- Vista para ver el calendario académico
DROP VIEW IF EXISTS vw_calendario_academico;
CREATE VIEW vw_calendario_academico AS
SELECT sede.sed_nombre, evento.cal_ano, evento.cal_semestre, calendario_academico.acuerdo, evento.actividad, evento.responsable
FROM calendario_academico NATURAL JOIN evento NATURAL JOIN sede;

-- Consulta de las vistas definidas
SELECT * FROM vw_fac_pro_sed;
SELECT * FROM vw_pro_asignatura;
SELECT * FROM vw_asignatura_prereq; 
SELECT * FROM vw_calificacion_grupo;
SELECT * FROM vw_calificacion_asig;
SELECT * FROM vw_cita_inscrip;
SELECT * FROM vw_docentes_act;
SELECT * FROM vw_estudiantes_act;
SELECT * FROM vw_historia_academica;
SELECT * FROM vw_estudiantes_pregrado;
SELECT * FROM vw_estudiantes_posgrado;
SELECT * FROM vw_estudiantes_doble;
SELECT * FROM vw_estudiantes_reserva;
SELECT * FROM vw_ceremonia_grado;
SELECT * FROM vw_solicitud_inscripcion_grado;
SELECT * FROM vw_datos_personales_estudiante;
SELECT * FROM vw_datos_personales_profesor;
SELECT * FROM vw_buscador_cursos;
SELECT * FROM vw_asignatura_grupos;
SELECT * FROM vw_grupos_disponibles;
SELECT * FROM vw_grupos_disponibles2;
SELECT * FROM vw_calendario_academico;