
UPDATE `stampante_moduli` SET `modulo`='SALDO FATTURE' WHERE  `id_documento`=4 AND `Id_modulo`=1;
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (2, 4, 2, '2016-12-10 07:54:04');
UPDATE `stampante_moduli` SET `Attivo`=b'0' WHERE  `id_documento`=4 AND `Id_modulo`=4;

ALTER TABLE `fattura`
	ADD COLUMN `costo_totale` FLOAT(11,2) NOT NULL DEFAULT '0.00' AFTER `importo_totale`;

DROP PROCEDURE IF EXISTS sp_tmp_calculate_invoice_totals; 
DELIMITER $$
CREATE PROCEDURE `sp_tmp_calculate_invoice_totals`(
)
BEGIN
	
	DROP TABLE IF EXISTS tmp_invoice_totals_tbl;
	CREATE TABLE tmp_invoice_totals_tbl
	SELECT 
		fattura.id_fattura, 
		fattura.anno,
		round(SUM(round(CAST((IFNULL(costo, 0) * IFNULL(quantità, 0))AS decimal(11,5)),2)), 2)  AS "costo_totale"
	FROM fattura  
		INNER JOIN fattura_articoli AS c ON fattura.id_fattura = c.id_fattura AND fattura.anno = c.anno
	GROUP BY id_fattura, anno
	ORDER BY anno desc, id_fattura desc;
	
	UPDATE fattura
		INNER JOIN tmp_invoice_totals_tbl as tmp ON fattura.id_fattura = tmp.id_fattura AND fattura.anno = tmp.anno
	SET fattura.costo_totale = IFNULL(tmp.costo_totale, 0);


	DROP TABLE IF EXISTS tmp_invoice_totals_tbl;
END $$
DELIMITER ;

call sp_tmp_calculate_invoice_totals();

DROP PROCEDURE IF EXISTS sp_tmp_calculate_invoice_totals; 
