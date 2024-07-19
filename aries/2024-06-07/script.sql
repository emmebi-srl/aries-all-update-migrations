DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpGetBetweenDates;

INSERT IGNORE INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES ('2', '14', '2', '2016-12-10 07:54:04');

ALTER TABLE `fattura_studi`
	DROP FOREIGN KEY `FK_fattura_studi_tipo_fattura`;
ALTER TABLE `fattura_studi`
	ADD CONSTRAINT `FK_fattura_studi_tipo_intervento` FOREIGN KEY (`tipo_fattura`) REFERENCES `tipo_intervento` (`id_tipo`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `fattura_studi`
	DROP FOREIGN KEY `FK_fattura_studi_tipo_intervento`;

ALTER TABLE `fattura_studi`
	CHANGE COLUMN `tipo_fattura` `tipo_intervento` INT(11) NULL DEFAULT NULL AFTER `anno`,
	DROP INDEX `FK_fattura_studi_tipo_intervento`,
	ADD INDEX `FK_fattura_studi_tipo_intervento` (`tipo_intervento`) USING BTREE;


ALTER TABLE `fattura_studi`
	ADD CONSTRAINT `FK_fattura_studi_tipo_intervento` FOREIGN KEY (`tipo_intervento`) REFERENCES `tipo_intervento` (`id_tipo`) ON UPDATE CASCADE ON DELETE RESTRICT;
    

ALTER TABLE `tipo_intervento`
	ADD COLUMN `studi_settore` BIT NULL DEFAULT 0 AFTER `Descrizione`;


UPDATE tipo_intervento SET studi_settore = 1 where id_tipo in (1,2,6);