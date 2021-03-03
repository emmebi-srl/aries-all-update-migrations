ALTER TABLE `rapporto_mobile`
	ADD COLUMN `invia_a_tecnico` BIT NULL AFTER `mail_responsabile`;

ALTER TABLE `rapporto_mobile`
ADD COLUMN `da_reperibilita_telefonica` BIT(1) NULL DEFAULT b'0' AFTER `invia_a_tecnico`;


ALTER TABLE `rapporto_mobile`
ADD COLUMN `id_tecnico` MEDIUMINT NOT NULL AFTER `da_reperibilita_telefonica`;