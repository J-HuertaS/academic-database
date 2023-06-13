/* PROCEDIMIENTOS ALMACENADOS */
use academico;
/* GUI ESTUDIANTE */

-- actualizar PAPA de un estudiante dado el código de su historia académica
drop procedure if exists sp_actualizar_PAPA;
delimiter $$
create procedure sp_actualizar_PAPA(IN codigo INT,IN ano INT,IN semestre INT,OUT PAPA double)
	begin
		if ano is null then
			set ano = year(curdate());
		end if;
        if semestre is null then
			set semestre = obtenerSemestreActual();
		end if;
		select (sum(cal_final*asi_creditos)/IFNULL(sum(asi_creditos),0)) into PAPA from calificacion natural join asignatura where his_codigo = codigo and cal_final is not null;
        update historia_academica set his_PAPA = round(PAPA,2) where his_codigo = codigo  and his_ano = year(curdate()) and his_semestre = semestre;
	end$$
delimiter ;

-- actualizar PAPPI de un estudiante dado el código de su historia académica
drop procedure if exists sp_actualizar_PAPPI;
delimiter $$
create procedure sp_actualizar_PAPPI(IN codigo INT,IN ano INT,IN semestre INT,OUT PAPPI DOUBLE)
	begin
        declare sum_creditos int;
		if ano is null then
			set ano = year(curdate());
		end if;
        if semestre is null then
			set semestre = obtenerSemestreActual();
		end if;
        select IFNULL(sum(asi_creditos),0) into sum_creditos from inscripcion natural join asignatura where his_codigo = codigo and ins_influencia_creditos = 1;
		select (sum(cal_final*asi_creditos))/sum_creditos into PAPPI from calificacion natural join asignatura where his_codigo = codigo and cal_final is not null;
        update historia_academica set his_PAPPI = round(PAPPI,2) where his_codigo = codigo  and his_ano = year(curdate()) and his_semestre = semestre;
	end$$
delimiter ;

-- consultar los programas asociados a un estudiante
drop procedure if exists sp_programas_est;
delimiter $$
create procedure sp_programas_est(IN usuario VARCHAR(20))
	begin
		declare documento BIGINT(10);
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
		select distinct CONCAT('(',pro_id,') ',pro_nombre) as programa from historia_academica natural join programa where per_documento_identidad = documento;
	end $$
delimiter ;

-- consultar las asignaturas que ha cursado un estudiante especifico
drop procedure if exists sp_asignaturas_historia;
delimiter $$
create procedure sp_asignaturas_historia(IN usuario VARCHAR(20), IN programa VARCHAR(4))
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
		select concat(asi_nombre,' (',asi_codigo,')') as ASIGNATURAS,asi_creditos as CRÉDITOS,concat(malla_componente,' ',obligatorio(malla_obligatorio)) as TIPO,concat(his_ano,'-',his_semestre,' ',cal_modalidad) as PERIODO,concat(cal_final,' ',aprobacion(cal_aprobado)) as CALIFICACIÓN from (select * from calificacion natural join asignatura where his_codigo = historia_cod) as calificacion natural join malla where pro_id = programa;
	end $$
delimiter ;

-- procedimiento para obtener datos personales seccionados según la necesidad de la GUI
drop procedure if exists sp_info_personal;
delimiter $$
create procedure sp_info_personal(IN usuario VARCHAR(20))
	begin
		declare documento_est BIGINT(10);
        select per_documento_identidad into documento_est from vinculado where vin_usuario = usuario;
        select concat(per_nombre,' ',per_apellidos) as profesor, concat('Correo: ',vin_correo_institucional,' Oficina: ',pro_num_oficina) as info from estudiante_has_tutor join profesor on (prof_per_documento_identidad = profesor.per_documento_identidad) join vinculado join persona on (prof_per_documento_identidad = persona.per_documento_identidad) where estudiante_has_tutor.per_documento_identidad = documento_est;
		-- INFORMACION INICIAL
        select concat(es_nombre,' ',es_apellidos) as NOMBRE_COMPLETO, es_documento_identidad, coalesce(est_etnia,'No informado') as est_etnia,per_sexo_biologico, per_correo_personal, vin_correo_institucional,coalesce(per_telefono_cel,'No informado') as per_telefono_cel,coalesce(per_telefono,'No informado') as per_telefono,vin_codigo,per_nacionalidad,per_fecha_nacimiento,concat('¿Cuenta con libreta militar? ',IF(est_situacion_militar=0,"No","Si")) as est_situacion_militar,concat(res_calle,' ',res_numero,', ',res_ciudad,', Colombia')as direccion,res_estrato,res_codigo_postal from vw_datos_personales_estudiante where es_documento_identidad = documento_est;
		-- INFORMACION DE RESPONSABLES
        select concat(per_nombre,' ',per_apellidos) as NOMBRE_COMPLETO, per_documento_identidad from (select res_per_documento_identidad from estudiante_has_responsable where est_per_documento_identidad = documento_est) as Responsables join persona on per_documento_identidad = res_per_documento_identidad;
    end $$
delimiter ;


-- procedimiento para cargar la actualización de los datos
drop procedure if exists sp_info_personal_act;
delimiter $$
create procedure sp_info_personal_act(IN usuario VARCHAR(20))
	begin
		declare documento_est BIGINT(10);
        select per_documento_identidad into documento_est from vinculado where vin_usuario = usuario;	
        select res_ciudad,res_calle,res_numero,per_telefono_cel, per_telefono,per_correo_personal from vw_datos_personales_estudiante where es_documento_identidad = documento_est;
    end $$
delimiter ;

-- procedimiento para que el estudiante actualice sus datos personales
drop procedure if exists sp_est_actualizar_datos;
delimiter $$
create procedure sp_est_actualizar_datos(IN usuario VARCHAR(20), IN ciudad VARCHAR(17),calle VARCHAR(15),dir_numero VARCHAR(10),telefono_cel BIGINT(10),telefono BIGINT(10), correo_personal VARCHAR(45))
	begin
		declare documento_est BIGINT(10);
        select per_documento_identidad into documento_est from vinculado where vin_usuario = usuario;
		update residencia natural join persona set res_ciudad = ciudad, res_calle = calle, res_numero = dir_numero where per_documento_identidad = documento_est;
        update persona set per_telefono_cel = telefono_cel, per_telefono = telefono, per_correo_personal = correo_personal where per_documento_identidad = documento_est;
        /* NO OLVIDAR CREAR TRIGGER DE UPDATE PARA RESIDENCIA Y PERSONA */
    end $$
delimiter ;


-- procedimiento para generar resumen de creditos
drop procedure if exists sp_resumen_creditos;
delimiter $$
create procedure sp_resumen_creditos(IN usuario VARCHAR(20), IN programa VARCHAR(4))
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
        declare exigidos INT;
        declare aprobados INT;
        declare pendientes INT;
        declare inscritos INT;
        declare cursados INT;
        
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        /* TABLA GENERAL DE RESUMEN DE CRÉDITOS */
        DROP TABLE IF EXISTS resumen;
        CREATE TEMPORARY TABLE resumen (
		tipologia VARCHAR(30),
		exigido INT,
        aprobado INT,
        pendientes INT,
        inscritos INT,
		cursados INT);
        
        /* INSERCIONES */
        -- fila 1
        select sum(pro_cre_DOp) into exigidos from programa where pro_id = programa;
        select IFNULL(IFNULL(sum(asi_creditos),0),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'DISCIPLINAR' and malla_obligatorio = 0 and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(IFNULL(sum(asi_creditos),0),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod  and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente = 'DISCIPLINAR' and malla_obligatorio = 0 and pro_id = programa;
        select IFNULL(IFNULL(sum(asi_creditos),0),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'DISCIPLINAR' and malla_obligatorio = 0 and pro_id = programa;
        insert into resumen (tipologia,exigido,aprobado,pendientes,inscritos,cursados) values ('DISCIPLINAR OPTATIVA',exigidos,aprobados,pendientes,inscritos,cursados);
        -- fila 2
        select sum(pro_cre_FOb) into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'FUNDAMENTACIÓN' and malla_obligatorio = 1 and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod  and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente = 'FUNDAMENTACIÓN' and malla_obligatorio = 1 and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'FUNDAMENTACIÓN' and malla_obligatorio = 1 and pro_id = programa;
        insert into resumen values ('FUND. OBLIGATORIA',exigidos,aprobados,pendientes,inscritos,cursados);
        -- fila 4
        select sum(pro_cre_FOp) into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'FUNDAMENTACIÓN' and malla_obligatorio = 0 and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente = 'FUNDAMENTACIÓN' and malla_obligatorio = 0 and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'FUNDAMENTACIÓN' and malla_obligatorio = 0 and pro_id = programa;
        insert into resumen values ('FUND. OPTATIVA',exigidos,aprobados,pendientes,inscritos,cursados);
        -- fila 5
        select sum(pro_cre_DOb) into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'DISCIPLINAR' and malla_obligatorio = 1 and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente = 'DISCIPLINAR' and malla_obligatorio = 1 and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'DISCIPLINAR' and malla_obligatorio = 1 and pro_id = programa;
        insert into resumen values ('DISCIPLINAR OBLIGATORIA',exigidos,aprobados,pendientes,inscritos,cursados);
       -- fila 6
        select sum(pro_cre_LE) into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'LIBRE ELECCIÓN' and malla_obligatorio is null and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente = 'LIBRE ELECCIÓN' and malla_obligatorio is null and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'LIBRE ELECCIÓN' and malla_obligatorio is null and pro_id = programa;
        insert into resumen values ('LIBRE ELECCIÓN',exigidos,aprobados,pendientes,inscritos,cursados);
        -- fila 7
        select sum(pro_cre_Grado) into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura where asi_nombre = 'TRABAJO DE GRADO') as Creditos natural join malla where malla_obligatorio is null and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and asi_nombre = 'TRABAJO DE GRADO' and ins_cancelacion = 0) as Inscritos natural join malla where malla_obligatorio is null and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Cursados natural join asignatura where asi_nombre = 'TRABAJO DE GRADO') as Creditos natural join malla where malla_obligatorio is null and pro_id = programa;
        insert into resumen values ('TRABAJO DE GRADO',exigidos,aprobados,pendientes,inscritos,cursados);
        -- fila 8
        select sum(pro_creditos_exigidos) into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente not like 'NIVELACIÓN' and pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente not like 'NIVELACIÓN' and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente not like 'NIVELACIÓN' and pro_id = programa;
        insert into resumen values ('TOTAL',exigidos,aprobados,pendientes,inscritos,cursados);
        -- fila 9
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'NIVELACIÓN' and malla_obligatorio is null and pro_id = programa;
        set pendientes = 12 - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where malla_componente = 'NIVELACIÓN' and malla_obligatorio is null and pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where malla_componente = 'NIVELACIÓN' and malla_obligatorio is null and pro_id = programa;
        insert into resumen values ('NIVELACIÓN',12,aprobados,pendientes,inscritos,cursados);
        -- fila 10
        select sum(pro_creditos_exigidos) + 12 into exigidos from programa where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into aprobados from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where pro_id = programa;
        set pendientes = exigidos - aprobados;
        select IFNULL(sum(asi_creditos),0) into inscritos from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where pro_id = programa;
        select IFNULL(sum(asi_creditos),0) into cursados from (select asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod) as Aprobados natural join asignatura) as Creditos natural join malla where pro_id = programa;
        insert into resumen values ('TOTAL ESTUDIANTE',exigidos,aprobados,pendientes,inscritos,cursados);
           
           
       select * from resumen;
		
        drop table if exists resumen;
	end $$
delimiter ;


-- obtener citas asociadas a los programas del estudiante
drop procedure if exists sp_obtener_citas;
delimiter $$
create procedure sp_obtener_citas(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
		declare documento BIGINT(10);
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        if programa is null then
			select distinct pro_nombre as programa,concat('Fecha: ',cit_fecha) as fecha from cita_por_historia_academica natural join historia_academica natural join programa where his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) and cit_fecha > curdate() order by pro_id;
		else
			select distinct pro_nombre as programa,concat('Fecha: ',cit_fecha) as fecha from cita_por_historia_academica natural join historia_academica natural join programa where his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento and pro_id = programa) and cit_fecha > curdate() order by pro_id;
		end if;
    end$$
delimiter ;

-- asignaturas que puede inscribir en cita de inscripcion/cancelacion
drop procedure if exists sp_inscripcion_prerrequisito;
delimiter $$
create procedure sp_inscripcion_prerrequisito(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        

        drop table if exists temporal;
        create temporary table temporal as
        select concat(asi_nombre,' (',asignatura.asi_codigo,')') as asignatura,asi_creditos as creditos,concat(malla_componente,' ',coalesce(obligatorio(malla_obligatorio),''))as tipo,count(grupo.gru_numero) as grupos,coalesce(sum(grupo.gru_cupos),0) as cupos,ins_cancelacion as inscrito from malla natural join prerrequisito natural join asignatura natural join inscripcion left join grupo on (grupo.asi_codigo = asignatura.asi_codigo)
        where asi_codigo_pre IN ((select asi_codigo from calificacion where his_codigo = historia_cod) union 
        (select asi_codigo from asignatura_asociada where id IN (select id from asignatura_asociada where asi_codigo IN (select asi_codigo from calificacion where his_codigo = historia_cod) ))) and asignatura.asi_codigo NOT IN (select asi_codigo from inscripcion where his_codigo = historia_cod and (his_semestre != obtenerSemestreActual() or his_ano != year(curdate()))) and pro_id = programa and his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate()) and ins_cancelacion = 0 group by asignatura.asi_codigo, asi_creditos, CONCAT(malla_componente, ' ', obligatorio(malla_obligatorio)) 
        union all
        select concat(asi_nombre,' (',asignatura.asi_codigo,')') as asignatura,asi_creditos as creditos,concat(malla_componente,' ',coalesce(obligatorio(malla_obligatorio),''))as tipo,count(grupo.gru_numero) as grupos,coalesce(sum(grupo.gru_cupos),0) as cupos,IF(asignatura.asi_codigo IN (select asi_codigo from inscripcion where his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate()) and ins_cancelacion = 0),0,1) as inscrito from malla natural join asignatura left join grupo on (grupo.asi_codigo = asignatura.asi_codigo)
        where asignatura.asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod) and pro_id = programa and asignatura.asi_codigo NOT IN (select asi_codigo from prerrequisito where pro_id = programa) and malla_componente not like 'TRABAJO DE GRADO' group by asignatura.asi_codigo, asi_creditos, CONCAT(malla_componente, ' ', obligatorio(malla_obligatorio))
        order by tipo,inscrito asc;

	

		drop table if exists temporal2;
		drop table if exists temporal3;
        create temporary table temporal2 as select * from temporal;
        create temporary table temporal3 as select * from temporal;
        
		UPDATE temporal
		SET inscrito = 0
		WHERE (asignatura, creditos,tipo) IN (
			SELECT asignatura,creditos,tipo
			FROM temporal2
			GROUP BY asignatura,creditos,tipo
			HAVING COUNT(*) > 1
		)	;
        

        delete from temporal where grupos NOT IN (
			SELECT MAX(grupos)
			FROM temporal2
			GROUP BY asignatura,creditos,tipo
			HAVING COUNT(*) > 1
        ) and asignatura IN (SELECT asignatura
			FROM temporal3
			GROUP BY asignatura,creditos,tipo
			HAVING COUNT(*) > 1);
        
        select distinct * from temporal order by inscrito asc;
        
		drop table if exists temporal;
        drop table if exists temporal2;
        drop table if exists temporal3;
    end $$
delimiter ;


-- mostrar grupos de una asignatura en especifico
drop procedure if exists sp_grupos_por_asignatura;
delimiter $$
create procedure sp_grupos_por_asignatura(IN usuario VARCHAR(20),IN programa VARCHAR(4),IN asig VARCHAR(10))
	begin
		declare asignatura_nom VARCHAR(90);
        declare historia_cod int;
		declare documento BIGINT(10);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        
        select asi_nombre into asignatura_nom from asignatura where asi_codigo = asig;
		select concat(asignatura_nom,' (',asig,')') as asignatura,gru_numero as grupo,gru_cupos as cupos,IF(gru_numero IN (select gru_numero from inscripcion where asi_codigo = asig and his_semestre = obtenerSemestreActual() and his_ano = year(curdate()) and ins_cancelacion = 0 and his_codigo = historia_cod),0,1) as inscrita from grupo natural join asignatura where asi_codigo = asig and gru_cupos > 0;
    end $$
delimiter ;

-- mostrar grupos de una asignatura en especifico para sobrecupos
drop procedure if exists sp_grupos_por_asignatura_sc;
delimiter $$
create procedure sp_grupos_por_asignatura_sc(IN usuario VARCHAR(20),IN programa VARCHAR(4),IN asig VARCHAR(10))
	begin
		declare asignatura_nom VARCHAR(90);
        declare historia_cod int;
		declare documento BIGINT(10);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        
        select asi_nombre into asignatura_nom from asignatura where asi_codigo = asig;
		select concat(asignatura_nom,' (',asig,')') as asignatura,gru_numero as grupo,gru_cupos as cupos,IF(gru_numero IN (select gru_numero from inscripcion where asi_codigo = asig and ins_cancelacion = 0 and his_semestre = obtenerSemestreActual() and his_ano = year(curdate()) and his_codigo = historia_cod),0,1) as inscrita from grupo natural join asignatura where asi_codigo = asig;
    end$$
delimiter ;

-- mostrar asignaturas de libre elección en proceso de inscripcion/cancelacion
drop procedure if exists sp_inscripcion_le;
delimiter $$
create procedure sp_inscripcion_le(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
    
        declare historia_cod int;
		declare documento BIGINT(10);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        

        select concat('(',asignatura.asi_codigo,') ',asi_nombre) as asignatura, asi_creditos as creditos,concat(malla_componente,' ',coalesce(obligatorio(malla_obligatorio),'')) as tipo, count(gru_numero) as grupos,coalesce(sum(gru_cupos),0) as cupos,IF(asignatura.asi_codigo IN (select asi_codigo from inscripcion where his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate()) and ins_cancelacion = 0),0,1) as inscrito from asignatura natural join malla left join grupo on (grupo.asi_codigo = asignatura.asi_codigo) where pro_id = '2CLE' group by asignatura.asi_codigo,malla_componente,asi_creditos;
    end $$
delimiter ;


-- mostrar asignaturas de libre elección en proceso de inscripcion/cancelacion
drop procedure if exists sp_inscripcion_sobrecupo;
delimiter $$
create procedure sp_inscripcion_sobrecupo(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
        declare historia_cod int;
		declare documento BIGINT(10);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        
		
        drop table if exists temporal;
        create temporary table temporal as
		select concat(asi_nombre,' (',asignatura.asi_codigo,')') as asignatura,asi_creditos as creditos,concat(malla_componente,' ',obligatorio(malla_obligatorio))as tipo,count(grupo.gru_numero) as grupos,coalesce(sum(grupo.gru_cupos),0) as cupos from malla natural join prerrequisito natural join asignatura left join grupo on (grupo.asi_codigo = asignatura.asi_codigo)
        where asi_codigo_pre IN ((select asi_codigo from calificacion where his_codigo = historia_cod) union 
        (select asi_codigo from asignatura_asociada where id IN (select id from asignatura_asociada where asi_codigo IN (select asi_codigo from calificacion where his_codigo = historia_cod) ))) and asignatura.asi_codigo NOT IN (select asi_codigo from inscripcion where his_codigo = historia_cod and ins_cancelacion = 0 and (his_semestre != obtenerSemestreActual() or his_ano != year(curdate()))) and asignatura.asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod) and pro_id = programa group by asignatura.asi_codigo, asi_creditos, CONCAT(malla_componente, ' ', obligatorio(malla_obligatorio)) having sum(gru_cupos) = 0 and count(gru_numero) != 0;
        

        select * from temporal;
        
		drop table if exists temporal;

    end $$
delimiter ;

-- mostrar grupos de asignatura especifica
drop procedure if exists sp_grupos_sobrecupo;
delimiter $$
create procedure sp_grupos_sobrecupo(IN asignatura VARCHAR(10))
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        
        select concat(asi_nombre,' (',asi_codigo,')'),gru_numero from grupo where asi_codigo = asignatura;
    end $$
delimiter ;

-- mostrar cupo de creditos. Procedimiento aplicado en la GUI del rol estudiante
drop procedure if exists sp_cupo_creditos;
delimiter $$
create procedure sp_cupo_creditos(IN usuario VARCHAR(20),IN programa VARCHAR(4),OUT creditos_disponibles INT)
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
        declare cupo_creditos int;
        declare creditos_adicionales int;
        declare creditos_doble_tit int;
        declare creditos_disponibles int;
        
        select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        
        set cupo_creditos = IF((select pro_creditos_exigidos from programa where pro_id = programa)/2 > 80,80,(select pro_creditos_exigidos from programa where pro_id = programa)/2);
        if (select est_nivelacion_mat from estudiante where per_documento_identidad = documento) = 1 then
			set cupo_creditos = cupo_creditos + 4;
		end if;
        
		if (select est_nivelacion_lecto from estudiante where per_documento_identidad = documento) = 1 then
			set cupo_creditos = cupo_creditos + 4;
		end if;
        
		if (select est_nivelacion_ingles from estudiante where per_documento_identidad = documento) != 5 and (select est_nivelacion_ingles from estudiante where per_documento_identidad = documento) then
			set cupo_creditos = cupo_creditos + 3*(select coalesce(est_nivelacion_ingles,0) from estudiante where per_documento_identidad = documento);
		end if;
        
        set cupo_creditos = cupo_creditos + (select 2*IFNULL(sum(asi_creditos),0) from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where pro_id = programa) + 2*(select IFNULL(sum(asi_creditos),0) from (select distinct * from inscripcion natural join asignatura where his_codigo = historia_cod and ins_cancelacion = 0 and asi_codigo NOT IN (select asi_codigo from calificacion where his_codigo = historia_cod)) as Inscritos natural join malla where pro_id = programa);
		set creditos_disponibles = cupo_creditos - (select pro_creditos_exigidos from programa where pro_id = programa) + (select IFNULL(sum(asi_creditos),0) from (select asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where pro_id = programa);
        select IFNULL(sum(asi_creditos),0)*2 into creditos_adicionales from (select distinct asi_creditos,asi_codigo from (select his_codigo,asi_codigo from calificacion where his_codigo = historia_cod and cal_aprobado = 1) as Aprobados natural join asignatura) as Creditos natural join malla where pro_id = programa;
        set creditos_adicionales = IF(creditos_adicionales>80,80,creditos_adicionales);
		set creditos_doble_tit = creditos_adicionales;
        select IF(creditos_adicionales>80,80,creditos_adicionales) as cre_adicionales,cupo_creditos,IF(creditos_disponibles<0,0,creditos_disponibles) as cre_adicionales,IF(creditos_doble_tit>80,80,creditos_doble_tit) as cre_doble_tit;
    end$$
delimiter ;

DROP PROCEDURE IF EXISTS sp_AsignaturasInscritas;
DELIMITER $$
CREATE PROCEDURE sp_AsignaturasInscritas(IN usuario VARCHAR(255), IN programa INT)
BEGIN
	declare historia_cod int;
	declare documento BIGINT(10);
       
	select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
	select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;

	SELECT asignatura.asi_nombre AS asignatura, grupo.gru_numero AS grupo, grupo_info.gru_pro_componente as componente,
    CONCAT(coalesce(grupo_info.info_edificio,''),"-",grupo_info.info_salon," ",GROUP_CONCAT(CONCAT(grupo_info.info_fecha, " ", grupo_info.info_hora_inicio, "-", grupo_info.info_hora_final)))
    AS espacio, grupo_info.gru_pro_componente AS componente FROM inscripcion NATURAL JOIN grupo NATURAL JOIN grupo_info
    NATURAL JOIN asignatura
    WHERE inscripcion.ins_cancelacion=0 AND inscripcion.his_ano=YEAR(CURDATE()) AND inscripcion.his_semestre=obtenerSemestreActual()
    AND inscripcion.his_codigo = historia_cod group by asignatura.asi_nombre,grupo.gru_numero,inscripcion.his_codigo,grupo_info.gru_pro_componente;
END$$
DELIMITER ;
-- procedimiento para buscador de cursos
drop procedure if exists sp_buscador_cursos;
delimiter $$
create procedure sp_buscador_cursos(IN pro VARCHAR(4),IN tipo VARCHAR(30),IN cre INT,IN nombre VARCHAR(90),IN dias TEXT)
	begin
		if (tipo not like "TODAS MENOS LIBRE ELECCIÓN") then 
            call sp_InsertarElementos(dias);
			select * from (select * from vw_buscador_cursos where programa = pro and if(tipo is null,tipologia=tipologia,tipologia=tipo) and if(cre is null,creditos=creditos,creditos=cre) and if(nombre is null,asignatura=asignatura,asignatura like nombre)) as subconsulta;
		else
			if (tipo like "TODAS MENOS LIBRE ELECCIÓN") then 
				select * from (select * from vw_buscador_cursos where programa = pro and tipo not like "LIBRE ELECCIÓN" and if(cre is null,creditos=creditos,creditos=cre) and if(nombre is null,asignatura=asignatura,nombre=asignatura)) as subconsulta;
			else 
				select * from vw_buscador_cursos where pro = programa and if(tipo is null,tipologia=tipologia,tipologia=tipo) and if(cre is null,creditos=creditos,creditos=cre) and if(nombre is null,asignatura=asignatura,nombre=asignatura);
			end if;
		end if;
	end$$
delimiter ;

-- procedimiento para buscador de cursos por asignatura
drop procedure if exists sp_buscador_cursos_por_asignatura;
delimiter $$
create procedure sp_buscador_cursos_por_asignatura(IN asignatur VARCHAR(10),IN programa VARCHAR(4))
	begin
    
		declare nombre VARCHAR(200);
        declare agrupacion INT;
        declare aux INT;
        
		drop table if exists temp;
		create temporary table temp (
		id VARCHAR(36),
        asignatura_codigo VARCHAR(30),
        asignatura_nombre VARCHAR(200)
        );
        
        select asi_nombre into nombre from asignatura where asi_codigo = asignatur;
		select nombre,componente,grupo,cupos,espacio,profesor from vw_grupos_disponibles2 where codigo = asignatur;
        select id into agrupacion from asignatura_asociada where asi_codigo = asignatur;
        
        insert into temp (asignatura_codigo,asignatura_nombre)
        select distinct asi_codigo_pre,asi_nombre from prerrequisito join asignatura on (asignatura.asi_codigo = prerrequisito.asi_codigo_pre) where prerrequisito.asi_codigo = asignatur and pro_id = programa
        union all
        select asi_codigo,asi_nombre from asignatura_asociada natural join asignatura where id IN (select distinct id from asignatura_asociada where asi_codigo IN (select distinct asi_codigo_pre from prerrequisito join asignatura on (asignatura.asi_codigo = prerrequisito.asi_codigo_pre) where prerrequisito.asi_codigo = asignatur and pro_id = programa));
        
        
        update temp join asignatura_asociada on (temp.asignatura_codigo = asignatura_asociada.asi_codigo)
        set temp.id = CONVERT(asignatura_asociada.id, CHAR(36));
        
        -- Asignar un ID aleatorio a los registros con ID nulo
		UPDATE temp
		SET id = UUID()
		WHERE id IS NULL;
        
		CREATE TEMPORARY TABLE temp_unique AS
		SELECT DISTINCT id, asignatura_codigo, asignatura_nombre
		FROM temp;
	

        if ((select count(*) from temp_unique) > 0) then 
			select group_concat(concat(asignatura_codigo,' - ',asignatura_nombre) separator '//') as asignatura from temp_unique group by (id);
		else
			select 'Asignatura sin prerrequisitos.' as asignatura;
		end if;
        
        drop table if exists temp;
	end$$
delimiter ;

-- procedimiento para generar el horario del estudiante.
drop procedure if exists sp_horario_est;
delimiter $$
create procedure sp_horario_est(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
        
        declare lunes TEXT(5000);
        declare martes TEXT(5000);
        declare miercoles TEXT(5000);
        declare jueves TEXT(5000);
        declare viernes TEXT(5000);
        declare sabado TEXT(5000);
        declare domingo TEXT(5000);
       
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        
        
        if programa is not null then
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into lunes FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'lunes' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into martes FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'martes' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into miercoles FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'miércoles' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into jueves FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'jueves' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into viernes FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'viernes' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into sabado FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'sabado' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into domingo FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo = historia_cod AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'domingo' and ins_cancelacion = 0;
		else 
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into lunes FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'lunes' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into martes FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'martes' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into miercoles FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'miércoles' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into jueves FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'jueves' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into viernes FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'viernes' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into sabado FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'sabado' and ins_cancelacion = 0;
			SELECT coalesce(GROUP_CONCAT(concat(info_hora_inicio,'\n',asi_nombre) SEPARATOR '\n'),'') AS registros_concatenados into domingo FROM inscripcion NATURAL JOIN asignatura NATURAL JOIN grupo_info WHERE his_codigo IN (select distinct his_codigo from historia_academica where per_documento_identidad = documento) AND his_ano = YEAR(CURDATE()) AND his_semestre = obtenerSemestreActual() AND info_fecha = 'domingo' and ins_cancelacion = 0;
		end if;
        
        DROP TABLE IF EXISTS dias_semana;
		CREATE TEMPORARY TABLE dias_semana (
			Lunes TEXT(5000),
			Martes TEXT(5000),
			Miércoles TEXT(5000),
			Jueves TEXT(5000),
			Viernes TEXT(5000),
			Sábado TEXT(5000),
			Domingo TEXT(5000));
		
	INSERT INTO dias_semana (Lunes, Martes, Miércoles, Jueves, Viernes, Sábado, Domingo)
	VALUES (lunes,martes,miercoles,jueves,viernes,sabado,domingo);

	SELECT * FROM dias_semana;
    
     if programa is not null then
		select info_fecha,group_concat(concat(asi_nombre,'\nGrupo: ',gru_numero,'\nProfesor: ',per_nombre,' ',per_apellidos,'\nComponente: ',gru_pro_componente,'\nLugar: ',coalesce(info_edificio,''),'-',info_salon,'\nFranja Horaria: ',info_hora_inicio,' - ',info_hora_final) separator '\n') as dia
		from inscripcion natural join asignatura natural join grupo_info natural join persona where his_codigo = historia_cod and his_ano = year(curdate()) and his_semestre = obtenerSemestreActual() and ins_cancelacion = 0 group by info_fecha;
	else
		select info_fecha,group_concat(concat(asi_nombre,'\nGrupo: ',gru_numero,'\nProfesor: ',per_nombre,' ',per_apellidos,'\nComponente: ',gru_pro_componente,'\nLugar: ',coalesce(info_edificio,''),'-',info_salon,'\nFranja Horaria: ',info_hora_inicio,' - ',info_hora_final) separator '\n') as dia
		from inscripcion natural join asignatura natural join grupo_info natural join persona where his_codigo in (select distinct his_codigo from historia_academica where per_documento_identidad = documento) and his_ano = year(curdate()) and his_semestre = obtenerSemestreActual() and ins_cancelacion = 0 group by info_fecha;
	end if;
    end $$
delimiter ;

-- procedimiento que dado una sede, retorne todas las facultades
drop procedure if exists sp_facultades_buscador;
delimiter $$
create procedure sp_facultades_buscador(IN sede INT,IN nivel VARCHAR(25))
	begin
        select concat(fac_id,' ',fac_nombre) as facultad from facultad where if(sede is null,sed_id=sed_id,sed_id=sede) and sed_id IN (select sed_id from programa where pro_grado_de_licenciatura = nivel);
	end$$
delimiter ;
            
-- procedimiento que dada una facultad, retorne todos los programas
drop procedure if exists sp_programas_por_facultades;
delimiter $$
create procedure sp_programas_por_facultades(IN facultad INT)
	begin
        select concat(pro_id,' ',pro_nombre) as programa from programa where dep_id IN (select dep_id from departamento where fac_id = facultad);
	end$$
delimiter ;

-- procedimiento que encapsula todos los procedimientos para ejecutar historia academica
drop procedure if exists sp_historia_academica;
delimiter $$
create procedure sp_historia_academica(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
		declare doc INT;
        select per_documento_identidad into doc from vinculado where vin_usuario = usuario; 
        select concat('(',programa,') ',pro_nombre) as programa from programa where pro_id = programa;
        select concat(year(curdate()),'-',obtenerSemestreActual()) as periodo;
        select distinct his_codigo as historia from historia_academica where per_documento_identidad = doc and pro_id = programa;
        select getPAPA(usuario,programa) as PAPA;
        select getPAPPI(usuario,programa) as PAPPI;
        call sp_asignaturas_historia(usuario,programa);
	end$$
delimiter ;

-- procedimiento que encapsula todos los procedimientos para ejecutar resumen de creditos
drop procedure if exists sp_encap_resumen_creditos;
delimiter $$
create procedure sp_encap_resumen_creditos(IN usuario VARCHAR(20),IN programa VARCHAR(4))
	begin
		declare creditos_disponibles INT;
		call sp_resumen_creditos(usuario,programa);
        call sp_cupo_creditos(usuario,programa,creditos_disponibles);
        select getAvance(usuario,programa) as Avance;
        select getTotalCreditosCancelados(usuario,programa) as Cancelados;
        select getCreditosExcedentes(usuario,programa) as Excedentes;
	end$$
delimiter ;

-- procedimiento para solicitar sobrecupo
drop procedure if exists sp_solicitar_sobrecupo;
delimiter $$
create procedure sp_solicitar_sobrecupo(IN usuario VARCHAR(20),IN id_pro INT, IN asignatura VARCHAR(10),IN grupo INT,IN prioridad TINYINT(1))
	begin
		declare historia_cod int;
		declare documento BIGINT(10);
        DECLARE custom_error CONDITION FOR SQLSTATE '45000';

		
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = id_pro;
        START TRANSACTION;
        insert into solicitud_sobrecupo (his_codigo,his_semestre,his_ano,gru_numero,asi_codigo,sol_prioridad_inscripcion) values (historia_cod,obtenerSemestreActual(),year(curdate()),grupo,asignatura,prioridad);
        if (select count(asi_codigo) from solicitud_sobrecupo where his_ano = year(curdate()) and his_semestre = obtenerSemestreActual() and his_codigo = historia_cod) > 1 then
			SIGNAL custom_error SET MESSAGE_TEXT = 'No puedes solicitar dos veces un sobrecupo a la misma asignatura';
            ROLLBACK;
		else
			COMMIT;
		end if;
    end $$
delimiter ;
/* PROCEDIMIENTOS PARA DIRRECIÓN DE REGISTRO Y MATRÍCULA */

-- procedimiento para generar historia académica de estudiante "nuevo"
drop procedure if exists sp_generate_historia_nueva;
delimiter $$
create procedure sp_generate_historia_nueva(INOUT est_doc_id BIGINT(10),IN id_pro INT)
	begin
		declare codigo INT default 1;
		set codigo = (select max(his_codigo) from historia_academica) + 1;
		insert into his_academica (his_codigo,his_ano,his_semestre,per_documento_identidad) values (codigo,year(curdate()),obtenerSemestreActual(),est_doc_id);
    end $$
delimiter ;

-- procedimiento para generar historias académicas de estudiantes
drop procedure if exists sp_generate_historias;
delimiter $$
create procedure sp_generate_historias()
	begin
        insert into historia (his_codigo,his_ano,his_semestre,per_documento_identidad)
		select distinct his_codigo, IF(his_semestre = 2,his_ano + 1,his_ano), IF(his_semestre = 2, 1, his_semestre + 1),per_documento_identidad AS nuevo_semestre
		from historia;
    end $$
delimiter ;

-- procedimiento para traslado de programa de estudiante
drop procedure if exists sp_traslado_programa;
delimiter $$
create procedure sp_traslado_programa(IN historia INT,IN programa_nuevo VARCHAR(4))
	begin
		declare documento INT;
        select per_documento_identidad into documento from historia_academica where his_codigo = historia;
        call sp_generate_historia_nueva(documento,programa_nuevo);
        update historia_academico set his_traslado = 1 where his_codigo = documento;
    end $$
delimiter ;

-- crear grupo 
drop procedure if exists sp_nuevo_grupo;
delimiter $$
create procedure sp_nuevo_grupo(IN codigo_asi INT, IN cupos INT)
	sp: begin
        declare contador INT default 1;
        while 1 do
			if contador IN (select gru_numero from grupo where asi_codigo = codigo_asi) then
				set contador = contador + 1;
			else
				insert into grupo (gru_numero,asi_codigo,gru_cupos) values (contador,codigo_asi,cupos);
				leave sp;
			end if;
		end while;
    end $$
delimiter ;

-- eliminar grupo
drop procedure if exists sp_borrar_grupo;
delimiter $$
create procedure sp_borrar_grupo(IN codigo_asi INT, IN grupo INT)
	begin
        delete from grupo where asi_codigo = codigo_asi and gru_numero = grupo;
	end$$
delimiter ;

-- mostrar resumen del proceso de inscripción/cancelacion
drop procedure if exists sp_resumen_ins_can;
delimiter $$
create procedure sp_insertar_calificacion_no_doc(IN historia int,IN modalidad VARCHAR(20),IN calificacion float, IN asignatura INT)
	begin
		insert into inscripcion values (0,1,null,asignatura,historia,year(curdate()),obtenerSemestreActual(),null);
		insert into calificacion values (null,null,null,calificacion,0,null,asignatura,historia,year(curdate()),obtenerSemestreActual(),modalidad);
        /* RECORDAR TRIGGER DE INSERCIÓN DE CALIFICACIÓN */
    end$$
delimiter ;


-- insertar calificacion sin inscripcion (homologación, equivalencia, etc)
drop procedure if exists sp_insertar_calificacion_no_doc;
delimiter $$
create procedure sp_insertar_calificacion_no_doc(IN historia int,IN modalidad VARCHAR(20),IN calificacion float, IN asignatura INT)
	begin
		insert into inscripcion values (0,1,null,asignatura,historia,year(curdate()),obtenerSemestreActual(),null);
		insert into calificacion values (null,null,null,calificacion,0,null,asignatura,historia,year(curdate()),obtenerSemestreActual(),modalidad);
        /* RECORDAR TRIGGER DE INSERCIÓN DE CALIFICACIÓN */
    end$$
delimiter ;

-- procedimiento para seleccionar rol
DROP PROCEDURE IF EXISTS sp_seleccionar_rol;
DELIMITER $$
CREATE PROCEDURE sp_seleccionar_rol(IN rol VARCHAR(30))
BEGIN
    DECLARE mensaje_error VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET mensaje_error = "Error: Usted no tiene acceso a este rol. Pruebe ingresando a otro.";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje_error;
    END;
    
    START TRANSACTION;
    SET ROLE rol;
    COMMIT;
END$$
DELIMITER ;



-- procedimiento para inscribir materia
drop procedure if exists sp_inscribir_asig;
delimiter $$
create procedure sp_inscribir_asig(IN usuario VARCHAR(20),IN programa VARCHAR(4),IN asignatura VARCHAR(10),IN grupo INT,IN seleccion BOOLEAN)
	BEGIN
		declare historia_cod int;
		declare documento BIGINT(10);
		declare aparicion BOOLEAN;
        declare cita datetime;
        
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			RESIGNAL;
		END;
        
		select per_documento_identidad into documento from vinculado where vin_usuario = usuario;
        select distinct his_codigo into historia_cod from historia_academica where per_documento_identidad = documento and pro_id = programa;
        SELECT SUBTIME(DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:00'), SEC_TO_TIME((MINUTE(NOW()) % 30) * 60)) AS rounded_time into cita;



		select IF(asignatura IN (select asi_codigo from inscripcion where his_ano = year(curdate()) and his_semestre = obtenerSemestreActual()),true,false) into aparicion;
        START TRANSACTION;
		if aparicion then
			if seleccion then
				delete from inscripcion where asi_codigo = asignatura and his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate());
				-- insert into inscripcion values (0,1,grupo,asignatura,historia_cod,obtenerSemestreActual(),year(curdate()),cita);
                 insert into inscripcion values (0,1,grupo,asignatura,historia_cod,obtenerSemestreActual(),year(curdate()),null);
			else
				update inscripcion set ins_cancelacion = 1,ins_influencia_creditos = IF(curdate()>(select fecha from calendario_academico natural join evento where actividad = 'Fin de adición y cancelación de asignaturas sin pérdida de créditos' and cal_ano = year(curdate()) and cal_semestre = obtenerSemestreActual() and sed_id = (select sed_id from programa where pro_id = programa)),1,0)
                where gru_numero = grupo and asi_codigo = asignatura and his_codigo = historia_cod and his_semestre = obtenerSemestreActual() and his_ano = year(curdate());
			end if;
		else
			if seleccion then
				insert into inscripcion values (0,1,grupo,asignatura,historia_cod,obtenerSemestreActual(),year(curdate()),null);
                -- insert into inscripcion values (0,1,grupo,asignatura,historia_cod,obtenerSemestreActual(),year(curdate()),cita);
			end if;
		end if;
		COMMIT;
	END$$
delimiter ;

DROP PROCEDURE IF EXISTS sp_InsertarElementos;
DELIMITER $$
CREATE PROCEDURE sp_InsertarElementos(IN texto VARCHAR(255))
BEGIN

    -- Elimina espacios en blanco alrededor del texto
    SET texto = TRIM(texto);
    
    drop table if exists dias;
    create temporary table dias (dia VARCHAR(20));
    
	INSERT INTO dias (dia)
	SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(texto, ',', numbers.n), ',', -1) AS elemento
	FROM
	  (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7) numbers
	WHERE
	  FIND_IN_SET(SUBSTRING_INDEX(SUBSTRING_INDEX(texto, ',', numbers.n), ',', -1), texto) > 0;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_CrearCitasInscripcion
DELIMITER $$ 
CREATE PROCEDURE sp_CrearCitasInscripcion(IN fecha1 DATE, IN fecha2 DATE)
BEGIN	
    declare fechainicio DATETIME;
    declare fechafinal DATETIME;
    declare condicion INT;
    IF fecha1<obtenerFinCanSinSolicitud() AND fecha2<obtenerFinCanSinSolicitud() THEN
    set fechainicio	= DATE_ADD(fecha1, INTERVAL 6 HOUR);
    set fechafinal = DATE_ADD(fecha2, INTERVAL 20 HOUR);
    WHILE fechainicio<=fechafinal DO
        IF HOUR(fechainicio)=20 THEN
			set fechainicio	= DATE_ADD(fechainicio, INTERVAL 10 HOUR);
		END IF;
        SELECT COUNT(cit_fecha) INTO condicion FROM cita_ins_can WHERE cit_fecha=fechainicio;
        IF condicion=0 THEN
			INSERT INTO cita_ins_can(cit_fecha) VALUES (fechainicio);
		END IF;
        set fechainicio	= DATE_ADD(fechainicio, INTERVAL 30 MINUTE);        
    END WHILE;
    SELECT fechainicio;
    END IF;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_OrganizarCitas;
DELIMITER $$
CREATE PROCEDURE sp_OrganizarCitas()
BEGIN
	DECLARE var_id_his INT;
	DECLARE var_his_ano INT;
	DECLARE var_his_semestre INT;
	DECLARE var_id_persona INT;
	DECLARE var_especial INT;
	DECLARE var_pro_id INT;
	DECLARE var_usuario VARCHAR(255);
	DECLARE condicion INT;
    DECLARE contador INT;
    DECLARE cur CURSOR FOR SELECT his_codigo, his_ano, his_semestre, per_documento_identidad, est_admision_esp, pro_id FROM vw_historia_academica
    WHERE his_ano=YEAR(CURDATE()) AND his_semestre=obtenerSemestreActual();
    SELECT COUNT(his_codigo) INTO condicion FROM vw_historia_academica WHERE his_ano=YEAR(CURDATE()) AND his_semestre=obtenerSemestreActual();
	set contador=1;
    DROP TEMPORARY TABLE IF EXISTS tabla_temporal1;	
	CREATE TEMPORARY TABLE tabla_temporal1(id_his INT, his_ano INT, his_semestre INT, id_persona INT, especial TINYINT, avance FLOAT);
    OPEN cur;
    WHILE contador<=condicion DO
		FETCH cur INTO var_id_his, var_his_ano, var_his_semestre, var_id_persona, var_especial, var_pro_id;
		SELECT vin_usuario INTO var_usuario FROM vinculado WHERE per_documento_identidad=var_id_persona;
		INSERT INTO tabla_temporal1 (id_his, his_ano, his_semestre, id_persona, especial, avance) 
		VALUES (var_id_his, var_his_ano, var_his_semestre, var_id_persona, var_especial, getAvance(var_usuario, var_pro_id));
		set contador = contador+1;
    END WHILE;
    CLOSE cur;
END$$
DELIMITER ;

INSERT INTO cita_ins_can(cit_fecha) VALUES ('2023-06-12');
DROP PROCEDURE IF EXISTS sp_AsignarCitas;
DELIMITER $$
CREATE PROCEDURE sp_AsignarCitas(IN fechainicio DATE, IN fechafin DATE, IN condicion2 INT)
BEGIN
    DECLARE contador INT;
    DECLARE condicion INT;
    DECLARE var_id_his INT;
	DECLARE var_his_ano INT;
	DECLARE var_his_semestre INT;
	DECLARE var_id_persona INT;
	DECLARE var_especial INT;
	DECLARE var_avance FLOAT;
    DECLARE var_fecha DATETIME;
    DECLARE contador2 INT;
    DECLARE condicion2 INT;
    DECLARE condicion3 INT;
    DECLARE cur1 CURSOR FOR SELECT id_his, his_ano, his_semestre, id_persona, especial, avance FROM tabla_temporal1 ORDER BY especial DESC, avance DESC;
    DECLARE cur2 CURSOR FOR SELECT cit_fecha FROM cita_ins_can WHERE cit_fecha>=fechainicio AND cit_fecha<=fechafin;
	SELECT COUNT(id_his) INTO condicion FROM tabla_temporal1;
    SELECT COUNT(cit_fecha) INTO condicion3 FROM cita_ins_can;
	set contador=1;
    set contador2=1;
    OPEN cur1;
	OPEN cur2;
    WHILE contador<=condicion AND contador<=condicion3 DO
		FETCH cur2 INTO var_fecha;
		WHILE contador2<=condicion2 DO
			FETCH cur1 INTO var_id_his, var_his_ano, var_his_semestre, var_id_persona, var_especial, var_avance;
			INSERT INTO cita_por_historia_academica (cit_fecha, his_codigo, his_semestre, his_ano) 
			VALUES ('2023-06-12', var_id_his, var_his_semestre, var_his_ano);
			set contador = contador+1;
			set contador2 = contador2+1;
		END WHILE;
		set contador2=1;
    END WHILE;
    CLOSE cur1;
    CLOSE cur2;
END$$
DELIMITER ;


