CREATE TABLE `campagna_aries_mail_stato` (
	`id` INT(11) NOT NULL,
	`uuid` CHAR(36) NOT NULL COLLATE 'latin1_swedish_ci',
	`nome` VARCHAR(30) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`descrizione` VARCHAR(100) NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`finale` BIT(1) NOT NULL DEFAULT b'0',
	`colore` VARCHAR(30) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uuid` (`uuid`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `campagna_aries_mail_stato`
	CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT FIRST;



INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'IN ATTESA DI INVIO', 0, '$00FFFF', NOW());


INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'INVIATA', 0, '$00FFFF', NOW());


INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'VISIONATA', 0, '$FFFFE0', NOW());


INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'APERTURA PAGINA', 0, '$E6D8AD', NOW());


INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'RICEVUTA RISPOSTA', 0, '$FF0000', NOW());

INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'ESITO POSITIVO', 1, '$00FF00', NOW());

INSERT INTO campagna_aries_mail_stato (uuid, nome, finale, colore, data_ins)
VALUES (UUID(), 'ESITO NEGATIVO', 1, '$0000FF', NOW());

ALTER TABLE `campagna_aries_mail`
	ADD COLUMN `id_stato` INT NOT NULL DEFAULT '1' AFTER `processato`,
	ADD CONSTRAINT `FK_campagna_aries_mail_stato` FOREIGN KEY (`id_stato`) REFERENCES `campagna_aries_mail_stato` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;


RENAME TABLE `campagna_aries_mail_stato` TO `stato_campagna_aries_mail`;