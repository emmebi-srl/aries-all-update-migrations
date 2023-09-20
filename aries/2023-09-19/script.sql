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
		insert into environment_variables VALUES ('ARIES_DOTNET_API_HOST', 'http://81.174.1.89:81', NOW());
		insert into environment_variables VALUES ('ARIES_WEB_APP_HOST', 'http://81.174.1.89:8093', NOW());
	ELSE
		insert into environment_variables VALUES ('ARIES_DOTNET_API_HOST', 'http://192.168.20.233', NOW());
		insert into environment_variables VALUES ('ARIES_WEB_APP_HOST', 'http://192.168.20.241', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 
ALTER TABLE `azienda`
	DROP COLUMN `aries_web_host`;
