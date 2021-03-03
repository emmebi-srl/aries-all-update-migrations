-- First of all align old invocie payment

DROP PROCEDURE IF EXISTS sp_tmp;
DELIMITER $$
CREATE PROCEDURE `sp_tmp`(
)
BEGIN

	DROP TABLE IF EXISTS tmp_fattura_pagamenti;

	CREATE TABLE `tmp_fattura_pagamenti` 
	SELECT 
		
		fattura.id_fattura,
		fattura.anno, 
		
		ROUND((ROUND(ROUND(SUM(CAST(ROUND(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5)),2)*quantità AS DECIMAL(11,3))),3),2)* IF(tipo_fattura=4,0,1) + ROUND(ROUND(SUM(CAST(ROUND(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5)),2)*quantità*c.iva/100 AS DECIMAL(11,3))),3),2))/a.mesi - (
	SELECT IF(SUM(importo) IS NULL,0, SUM(importo))
	FROM fattura_acconto
	WHERE fattura_acconto.id_fattura=fattura.id_fattura AND fattura_acconto.anno=fattura.anno AND fattura_acconto.id_pagamento = DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d'))+((bollo+incasso+trasporto)*((22+100)/100))/a.mesi, 2) AS "Importo_rata", 

	LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY AS "Data_pagamento", 

	Id_pagamento,
	fattura_pagamenti.data AS "Data_effettiva_pagamento", 

	a.Id_condizione AS "Id_condizione_pagamento", 
	a.nome AS "Condizione_pagamento", 
	IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, fattura_pagamenti.tipo_pagamento, a.tipo)  AS "Id_tipo_pagamento", 
	IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, tipopag_pagamento1.nome, tipopag_pagamento.nome) AS "Tipo_pagamento",
	 fattura_pagamenti.data IS NOT NULL AS "Pagato", 
	 nota  AS "nota", 
	 fattura_pagamenti.insoluto
	FROM fattura
	INNER JOIN fattura_articoli AS c ON c.id_fattura = fattura.id_fattura AND c.anno=fattura.anno
	INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione
	INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
	LEFT JOIN fattura_pagamenti ON fattura.id_fattura=fattura_pagamenti.id_fattura AND fattura_pagamenti.anno=fattura.anno AND fattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d')
	LEFT JOIN tipo_pagamento AS tipopag_pagamento ON a.tipo = tipopag_pagamento.id_tipo
	LEFT JOIN tipo_pagamento AS tipopag_pagamento1 ON fattura_pagamenti.tipo_pagamento = tipopag_pagamento1.id_tipo
	GROUP BY fattura.id_fattura, fattura.anno, Data_pagamento
	ORDER BY fattura.anno desc, fattura.id_fattura desc;
	
	
	
	
	INSERT IGNORE INTO fattura_pagamenti (	`id_fattura`,`anno`,`nota`,	`data`,	`id_pagamento`,`tipo_pagamento`,`insoluto` )
	SELECT Id_fattura, anno, nota, data_effettiva_pagamento, IFNULL(Id_pagamento, DATE_FORMAT(Data_pagamento,'%Y%m%d')), Id_tipo_pagamento, insoluto 
	
	FROM tmp_fattura_pagamenti;
	
	
	
	-- Check if successfull insert
		SELECT 
		
		fattura.id_fattura,
		fattura.anno, 
		
		ROUND((ROUND(ROUND(SUM(CAST(ROUND(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5)),2)*quantità AS DECIMAL(11,3))),3),2)* IF(tipo_fattura=4,0,1) + ROUND(ROUND(SUM(CAST(ROUND(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5)),2)*quantità*c.iva/100 AS DECIMAL(11,3))),3),2))/a.mesi - (
	SELECT IF(SUM(importo) IS NULL,0, SUM(importo))
	FROM fattura_acconto
	WHERE fattura_acconto.id_fattura=fattura.id_fattura AND fattura_acconto.anno=fattura.anno AND fattura_acconto.id_pagamento = DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d'))+((bollo+incasso+trasporto)*((22+100)/100))/a.mesi, 2) AS "Importo_rata", 

	LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY AS "Data_pagamento", 

	Id_pagamento,
	fattura_pagamenti.data AS "Data_effettiva_pagamento", 

	a.Id_condizione AS "Id_condizione_pagamento", 
	a.nome AS "Condizione_pagamento", 
	IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, fattura_pagamenti.tipo_pagamento, a.tipo)  AS "Id_tipo_pagamento", 
	IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, tipopag_pagamento1.nome, tipopag_pagamento.nome) AS "Tipo_pagamento",
	 fattura_pagamenti.data IS NOT NULL AS "Pagato", 
	 nota  AS "nota", 
	 fattura_pagamenti.insoluto
	FROM fattura
	INNER JOIN fattura_articoli AS c ON c.id_fattura = fattura.id_fattura AND c.anno=fattura.anno
	INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione
	INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
	LEFT JOIN fattura_pagamenti ON fattura.id_fattura=fattura_pagamenti.id_fattura AND fattura_pagamenti.anno=fattura.anno AND fattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d')
	LEFT JOIN tipo_pagamento AS tipopag_pagamento ON a.tipo = tipopag_pagamento.id_tipo
	LEFT JOIN tipo_pagamento AS tipopag_pagamento1 ON fattura_pagamenti.tipo_pagamento = tipopag_pagamento1.id_tipo
	GROUP BY fattura.id_fattura, fattura.anno, Data_pagamento
	ORDER BY fattura.anno desc, fattura.id_fattura desc;
	
	
	
	DROP TABLE IF EXISTS tmp_fattura_pagamenti;		
END $$
DELIMITER ;

CALL sp_tmp(); 
DROP PROCEDURE IF EXISTS sp_tmp;




ALTER TABLE `prima_nota`
	DROP FOREIGN KEY `FK_prima_nota_4_fattura_pag`;


DROP PROCEDURE IF EXISTS sp_tmp;
DELIMITER $$
CREATE PROCEDURE `sp_tmp`(
)
BEGIN

START TRANSACTION;

DROP TABLE IF EXISTS tmp_fattura_pagamenti;

CREATE TABLE `tmp_fattura_pagamenti` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_pagamento` INT(11),
	`id_fattura` INT(11) NOT NULL,
	`anno` INT(11) NOT NULL,
	Importo DECIMAL(10,2) NOT NULL,
	`data_prevista` DATE NOT NULL,
	`data_effettiva` DATE NULL,
	`nota` VARCHAR(150) NULL,
	`Id_tipo_pagamento` INT(11) NULL DEFAULT NULL,
	`Insoluto` BIT NOT NULL DEFAULT b'0',
	`Pagato` BIT NOT NULL DEFAULT b'0',
	`Data_Ins` DATETIME NOT NULL,
	`Data_Mod` DATETIME NULL DEFAULT NULL,
	`Utente_Ins` SMALLINT NOT NULL,
	`Utente_Mod` SMALLINT NULL DEFAULT NULL,
	INDEX `Index_3_tipopag` (`Id_tipo_pagamento`),
	INDEX `Index_3_fat` (`id_fattura`, `anno`),
	UNIQUE INDEX `id_fattura_anno_data_prevista` (`id_fattura`, `anno`, `data_prevista`),
	PRIMARY KEY (`id`),
	CONSTRAINT `FK_fattura_pagamenti_fattura` FOREIGN KEY (`id_fattura`, `anno`) REFERENCES `fattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_fattura_pagamenti_tipo_pagamento` FOREIGN KEY (`Id_tipo_pagamento`) REFERENCES `tipo_pagamento` (`id_Tipo`) ON UPDATE CASCADE ON DELETE NO ACTION
		
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

	
	
	INSERT INTO tmp_fattura_pagamenti (	id_pagamento,`id_fattura`,`anno`,Importo,`data_prevista`,`data_effettiva`,`nota`,
		`Id_tipo_pagamento`,`Insoluto`,`Pagato`,`DataIns`,`DataMod`,`UtenteIns`,`UtenteMod`)
	SELECT
		fattura_pagamenti.id_pagamento,
		fattura_pagamenti.id_fattura,
		fattura_pagamenti.anno,
				ROUND((ROUND(ROUND(SUM(CAST(ROUND(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5)),2)*quantità AS DECIMAL(11,3))),3),2)* IF(tipo_fattura=4,0,1) + ROUND(ROUND(SUM(CAST(ROUND(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5)),2)*quantità*c.iva/100 AS DECIMAL(11,3))),3),2))/a.mesi - (
			SELECT IF(SUM(importo) IS NULL,0, 0)
			FROM fattura_acconto
			WHERE fattura_acconto.id_fattura=fattura.id_fattura AND fattura_acconto.anno=fattura.anno AND fattura_acconto.id_pagamento = DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d'))+((bollo+incasso+trasporto)*((22+100)/100))/a.mesi, 2) AS "Importo_rata", 
		STR_TO_DATE(id_pagamento,'%Y%m%d'),
		fattura_pagamenti.data,
		IF(fattura_pagamenti.nota IS NULL or fattura_pagamenti.nota = '', NULL, fattura_pagamenti.nota),
		fattura_pagamenti.tipo_pagamento,
		IFNULL(fattura_pagamenti.Insoluto, 0),
		IF(fattura_pagamenti.Data IS NOT NULL, 1, 0),
		Data_registrazione,
		Data_ultima_modifica,
		10,
		10
	FROM fattura_pagamenti 
		INNER JOIN fattura
		ON fattura_pagamenti.id_Fattura = fattura.Id_fattura
			AND fattura_pagamenti.anno = fattura.anno
	ORDER BY fattura.ANNO, fattura.Id_fattura; 

	SELECT * FROM tmp_fattura_pagamenti; 
	
	
	UPDATE prima_nota 
	INNER JOIN tmp_fattura_pagamenti 
		on prima_nota.id_fattura = tmp_fattura_pagamenti.Id_Fattura
		AND prima_nota.anno_fattura = tmp_fattura_pagamenti.anno
		AND prima_nota.id_pagamento = tmp_fattura_pagamenti.id_pagamento2
	SET prima_nota.id_pagamento = tmp_fattura_pagamenti.id_pagamento;
	
	
	

	DROP TABLE fattura_pagamenti;
	
	ALTER TABLE tmp_fattura_pagamenti DROP COLUMN id_pagamento2;
	Rename Table tmp_fattura_pagamenti TO fattura_pagamenti; 
	
	SELECT * FROM fattura_pagamenti; 
	
	ROLLBACK; 
				
END $$
DELIMITER ;

CALL sp_tmp(); 
DROP PROCEDURE IF EXISTS sp_tmp;



