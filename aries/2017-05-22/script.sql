CREATE TABLE `preventivo_confcost_categoria` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO `preventivo_confcost_categoria` (`id`, `nome`) VALUES (1, 'Materiale');
INSERT INTO `preventivo_confcost_categoria` (`id`, `nome`) VALUES (2, 'Lavoro');

ALTER TABLE `preventivo_confcost`
	ADD COLUMN `id_categoria` INT(11) NOT NULL DEFAULT 1 AFTER `fattore2`,
	ADD COLUMN `data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `id_categoria`,
	ADD COLUMN `utente_ins` MEDIUMINT(9) NOT NULL DEFAULT '1',
	ADD CONSTRAINT `FK_categoria` FOREIGN KEY (id_categoria) REFERENCES `preventivo_confcost_categoria` (id);


ALTER TABLE `preventivo_confcost`
	CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT FIRST;
