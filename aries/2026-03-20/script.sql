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
		VALUES ('ARIES_DOTNET_API_HOST', 'https://api.emmebi.tv.it', NOW())
		ON DUPLICATE KEY UPDATE
			`var_value` = VALUES(`var_value`),
			`timestamp` = NOW();
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp;
