
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
		insert into environment_variables VALUES ('FONT_DEFAULT_NAME', 'Tahoma', NOW());
		insert into environment_variables VALUES ('FONT_DEFAULT_SIZE', '8', NOW());
	ELSE
		insert into environment_variables VALUES ('FONT_DEFAULT_NAME', 'Verdana', NOW());
		insert into environment_variables VALUES ('FONT_DEFAULT_SIZE', '10', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 
