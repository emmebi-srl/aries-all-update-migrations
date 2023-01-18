ALTER TABLE `rapporto`
	DROP COLUMN `materiale`;

ALTER TABLE `rapporto_mobile`
	DROP COLUMN `materiale`;


ALTER TABLE `rapporto`
	CHANGE COLUMN `dir_ric_fatturato` `dir_ric_fatturato` TINYINT NOT NULL DEFAULT 0 AFTER `Diritto_chiamata`;
ALTER TABLE `rapporto_mobile`
	CHANGE COLUMN `dir_ric_fatturato` `dir_ric_fatturato` TINYINT NOT NULL DEFAULT 0 AFTER `Diritto_chiamata`;

ALTER TABLE `rapporto`
	CHANGE COLUMN `dir_ric_fatturato` `tipo_diritto_chiamata` TINYINT(4) NOT NULL DEFAULT '0' AFTER `Diritto_chiamata`;


ALTER TABLE `rapporto_mobile`
	CHANGE COLUMN `dir_ric_fatturato` `tipo_diritto_chiamata` TINYINT(4) NOT NULL DEFAULT '0' AFTER `Diritto_chiamata`;

	

UPDATE rapporto SET tipo_diritto_chiamata = 0 WHERE diritto_chiamata = 0;
