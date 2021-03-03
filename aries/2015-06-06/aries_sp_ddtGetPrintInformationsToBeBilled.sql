DROP PROCEDURE IF EXISTS sp_ddtGetPrintInformationsToBeBilled;
DELIMITER $$
CREATE PROCEDURE sp_ddtGetPrintInformationsToBeBilled(
	ddtYear SMALLINT, OUT ddtsNumbers MEDIUMINT, OUT ddtsTotalPrice DECIMAL(11,2), OUT ddtsTotalCost DECIMAL(11,2))
BEGIN

	SELECT 
		ddt.id_ddt AS "DdtId", 
		data_documento AS "Date", 
		clienti.ragione_sociale AS "CompanyName",
		causale_trasporto.causale AS "CausalTransport", 
		IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Municipality",  
		IFNULL(ddt.fattura, "") AS "InvoiceId",
		IFNULL(impianto.descrizione, "") AS "SystemDescription", 
		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalPrice, 
		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalCost
	FROM ddt
		LEFT JOIN causale_trasporto ON ddt.causale=id_causale
		INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente
		LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione
		LEFT JOIN comune AS b1 ON b1.id_comune=b.comune
		LEFT JOIN impianto ON id_impianto=impianto
		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
	WHERE (ddt.Stato = 1 OR (ddt.Stato=3 AND ddt.fattura IS NULL)) AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno)
	GROUP BY ddt.Id_ddt, ddt.anno
	ORDER BY ddt.anno DESC, ddt.Id_ddt; 
	
	SELECT COUNT(ddt.id_ddt),
		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)), 
		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2))
		INTO 
		ddtsNumbers,
		ddtsTotalPrice,
		ddtsTotalCost
	FROM ddt
		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
	WHERE (ddt.Stato = 1 OR (ddt.Stato=3 AND ddt.fattura IS NULL)) AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno);
			

END $$
DELIMITER ;
