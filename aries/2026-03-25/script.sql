DROP PROCEDURE IF EXISTS sp_tmp;

DROP PROCEDURE IF EXISTS sp_tmp_email_account_configuration;
DELIMITER $$

CREATE PROCEDURE sp_tmp_email_account_configuration()
BEGIN
	DECLARE is_emmebi BIT(1) DEFAULT 0;

	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda
	WHERE partita_iva = '04371390263';

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
		`reply_to` VARCHAR(100) NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
		`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		PRIMARY KEY (`id`),
		UNIQUE KEY `idx_configurazione_account_email_uuid` (`uuid`),
		KEY `idx_configurazione_account_email_rif_applicazione` (`rif_applicazione`)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

	IF is_emmebi THEN
		INSERT INTO `configurazione_account_email`
			(`uuid`, `descrizione`, `rif_applicazione`, `host`, `username`, `password`, `port`, `ssl`, `from`, `reply_to`)
		VALUES
			(
				UUID(),
				'campagne aries',
				'campaign_aries',
				'smtps.aruba.it',
				'no-reply@emmebi.tv.it',
				'xvBt45nr!22',
				587,
				b'1',
				'no-reply@emmebi.tv.it',
				NULL
			)
		ON DUPLICATE KEY UPDATE
			`descrizione` = VALUES(`descrizione`),
			`rif_applicazione` = VALUES(`rif_applicazione`),
			`host` = VALUES(`host`),
			`username` = VALUES(`username`),
			`password` = VALUES(`password`),
			`port` = VALUES(`port`),
			`ssl` = VALUES(`ssl`),
			`from` = VALUES(`from`),
			`reply_to` = VALUES(`reply_to`);
	END IF;
END
$$

DELIMITER ;

CALL sp_tmp_email_account_configuration();

DROP PROCEDURE IF EXISTS sp_tmp_email_account_configuration;
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN
	DECLARE is_emmebi BIT(1) DEFAULT 0;
	DECLARE has_default_value_column BIT(1) DEFAULT 0;

	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda
	WHERE partita_iva = '04371390263';

	UPDATE `campagna_aries_segnaposto`
	SET
		`nome` = 'link_landing_accept_page',
		`descrizione` = 'Link landing accept page'
	WHERE `nome` = 'link_landing_page';

	IF is_emmebi THEN
		INSERT INTO `campagna_aries_segnaposto` (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
		VALUES (
			UUID(),
			(select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'),
			'link_landing_reject_page',
			'Link landing rifiuto proposta',
			'https://aries.emmebi.tv.it/landing/reject-subscription-proposal'
		)
		ON DUPLICATE KEY UPDATE
			`descrizione` = VALUES(`descrizione`),
			`valore_predefinito` = VALUES(`valore_predefinito`);
	ELSE
		INSERT INTO `campagna_aries_segnaposto` (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
		VALUES (
			UUID(),
			(select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'),
			'link_landing_reject_page',
			'Link landing rifiuto proposta',
			''
		)
		ON DUPLICATE KEY UPDATE
			`descrizione` = VALUES(`descrizione`),
			`valore_predefinito` = VALUES(`valore_predefinito`);
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp;
