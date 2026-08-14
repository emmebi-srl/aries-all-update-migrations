CREATE TABLE IF NOT EXISTS `agente_ai_richiesta_azione` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`id_richiesta` BIGINT UNSIGNED NOT NULL,
	`action_id` VARCHAR(100) NOT NULL,
	`posizione` SMALLINT UNSIGNED NOT NULL,
	`tipo` VARCHAR(100) NOT NULL,
	`idempotency_key` VARCHAR(200) NOT NULL,
	`idempotency_hash` BINARY(32) NOT NULL,
	`data_applicazione` DATETIME NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_agente_ai_richiesta_azione_richiesta_action` (`id_richiesta`, `action_id`),
	UNIQUE KEY `uq_agente_ai_richiesta_azione_idempotency` (`idempotency_hash`),
	KEY `idx_agente_ai_richiesta_azione_richiesta_posizione` (`id_richiesta`, `posizione`),
	CONSTRAINT `fk_agente_ai_richiesta_azione_richiesta`
		FOREIGN KEY (`id_richiesta`)
		REFERENCES `agente_ai_richiesta` (`id`)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

UPDATE `agente_ai_configurazione`
SET `configurazione_json` = CASE
	WHEN `configurazione_json` IS NULL
		OR TRIM(`configurazione_json`) = ''
		OR TRIM(`configurazione_json`) = '{}'
	THEN '{"result_execution":{"ticket_cause_id":5,"ticket_urgency_id":0,"ticket_intervention_type_id":2,"ticket_communication_type_id":1,"ticket_open_status_id":1,"ticket_closed_status_id":3}}'
	WHEN RIGHT(TRIM(`configurazione_json`), 1) = '}'
	THEN CONCAT(
		LEFT(
			TRIM(`configurazione_json`),
			CHAR_LENGTH(TRIM(`configurazione_json`)) - 1
		),
		',"result_execution":{"ticket_cause_id":5,"ticket_urgency_id":0,"ticket_intervention_type_id":2,"ticket_communication_type_id":1,"ticket_open_status_id":1,"ticket_closed_status_id":3}}'
	)
	ELSE `configurazione_json`
END
WHERE `codice` = 'gestore_rapporti'
	AND (
		`configurazione_json` IS NULL
		OR `configurazione_json` NOT LIKE '%"result_execution"%'
	);
