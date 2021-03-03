DROP PROCEDURE IF EXISTS `sp_getQuoteTotals`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getQuoteTotals`(IN `quote_id` INT, IN `quote_year` INT, IN `quote_revision_id` INT, OUT `total_price_material` DECIMAL(11,2), OUT `total_cost_material` DECIMAL(11,2), OUT `total_profit_material` DECIMAL(11, 2), OUT `total_price_work` DECIMAL(11, 2), OUT `total_cost_work` DECIMAL(11, 2), OUT `total_profit_work` DECIMAL(11, 2), OUT `total_hours` DECIMAL(11, 2), OUT `total_price` DECIMAL(11, 2), OUT `total_cost` DECIMAL(11, 2), OUT `total_profit` DECIMAL(11, 2), OUT `total_sale` DECIMAL(11, 2)
)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

	SELECT SUM(CAST(ROUND(prezzo * (100 - IF(preventivo_lotto.tipo_ricar = 1, 0, sconto)) / 100, 2) * (100 - IFNULL(NULLIF(scontoriga, ""), 0)) / 100 AS DECIMAL(11, 2)) * quantità)
		INTO total_price_material
	FROM articolo_preventivo 
		LEFT JOIN preventivo_lotto ON preventivo_lotto.id_preventivo = articolo_preventivo.id_preventivo 
			AND preventivo_lotto.anno = articolo_preventivo.anno 
			AND preventivo_lotto.id_revisione = articolo_preventivo.id_revisione 
			AND articolo_preventivo.lotto = preventivo_lotto.posizione 
	WHERE articolo_preventivo.id_preventivo = quote_id
		AND articolo_preventivo.anno = quote_year
		AND articolo_preventivo.id_revisione = quote_revision_id;

	SELECT SUM(costo * quantità)
		INTO total_cost_material
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;

	SELECT SUM(CAST((IF(montato = "0", 0, ap.tempo_installazione / 60 * prezzo_h * (100 - scontolav) / 100) * ((100 - IFNULL(scontoriga, 0)) / 100)) AS DECIMAL(11, 2)) * quantità)
		INTO total_price_work
	FROM articolo_preventivo ap
		LEFT JOIN preventivo_lotto pl ON pl.id_preventivo = ap.id_preventivo
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND ap.lotto = pl.posizione 
	WHERE ap.id_preventivo = quote_id
		AND ap.anno = quote_year
		AND ap.id_revisione = quote_revision_id;

	SELECT SUM(IF(montato = "0", 0, quantità * (tempo_installazione / 60 * costo_h)))
		INTO total_cost_work
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;

	SELECT SUM(IF(montato = "0", 0, quantità) * tempo_installazione / 60)
		INTO total_hours
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;

	SELECT SUM(((ROUND(ROUND((prezzo-(sconto/100*prezzo)),2)*scontoriga/100,2)*quantità)+((IF(montato="0",0,quantità*((tempo_installazione/60*prezzo_h) - ((tempo_installazione/60*prezzo_h)*scontolav/100)))))*scontoriga/100))
		INTO total_sale
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;
	
	SET total_price_material = IFNULL(total_price_material, 0);
	SET total_cost_material = IFNULL(total_cost_material, 0);
	SET total_price_work = IFNULL(total_price_work, 0);
	SET total_cost_work = IFNULL(total_cost_work, 0);
	SET total_sale = IFNULL(total_sale, 0);
	SET total_cost = IFNULL(total_cost_material, 0) + IFNULL(total_cost_work, 0);
	SET total_price = IFNULL(total_price_material, 0) + IFNULL(total_price_work, 0);
	SET total_profit_material = IFNULL(total_price_material, 0) - IFNULL(total_cost_material, 0);
	SET total_profit_work = IFNULL(total_price_work, 0) - IFNULL(total_cost_work, 0);
	SET total_profit = total_profit_material + total_profit_work;
	SET total_hours = IFNULL(total_hours, 0);

END $$
DELIMITER ;

ALTER TABLE `articoli_ddt_ricevuti`
	CHANGE COLUMN `tipo` `tipo` CHAR(1) NULL DEFAULT NULL COMMENT '[vuoto] = Articolo, N = nota, ? = Riferimento DDT, + = Articolo DDT, F = Riferimento Ordine, O = Articolo Ordine' AFTER `Serial_number`;

