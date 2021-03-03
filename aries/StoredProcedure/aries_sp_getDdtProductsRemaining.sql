DROP PROCEDURE IF EXISTS sp_getDdtProductsRemaining;
DELIMITER $$
CREATE PROCEDURE sp_getDdtProductsRemaining(
	ddtId INT, ddtYear INT)
BEGIN

	-- CREATE TEMPORARY TABLE WITH RICEIVED PRODUCTS
	DROP TEMPORARY TABLE IF EXISTS tmpTblDdtProductsRiceived;
	CREATE TEMPORARY TABLE tmpTblDdtProductsRiceived (
			product_id VARCHAR(11) NOT NULL PRIMARY KEY,
			quantity DECIMAL(11,2)
	) ENGINE = innoDB;

	INSERT INTO tmpTblDdtProductsRiceived 
	SELECT Id_articolo AS product_id, SUM(Quantita) AS quantity
	FROM (
			SELECT ff.id_materiale AS Id_articolo, ff.`quantità` AS Quantita
			FROM articoli_ddt de
				INNER JOIN fornfattura_articoli ff 
					ON de.id_ddt = ff.id_rif
					AND de.anno = ff.anno_rif
					AND de.Id_articolo = ff.id_materiale
					AND ff.tipo = '+'
			WHERE de.id_ddt = ddtId
			AND de.anno = ddtYear
			UNION ALL 
			SELECT dr.id_articolo, dr.`quantità`
			FROM articoli_ddt de
				INNER JOIN articoli_ddt_ricevuti dr 
					ON de.id_ddt = dr.id_rif
					AND de.anno = dr.anno_rif
					AND de.Id_articolo = dr.id_articolo
					AND dr.tipo = '+'
			WHERE de.id_ddt = ddtId
			AND de.anno = ddtYear
			) AS DdtProductsRiceived
	GROUP BY Id_articolo;

	SELECT id_articolo, desc_breve, codice_fornitore, serial_number, if(quantity IS NULL, quantità, quantità-quantity) as quantità ,unità_misura, prezzo, costo, id_Ddt, anno, idnota, 
	causale_scarico,sconto
	FROM articoli_ddt de
		LEFT JOIN tmpTblDdtProductsRiceived 
			ON de.Id_articolo = tmpTblDdtProductsRiceived.product_id
	WHERE de.id_ddt = ddtId
	AND de.anno = ddtYear
	AND (tmpTblDdtProductsRiceived.product_id IS NULL
	OR de.`quantità`>tmpTblDdtProductsRiceived.quantity)
	ORDER BY numero_tab;

		
END $$
DELIMITER ;