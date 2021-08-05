DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_job_id INT(11);
	DECLARE V_year_id INT(11);
	DECLARE V_sub_job_id INT(11);
	DECLARE V_lot_id INT(11);
	DECLARE V_system_id INT(11);
	DECLARE V_system_count INT(11);
	DECLARE V_curA CURSOR FOR SELECT 
			id_commessa,
			anno,
			id_sottocommessa,
			id_lotto,
			impianto
		FROM commessa_lotto 
		WHERE impianto IS NOT NULL;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_job_id, V_year_id, V_sub_job_id, V_lot_id, V_system_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		SET V_system_count = 0;

		SELECT COUNT(id_impianto) 
			INTO V_system_count
		FROM impianto
		WHERE id_impianto = V_system_id;

		IF V_system_count = 0 THEN
			UPDATE commessa_lotto
			SET impianto = NULL
			WHERE id_commessa = V_job_id
				AND anno = V_year_id
				AND id_sottocommessa = V_sub_job_id
				AND id_lotto = V_lot_id;
		END IF;

	END LOOP;
	CLOSE V_curA;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 

ALTER TABLE `commessa_lotto`
	ADD CONSTRAINT `fk_commessa_lotto_impianto` FOREIGN KEY (`impianto`) REFERENCES `impianto` (`Id_impianto`) ON UPDATE CASCADE ON DELETE SET NULL;
