ALTER TABLE `ddt`
	ADD CONSTRAINT `FK_ddt_stato_ddt` FOREIGN KEY (`stato`) REFERENCES `stato_ddt` (`Id_stato`) ON UPDATE CASCADE;

ALTER TABLE `ddt`
	CHANGE COLUMN `stato` `stato` INT(11) NOT NULL DEFAULT '1' AFTER `anno_fatturaf`;

ALTER TABLE `tipo_fattura`
	CHANGE COLUMN `Descrizione` `Descrizione` VARCHAR(150) NULL DEFAULT NULL AFTER `nome`;

INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('PARCELLA', 'PARCELLA', 'TD06');
INSERT INTO tipo_fattura(`nome`, `Descrizione`, `tipo_PA`) VALUES ('ACCONTO/ANTICIPO PARCELLA', 'ACCONTO/ANTICIPO SU PARCELLA', 'TD03');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('FATTURA SEMPLIFICATA', 'FATTURA SEMPLIFICATA', 'TD07');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('NOTA DI CREDITO SEMPLIF', 'NOTA DI CREDITO SEMPLIFICATA', 'TD08');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('NOTA DI DEBITO SEMPLIF', 'NOTA DI DEBITO SEMPLIFICATA', 'TD09');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('FATTURA ACQUISTO INTRACOM BENI', 'FATTURA DI ACQUISTO INTERCOMUNITARIO BENI', 'TD10');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('FATTURA ACQUISTO INTRACOM SERVIZI', 'FATTURA DI ACQUISTO INTERCOMUNITARIO SERVIZI', 'TD11');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('DOCUMENTO RIEPILOGATIVO', 'DOCUMENTO RIEPILOGATIVO (art. 6, d.P.R. 695/1996)', 'TD12');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('INTEGRAZIONE REVERSE CHARGE INTERNO', 'INTEGRAZIONE FATTURA REVERSE CHARGE INTERNO', 'TD16');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('AUTOFATTURA AQUISTO SERVIZI ESTERO', 'INTEGRAZIONE/AUTOFATTURA PER AQUISTO SERVIZI DALL\'ESTERO', 'TD17');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('INTEGRAZIONE AQUISTO BENI INTRACOM', 'INTEGRAZIONE PER AQUISTO BENI INTRACOMUNITARI', 'TD18');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('AUTOFATTURA AQUISTO BENI EX ART 17 C.2', 'AUTOFATTURA PER AQUISTO BENI EX ART 17 c.2 D PR 633/72', 'TD19');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('AUTOFATTURA PER REGOLAR E INTEGR DELLE FATTURE', 'AUTOFATTURA PER REGOLARIZZAZIONE E INTEGRAZIONE DELLE FATTURE (EX ART. 6 C.8 E 9 BIS D.LGS. 471/97 O ART. 46 C.5 D.L. 331/93)', 'TD20');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('AUTOFATTURA PER SPLAFONAMENTO', 'AUTOFATTURA PER SPLAFONAMENTO', 'TD21');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('ESTRAZIONE BENI DA DEPOSITO IVA', 'ESTRAZIONE BENI DA DEPOSITO IVA', 'TD22');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('ESTRAZIONE BENI DA DEPOSITO IVA CON VERSAMENTO IVA', 'ESTRAZIONE BENI DA DEPOSITO IVA CON VERSAMENTO DELL IVA', 'TD23');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('FATTURA DIFFERITA - ART. 21, COMMA 4, LETT A)', 'FATTURA DIFFERITA DI CUI ALL\'ART. 21, COMMA 4, LETT. A)', 'TD24');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('FATTURA DIFFERITA - ART. 21, TERZO PERIOD LETT B)', 'FATTURA DIFFERITA DI CUI ALL\'ART. 21, COMMA 4, TERZO PERIODO LETT. B)', 'TD25');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('CESSIONE BENI AMMORTIZ/PASSAGGI INTERNI', 'CESSIONE DI BENI AMMORTIZZABILI E PER PASSAGGI INTERNI (EX ART. 36 D.P.R. 633/72)', 'TD26');
INSERT INTO tipo_fattura(Nome, Descrizione, Tipo_PA) VALUES ('FATTURA AUTOCONSUMO/CESSIONI GRATUITE', 'FATTURA PER AUTOCONSUMO O PER CESSIONI GRATUITE SENZA RIVALSA', 'TD27');

CREATE TABLE `tipo_natura_iva` (
	`id_tipo_natura_iva` INT(11) NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(100) NOT NULL,
	`descrizione` VARCHAR(350) NOT NULL,
	`tipo_PA` VARCHAR(10) NOT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_tipo_natura_iva`),
	UNIQUE INDEX `tipo_pa` (`tipo_PA`)
);
INSERT INTO tipo_natura_iva  (tipo_PA, descrizione, nome) VALUES
("N1","Operazioni escluse ex art. 15","OPERAZIONI ESCUSE"),
("N2.1","Operazioni non soggette ad IVA ai sensi degli artt. da 7 a 7-septies","OPERAZIONI NON SOGGETTE A IVA ART 7"),
("N2.2","Operazioni non soggette – altri casi","OPERAZIONI NON SOGGETTE -  ALTRI CASI"),
("N3.1","Operazioni non imponibili – esportazioni","OPERAZIONI NON IMPONIBILI - ESPORTAZIONI"),
("N3.2","Operazioni non imponibili – cessioni intracomunitarie","OPERAZIONI NON IMPONIBILI - CESSIONI INTRACOM"),
("N3.3","Operazioni non imponibili – cessioni verso San Marino","OPERAZIONI NON IMPONIBILI - CESSIONI SAN MARINO"),
("N3.4","Operazioni non imponibili – operazioni assimilate alle cessioni all’esportazione","OPERAZIONI NON IMPONIBILI - ASSIMILATE ALLE CESIONI ALL'ESPORTAZIONE"),
("N3.5","Operazioni non imponibili – a seguito di dichiarazioni d’intento","OPERAZIONI NON IMPONIBILI - DA LETTERA D'INTENTO"),
("N3.6","Operazioni non imponibili – altre operazioni che non concorrono alla formazione del plafond","OPERAZIONI NON IMPONIBILI - ALTRE OPERAZIONI NO PLAFOND"),
("N4","Operazioni esenti","OPERAZIONI ESENTI"),
("N5","Regime del margine/IVA non esposta in fattura","REGIME MARGINE/IVA NON ESPOSTA IN FATTURA"),
("N6.1","Inversione contabile – cessione di rottami e altri materiali di recupero","INVERSIONE CONTABILE - CESSIONE ROTTAMI/MATERIALI DI RECUPERO"),
("N6.2","Inversione contabile – cessione di oro e argento puro","INVERSIONE CONTABILE - CESSIONE ORO/ARGENTO PURO"),
("N6.3","Inversione contabile – subappalto nel settore edile","INVERSIONE CONTABILE - SUBBAPALTO SETTORE EDILE"),
("N6.4","Inversione contabile – cessione di fabbricati","INVERSIONE CONTABILE - CESSIONE FABBRICATI"),
("N6.5","Inversione contabile – cessione di telefoni cellulari","INVERSIONE CONTABILE - CESSIONE TELEFONI CELLULARI"),
("N6.6","Inversione contabile – cessione di prodotti elettronici","INVERSIONE CONTABILE - CESSIONE PRODOTTI ELETTRONICI"),
("N6.7","Inversione contabile – prestazioni comparto edile e settori connessi","INVERSIONE CONTABILE - COMPARTO EDILE E SETTORI CONNESSI"),
("N6.8","Inversione contabile – operazioni settore energetico","INVERSIONE CONTABILE - SETTORE ENERGETICO"),
("N6.9","Inversione contabile – altri casi","INVERSIONE CONTABILE - ALTRI CASI"),
("N7","IVA assolta in altro stato UE (vendite a distanza ex art. 40 commi 3 e 4 e art. 41 comma 1 lett. b), D.L, 331/93; prestazione di servizi di telecomunicazioni, tele-radiodiffusione ed elettronici ex art. 7-sexies f), g), DPR n. 633/72 e art. 74-sexies, DPR n. 633/72)", "IVA ASSOLTA IN ALTRO STATO UE");


ALTER TABLE `fattura`
	ADD COLUMN `id_tipo_natura_iva` INT(11) NULL DEFAULT NULL AFTER `id_iv`;
ALTER TABLE `fattura`
	CHANGE COLUMN `id_tipo_natura_iva` `id_tipo_natura_iva` INT(11) NULL DEFAULT NULL AFTER `id_iv`;

ALTER TABLE `fattura`
	DROP FOREIGN KEY `FK_fattura_8`;
ALTER TABLE `fattura`
	ADD CONSTRAINT `FK_fattura_tipo_iva` FOREIGN KEY (`id_iv`) REFERENCES `tipo_iva` (`Id_iva`);

ALTER TABLE `fattura`
	ADD CONSTRAINT `FK_fattura_tipo_natura_iva` FOREIGN KEY (`id_tipo_natura_iva`) REFERENCES `tipo_natura_iva` (`id_tipo_natura_iva`);

ALTER TABLE `tipo_natura_iva`
	ADD COLUMN `abilitato` BIT NOT NULL DEFAULT b'1' AFTER `tipo_PA`;

INSERT INTO `tipo_natura_iva` (`nome`, `descrizione`, `tipo_PA`, `abilitato`) VALUES ('OPERAZIONI NON SOGGETTE', 'Operazioni non soggette', 'N2', b'0');
INSERT INTO `tipo_natura_iva` (`nome`, `descrizione`, `tipo_PA`, `abilitato`) VALUES ('OPERAZIONI NON IMPONIBILI', 'Operazioni non imponibili', 'N3', b'0');
INSERT INTO `tipo_natura_iva` (`nome`, `descrizione`, `tipo_PA`, `abilitato`) VALUES ('INVERSIONE CONTABILE', 'Inversione contabile', 'N6', b'0');


UPDATE FATTURA
	INNER JOIN tipo_iva ON tipo_iva.Id_iva = Fattura.Id_iv AND natura IS NOT NULL AND natura <> ''
	INNER JOIN tipo_natura_iva ON tipo_natura_iva.tipo_PA = natura
SET Fattura.id_tipo_natura_iva = tipo_natura_iva.id_tipo_natura_iva;

ALTER TABLE `tipo_iva`
	DROP COLUMN `natura`;
    
drop table fattura_pa;

CREATE TABLE `fattura_elettronica_versione` (
	`id_fattura_elettronica_versione` INT(11) NOT NULL AUTO_INCREMENT,
	`versione` VARCHAR(20) NOT NULL,
	`codice_versione_pa` VARCHAR(10) NOT NULL,
	`codice_versione_privato` VARCHAR(10) NOT NULL,
	`styles_versione_pa` TEXT NOT NULL,
	`local_styles_versione_pa` TEXT NOT NULL,
	`styles_versione_privato` TEXT NOT NULL,
	`local_styles_versione_privato` TEXT NOT NULL,
	`data_inizio` DATE NULL DEFAULT NULL,
	`data_fine` DATE NULL DEFAULT NULL,
	`corrente` BIT(1) NOT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_fattura_elettronica_versione`)
)
ENGINE=InnoDB
;

INSERT INTO `fattura_elettronica_versione` (`versione`, `codice_versione_pa`, `codice_versione_privato`, `styles_versione_pa`, `local_styles_versione_pa`, `styles_versione_privato`, `local_styles_versione_privato`, `data_fine`, `corrente`) VALUES
  ('v1.2.1', 'FPA12', 'FPR12', '<?xml-stylesheet type="text/xsl" href="http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2.1/fatturaPA_v1.2.1.xsl"?>', 'fatturaPA_v1.2.1.xsl', '<?xml-stylesheet type="text/xsl" href="http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2.1/fatturaordinaria_v1.2.1.xsl"?>', 'fatturaordinaria_v1.2.1.xsl', '2020-12-31', b'0');

UPDATE `fattura_elettronica_versione`
	SET `data_inizio`='2018-01-01'
WHERE  `id_fattura_elettronica_versione`=1;

INSERT INTO `fattura_elettronica_versione` (`versione`, `codice_versione_pa`, `codice_versione_privato`, `styles_versione_pa`, `local_styles_versione_pa`, `styles_versione_privato`, `local_styles_versione_privato`, `data_inizio`, `corrente`, `data_mod`) VALUES ('v1.6.2', 'FPA12', 'FPR12', '<?xml-stylesheet type="text/xsl" href="http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2.1/fatturaPA_v1.2.1.xsl"?>', 'fatturaPA_v1.6.2.xsl', '<?xml-stylesheet type="text/xsl" href="http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2.1/fatturaordinaria_v1.2.1.xsl"?>', 'fatturaordinaria_v1.6.2.xsl', '2021-01-01', b'1', '2020-12-24 05:49:12');
UPDATE `fattura_elettronica_versione`
SET `styles_versione_pa`='<?xml-stylesheet type="text/xsl" href="http://www.fatturapa.gov.it/export/documenti/fatturapa/v1.2.1/Foglio_di_stile_fatturaPA_v1.2.1.xsl"?>',
  `styles_versione_privato`='<?xml-stylesheet type="text/xsl" href="http://www.fatturapa.gov.it/export/documenti/fatturapa/v1.2.1/Foglio_di_stile_fatturaordinaria_v1.2.1.xsl"?>'
WHERE  `id_fattura_elettronica_versione`=2;
