DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_siantel BIT(1) DEFAULT 0;
	DECLARE web_address VARCHAR(150);

	ALTER TABLE `azienda`
	ADD COLUMN `aries_web_host` VARCHAR(150) NULL DEFAULT NULL AFTER `fattura_pa_api_key`;


	SELECT COUNT(*)
	INTO is_siantel
	FROM azienda 
	WHERE partita_iva = '03173480967';

	IF is_siantel THEN
		SET web_address = 'http://192.168.20.241/';
	ELSE
		SET web_address = 'http://dnsemmuff.mioddns.com:8093/';
	END IF;

	UPDATE azienda
	SET aries_web_host = web_address;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 