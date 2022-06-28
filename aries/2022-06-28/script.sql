
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
		insert into environment_variables VALUES ('ENABLE_QUOTE_PRINT_ALERT_FOR_SUPPLIER_PRODUCT_CODE', '1', NOW());
	ELSE
		insert into environment_variables VALUES ('ENABLE_QUOTE_PRINT_ALERT_FOR_SUPPLIER_PRODUCT_CODE', '0', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 
