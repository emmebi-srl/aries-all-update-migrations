ALTER TABLE `ticket`
	ADD COLUMN `richiedi_invio_promemoria` BIT NULL DEFAULT b'0',
	ADD COLUMN `data_ultimo_promemoria` DATETIME NULL DEFAULT NULL AFTER `richiedi_invio_promemoria`;

ALTER TABLE `impianto_componenti`
	ADD COLUMN `richiedi_invio_promemoria` BIT NULL DEFAULT b'0',
	ADD COLUMN `data_promemoria` DATETIME NULL DEFAULT NULL AFTER `richiedi_invio_promemoria`,
	ADD COLUMN `data_ultimo_promemoria` DATETIME NULL DEFAULT NULL AFTER `data_promemoria`;

ALTER TABLE `impianto_abbonamenti_mesi`
	ADD COLUMN `richiedi_invio_promemoria` BIT NULL DEFAULT b'0',
	ADD COLUMN `data_promemoria` DATETIME NULL DEFAULT NULL AFTER `richiedi_invio_promemoria`,
	ADD COLUMN `data_ultimo_promemoria` DATETIME NULL DEFAULT NULL AFTER `data_promemoria`;


ALTER TABLE `impianto`
	ADD COLUMN `richiedi_invio_promemoria_garanzia` BIT NULL DEFAULT b'0',
	ADD COLUMN `data_promemoria_garanzia` DATETIME NULL DEFAULT NULL AFTER `richiedi_invio_promemoria_garanzia`,
	ADD COLUMN `data_ultimo_promemoria_garanzia` DATETIME NULL DEFAULT NULL AFTER `data_promemoria_garanzia`;



ALTER TABLE `impianto_ricarica_tipo`
	ADD COLUMN `data_promemoria` DATETIME NULL DEFAULT NULL AFTER `richiedi_invio_promemoria`;

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
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_TICKET_EXPIRATION_REMINDER', '1', NOW());
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_PRODUCT_EXPIRATION_REMINDER', '1', NOW());
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_SYSTEM_MAINTENANCE_REMINDER', '1', NOW());
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_SYSTEM_WARRANTY_REMINDER', '1', NOW());
		insert into environment_variables VALUES ('ENABLE_SYSTEMS_EXPIRATIONS', '1', NOW());
	ELSE
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_PRODUCT_EXPIRATION_REMINDER', '0', NOW());
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_TICKET_EXPIRATION_REMINDER', '0', NOW());
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_SYSTEM_MAINTENANCE_REMINDER', '0', NOW());
		insert into environment_variables VALUES ('ENABLE_CUSTOMER_SYSTEM_WARRANTY_REMINDER', '0', NOW());
		insert into environment_variables VALUES ('ENABLE_SYSTEMS_EXPIRATIONS', '0', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 


ALTER TABLE `impianto_componenti`
	ADD COLUMN `id_impianto_componenti` INT NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `id_impianto_componenti` (`id_impianto_componenti`);


INSERT INTO `cliente_promemoria_configurazione` (`Nome`, `Tipo_intervallo`, `Valore`, `Data_ultima_esecuzione`, `Oggetto_email`, `Corpo_email`, `Testo_sms`, `abilita_sms`, `abilita_email`, `Data_mod`, `Utente_mod`)
VALUES
('PROMEMORIA COMPONENTE IMPIANTO', 6, 0, CURRENT_DATE, 'Scadenza {product_name} Impianto {system_type} {municipality}', '{system_type} {full_address} {system_description} {company_name} {title} {product_name} {municipality} {quantity}', 'some text', b'0', b'0', CURRENT_DATE, 1),
('PROMEMORIA RINNOVO SIM', 6, 0, CURRENT_DATE, 'Rinnovo SIM {phone_number}', '{system_type} {full_address} {system_description} {company_name} {title} {phone_number} {municipality} {renew_price}', 'some text', b'0', b'0', CURRENT_DATE, 1),
('CONTROLLO PERIODICO', 6, 0, CURRENT_DATE, 'Manutenzione Impianto {system_type} {municipality}', '{system_type} {full_address} {system_description} {company_name} {title} {system_maintenance_month} {system_maintenance_year} {municipality}', 'some text', b'0', b'0', CURRENT_DATE, 1),
('PROMEMORIA GARANZIA IMPIANTO', 6, 0, CURRENT_DATE, 'Garanzia Impianto {system_type} {municipality}', '{system_type} {full_address} {system_description} {company_name} {title} {system_warranty_date} {municipality}', 'some text', b'0', b'0', CURRENT_DATE, 1),
('TICKET IN SCADENZA', 6, 0, CURRENT_DATE, 'Scadenza TIcket {system_type} {municipality}', '{system_type} {full_address} {system_description} {company_name} {title} {ticket_expiration_date} {municipality} {ticket_customer_description}', 'some text', b'0', b'0', CURRENT_DATE, 1);
