/* TRIGGERS */
-- Drop triggers
drop trigger if exists tr_actualizar_PAPA;
drop trigger if exists tr_actualizar_PAPPI;
drop trigger if exists tr_cancelacion_asi;
drop trigger if exists tr_restriccion_cancelacion;
-- Triggers
-- actualizar PAPA cada vez que se inserta una definitiva nueva
delimiter $$
create trigger tr_actualizar_PAPA AFTER INSERT ON calificacion 
	for each row
	begin
		call sp_actualizar_PAPA(NEW.his_codigo,NEW.his_ano,NEW.his_semestre,@PAPA);
    end$$
delimiter ;
-- actualizar PAPPI cada vez que se inserta una definitiva nueva
delimiter $$
create trigger tr_actualizar_PAPPI AFTER INSERT ON calificacion 
	for each row
	begin
		call sp_actualizar_PAPPI(NEW.his_codigo,NEW.his_ano,NEW.his_semestre,@PAPPI);
    end$$
delimiter ;
-- actualizar PAPPI al cancelar asignatura considerando la afectación de los créditos de la asignatura cancelada
delimiter $$
create trigger tr_cancelacion_asi AFTER UPDATE ON inscripcion
	for each row
	begin
		call sp_actualizar_PAPPI(NEW.his_codigo,NEW.his_ano,NEW.his_semestre,@PAPPI);
    end$$
delimiter ;
-- no permite insertar cancelaciones ya que estas se trabajan unicamente por updates de inscripciones ya registradas.
drop trigger if exists tr_restriccion_cancelacion;
delimiter $$
create trigger tr_restriccion_cancelacion before insert on inscripcion
for each row
	begin
    if NEW.ins_cancelacion = 1 then
        -- Generar un error para abortar la transacción
        signal sqlstate '45000' set message_text = 'No se permite la inserción de este valor.';
    end if;
	
	update grupo set gru_cupos = gru_cupos - 1 where NEW.gru_numero = gru_numero and NEW.asi_codigo = grupo.asi_codigo;

    end$$
delimiter ; 

drop trigger if exists tr_restriccion_cancelacion2;
delimiter $$
create trigger tr_restriccion_cancelacion2 after update on inscripcion
for each row
	begin
    if NEW.ins_cancelacion = 1 then
		update grupo set gru_cupos = gru_cupos + 1 where NEW.gru_numero = gru_numero and NEW.asi_codigo = grupo.asi_codigo;
	end if;
	end$$
delimiter ; 

drop trigger if exists tr_restriccion_cancelacion3;
delimiter $$
create trigger tr_restriccion_cancelacion3 after delete on inscripcion
for each row
	begin
		update grupo set gru_cupos = gru_cupos + 1 where OLD.gru_numero = gru_numero and OLD.asi_codigo = grupo.asi_codigo;
	end$$
delimiter ; 
drop trigger if exists tr_restriccion_cancelacion3;
-- definir aprobado o no una calificacion
drop trigger if exists tr_definicion_aprobacion;
delimiter $$
create trigger tr_definicion_aprobacion before insert on calificacion
for each row
	begin
		declare cal_aprobado TINYINT(1);
		if NEW.cal_final >= 3 then
			-- Generar un error para abortar la transacción
			set NEW.cal_aprobado = 1;
		else 
			set NEW.cal_aprobado = 0;
		end if;
        SET NEW.cal_fecha = DATE(ADDTIME(curdate(), current_time()));
	end$$
delimiter ; 