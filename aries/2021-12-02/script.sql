ALTER TABLE `impianto_ricarica_tipo`
	ADD COLUMN `richiedi_invio_promemoria` BIT NULL DEFAULT b'0' AFTER `data_scadenza`,
	ADD COLUMN `data_ultimo_promemoria` DATETIME NULL DEFAULT NULL AFTER `richiedi_invio_promemoria`,
	ADD CONSTRAINT `FK_impianto_ricarica_tipo_impianto` FOREIGN KEY (`id_impianto`) REFERENCES `impianto` (`Id_impianto`) ON UPDATE CASCADE ON DELETE CASCADE;



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
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_SIM_EXPIRATION_REMINDER', '1', NOW());
	ELSE
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_SIM_EXPIRATION_REMINDER', '0', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 

ALTER TABLE `environment_variables`
	ADD PRIMARY KEY (`var_key`);


INSERT INTO `cliente_promemoria_configurazione` (`Nome`, `Tipo_intervallo`, `Valore`, `Data_ultima_esecuzione`, `Oggetto_email`, `Corpo_email`, `Testo_sms`, `abilita_sms`, `abilita_email`, `Data_mod`, `Utente_mod`)
VALUES ('PROMEMORIA SCADENZA SIM', 4, 1, '2020-07-04 09:43:06', 'Scadenza SIM {phone_number}', 'some text', 'some text', b'1', b'1', '2021-12-02 05:30:49', 1);

ALTER TABLE `impianto_ricarica_tipo`
	ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `id` (`id`);