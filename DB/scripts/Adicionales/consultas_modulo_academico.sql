use academico;


-- consultas complejas
-- primera consulta: Buscador de cursos
select asi_codigo,asi_nombre,gru_numero,gru_pro_componente,gru_cupos,info_edificio,info_salon,info_fecha,concat(info_hora_inicio,'-',info_hora_final),concat(per_nombre," ",per_apellidos) as Profesor,pro_num_oficina,pro_grupo_investigacion from 
(select * from 
	(select * from 
		(select * from 
			(select * from 
				(select * from grupo natural join asignatura where gru_activo=1) as AsignaturasVigentes 
                natural join grupo_info) as BuscadorCursos
		natural join profesor) as ProfesoresIdentificados 
	natural join vinculado) as ProfesoresVinculados) as Final
natural join persona;
-- segunda consulta: promedios ordenados de manera descendente de un programa especifico en un periodo dado
select per_documento_identidad,per_nombre,his_PAPA from (select * from (select * from historia_academica natural join persona where his_ano = 2023 and his_semestre = 2) as historiaActual natural join programa) as consultaFinal where pro_nombre = "Ingeniería Industrial" and pro_id = 1032 order by (his_PAPA) desc;
-- tercera consulta: promedios ordenados de manera descendente de una facultad en un periodo dado
select per_documento_identidad,per_nombre,his_PAPA from (select * from (select * from historia_academica natural join persona where his_ano = 2023 and his_semestre = 2) as historiasActuales natural join programa where dep_id in (select dep_id from departamento where fac_id = 2312)) as consultaFinal order by (his_PAPA) desc;
-- cuarta consulta: asignaturas que no están siendo ofertadas
select asi_nombre from asignatura where asi_nombre NOT IN (select distinct asi_nombre as asignaturasOfertadas from asignatura natural join grupo where gru_activo = 1);
-- quinta consulta: cantidad de estudiantes activos
select count(per_documento_identidad) from (select distinct per_documento_identidad from historia_academica where his_ano = 2023 and his_semestre = 2 and his_estudiante_activo = 1) as TotalEstudiantesActivos;
-- sexta consulta: Cursos que dicta un profesor dado su numero de identificacion
select distinct per_nombre,asi_nombre,gru_pro_componente from
(select * from (select * from (select * from profesor natural join persona where per_documento_identidad = 3067890123) as NombreProfesor
	natural join grupo_info) as CursosAsociados 
		natural join asignatura) as AsignaturasDadas;
-- séptima consulta: Asignaturas sin prerrequisitos de Ingeniería Industrial
select asi_nombre from (select asi_codigo from malla natural join programa where pro_id=1032 and asi_codigo NOT IN (select asi_codigo1 from prerrequisito where pro_id = 1032)) as AsigIndSinPre natural join asignatura;
-- octava consulta: Asignaturas obligatorias para el programa de Ingeniería de Sistemas sede Bogotá
select asi_nombre from ((select * from malla where pro_id=1023 and malla_obligatorio = 1) as AsignaturasSistemas natural join asignatura);
-- novena consulta: Total de estudiantes egresados en una sede
select count(sol_id) from solicitud_inscripcion_grado natural join ceremonia_grado where sed_id = 3333 and solicitud_inscripcion_grado.cere_id != null and sol_aprobacion = 1;
-- décima consulta: estudiantes ordenados por PAPPI y admision especial
select * from historia_academica natural join estudiante where his_ano = year(curdate()) and his_semestre = obtenerSemestreActual() order by est_admision_especial,his_PAPPI desc;
	