CREATE TABLE IF NOT EXISTS `richiesta_campagna_abbonamento` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `uuid` CHAR(36) NOT NULL,
    `id_cliente` INT(11) NOT NULL,
    `id_impianto` INT(11) NOT NULL,
    `tipo_sorgente` VARCHAR(30) NOT NULL,
    `id_sorgente` INT(11) NOT NULL,
    `anno_sorgente` INT(11) NOT NULL,
    `data_sorgente` DATETIME NOT NULL,
    `numero_manutenzioni_raccomandato` INT(11) NOT NULL,
    `prezzo_manutenzione_raccomandato` DECIMAL(12,2) NOT NULL,
    `confidenza` DECIMAL(5,4) NOT NULL,
    `motivazione` TEXT NULL,
    `rif_stato` VARCHAR(50) NOT NULL DEFAULT 'pricing_recommended',
    `id_campagna_aries` INT(11) NULL DEFAULT NULL,
    `id_campagna_aries_mail` INT(11) NULL DEFAULT NULL,
    `data_notifica` DATETIME NULL DEFAULT NULL,
    `data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_richiesta_campagna_abbonamento_uuid` (`uuid`),
    UNIQUE KEY `uq_richiesta_campagna_abbonamento_sorgente`
        (`id_impianto`, `tipo_sorgente`, `id_sorgente`, `anno_sorgente`),
    KEY `idx_richiesta_campagna_abbonamento_notifica` (`rif_stato`, `data_notifica`),
    KEY `idx_richiesta_campagna_abbonamento_cliente` (`id_cliente`),
    KEY `idx_richiesta_campagna_abbonamento_impianto` (`id_impianto`),
    KEY `idx_richiesta_campagna_abbonamento_campagna` (`id_campagna_aries`),
    KEY `idx_richiesta_campagna_abbonamento_campagna_mail` (`id_campagna_aries_mail`),
    CONSTRAINT `fk_richiesta_campagna_abbonamento_cliente`
        FOREIGN KEY (`id_cliente`) REFERENCES `clienti` (`Id_cliente`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_richiesta_campagna_abbonamento_impianto`
        FOREIGN KEY (`id_impianto`) REFERENCES `impianto` (`Id_impianto`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_richiesta_campagna_abbonamento_campagna`
        FOREIGN KEY (`id_campagna_aries`) REFERENCES `campagna_aries` (`id`)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT `fk_richiesta_campagna_abbonamento_campagna_mail`
        FOREIGN KEY (`id_campagna_aries_mail`) REFERENCES `campagna_aries_mail` (`id`)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
