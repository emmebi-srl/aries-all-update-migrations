-- SystemRepository.FindByIds now needs impianto.costo_manutenzione (SystemDto.MaintenanceCost):
-- the dashboard timeline uses it as the last fallback to price periodic checks.

DROP PROCEDURE IF EXISTS sp_apiSystemGetByIds;
DELIMITER //
CREATE PROCEDURE sp_apiSystemGetByIds (
	IN system_ids MEDIUMTEXT
)
BEGIN
	SELECT `impianto`.`Id_impianto`                       AS `id_impianto`,
		`impianto`.`Id_cliente`                       AS `id_cliente`,
		IFNULL(`impianto`.`Abbonamento`,0) AS `id_abbonamento`, 
		impianto.Destinazione AS Id_destinazione, 
		IFNULL(`impianto`.`Data_Funzione`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `data_funzione`, 
		IFNULL(`impianto`.`scadenza_garanzia`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `Scadenza_Garanzia`,
		`impianto`.`Tipo_impianto` AS `tipo_impianto`,
		`tipo_impianto`.`Nome` AS `tipo_impianto_descrizione`,
		`impianto`.`Stato` AS `stato`,
		`stato_impianto`.`Nome` AS `stato_descrizione`,
		`impianto`.`Descrizione`                       AS `descrizione`, 
		IFNULL(`impianto`.`centrale`,'') AS `centrale`, 
		IFNULL(`impianto`.`gsm`,'') AS `gsm`, 
		IFNULL(`impianto`.`combinatore_telefonico`,'') AS `combinatore_telefonico`,
		`impianto`.`orario_prog`                       AS `orario_prog`, 
		checklist_model_impianto.id_checklist,
		abbonamento.nome as "abbonamento",
		IFNULL(impianto.costo_manutenzione, 0) AS costo_manutenzione,
		impianto.id_stato_promemoria_garanzia,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
	FROM impianto
		INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
		INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
		INNER JOIN stato_impianto ON id_stato = Stato
		LEFT JOIN checklist_model_impianto ON impianto.id_impianto = checklist_model_impianto.id_impianto
		LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
	WHERE FIND_IN_SET(`impianto`.`Id_impianto`, system_ids);
END; //
DELIMITER ;
