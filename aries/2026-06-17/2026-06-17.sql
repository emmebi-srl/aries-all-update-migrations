CREATE TABLE IF NOT EXISTS `conto_bancario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `banca` varchar(150) DEFAULT NULL,
  `iban` varchar(34) DEFAULT NULL,
  `bic` varchar(20) DEFAULT NULL,
  `intestatario` varchar(150) DEFAULT NULL,
  `note` text,
  `attivo` tinyint(1) NOT NULL DEFAULT '1',
  `data_ins` datetime NOT NULL,
  `utente_ins` int(11) DEFAULT NULL,
  `data_mod` datetime DEFAULT NULL,
  `utente_mod` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conto_bancario_attivo` (`attivo`),
  KEY `idx_conto_bancario_nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `conto_bancario_saldo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_conto_bancario` int(11) NOT NULL,
  `data_saldo` date NOT NULL,
  `saldo` decimal(13,2) NOT NULL,
  `note` text,
  `data_ins` datetime NOT NULL,
  `utente_ins` int(11) DEFAULT NULL,
  `data_mod` datetime DEFAULT NULL,
  `utente_mod` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conto_bancario_saldo_conto_data` (`id_conto_bancario`, `data_saldo`),
  CONSTRAINT `fk_conto_bancario_saldo_conto`
    FOREIGN KEY (`id_conto_bancario`) REFERENCES `conto_bancario` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
