ALTER TABLE `tablet_configurazione`
	ADD COLUMN `email_ufficio` VARCHAR(100) NULL AFTER `messaggio_non_abbonato`;

DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_emmebi BIT(1) DEFAULT 0;
	DECLARE office_email VARCHAR(100) DEFAULT NULL;

	SELECT IF(COUNT(*) > 1, 1, 0)
	INTO is_emmebi
	FROM azienda 
	WHERE partita_iva = '04371390263';

	IF is_emmebi THEN
		SET office_email = 'amministrazione@emmebi.tv.it';
	END IF;

	UPDATE tablet_configurazione
	SET email_ufficio = office_email;
END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 

ALTER TABLE `tablet_configurazione`
	ALTER `email_ufficio` DROP DEFAULT;
ALTER TABLE `tablet_configurazione`
	CHANGE COLUMN `email_ufficio` `email_ufficio` VARCHAR(100) NULL COMMENT 'Email dell\'ufficio dove recapitare i rapporti mobile. Questa email sara usata in CCN' AFTER `messaggio_non_abbonato`;
