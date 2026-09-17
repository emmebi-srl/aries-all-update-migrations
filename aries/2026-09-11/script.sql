CREATE TABLE IF NOT EXISTS `campagna_aries_mail_allegato` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `id_campagna_aries_mail` INT(11) NOT NULL,
  `percorso_file` TEXT NOT NULL,
  `nome_file` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_campagna_aries_mail_allegato_uuid` (`uuid`),
  INDEX `idx_campagna_aries_mail_allegato_mail` (`id_campagna_aries_mail`),
  CONSTRAINT `fk_campagna_aries_mail_allegato_mail`
    FOREIGN KEY (`id_campagna_aries_mail`)
    REFERENCES `campagna_aries_mail` (`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
)
ENGINE=InnoDB
DEFAULT COLLATE='latin1_swedish_ci';
