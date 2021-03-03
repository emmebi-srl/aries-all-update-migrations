INSERT INTO `configurazione_percorsi` 
SELECT CONCAT(Percorso, 'RAPPORTO\\{report_year}\\{report_id}\\FIRME\\'),
	'RAPPORTO_FIRME' 
FROM configurazione_percorsi 
WHERE Tipo_percorso = 'DEFAULT'; 

ALTER TABLE `rapporto_mobile`
	ADD COLUMN `filename_firma_cliente` VARCHAR(50) NULL DEFAULT NULL AFTER `da_reperibilita_telefonica`,
	ADD COLUMN `filename_firma_tecnico` VARCHAR(50) NULL DEFAULT NULL AFTER `filename_firma_cliente`;

	
ALTER TABLE `rapporto_mobile_collaudo`
	ADD COLUMN `filename_firma_cliente` VARCHAR(50) NULL DEFAULT NULL AFTER `Processato`,
	ADD COLUMN `filename_firma_tecnico` VARCHAR(50) NULL DEFAULT NULL AFTER `filename_firma_cliente`;


ALTER TABLE `ddt`
	ADD COLUMN `filename_firma_destinatario` VARCHAR(50) NULL DEFAULT NULL AFTER `stato`;

ALTER TABLE `ddt`
	ADD COLUMN `filename_firma_conducente` VARCHAR(50) NULL DEFAULT NULL AFTER `filename_firma_destinatario`;
	

ALTER TABLE `rapporto_mobile`
	ADD COLUMN `usa_firma_su_ddt` BIT NULL DEFAULT b'0' COMMENT 'Se true viene usata la firma del rapporto su DDT automaticamente alla stampa' AFTER `filename_firma_tecnico`;

	
ALTER TABLE `rapporto`
	ADD COLUMN `filename_firma_cliente` VARCHAR(50) NULL DEFAULT NULL AFTER `Id_tipo_sorgente`,
	ADD COLUMN `filename_firma_tecnico` VARCHAR(50) NULL DEFAULT NULL AFTER `filename_firma_cliente`;

INSERT INTO `configurazione_percorsi` 
SELECT CONCAT(Percorso, 'DDT EMESSI\\{ddt_year}\\{ddt_id}\\FIRME\\'),
	'DDT_FIRME' 
FROM configurazione_percorsi 
WHERE Tipo_percorso = 'DEFAULT'; 

ALTER TABLE `rapporto_mobile`
	ADD COLUMN `usa_altra_firma_su_ddt` BIT NULL DEFAULT b'0' COMMENT 'Se true viene usata la firma del rapporto su DDT automaticamente alla stampa' AFTER filename_firma_tecnico,
	ADD COLUMN `filename_firma_per_ddt` VARCHAR(50) NULL DEFAULT NULL AFTER `usa_altra_firma_su_ddt`;
	

ALTER TABLE `rapporto`
	ADD COLUMN `usa_firma_su_ddt` BIT NULL DEFAULT b'0' COMMENT 'Se true viene usata la firma del rapporto su DDT automaticamente alla stampa' AFTER `filename_firma_tecnico`;
ALTER TABLE `rapporto`
	ADD COLUMN `filename_firma_per_ddt` VARCHAR(50) NULL DEFAULT NULL AFTER `usa_firma_su_ddt`;
	
	


	