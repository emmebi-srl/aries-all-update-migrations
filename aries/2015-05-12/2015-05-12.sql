DROP PROCEDURE IF EXISTS sp_getInvoicePeriodicTotals;
DELIMITER $$
CREATE PROCEDURE sp_getInvoicePeriodicTotals(
	IN AnnoFatture INT,
	IN MeseFatture INT,
	OUT FatturaPrezzoNetto DECIMAL(11,2),
	OUT FatturaPrezzoLordo DECIMAL(11,2),
	OUT FatturaPrezzoIva DECIMAL(11,2),
	OUT FatturaCosto DECIMAL(11,2),
	OUT PrefatturaPrezzoLordo DECIMAL(11,2),
	OUT PrefatturaCosto DECIMAL(11,2),
	OUT TotalePrezzoLordo DECIMAL(11,2),
	OUT TotaleCosto DECIMAL(11,2)
)
BEGIN

	SELECT
		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità), 2), 
		ROUND(SUM(ROUND(costo, 2) * quantità), 2), 
		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva / 100), 2), 
		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità + ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva/100), 2)
	INTO
		FatturaPrezzoNetto,
		FatturaCosto,
		FatturaPrezzoIva,
		FatturaPrezzoLordo
	FROM fattura_articoli fa 
		LEFT JOIN fattura f ON fa.id_fattura = f.id_fattura 
			AND f.anno = fa.anno 
	WHERE f.anno = AnnoFatture
		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);
		
	SELECT
		ROUND(SUM(ROUND(costo, 2) * quantità), 2), 
		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità + ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva/100), 2)
	INTO
		PrefatturaCosto,
		PrefatturaPrezzoLordo
	FROM fattura_articoli fa 
		LEFT JOIN fattura f ON fa.id_fattura = f.id_fattura 
			AND f.anno = fa.anno 
	WHERE f.anno = 0
		AND YEAR(f.data) = AnnoFatture
		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);
		
	SELECT
		ROUND(SUM(ROUND(costo, 2) * quantità), 2), 
		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità + ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva/100), 2)
	INTO
		TotaleCosto,
		TotalePrezzoLordo
	FROM fattura_articoli fa 
		LEFT JOIN fattura f ON fa.id_fattura = f.id_fattura 
			AND f.anno = fa.anno 
	WHERE YEAR(f.data) = AnnoFatture
		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);
		
	SET FatturaPrezzoNetto = IFNULL(FatturaPrezzoNetto, 0);
	SET FatturaPrezzoLordo = IFNULL(FatturaPrezzoLordo, 0);
	SET FatturaPrezzoIva = IFNULL(FatturaPrezzoIva, 0);
	SET FatturaCosto = IFNULL(FatturaCosto, 0);
	SET PrefatturaPrezzoLordo = IFNULL(PrefatturaPrezzoLordo, 0);
	SET PrefatturaCosto = IFNULL(PrefatturaCosto, 0);
	SET TotalePrezzoLordo = IFNULL(TotalePrezzoLordo, 0);
	SET TotaleCosto = IFNULL(TotaleCosto, 0);
	
END $$
DELIMITER ;