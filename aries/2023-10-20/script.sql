CREATE TABLE `tipo_contratto_stampa` (
	`id_tipo_stampa` INT(11) NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(45) NOT NULL COLLATE 'latin1_swedish_ci',
	`descrizione` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`id_tipo_stampa`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO tipo_contratto_stampa (nome, descrizione) VALUES ("STANDARD", "Stampa di base"), ("PREVENTIVO", "Stampa concatenando il preventivo");

ALTER TABLE `contratto`
	ADD COLUMN `tipo_stampa` INT(11) NOT NULL DEFAULT '2' AFTER `tipo_contratto`,
	ADD CONSTRAINT `FK_contratto_tipo_stampa` FOREIGN KEY (`tipo_stampa`) REFERENCES `tipo_contratto_stampa` (`id_tipo_stampa`) ON UPDATE CASCADE ON DELETE RESTRICT;


INSERT INTO `environment_variables` (`var_key`, `var_value`, `timestamp`) VALUES ('DEFAULT_CONTRACT_PRINT_TYPE', '2', '2023-09-25 09:47:12');

ALTER TABLE `tipo_preventivo`
	ADD COLUMN `id_tipo_contratto` INT NOT NULL DEFAULT '1' AFTER `descrizione`,
	ADD CONSTRAINT `FK_tipo_preventivo_id_tipo_contratto` FOREIGN KEY (`id_tipo_contratto`) REFERENCES `tipo_contratto` (`id_tipo`) ON UPDATE CASCADE ON DELETE RESTRICT;

UPDATE `tipo_preventivo` SET `id_tipo_contratto`='2' WHERE  `id_tipo`=4;

ALTER TABLE `contratto`
	CHANGE COLUMN `pagamento` `pagamento` INT(11) NULL DEFAULT NULL AFTER `id_cliente`,
	CHANGE COLUMN `id_destinazione` `id_destinazione` INT(11) NULL DEFAULT NULL AFTER `tipo_stampa`;
ALTER TABLE `contratto`
	CHANGE COLUMN `data_inserimento` `data_inserimento` DATE NULL DEFAULT NULL AFTER `varie`,
	CHANGE COLUMN `data` `data` DATE NULL DEFAULT NULL AFTER `data_modifica`;
