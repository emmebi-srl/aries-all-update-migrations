-- ReportGroupRepository.Find/Search no longer use sp_apiReportGroupGet: they query
-- resoconto/resoconto_totali/stato_resoconto/tipo_resoconto directly, with dynamic
-- filters and LIMIT/OFFSET in Search instead of loading every row into memory.
DROP PROCEDURE IF EXISTS sp_apiReportGroupGet;

-- ReportGroupRepository.FindToRemind still uses sp_apiReportGroupGetToRemind, and its
-- DbObjectToDto now reads escludi_da_statistiche_resoconto unconditionally, so this
-- procedure must expose that column too or FindToRemind throws.
DROP PROCEDURE IF EXISTS sp_apiReportGroupGetToRemind;
DELIMITER //
CREATE PROCEDURE `sp_apiReportGroupGetToRemind`(
	IN maximum_reminder_count INT(11),
	IN reminder_window_days INT(11)
)
BEGIN
	SELECT
		resoconto.`id_resoconto`,
		resoconto.`anno`,
		`data`,
		resoconto.`Descrizione`,
		`Numero_ordine`,
		`Id_cliente`,
		stato_resoconto.Id_stato AS id_stato_resoconto,
		stato_resoconto.nome AS stato_resoconto,
		stato_resoconto.escludi_da_statistiche AS escludi_da_statistiche_resoconto,
		`Nota`,
		`fattura`,
		`anno_fattura`,
		`id_utente`,
		tipo_resoconto.id_tipo AS id_tipo_resoconto,
		tipo_resoconto.nome AS tipo_resoconto,
		IFNULL(inviato, 0) AS inviato,
		resoconto.data_invio,
		`nota_fine`,
		IFNULL(stm, 0) as stm,
		`fat_SpeseRap`,
		`resoconto_totali`.`prezzo_manutenzione`,
		`resoconto_totali`.`costo_manutenzione`,
		`resoconto_totali`.`costo_diritto_chiamata`,
		`resoconto_totali`.`prezzo_diritto_chiamata`,
		`resoconto_totali`.`costo_lavoro`,
		`resoconto_totali`.`prezzo_lavoro`,
		`resoconto_totali`.`costo_viaggio`,
		`resoconto_totali`.`prezzo_viaggio`,
		`resoconto_totali`.`costo_materiale`,
		`resoconto_totali`.`prezzo_materiale`,
		`resoconto_totali`.`costo_totale`,
		`resoconto_totali`.`prezzo_totale`,
		promemoria_inviato,
		data_invio_promemoria,
		COALESCE(numero_promemoria_inviati, 0) AS numero_promemoria_inviati
	FROM resoconto
		INNER JOIN resoconto_totali ON resoconto.id_resoconto = resoconto_totali.id_resoconto AND resoconto.anno = resoconto_totali.anno
		INNER JOIN stato_resoconto ON resoconto.stato = stato_resoconto.id_stato
		INNER JOIN tipo_resoconto ON resoconto.tipo_resoconto = tipo_resoconto.id_tipo

	WHERE resoconto.inviato = 1
		AND resoconto.data_invio IS NOT NULL
		AND resoconto.stato NOT IN (2, 3, 5, 6, 7)
		AND COALESCE(resoconto.numero_promemoria_inviati, 0) < maximum_reminder_count
		AND CURRENT_DATE BETWEEN
			DATE(TIMESTAMPADD(
				MONTH,
				COALESCE(resoconto.numero_promemoria_inviati, 0) + 1,
				resoconto.data_invio
			))
			AND DATE(TIMESTAMPADD(
				DAY,
				reminder_window_days,
				TIMESTAMPADD(
					MONTH,
					COALESCE(resoconto.numero_promemoria_inviati, 0) + 1,
					resoconto.data_invio
				)
			));
END//
DELIMITER ;
