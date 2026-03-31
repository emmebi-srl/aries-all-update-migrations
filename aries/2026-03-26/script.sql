CREATE TABLE IF NOT EXISTS `configurazione_account_email` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`descrizione` VARCHAR(100) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
	`rif_applicazione` VARCHAR(100) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
	`host` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`username` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`password` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`port` INT(11) NOT NULL DEFAULT '0',
	`ssl` BIT(1) NOT NULL DEFAULT b'0',
	`from` VARCHAR(100) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
	`reply_to` VARCHAR(100) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `idx_configurazione_account_email_uuid` (`uuid`),
	KEY `idx_configurazione_account_email_rif_applicazione` (`rif_applicazione`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

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
		IF EXISTS (
			SELECT 1
			FROM configurazione_account_email
			WHERE rif_applicazione = 'campaign_aries'
		) THEN
			UPDATE configurazione_account_email
			SET
				descrizione = 'campagne aries',
				host = 'smtps.aruba.it',
				username = 'no-reply@emmebi.tv.it',
				password = 'xvBt45nr!22',
				port = 587,
				`ssl` = b'1',
				`from` = 'no-reply@emmebi.tv.it',
				reply_to = NULL
			WHERE rif_applicazione = 'campaign_aries'
			ORDER BY id
			LIMIT 1;
		ELSE
			INSERT INTO configurazione_account_email
			(uuid, descrizione, rif_applicazione, host, username, password, port, `ssl`, `from`, reply_to)
			VALUES
			(UUID(), 'campagne aries', 'campaign_aries', 'smtps.aruba.it', 'no-reply@emmebi.tv.it', 'xvBt45nr!22', 587, b'1', 'no-reply@emmebi.tv.it', NULL);
		END IF;

		IF EXISTS (
			SELECT 1
			FROM configurazione_account_email
			WHERE rif_applicazione = 'subscription_proposal_result'
		) THEN
			UPDATE configurazione_account_email
			SET
				descrizione = 'risultato proposta abbonamento',
				host = 'smtps.aruba.it',
				username = 'no-reply@emmebi.tv.it',
				password = 'xvBt45nr!22',
				port = 587,
				`ssl` = b'1',
				`from` = 'no-reply@emmebi.tv.it',
				reply_to = NULL
			WHERE rif_applicazione = 'subscription_proposal_result'
			ORDER BY id
			LIMIT 1;
		ELSE
			INSERT INTO configurazione_account_email
			(uuid, descrizione, rif_applicazione, host, username, password, port, `ssl`, `from`, reply_to)
			VALUES
			(UUID(), 'risultato proposta abbonamento', 'subscription_proposal_result', 'smtps.aruba.it', 'no-reply@emmebi.tv.it', 'xvBt45nr!22', 587, b'1', 'no-reply@emmebi.tv.it', NULL);
		END IF;

		INSERT INTO `environment_variables` (`var_key`, `var_value`, `timestamp`)
		VALUES ('SUBSCRIPTION_PROPOSAL_INTERNAL_NOTIFICATION_EMAILS', 'info@emmebi.tv.it,amministrazione@emmebi.tv.it', NOW())
		ON DUPLICATE KEY UPDATE
			`timestamp` = NOW();
	ELSE
		IF EXISTS (
			SELECT 1
			FROM configurazione_account_email
			WHERE rif_applicazione = 'campaign_aries'
		) THEN
			UPDATE configurazione_account_email
			SET
				descrizione = 'campagne aries',
				host = '',
				username = '',
				password = '',
				port = 0,
				`ssl` = b'0',
				`from` = '',
				reply_to = NULL
			WHERE rif_applicazione = 'campaign_aries'
			ORDER BY id
			LIMIT 1;
		ELSE
			INSERT INTO configurazione_account_email
			(uuid, descrizione, rif_applicazione, host, username, password, port, `ssl`, `from`, reply_to)
			VALUES
			(UUID(), 'campagne aries', 'campaign_aries', '', '', '', 0, b'0', '', NULL);
		END IF;

		IF EXISTS (
			SELECT 1
			FROM configurazione_account_email
			WHERE rif_applicazione = 'subscription_proposal_result'
		) THEN
			UPDATE configurazione_account_email
			SET
				descrizione = 'risultato proposta abbonamento',
				host = '',
				username = '',
				password = '',
				port = 0,
				`ssl` = b'0',
				`from` = '',
				reply_to = NULL
			WHERE rif_applicazione = 'subscription_proposal_result'
			ORDER BY id
			LIMIT 1;
		ELSE
			INSERT INTO configurazione_account_email
			(uuid, descrizione, rif_applicazione, host, username, password, port, `ssl`, `from`, reply_to)
			VALUES
			(UUID(), 'risultato proposta abbonamento', 'subscription_proposal_result', '', '', '', 0, b'0', '', NULL);
		END IF;

		INSERT INTO `environment_variables` (`var_key`, `var_value`, `timestamp`)
		VALUES ('SUBSCRIPTION_PROPOSAL_INTERNAL_NOTIFICATION_EMAILS', '', NOW())
		ON DUPLICATE KEY UPDATE
			`timestamp` = NOW();
	END IF;
END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp;

DROP TRIGGER IF EXISTS `trg_afterMailUpdate`;
DROP TRIGGER IF EXISTS `trg_beforeCampaignMailUpdate`;
DELIMITER $$

CREATE TRIGGER `trg_afterMailUpdate`
AFTER UPDATE ON `mail`
FOR EACH ROW
BEGIN
	IF CAST(OLD.`Letto` AS UNSIGNED) <> CAST(NEW.`Letto` AS UNSIGNED)
		AND CAST(NEW.`Letto` AS UNSIGNED) = 1 THEN
		UPDATE `campagna_aries_mail` `campagnaMail`
		INNER JOIN `stato_campagna_aries_mail` `statoCampagnaMail`
			ON `statoCampagnaMail`.`rif_applicazione` = 'viewed'
		SET
			`campagnaMail`.`id_stato` = `statoCampagnaMail`.`id`
		WHERE `campagnaMail`.`id_mail` = NEW.`Id`;
	END IF;
END
$$

CREATE TRIGGER `trg_beforeCampaignMailUpdate`
BEFORE UPDATE ON `campagna_aries_mail`
FOR EACH ROW
BEGIN
	DECLARE viewed_status_id INT(11) DEFAULT NULL;
	DECLARE landing_page_opened_status_id INT(11) DEFAULT NULL;

	SELECT `id`
	INTO viewed_status_id
	FROM `stato_campagna_aries_mail`
	WHERE `rif_applicazione` = 'viewed'
	LIMIT 1;

	SELECT `id`
	INTO landing_page_opened_status_id
	FROM `stato_campagna_aries_mail`
	WHERE `rif_applicazione` = 'landing_page_opened'
	LIMIT 1;

	IF IFNULL(OLD.`id_stato`, 0) <> IFNULL(NEW.`id_stato`, 0) THEN
		IF NEW.`id_stato` = viewed_status_id THEN
			SET NEW.`letto` = b'1';
		ELSEIF NEW.`id_stato` = landing_page_opened_status_id THEN
			SET NEW.`letto` = b'1';
			SET NEW.`interagito` = b'1';
		END IF;
	END IF;
END
$$

DELIMITER ;


INSERT INTO `utente` (`Id_utente`, `Password`, `Nome`, `Descrizione`, `mail`, `Firma`, `calendario`, `smtp`, `porta`, `mssl`, `nome_utente_mail`, `password_mail`, `tipo_utente`, `conferma`, `salt`) VALUES (20, 'no-password', 'internal.service', 'Utente destinato a servizi interni', NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, 1, 0, '');
