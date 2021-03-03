ALTER TABLE `fattura`
	ADD COLUMN `importo_imponibile` FLOAT(11,2) NOT NULL DEFAULT '0.00' AFTER `trasporto`,
	ADD COLUMN `importo_iva` FLOAT(11,2) NOT NULL DEFAULT '0.00' AFTER `importo_imponibile`,
	ADD COLUMN `importo_totale` FLOAT(11,2) NOT NULL DEFAULT '0.00' AFTER `importo_iva`;


DROP PROCEDURE IF EXISTS sp_tmp_calculate_invoice_totals; 
DELIMITER $$
CREATE PROCEDURE `sp_tmp_calculate_invoice_totals`(
)
BEGIN
	DECLARE vat_value INT(11);
	SELECT aliquota INTO vat_value FROM tipo_iva WHERE normale=1;
	
	DROP TABLE IF EXISTS tmp_invoice_totals_tbl;
	CREATE TABLE tmp_invoice_totals_tbl
	SELECT 
		fattura.id_fattura, 
		fattura.anno,
		round(round(SUM(CAST(round(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS decimal(11,5)),2)*quantità AS decimal(11,3))),3),2)*if(tipo_fattura=4,0,1)
          +((bollo+incasso+trasporto)) AS "importo_imponibile",
		round(round(SUM(CAST(round(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS decimal(11,5)),2)*quantità*c.iva/100 AS decimal(11,3))),3),2) 
          +((bollo+incasso+trasporto)*((
        vat_value )/100)) AS "importo_iva",
		(round(round(SUM(CAST(round(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS decimal(11,5)),2)*quantità AS decimal(11,3))),3),2)*if(tipo_fattura=4,0,1)
        +round(round(SUM(CAST(round(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS decimal(11,5)),2)*quantità*c.iva/100 AS decimal(11,3))),3),2)) 
          +((bollo+incasso+trasporto)*((
        vat_value +100)/100)) AS "importo_totale"
	FROM fattura  
		INNER JOIN fattura_articoli AS c ON fattura.id_fattura = c.id_fattura AND fattura.anno = c.anno
	GROUP BY id_fattura, anno
	ORDER BY anno desc, id_fattura desc;
	
	UPDATE fattura
		INNER JOIN tmp_invoice_totals_tbl as tmp ON fattura.id_fattura = tmp.id_fattura AND fattura.anno = tmp.anno
	SET fattura.importo_imponibile = IFNULL(tmp.importo_imponibile, 0),
		fattura.importo_iva = IFNULL(tmp.importo_iva, 0),
		fattura.importo_totale = IFNULL(tmp.importo_totale, 0);


	DROP TABLE IF EXISTS tmp_invoice_totals_tbl;
END $$
DELIMITER ;

call sp_tmp_calculate_invoice_totals();

DROP PROCEDURE IF EXISTS sp_tmp_calculate_invoice_totals; 

DROP TABLE IF EXISTS`fattura_totali_iva`;
CREATE TABLE `fattura_totali_iva` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_fattura` INT(11) NOT NULL,
	`anno` INT(11) NOT NULL,
	`id_iva` INT(11) NOT NULL,
	`importo_imponibile` DECIMAL(10,2) NOT NULL,
	`importo_iva` DECIMAL(10,2) NOT NULL,
	`importo_totale` DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id_fattura_anno_id_iva` (`id_fattura`, `anno`, `id_iva`),
	INDEX `fk_fattura_totali_id_iva` (`id_iva`),
	CONSTRAINT `fk_fattura_totali_id_iva` FOREIGN KEY (`id_iva`) REFERENCES `tipo_iva` (`Id_iva`),
	CONSTRAINT `fk_fattura_totali_fattura` FOREIGN KEY (`id_fattura`, `anno`) REFERENCES `fattura` (`Id_fattura`, `anno`)
)
COMMENT='Storico dei totali delle fatture suddivisi per iva'
ENGINE=InnoDB
;
INSERT INTO `tipo_iva` VALUES (19, 'IVA 19%', NULL, 19, NULL, 0, NULL, NULL, 1);


DROP PROCEDURE IF EXISTS sp_tmp_calculate_invoice_totals_by_tax; 
DELIMITER $$
CREATE PROCEDURE `sp_tmp_calculate_invoice_totals_by_tax`(
)
BEGIN
	DECLARE cursor_id INT(11);
	DECLARE invoice_id INT(11);
	DECLARE invoice_year INT(11);
	DECLARE invoice_type INT(11);
	DECLARE reg_date DATE;
	DECLARE iva_id INT(11);
	DECLARE rows_number INT(11);
	DECLARE exit_loop BOOLEAN;
	
	DECLARE cursos CURSOR FOR SELECT id, 
			id_fattura, 
			Anno, 
			Tipo_fattura,
			Data_registrazione
	FROM fattura;
			
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
		
	TRUNCATE fattura_totali_iva;

	OPEN cursos;
		
		-- start looping
		cursos_loop: LOOP
		-- read the name from next row into the variables 
		FETCH  cursos INTO cursor_id, invoice_id, invoice_year, invoice_type, reg_date;
		
		IF exit_loop THEN
			CLOSE cursos;
			LEAVE cursos_loop;
		END IF;
		
		IF (Reg_date < CAST('1997-10-01' AS DATE)) THEN
			SELECT id_iva INTO iva_id
			FROM tipo_iva
			WHERE aliquota = 19;
		ELSE 
			IF (Reg_date < CAST('2011-09-17' AS DATE)) THEN
				SELECT id_iva INTO iva_id
				FROM tipo_iva
				WHERE aliquota = 20;
			ELSE 
				IF (Reg_date < CAST('2013-10-01' AS DATE)) THEN
					SELECT id_iva INTO iva_id
					FROM tipo_iva
					WHERE aliquota = 21;
				ELSE
					SELECT id_iva INTO iva_id
					FROM tipo_iva
					WHERE aliquota = 22;
				END IF;
			END IF;
		END IF;
		
		
		SELECT COUNT(*) into rows_number
		FROM  (SELECT invoice_id, invoice_year, iva AS "id_tipo_iva", 
				ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2) * IF(invoice_type = 4, 0, 1)  AS "iv1", 
				CAST(ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2)*aliquota/100 AS decimal(11,2)) AS "iv2", 
				ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2) * IF(invoice_type = 4, 0, 1) + CAST(ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2)*aliquota/100 AS decimal(11,2))
			FROM (
				SELECT 
					IF(iva = 0, (SELECT id_iva FROM tipo_iva where natura ='N6' LIMIT 1),  (SELECT id_iva FROM tipo_iva where aliquota = iva LIMIT 1)) AS "iva", 
					IF(tipo<>"S", prezzo_unitario,"0") AS "prezzo_unitario", 
					IF(tipo="S", prezzo_unitario,"0") AS "uni2",
					sconto,
					quantità 
				FROM fattura_articoli
				WHERE id_fattura = invoice_id and anno = invoice_year
			   UNION ALL SELECT 
					iva_id AS "iva",
					trasporto AS "prezzo_unitario",
					trasporto AS "uni2",
					0 AS "sconto",
					1 AS "quantità"
				FROM fattura 
				WHERE trasporto > 0 AND id = cursor_id
			   UNION ALL SELECT 
					iva_id AS "iva",
					incasso AS "prezzo_unitario",
					incasso,
					0 AS "sconto",
					1 AS "quantità" 
				FROM fattura 
				WHERE incasso > 0 AND id = cursor_id
			   UNION ALL SELECT 
					(SELECT id_iva FROM tipo_iva where natura ='N6' LIMIT 1) AS "iva",
					bollo AS "prezzo_unitario",
					bollo,
					0 AS "sconto",
					1 AS "quantità" 
				FROM fattura 
				WHERE bollo > 0 AND id = cursor_id
			) AS asdasd
				INNER JOIN tipo_iva ON asdasd.iva = tipo_iva.id_iva
			WHERE iva IS NOT NULL GROUP BY iva HAVING iv1 > 0 ) as asdiohad;
		

		IF rows_number > 0 THEN
			INSERT INTO fattura_totali_iva (
				`id_fattura`,
				`anno`,
				`id_iva`,
				`importo_imponibile`,
				`importo_iva`,
				`importo_totale`
			)
			SELECT invoice_id, invoice_year, iva AS "id_tipo_iva", 
				ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2) * IF(invoice_type = 4, 0, 1)  AS "iv1", 
				CAST(ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2)*aliquota/100 AS decimal(11,2)) AS "iv2", 
				ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2) * IF(invoice_type = 4, 0, 1) + CAST(ROUND(ROUND(SUM(CAST(CAST((prezzo_unitario-(sconto/100*prezzo_unitario)) AS DECIMAL(11,5))*quantità AS decimal(11,3))),3),2)*aliquota/100 AS decimal(11,2))
			FROM (
				SELECT 
					IF(iva = 0, (SELECT id_iva FROM tipo_iva where natura ='N6' LIMIT 1),  (SELECT id_iva FROM tipo_iva where aliquota = iva LIMIT 1)) AS "iva", 
					IF(tipo<>"S", prezzo_unitario,"0") AS "prezzo_unitario", 
					IF(tipo="S", prezzo_unitario,"0") AS "uni2",
					sconto,
					quantità 
				FROM fattura_articoli
				WHERE id_fattura = invoice_id and anno = invoice_year
			   UNION ALL SELECT 
					iva_id AS "iva",
					trasporto AS "prezzo_unitario",
					trasporto AS "uni2",
					0 AS "sconto",
					1 AS "quantità"
				FROM fattura 
				WHERE trasporto > 0 AND id = cursor_id
			   UNION ALL SELECT 
					iva_id AS "iva",
					incasso AS "prezzo_unitario",
					incasso,
					0 AS "sconto",
					1 AS "quantità" 
				FROM fattura 
				WHERE incasso > 0 AND id = cursor_id
			   UNION ALL SELECT 
					(SELECT id_iva FROM tipo_iva where natura ='N6' LIMIT 1) AS "iva",
					bollo AS "prezzo_unitario",
					bollo,
					0 AS "sconto",
					1 AS "quantità" 
				FROM fattura 
				WHERE bollo > 0 AND id = cursor_id
			) AS temp
				INNER JOIN tipo_iva ON temp.iva = tipo_iva.id_iva
			WHERE iva IS NOT NULL GROUP BY iva HAVING iv1 > 0 ;
		END IF;
		

			
	END LOOP cursos_loop;

	
END $$
DELIMITER ;

call sp_tmp_calculate_invoice_totals_by_tax();

DROP PROCEDURE IF EXISTS sp_tmp_calculate_invoice_totals_by_tax; 

