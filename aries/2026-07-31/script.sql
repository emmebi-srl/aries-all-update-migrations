ALTER DATABASE
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_general_ci;

ALTER TABLE `rapporto_mobile`
	DEFAULT CHARACTER SET utf8mb4
	COLLATE utf8mb4_general_ci,
	MODIFY COLUMN `relazione` TEXT
		CHARACTER SET utf8mb4
		COLLATE utf8mb4_general_ci
		NULL,
	MODIFY COLUMN `Note_Generali` VARCHAR(1000)
		CHARACTER SET utf8mb4
		COLLATE utf8mb4_general_ci
		NULL DEFAULT NULL,
	MODIFY COLUMN `APPUNTI` TEXT
		CHARACTER SET utf8mb4
		COLLATE utf8mb4_general_ci
		NULL;

DELIMITER //

DROP PROCEDURE IF EXISTS `sp_apiReportMobileInterventionInsert`//

CREATE PROCEDURE `sp_apiReportMobileInterventionInsert` (
	id INT,
	`year` INT,
	system_id INT,
	customer_id INT,
	requesting_intervention VARCHAR(30),
	responsible_job VARCHAR(30),
	responsible VARCHAR(30),
	intervention_type TINYINT,
	right_call BIT,
	technical_report TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
	notes_highlights TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
	is_work_finished BIT,
	system_conditions TINYINT,
	execution_date DATE,
	report_number INT,
	user_id INT,
	email_company VARCHAR(45),
	is_nocturnal BIT,
	is_public_holiday BIT,
	is_on_call BIT,
	is_carried_out_in_day BIT,
	is_replaced BIT,
	is_repair BIT,
	is_custom BIT,
	intervention_detail_custom_text VARCHAR(45),
	is_under_warranty BIT,
	is_subscribed BIT,
	is_not_under_warranty BIT,
	is_not_subscribed BIT,
	ordinary_maintenance BIT,
	extra_ordinary_maintenance BIT,
	system_type INT,
	company_name VARCHAR(60),
	address VARCHAR(100),
	city VARCHAR(100),
	work_place VARCHAR(255),
	problem_detected VARCHAR(100),
	email_responsible VARCHAR(100),
	responsible_id INT,
	send_to_technician INT,
	clipboard TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
	is_telephone_avaibility BIT,
	technician_sender_id MEDIUMINT,
	creation_timestamp DATETIME,
	delivery_timestamp DATETIME,
	telephone_avaibility_timestamp DATETIME,
	has_ddt_signature BIT(1),
	attachments_number SMALLINT,
	report_type SMALLINT
)
BEGIN
	DECLARE subscription_id INT;
	DECLARE destination_id INT;
	DECLARE ref_interventionType TINYINT;

	SET subscription_id = 0;
	SET destination_id = 0;

	IF(system_id > 0) THEN
		SELECT abbonamento, destinazione
		INTO subscription_id, destination_id
		FROM Impianto
		WHERE id_impianto = system_id;
	END IF;

	IF(destination_id = 0) THEN
		SET destination_id = 1;
	END IF;

	SELECT rapporto_mobile_intervento_rif_tipo_intervento.Id_tipo_intervento
	INTO ref_interventionType
	FROM rapporto_mobile_intervento_rif_tipo_intervento
	WHERE rapporto_mobile_intervento_rif_tipo_intervento.Posizione = intervention_type;

	INSERT INTO rapporto_mobile SET
		id_rapporto = id,
		anno = year,
		id_impianto = system_id,
		id_destinazione = destination_id,
		id_cliente = customer_id,
		Richiesto = requesting_intervention,
		mansione = responsible_job,
		responsabile = responsible,
		tipo_intervento = IFNULL(ref_interventionType, 2),
		Diritto_chiamata = right_call,
		tipo_diritto_chiamata = 0,
		relazione = technical_report,
		terminato = is_work_finished,
		funzionante = system_conditions,
		stato = 1,
		Note_generali = notes_highlights,
		Fattura = NULL,
		Data = CURDATE(),
		Commessa = NULL,
		abbonamento = NULL,
		Numero_ordine = NULL,
		Totale = 0,
		Nr_rapporto = report_number,
		Data_esecuzione = execution_date,
		costo = 0,
		scan = 0,
		anno_fattura = NULL,
		controllo_periodico = NULL,
		prima = 0,
		numero = report_number,
		id_utente = user_id,
		cost_lav = NULL,
		prez_lav = NULL,
		dest_cli = customer_id,
		email_invio = email_company,
		inviato = 0,
		visionato = 0,
		id_ticket = NULL,
		tecnici = NULL,
		appunti = clipboard,
		notturno = is_nocturnal,
		festivo = is_public_holiday,
		su_chiamata = is_on_call,
		eff_giorn = is_carried_out_in_day,
		sost = is_replaced,
		ripar = is_repair,
		`not` = intervention_detail_custom_text,
		c_not = is_custom,
		abbon = is_subscribed,
		garanz = is_under_warranty,
		man_ordi = ordinary_maintenance,
		fuoriabbon = IFNULL(is_not_subscribed, 0),
		fuorigaranz = IFNULL(is_not_under_warranty, 0),
		man_straord = extra_ordinary_maintenance,
		tipo_impianto = system_type,
		ragione_sociale = company_name,
		indirizzo = address,
		citta = city,
		luogo_lavoro = work_place,
		difetto = problem_detected,
		id_riferimento = responsible_id,
		mail_responsabile = email_responsible,
		invia_a_tecnico = send_to_technician,
		da_reperibilita_telefonica = is_telephone_avaibility,
		id_tecnico = technician_sender_id,
		timestamp_creazione = creation_timestamp,
		timestamp_invio = delivery_timestamp,
		timestamp_reperibilita = telephone_avaibility_timestamp,
		usa_altra_firma_su_ddt = has_ddt_signature,
		tipo_rapporto = report_type,
		numero_allegati = attachments_number;
END//

DELIMITER ;

CREATE TABLE IF NOT EXISTS `agente_ai_configurazione` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`codice` VARCHAR(100) NOT NULL,
	`descrizione` VARCHAR(255) NOT NULL,
	`rif_applicazione` VARCHAR(100) NOT NULL,
	`provider` VARCHAR(50) NOT NULL,
	`tipo_configurazione` VARCHAR(100) NOT NULL,
	`endpoint` VARCHAR(500) NULL DEFAULT NULL,
	`modello` VARCHAR(150) NULL DEFAULT NULL,
	`agente` VARCHAR(150) NULL DEFAULT NULL,
	`configurazione_json` LONGTEXT NULL,
	`credenziali_json` LONGTEXT NULL,
	`email_notifiche_json` TEXT NULL,
	`timeout_secondi` INT UNSIGNED NOT NULL DEFAULT 300,
	`elimina_sessione_dopo_esito` BIT(1) NOT NULL DEFAULT b'0',
	`attivo` BIT(1) NOT NULL DEFAULT b'0',
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_agente_ai_configurazione_uuid` (`uuid`),
	UNIQUE KEY `uq_agente_ai_configurazione_codice` (`codice`),
	KEY `idx_agente_ai_configurazione_applicazione` (`rif_applicazione`, `attivo`),
	KEY `idx_agente_ai_configurazione_provider` (`provider`, `tipo_configurazione`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `agente_ai_richiesta` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`request_id` CHAR(36) NOT NULL,
	`id_configurazione` INT NOT NULL,
	`correlation_id` VARCHAR(191) NULL DEFAULT NULL,
	`conversation_id` VARCHAR(191) NULL DEFAULT NULL,
	`operazione` VARCHAR(100) NULL DEFAULT NULL,
	`stato` VARCHAR(30) NOT NULL DEFAULT 'PENDING',
	`configurazione_snapshot_json` LONGTEXT NOT NULL,
	`source_snapshot_json` LONGTEXT NULL,
	`richiesta_json` LONGTEXT NOT NULL,
	`provider_request_json` LONGTEXT NULL,
	`risposta_json` LONGTEXT NULL,
	`errore_json` LONGTEXT NULL,
	`metadati_json` LONGTEXT NULL,
	`provider_request_id` VARCHAR(191) NULL DEFAULT NULL,
	`http_status_code` SMALLINT UNSIGNED NULL DEFAULT NULL,
	`numero_tentativi` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
	`numero_massimo_tentativi` SMALLINT UNSIGNED NOT NULL DEFAULT 3,
	`input_tokens` INT UNSIGNED NULL DEFAULT NULL,
	`output_tokens` INT UNSIGNED NULL DEFAULT NULL,
	`durata_ms` INT UNSIGNED NULL DEFAULT NULL,
	`worker_id` VARCHAR(191) NULL DEFAULT NULL,
	`lock_token` CHAR(36) NULL DEFAULT NULL,
	`lock_scadenza` DATETIME NULL DEFAULT NULL,
	`slot_configurazione` INT NULL DEFAULT NULL,
	`data_prossimo_tentativo` DATETIME NULL DEFAULT NULL,
	`data_creazione` DATETIME NOT NULL,
	`data_inizio_elaborazione` DATETIME NULL DEFAULT NULL,
	`data_invio` DATETIME NULL DEFAULT NULL,
	`data_risposta` DATETIME NULL DEFAULT NULL,
	`data_completamento` DATETIME NULL DEFAULT NULL,
	`stato_elaborazione_esito` VARCHAR(30) NULL DEFAULT NULL,
	`tentativi_elaborazione_esito` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
	`massimo_tentativi_elaborazione_esito` SMALLINT UNSIGNED NOT NULL DEFAULT 3,
	`errore_elaborazione_esito_json` LONGTEXT NULL,
	`worker_elaborazione_esito` VARCHAR(191) NULL DEFAULT NULL,
	`lock_elaborazione_esito` CHAR(36) NULL DEFAULT NULL,
	`scadenza_lock_elaborazione_esito` DATETIME NULL DEFAULT NULL,
	`data_prossimo_tentativo_esito` DATETIME NULL DEFAULT NULL,
	`data_inizio_elaborazione_esito` DATETIME NULL DEFAULT NULL,
	`data_completamento_esito` DATETIME NULL DEFAULT NULL,
	`sessione_eliminata` BIT(1) NOT NULL DEFAULT b'0',
	`data_eliminazione_sessione` DATETIME NULL DEFAULT NULL,
	`errore_eliminazione_sessione_json` LONGTEXT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_agente_ai_richiesta_request_id` (`request_id`),
	UNIQUE KEY `uq_agente_ai_richiesta_lock_token` (`lock_token`),
	UNIQUE KEY `uq_agente_ai_richiesta_slot_configurazione` (`slot_configurazione`),
	UNIQUE KEY `uq_agente_ai_richiesta_lock_elaborazione_esito` (`lock_elaborazione_esito`),
	KEY `idx_agente_ai_richiesta_configurazione` (`id_configurazione`, `data_creazione`),
	KEY `idx_agente_ai_richiesta_correlazione` (`correlation_id`),
	KEY `idx_agente_ai_richiesta_conversazione` (`conversation_id`),
	KEY `idx_agente_ai_richiesta_stato` (`stato`, `data_creazione`),
	KEY `idx_agente_ai_richiesta_stato_esito` (`stato_elaborazione_esito`, `data_completamento`),
	CONSTRAINT `fk_agente_ai_richiesta_configurazione`
		FOREIGN KEY (`id_configurazione`)
		REFERENCES `agente_ai_configurazione` (`id`)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `agente_ai_richiesta_allegato` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`id_richiesta` BIGINT UNSIGNED NOT NULL,
	`tipo` VARCHAR(30) NOT NULL,
	`id_allegato_origine` INT NULL DEFAULT NULL,
	`nome_file` VARCHAR(500) NOT NULL,
	`percorso_file` VARCHAR(1000) NOT NULL,
	`mime_type` VARCHAR(150) NULL DEFAULT NULL,
	`dimensione_byte` BIGINT UNSIGNED NULL DEFAULT NULL,
	`sha256` CHAR(64) NULL DEFAULT NULL,
	`data_creazione` DATETIME NOT NULL,
	PRIMARY KEY (`id`),
	KEY `idx_agente_ai_richiesta_allegato_richiesta` (`id_richiesta`, `tipo`),
	CONSTRAINT `fk_agente_ai_richiesta_allegato_richiesta`
		FOREIGN KEY (`id_richiesta`)
		REFERENCES `agente_ai_richiesta` (`id`)
		ON DELETE CASCADE
		ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP PROCEDURE IF EXISTS `sp_tmp_agente_ai_configurazione`;

DELIMITER //

CREATE PROCEDURE `sp_tmp_agente_ai_configurazione`()
BEGIN
	DECLARE is_emmebi BIT(1) DEFAULT b'0';

	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM `azienda`
	WHERE `partita_iva` = '04371390263';

	IF is_emmebi THEN
		INSERT INTO `agente_ai_configurazione` (
			`uuid`,
			`codice`,
			`descrizione`,
			`rif_applicazione`,
			`provider`,
			`tipo_configurazione`,
			`endpoint`,
			`modello`,
			`agente`,
			`configurazione_json`,
			`credenziali_json`,
			`email_notifiche_json`,
			`timeout_secondi`,
			`elimina_sessione_dopo_esito`,
			`attivo`,
			`data_ins`
		)
		VALUES (
			UUID(),
			'gestore_rapporti',
			'Elaborazione rapporti tramite agente AI',
			'report_manager',
			'openclaw',
			'openai_responses',
			'http://192.168.12.239:18890/v1/responses',
			'openclaw/gestore-rapporti',
			'gestore-rapporti',
			'{"schema_version":"2.0","require_request_id":true,"retry_base_seconds":5,"request_options":{"stream":false}}',
			'{}',
			'["amministrazione@emmebi.tv.it","info@emmebi.tv.it","alex.gola93@gmail.com"]',
			300,
			b'1',
			b'0',
			NOW()
		)
		ON DUPLICATE KEY UPDATE
			`descrizione` = VALUES(`descrizione`),
			`rif_applicazione` = VALUES(`rif_applicazione`),
			`provider` = VALUES(`provider`),
			`tipo_configurazione` = VALUES(`tipo_configurazione`),
			`endpoint` = VALUES(`endpoint`),
			`modello` = VALUES(`modello`),
			`agente` = VALUES(`agente`),
			`configurazione_json` = VALUES(`configurazione_json`),
			`email_notifiche_json` = VALUES(`email_notifiche_json`),
			`timeout_secondi` = VALUES(`timeout_secondi`),
			`elimina_sessione_dopo_esito` = VALUES(`elimina_sessione_dopo_esito`);
	END IF;
END//

DELIMITER ;

CALL `sp_tmp_agente_ai_configurazione`();

DROP PROCEDURE IF EXISTS `sp_tmp_agente_ai_configurazione`;
