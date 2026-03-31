UPDATE `campagna_aries_segnaposto`
SET
	`nome` = 'subscription_maintenance_price',
	`descrizione` = 'Prezzo manutenzione'
WHERE `nome` = 'subscription_price';

ALTER TABLE `stato_campagna_aries_mail`
	ADD COLUMN `rif_applicazione` VARCHAR(50) NOT NULL DEFAULT '' AFTER `nome`;

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'waiting_for_send'
WHERE `nome` = 'IN ATTESA DI INVIO';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'sent'
WHERE `nome` = 'INVIATA';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'viewed'
WHERE `nome` = 'VISIONATA';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'landing_page_opened'
WHERE `nome` = 'APERTURA PAGINA';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'response_received'
WHERE `nome` = 'RICEVUTA RISPOSTA';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'positive_outcome'
WHERE `nome` = 'ESITO POSITIVO';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = 'negative_outcome'
WHERE `nome` = 'ESITO NEGATIVO';

UPDATE `stato_campagna_aries_mail`
SET `rif_applicazione` = CONCAT('legacy_', `id`)
WHERE `rif_applicazione` = '';

ALTER TABLE `stato_campagna_aries_mail`
	ADD UNIQUE INDEX `rif_applicazione` (`rif_applicazione`);

CREATE TABLE `impianto_accettazione_proposta_abbonamento` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_campagna_aries_mail` INT(11) NULL DEFAULT NULL,
	`id_impianto` INT(11) NOT NULL,
	`numero_manutenzioni` INT(11) NOT NULL,
	`prezzo_singola_manutenzione` DECIMAL(10,2) NOT NULL,
	`data_accettazione_termini_condizioni` DATETIME NOT NULL,
	`data_accettazione_fatturazione_immediata_diritto_chiamata` DATETIME NOT NULL,
	`note` TEXT NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_caama_mail` (`id_campagna_aries_mail`) USING BTREE,
	INDEX `FK_caama_impianto` (`id_impianto`) USING BTREE,
	CONSTRAINT `FK_caama_mail`
		FOREIGN KEY (`id_campagna_aries_mail`) REFERENCES `campagna_aries_mail` (`id`)
		ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT `FK_caama_impianto`
		FOREIGN KEY (`id_impianto`) REFERENCES `impianto` (`Id_impianto`)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE `impianto_accettazione_proposta_abbonamento_mese` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_impianto_accettazione_proposta_abbonamento` INT(11) NOT NULL,
	`indice_mese` INT(11) NOT NULL,
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_iapam_iapa` (`id_impianto_accettazione_proposta_abbonamento`) USING BTREE,
	CONSTRAINT `FK_iapam_iapa`
		FOREIGN KEY (`id_impianto_accettazione_proposta_abbonamento`) REFERENCES `impianto_accettazione_proposta_abbonamento` (`id`)
		ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS `trg_afterSubscriptionProposalAcceptanceInsert`;

DELIMITER $$

CREATE TRIGGER `trg_afterSubscriptionProposalAcceptanceInsert`
AFTER INSERT ON `impianto_accettazione_proposta_abbonamento`
FOR EACH ROW
BEGIN
	IF NEW.`id_campagna_aries_mail` IS NOT NULL THEN
		UPDATE `campagna_aries_mail` `campagnaMail`
		INNER JOIN `stato_campagna_aries_mail` `statoCampagnaMail`
			ON `statoCampagnaMail`.`rif_applicazione` = 'positive_outcome'
		SET `campagnaMail`.`id_stato` = `statoCampagnaMail`.`id`
		WHERE `campagnaMail`.`id` = NEW.`id_campagna_aries_mail`;
	END IF;
END$$

DELIMITER ;
