use academico;
-- comando para permitir la creación de funciones:
SET @@global.log_bin_trust_function_creators = 1;
/* FUNCIONES DISEÑADAS PARA EL MODELO */

-- obtiene el semestre actual ya que es bastante usado en diferentes procedimientos e incluso funciones
drop function if exists obtenerSemestreActual;
delimiter $$
create function obtenerSemestreActual()
	returns int
    begin
		declare semestre int;
        if month(curdate()) <= 6 then
			set semestre = 1;
		else 
			set semestre = 2;
		end if;
        return semestre;
	end$$
delimiter ;

-- devolver aprobado o no aprobado en caso del valor booleano de las calificaciones
drop function if exists aprobacion;
delimiter $$
create function aprobacion(aprobacion TINYINT)
	returns varchar(12)
    begin
		if aprobacion = 1 then
			return 'APROBADA';
		else 
			return 'NO APROBADA';
		end if;
	end$$
delimiter ;

-- devolver obligatoria u optativa para la tipología de la asignatura
drop function if exists obligatorio;
delimiter $$
create function obligatorio(componente TINYINT)
	returns varchar(12)
    begin
		if componente = 1 then
			return 'OBLIGATORIA';
		elseif componente = 0 then
			return 'OPTATIVA';
		else
			return null;
		end if;
	end$$
delimiter ;

-- obtener PAPA de un estudiante
drop function if exists getPAPA;
delimiter $$
create function getPAPA(usuario VARCHAR(20),programa INT)
	returns double
    begin
		declare historia_cod int;
		declare documento BIGINT(10);
        declare PAPA double;
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        select his_PAPA into PAPA from historia_academica where his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate());
		return round(PAPA,1);
	end$$
delimiter ;

-- obtener PAPPI de un estudiante
drop function if exists getPAPPI;
delimiter $$
create function getPAPPI(usuario VARCHAR(20),programa INT)
	returns double
    begin
		declare historia_cod int;
		declare documento BIGINT(10);
        declare PAPPI double;
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        select his_PAPPI into PAPPI from historia_academica where his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate());
		return round(PAPPI,1);
	end$$
delimiter ;

-- obtener porcentaje de avance de un estudiante dado su usuario y programa
drop function if exists getAvance;
delimiter $$
create function getAvance(usuario VARCHAR(20),programa int)
	returns double
    begin 
		declare historia_cod int;
		declare documento BIGINT(10);
        declare creditos_aprobados INT;
        declare creditos_exigidos INT;
        declare avance float;
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        select pro_creditos_exigidos into creditos_exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into creditos_aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where pro_id = programa;
		set avance = (creditos_aprobados/(creditos_exigidos+12))*100;
        return round(avance,2);
    end$$
delimiter ;

-- obtener creditos cancelados totales de un estudiante dado su usuario y programa
drop function if exists getTotalCreditosCancelados;
delimiter $$
create function getTotalCreditosCancelados(usuario VARCHAR(20),programa int)
	returns int
    begin 
		declare historia_cod int;
		declare documento BIGINT(10);
        declare total INT;
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        (select sum(asi_creditos) into total from inscripcion natural join asignatura where ins_cancelacion = 1 and ins_influencia_creditos = 1);
		return IFNULL(total,0);
    end$$
delimiter ;

-- obtener creditos cancelados en el periodo consultado de un estudiante dado su usuario y programa
drop function if exists getCreditosCanceladosActual;
delimiter $$
create function getCreditosCanceladosActual(usuario VARCHAR(20),programa int)
	returns double
    begin 
		declare historia_cod int;
		declare documento BIGINT(10);
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
		return coalesce((select sum(asi_creditos) from inscripcion natural join asignatura where ins_cancelacion = 1 and ins_influencia_creditos = 1 and his_ano = year(curdate()) and his_semestre = obtenerSemestreActual()),0);
    end$$
delimiter ;

-- obtener creditos excedentes
drop function if exists getCreditosExcedentes;
delimiter $$
create function getCreditosExcedentes(usuario VARCHAR(20),programa int)
	returns double
    begin 
		declare historia_cod int;
		declare documento BIGINT(10);
        declare creditos_exi int;
        declare creditos_apro int;
        declare cupo_creditos int;		
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select pro_creditos_exigidos into creditos_exi from programa where pro_id = programa;
        select sum(asi_creditos) into creditos_apro from calificacion natural join asignatura where cal_aprobado = 1;
        if creditos_exi <= creditos_apro then
			call cupo_creditos(usuario,programa,@excedentes);
            return @excedentes;
		else
			return 0;
		end if;
    end$$
delimiter ;

-- obtiene el inicio de la semana de adiciones y cancelación de asignatura
drop function if exists obtenerInAdiCan;
delimiter $$
create function obtenerInAdiCan()
	returns date
    begin
		declare fechainicio date;
		select fecha into fechainicio from calendario_academico NATURAL JOIN evento where 
        year(curdate())=calendario_academico.cal_ano and obtenerSemestreActual()=calendario_academico.cal_semestre
        and evento.actividad like 'Inicio de adición y cancelación de asignaturas sin pérdida de créditos';
        return fechainicio;
	end$$
delimiter ;

-- obtiene el fin de la semana de adiciones y cancelación de asignatura
drop function if exists obtenerFinAdiCan;
delimiter $$
create function obtenerFinAdiCan()
	returns date
    begin
		declare fechafin date;
		select fecha into fechafin from calendario_academico NATURAL JOIN evento where 
        year(curdate())=calendario_academico.cal_ano and obtenerSemestreActual()=calendario_academico.cal_semestre
        and evento.actividad like 'Fin de adición y cancelación de asignaturas sin pérdida de créditos';
        return fechafin;
	end$$
delimiter ;

-- obtiene la última semana en que se pueden cancelar materias sin solicitud al consejo de facultad
drop function if exists obtenerFinCanSinSolicitud;
delimiter $$
create function obtenerFinCanSinSolicitud()
	returns date
    begin
		declare fechafin date;
		select fecha into fechafin from calendario_academico NATURAL JOIN evento where 
        year(curdate())=calendario_academico.cal_ano and obtenerSemestreActual()=calendario_academico.cal_semestre
        and evento.actividad like 'Última semana de cancelación de asignaturas con pérdida de créditos';
        return fechafin;
	end$$
delimiter ;