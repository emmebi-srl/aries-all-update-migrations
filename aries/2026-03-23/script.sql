DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_emmebi BIT(1) DEFAULT 0;


	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda 
	WHERE partita_iva = '04371390263';

	IF is_emmebi THEN
		INSERT INTO `environment_variables` (`var_key`, `var_value`, `timestamp`)
		VALUES ('ENABLE_ARIES_API_INTEGRATION', '1', NOW())
		ON DUPLICATE KEY UPDATE
			`var_value` = VALUES(`var_value`),
			`timestamp` = NOW();
	ELSE
		INSERT INTO `environment_variables` (`var_key`, `var_value`, `timestamp`)
		VALUES ('ENABLE_ARIES_API_INTEGRATION', '0', NOW())
		ON DUPLICATE KEY UPDATE
			`var_value` = VALUES(`var_value`),
			`timestamp` = NOW();
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp;
