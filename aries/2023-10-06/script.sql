ALTER TABLE `ticket`
	ADD COLUMN `id_evento_scadenza` INT(10) UNSIGNED NULL DEFAULT NULL AFTER `scadenza`,
	ADD COLUMN `id_evento_promemoria` INT(10) UNSIGNED NULL DEFAULT NULL AFTER `data_promemoria`,
	ADD CONSTRAINT `FK_ticket_evento_promemoria` FOREIGN KEY (`id_evento_promemoria`) REFERENCES `evento` (`Id`) ON UPDATE CASCADE ON DELETE SET NULL,
	ADD CONSTRAINT `FK_ticket_evento_scadenza` FOREIGN KEY (`id_evento_scadenza`) REFERENCES `evento` (`Id`) ON UPDATE CASCADE ON DELETE SET NULL;

INSERT INTO `urgenza` (`Id_urgenza`, `Nome`, `Descrizione`) VALUES (0, 'Bassa', NULL);
INSERT INTO `urgenza` (`Id_urgenza`, `Nome`, `Descrizione`) VALUES (1, 'Media', NULL);
INSERT INTO `urgenza` (`Id_urgenza`, `Nome`, `Descrizione`) VALUES (2, 'Alta', NULL);

ALTER TABLE `evento_gruppo`
	CHANGE COLUMN `Id_stato` `Id_stato` TINYINT(4) NOT NULL DEFAULT '1' AFTER `Id_impianto`;
	
INSERT INTO `tipo_evento` (`id_tipo`, `nome`, `colore`, `Id_tipologia`, `Timestamp`) VALUES (60, 'PROMEMORIA TICKET', '$00DFFF00', 3, '2020-02-12 07:11:57');


DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE ticket_id INT(11);
	DECLARE ticket_year INT(11);
	
	DECLARE system_id INT;
	DECLARE customer_id INT;
	DECLARE urgency_id INT;
	DECLARE reminder_date DATE;
	DECLARE reminder_event_id INT;
	DECLARE expiration_date DATE;
	DECLARE expiration_event_id INT;
	DECLARE ticket_description TEXT;

	DECLARE curA CURSOR FOR
		SELECT Id_ticket, anno, id_impianto, id_cliente, urgenza, data_promemoria, id_evento_promemoria, scadenza, id_evento_scadenza, descrizione
		FROM ticket
		WHERE stato_ticket != 3 AND (ticket.data_promemoria IS NOT NULL OR ticket.scadenza IS NOT NULL) ORDER BY anno asc, id_ticket ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN curA;
	loopA: LOOP
		SET done = 0;
		FETCH curA INTO
			ticket_id,
			ticket_year,
			system_id,
			customer_id,
			urgency_id,
			reminder_date,
			reminder_event_id,
			expiration_date,
			expiration_event_id,
			ticket_description;

		IF done THEN
			LEAVE loopA;
		END IF;
		
		IF reminder_date IS NOT NULL THEN
			CALL sp_ariesTicketEnsureReminderEvent(ticket_id, ticket_year, system_id, customer_id, urgency_id, reminder_date, NULL, expiration_date, NULL, ticket_description, reminder_event_id);
			UPDATE ticket SET id_evento_promemoria = reminder_event_id WHERE id_ticket = ticket_id AND anno = ticket_year;
		END IF;

		IF expiration_date IS NOT NULL THEN
			CALL sp_ariesTicketEnsureExpirationEvent(ticket_id, ticket_year, system_id, customer_id, urgency_id, reminder_date, reminder_event_id, expiration_date, NULL, ticket_description, expiration_event_id);
			UPDATE ticket SET id_evento_scadenza = expiration_event_id WHERE id_ticket = ticket_id AND anno = ticket_year;
		END IF;
			
	END LOOP;
	CLOSE curA;
END
$$

DELIMITER ;

CALL sp_tmp();

