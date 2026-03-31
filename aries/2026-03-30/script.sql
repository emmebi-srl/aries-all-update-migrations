ALTER TABLE `impianto_accettazione_proposta_abbonamento`
	DROP COLUMN `note`;

ALTER TABLE `campagna_aries_mail`
	ADD COLUMN `note` TEXT NULL DEFAULT NULL AFTER `errore_processamento`;

CREATE TABLE `campagna_aries_disiscrizione` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`uuid` VARCHAR(36) NOT NULL,
	`id_tipo_campagna` INT NOT NULL,
	`mail` VARCHAR(255) NOT NULL,
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_campagna_aries_disiscrizione_tipo_mail` (`id_tipo_campagna`, `mail`),
	KEY `idx_campagna_aries_disiscrizione_uuid` (`uuid`),
	CONSTRAINT `fk_campagna_aries_disiscrizione_tipo_campagna`
		FOREIGN KEY (`id_tipo_campagna`) REFERENCES `tipo_campagna_aries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `stato_campagna_aries_mail` (`uuid`, `nome`, `finale`, `colore`, `rif_applicazione`, `data_ins`)
SELECT UUID(), 'ERRORE DI PROCESSAMENTO', b'0', '$0000FF', 'processing_error', NOW()
FROM DUAL
WHERE NOT EXISTS (
	SELECT 1
	FROM `stato_campagna_aries_mail`
	WHERE `rif_applicazione` = 'processing_error'
);

INSERT INTO `stato_campagna_aries_mail` (`uuid`, `nome`, `finale`, `colore`, `rif_applicazione`, `data_ins`)
SELECT UUID(), 'RICHIESTA INFORMAZIONI', b'0', '$008CFF', 'more_info_requested', NOW()
FROM DUAL
WHERE NOT EXISTS (
	SELECT 1
	FROM `stato_campagna_aries_mail`
	WHERE `rif_applicazione` = 'more_info_requested'
);
