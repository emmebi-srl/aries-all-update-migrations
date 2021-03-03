INSERT INTO `servizio_alert_configurazione` (Id, `Nome`, `Cartella`, `Tipo_intervallo`, `Valore`, `Numero_mesi`, `Data_ultima_esecuzione`, `Oggetto_email`, `Corpo_email`, `Data_mod`, `Utente_mod`) VALUES 
    (5, 'Scadenze invio fatture', 'SCADENZE INVIO FATTURE', 2, 1, 0, '2019-02-20 00:47:23', '[ARIES] SCADENZE INVIO FATTURA', 'Mail automaticamente creata. Non rispondere a questa email.', '2019-02-20 00:47:23', 10);


INSERT INTO `servizio_alert_ricevente` (`Id_servizio`, `Email`, `Data_ins`, `Utente_ins`) VALUES (5, 'amministrazione@emmebi.tv.it', '2018-02-10 10:54:15', 10);
INSERT INTO `servizio_alert_ricevente` (`Id_servizio`, `Email`, `Data_ins`, `Utente_ins`) VALUES (5, 'info@emmebi.tv.it', '2018-02-10 10:54:15', 10);

ALTER TABLE `rapporto`
	ADD COLUMN `numero_allegati` SMALLINT NOT NULL DEFAULT '0' AFTER `filename_firma_per_ddt`;

ALTER TABLE `rapporto_mobile`
	ADD COLUMN `numero_allegati` SMALLINT NOT NULL DEFAULT '0' AFTER `filename_firma_per_ddt`;


ALTER TABLE `rapporto_allegati`
	ADD COLUMN `invia_a_cliente` BIT NULL DEFAULT b'0' AFTER `file_name`;

ALTER TABLE `rapporto_allegati`
	DROP FOREIGN KEY `fk_rapporto_rapporto_allegati`;


ALTER TABLE `rapporto_allegati`
	CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `timestamp` `timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `invia_a_cliente`;
