ALTER TABLE `azienda`
	ADD COLUMN `id_filiale` BIGINT(11) NULL DEFAULT NULL AFTER `nome_mail`,
	ADD CONSTRAINT `FK_azieda_id_filiale` FOREIGN KEY (`id_filiale`) REFERENCES `filiale` (`Id_filiale`) ON UPDATE NO ACTION ON DELETE NO ACTION;



UPDATE azienda
LEFT JOIN filiale ON azienda.banca = filiale.Nome
SET azienda.id_filiale = filiale.id_filiale;
