DROP PROCEDURE IF EXISTS sp_usrGetIDByUsername;
DELIMITER //
CREATE PROCEDURE `sp_usrGetIDByUsername`(IN `username` VARCHAR(60), OUT `id_utente` INT)
BEGIN
SELECT utente.id_utente INTO id_utente
FROM utente
WHERE utente.Nome = username;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverReportMobileInterventionGetForPrint;
DELIMITER //
CREATE PROCEDURE sp_serverReportMobileInterventionGetForPrint ()
BEGIN
	
	SELECT IF(rapporto_mobile_intervento_rif_tipo_intervento.Posizione=0, "X", " ") AS inst, 
	IF(rapporto_mobile_intervento_rif_tipo_intervento.Posizione=1, "X", " ") AS inter, 
	IF(rapporto_mobile_intervento_rif_tipo_intervento.Posizione=2, "X", " ") AS spost, 
	IF(rapporto_mobile_intervento_rif_tipo_intervento.Posizione=3, "X", " ") AS ampl, 
	IF(rapporto_mobile_intervento_rif_tipo_intervento.Posizione=4, "X", " ") AS cont_p, 
	IF(rapporto_mobile_intervento_rif_tipo_intervento.Posizione=5, "X", " ") AS coll, 
	IF(funzionante="0", "X", " ") AS funz, 
	IF(funzionante="1", "X", " ") AS non_funz, 
	IF(funzionante="2", "X", " ") AS parz, 
	IF(notturno="1", "X", " ") AS nott, 
	IF(festivo="1", "X", " ") AS fest, 
	IF(terminato="1", "X", " ") AS term, 
	IF(terminato="0", "X", " ") AS non_term, 
	IF(su_chiamata="1", "X", " ") AS su_chiam, 
	IF(eff_giorn="1", "X", " ") AS eff_giornata, 
	IF(sost="1", "X", " ") AS sosti, 
	IF(ripar="1", "X", " ") AS rip, 
	IF(c_not="1", "X", " ") AS c_note, 
	IF(abbon="1", "X", " ") AS abbonam, 
	IF(garanz="1", "X", " ") AS garanzia, 
	IF(man_ordi="1", "X", " ") AS ordinaria, 
	IF(fuoriabbon="1", "X", " ") AS fuoriabbonam, 
	IF(fuorigaranz="1", "X", " ") AS fuorigaranzia, 
	IF(man_straord="1", "X", " ") AS straordinaria, 
	IF(tipo_impianto="6", "X", " ") AS incendio, 
	IF(tipo_impianto="7" OR tipo_impianto="12", "X", " ") AS rilevazione, 
	IF(tipo_impianto="11", "X", " ") AS spegnimento, 
	IF(tipo_impianto="16", "X", " ") AS telefonico,
	IF(tipo_impianto="5", "X", " ") AS furto, 
	IF(tipo_impianto="8", "X", " ") AS tvcc, 
	IF(tipo_impianto="13", "X", " ") AS automazione, 
	IF(tipo_impianto NOT IN ("6", "7", "11", "12","16", "5", "8", "13"), "X", " ") as c_altroo , 
	IF(tipo_impianto NOT IN ("6", "7", "11", "12","16", "5", "8", "13"), IFNULL(Tipo_impianto.Nome, " "), " ") as altroo , 
	rapporto_mobile.not,
	rapporto_mobile.ragione_sociale, 
	citta, 
	indirizzo, 
	difetto, 
	luogo_lavoro , 
	note_generali,
	email_invio,
	id_impianto,
	richiesto, 
	mansione, 
	responsabile, 
	tecnici, 
	id_rapporto, 
	id_rapporto, 
	relazione, 
	id_cliente, 
	data_esecuzione as "data", 
	anno, 
	SUBSTRING(cast(anno as char(4)),3) as anno2, 
	id_utente, 
	mail_responsabile ,
	rapporto_mobile.da_reperibilita_telefonica, 
	IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
	filename_firma_cliente, 
	filename_firma_tecnico
	FROM rapporto_mobile 
		LEFT JOIN Tipo_impianto ON Tipo_impianto.Id_tipo = tipo_impianto
		LEFT JOIN rapporto_mobile_intervento_rif_tipo_intervento 
			ON rapporto_mobile.Tipo_intervento = rapporto_mobile_intervento_rif_tipo_intervento.Id_tipo_intervento
	WHERE inviato=0 AND Data IS NOT NULL; 
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverReportMobileTestGetForPrint;
DELIMITER //
CREATE PROCEDURE sp_serverReportMobileTestGetForPrint ()
BEGIN
	
	
	SELECT 
		`Id`,
		`Id_rapporto`,
		`Anno`,
		`Id_cliente`,
		IFNULL(`Id_impianto`, 0) Id_impianto,
		`Indirizzo`,
		IFNULL(`Telefono`, "") Telefono,
		IFNULL(`Fax`, "") Fax,
		IFNULL(`Partita_iva_cod_fisc`, "") Partita_iva_cod_fisc,
		IFNULL(`Richiedente_intervento`, "") Richiedente_intervento,
		IFNULL(`Email`, "") Email,
		IFNULL(`Email_responsabile`, "") Email_responsabile,
		`Data`,
		IFNULL(`Descrizione_veicolo`, "") Descrizione_veicolo,
		`Tipo_intervento`,
		IFNULL(`Tipo_impianto`, 0) Tipo_impianto,
		`Ragione_sociale`,
		IFNULL(`Tipo_modello_impianto`, "") Tipo_modello_impianto,
		IFNULL(`Stato_impianto`, "") Stato_impianto,
		IF(`Test_check_1`= 1, "X", "") Test_check_1,
		IF(`Test_check_2`= 1, "X", "") Test_check_2,
		IF(`Test_check_3`= 1, "X", "") Test_check_3,
		IF(`Test_check_4`= 1, "X", "") Test_check_4,
		IF(`Test_check_5`= 1, "X", "") Test_check_5,
		IF(`Test_check_6`= 1, "X", "") Test_check_6,
		IF(`Test_check_7`= 1, "X", "") Test_check_7,
		IF(`Test_check_8`= 1, "X", "") Test_check_8,
		IF(`Test_check_9`= 1, "X", "") Test_check_9,
		IF(`Test_check_10`= 1, "X", "") Test_check_10,
		IF(`Test_check_11`= 1, "X", "") Test_check_11,
		IF(`Test_check_12`= 1, "X", "") Test_check_12,
		IF(`Test_check_13`= 1, "X", "") Test_check_13,
		IF(`Test_check_14`= 1, "X", "") Test_check_14,
		IF(`Test_check_15`= 1, "X", "") Test_check_15,
		IF(`Test_check_16`= 1, "X", "") Test_check_16,
		IF(`Test_check_17`= 1, "X", "") Test_check_17,
		IF(`Test_check_18`= 1, "X", "") Test_check_18,
		IF(`Test_check_19`= 1, "X", "") Test_check_19,
		IF(`Test_check_20`= 1, "X", "") Test_check_20,
		IF(`Test_check_21`= 1, "X", "") Test_check_21,
		IF(`Test_check_22`= 1, "X", "") Test_check_22,
		IF(`Test_check_23`= 1, "X", "") Test_check_23,
		IF(`Test_check_24`= 1, "X", "") Test_check_24,
		IF(`Test_check_25`= 1, "X", "") Test_check_25,
		IF(`Test_check_26`= 1, "X", "") Test_check_26,
		IF(`Test_check_27`= 1, "X", "") Test_check_27,
		IF(`Test_check_28`= 1, "X", "") Test_check_28,
		IF(`Test_check_29`= 1, "X", "") Test_check_29,
		IF(`Test_check_30`= 1, "X", "") Test_check_30,
		IF(`Test_check_31`= 1, "X", "") Test_check_31,
		IF(`Test_check_32`= 1, "X", "") Test_check_32,
		IF(`Test_check_33`= 1, "X", "") Test_check_33,
		IF(`Test_check_34`= 1, "X", "") Test_check_34,
		IF(`Test_check_35`= 1, "X", "") Test_check_35,
		IF(`Test_check_36`= 1, "X", "") Test_check_36,
		IF(`Test_check_37`= 1, "X", "") Test_check_37,
		IF(`Test_check_38`= 1, "X", "") Test_check_38,
		IF(`Test_check_39`= 1, "X", "") Test_check_39,
		IF(`Test_check_40`= 1, "X", "") Test_check_40,
		IF(`Test_check_41`= 1, "X", "") Test_check_41,
		IF(`Test_check_42`= 1, "X", "") Test_check_42,
		IF(`Test_check_43`= 1, "X", "") Test_check_43,
		IF(`Test_check_44`= 1, "X", "") Test_check_44,
		IF(`Test_check_45`= 1, "X", "") Test_check_45,
		IF(`Test_check_46_1`= 1, "X", "") Test_check_46_1,
		IF(`Test_check_47_1`= 1, "X", "") Test_check_47_1,
		IF(`Test_check_48_1`= 1, "X", "") Test_check_48_1,
		IF(`Test_check_46_2`= 1, "X", "") Test_check_46_2,
		IF(`Test_check_47_2`= 1, "X", "") Test_check_47_2,
		IF(`Test_check_48_2`= 1, "X", "") Test_check_48_2,
		IF(`Test_check_46_3`= 1, "X", "") Test_check_46_3,
		IF(`Test_check_47_3`= 1, "X", "") Test_check_47_3,
		IF(`Test_check_48_3`= 1, "X", "") Test_check_48_3,
		IF(`Test_quantita_1` = 0, "", CONCAT(Test_quantita_1, "")) Test_quantita_1,
		IF(`Test_quantita_2` = 0, "", CONCAT(Test_quantita_2, "")) Test_quantita_2,
		IF(`Test_quantita_3` = 0, "", CONCAT(Test_quantita_3, "")) Test_quantita_3,
		IF(`Test_quantita_4` = 0, "", CONCAT(Test_quantita_4, "")) Test_quantita_4,
		IF(`Test_quantita_5` = 0, "", CONCAT(Test_quantita_5, "")) Test_quantita_5,
		IF(`Test_quantita_6` = 0, "", CONCAT(Test_quantita_6, "")) Test_quantita_6,
		IF(`Test_quantita_7` = 0, "", CONCAT(Test_quantita_7, "")) Test_quantita_7,
		IF(`Test_quantita_8` = 0, "", CONCAT(Test_quantita_8, "")) Test_quantita_8,
		IF(`Test_quantita_9` = 0, "", CONCAT(Test_quantita_9, "")) Test_quantita_9,
		IF(`Test_quantita_10` = 0, "", CONCAT(Test_quantita_10, "")) Test_quantita_10,
		IF(`Test_quantita_11` = 0, "", CONCAT(Test_quantita_11, "")) Test_quantita_11,
		IF(`Test_quantita_12` = 0, "", CONCAT(Test_quantita_12, "")) Test_quantita_12,
		IF(`Test_quantita_13` = 0, "", CONCAT(Test_quantita_13, "")) Test_quantita_13,
		IF(`Test_quantita_14` = 0, "", CONCAT(Test_quantita_14, "")) Test_quantita_14,
		IF(`Test_quantita_15` = 0, "", CONCAT(Test_quantita_15, "")) Test_quantita_15,
		IF(`Test_quantita_16` = 0, "", CONCAT(Test_quantita_16, "")) Test_quantita_16,
		IF(`Test_quantita_17` = 0, "", CONCAT(Test_quantita_17, "")) Test_quantita_17,
		IF(`Test_quantita_18` = 0, "", CONCAT(Test_quantita_18, "")) Test_quantita_18,
		IF(`Test_quantita_19` = 0, "", CONCAT(Test_quantita_19, "")) Test_quantita_19,
		IF(`Test_quantita_20` = 0, "", CONCAT(Test_quantita_20, "")) Test_quantita_20,
		IF(`Test_quantita_21` = 0, "", CONCAT(Test_quantita_21, "")) Test_quantita_21,
		IF(`Test_quantita_22` = 0, "", CONCAT(Test_quantita_22, "")) Test_quantita_22,
		IF(`Test_quantita_23` = 0, "", CONCAT(Test_quantita_23, "")) Test_quantita_23,
		IF(`Test_quantita_24` = 0, "", CONCAT(Test_quantita_24, "")) Test_quantita_24,
		IF(`Test_quantita_25` = 0, "", CONCAT(Test_quantita_25, "")) Test_quantita_25,
		IF(`Test_quantita_26` = 0, "", CONCAT(Test_quantita_26, "")) Test_quantita_26,
		IF(`Test_quantita_27` = 0, "", CONCAT(Test_quantita_27, "")) Test_quantita_27,
		IF(`Test_quantita_28` = 0, "", CONCAT(Test_quantita_28, "")) Test_quantita_28,
		IF(`Test_quantita_29` = 0, "", CONCAT(Test_quantita_29, "")) Test_quantita_29,
		IF(`Test_quantita_30` = 0, "", CONCAT(Test_quantita_30, "")) Test_quantita_30,
		IF(`Test_quantita_31` = 0, "", CONCAT(Test_quantita_31, "")) Test_quantita_31,
		IF(`Test_quantita_32` = 0, "", CONCAT(Test_quantita_32, "")) Test_quantita_32,
		IF(`Test_quantita_33` = 0, "", CONCAT(Test_quantita_33, "")) Test_quantita_33,
		IF(`Test_quantita_34` = 0, "", CONCAT(Test_quantita_34, "")) Test_quantita_34,
		IF(`Test_quantita_35` = 0, "", CONCAT(Test_quantita_35, "")) Test_quantita_35,
		IF(`Test_quantita_36` = 0, "", CONCAT(Test_quantita_36, "")) Test_quantita_36,
		IF(`Test_quantita_37` = 0, "", CONCAT(Test_quantita_37, "")) Test_quantita_37,
		IF(`Test_quantita_38` = 0, "", CONCAT(Test_quantita_38, "")) Test_quantita_38,
		IF(`Test_quantita_39` = 0, "", CONCAT(Test_quantita_39, "")) Test_quantita_39,
		IF(`Test_quantita_40` = 0, "", CONCAT(Test_quantita_40, "")) Test_quantita_40,
		IF(`Test_quantita_41` = 0, "", CONCAT(Test_quantita_41, "")) Test_quantita_41,
		IF(`Test_quantita_42` = 0, "", CONCAT(Test_quantita_42, "")) Test_quantita_42,
		IF(`Test_quantita_43` = 0, "", CONCAT(Test_quantita_43, "")) Test_quantita_43,
		IF(`Test_quantita_44` = 0, "", CONCAT(Test_quantita_44, "")) Test_quantita_44,
		IF(`Test_quantita_45` = 0, "", CONCAT(Test_quantita_45, "")) Test_quantita_45,
		IF(`Test_quantita_46_1` = 0, "", CONCAT(Test_quantita_46_1, "")) Test_quantita_46_1,
		IF(`Test_quantita_47_1` = 0, "", CONCAT(Test_quantita_47_1, "")) Test_quantita_47_1,
		IF(`Test_quantita_48_1` = 0, "", CONCAT(Test_quantita_48_1, "")) Test_quantita_48_1,
		IF(`Test_quantita_46_2` = 0, "", CONCAT(Test_quantita_46_2, "")) Test_quantita_46_2,
		IF(`Test_quantita_47_2` = 0, "", CONCAT(Test_quantita_47_2, "")) Test_quantita_47_2,
		IF(`Test_quantita_48_2` = 0, "", CONCAT(Test_quantita_48_2, "")) Test_quantita_48_2,
		IF(`Test_quantita_46_3` = 0, "", CONCAT(Test_quantita_46_3, "")) Test_quantita_46_3,
		IF(`Test_quantita_47_3` = 0, "", CONCAT(Test_quantita_47_3, "")) Test_quantita_47_3,
		IF(`Test_quantita_48_3` = 0, "", CONCAT(Test_quantita_48_3, "")) Test_quantita_48_3,
		IFNULL(`Note`, "") Note,
		IF(DATE_FORMAT(Data_intervento, "%Y-%m-%d") <> "1970-01-01", DATE_FORMAT(Data_intervento, "%d/%m/%Y"), "") `Data_intervento`,
		IF(DATE_FORMAT(Ora_inizio_intervento_1, "%H:%i") <> "00:00", DATE_FORMAT(Ora_inizio_intervento_1, "%H:%i"), "") `Ora_inizio_intervento_1`,
		IF(DATE_FORMAT(Ora_fine_intervento_1, "%H:%i") <> "00:00", DATE_FORMAT(Ora_fine_intervento_1, "%H:%i"), "") `Ora_fine_intervento_1`,
		IF(DATE_FORMAT(Ora_inizio_intervento_2, "%H:%i") <> "00:00", DATE_FORMAT(Ora_inizio_intervento_2, "%H:%i"), "") `Ora_inizio_intervento_2`,
		IF(DATE_FORMAT(Ora_fine_intervento_2, "%H:%i") <> "00:00", DATE_FORMAT(Ora_fine_intervento_2, "%H:%i"), "") `Ora_fine_intervento_2`,
		Ore_intervento, 
		IF(`Ore_Viaggio` = 0, "", CONCAT(Ore_viaggio, "")) Ore_viaggio, 
		IF(`Ore_totali` = 0, "", CONCAT(Ore_totali, "")) Ore_totali,
		IF(`Prezzo_ora` = 0, "", CONCAT(Prezzo_ora, "")) Prezzo_ora,
		IFNULL(`Note_viaggio` , "") Note_viaggio,
		IF(`Numero_viaggi` = 0, "", CONCAT(Numero_viaggi, "")) Numero_viaggi,
		IF(`Km_percorsi` = 0, "", CONCAT(Km_percorsi, "")) Km_percorsi,
		IF(`Km_complessivi` = 0, "", CONCAT(Km_complessivi, "")) Km_complessivi,
		IF(`Prezzo_km` = 0, "", CONCAT(Prezzo_km, "")) Prezzo_km,
		IF(`Totale_prezzo_viaggio` = 0, "", CONCAT(Totale_prezzo_viaggio, "")) Totale_prezzo_viaggio,
		IF(`Totale_prezzo_orario` = 0, "", CONCAT(Totale_prezzo_orario, "")) Totale_prezzo_orario,
		IF(`Totale_prezzo_materiale` = 0, "", CONCAT(Totale_prezzo_materiale, "")) Totale_prezzo_materiale,
		IF(`Imponibile` = 0, "", CONCAT(Imponibile, "")) Imponibile,
		IF(`Iva` = 0, "", CONCAT(Iva, "")) Iva,
		IF(`Totale_prezzo` = 0, "", CONCAT(Totale_prezzo, "")) Totale_prezzo,
		Utente_inserimento Id_utente
	FROM rapporto_mobile_collaudo 
	WHERE Inviato = 0; 
	
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_serverReportMobileInterventionProductGetForPrint;
DELIMITER //
CREATE PROCEDURE sp_serverReportMobileInterventionProductGetForPrint 
(
	id MEDIUMINT,
	`year` SMALLINT
)
BEGIN
	
    SELECT descrizione as "nome_materiale",
		CONCAT("", quantita,"") as "quantita" 
    FROM rapporto_mobile_materiale
    WHERE id_rapporto = id
		AND anno_rapporto = `year` 
    ORDER BY descrizione 
    LIMIT 7; 
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverBackupSettingsGet;
DELIMITER //
CREATE PROCEDURE sp_serverBackupSettingsGet 
(
)
BEGIN
	
    SELECT id_impostazioni, 
	 	valore 
    FROM impostazioni_backup; 
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverPathConfigurationGet;
DELIMITER //
CREATE PROCEDURE sp_serverPathConfigurationGet 
(
)
BEGIN
	
    SELECT tipo_percorso, 
	 	Percorso 
    FROM configurazione_percorsi; 
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverPathConfigurationGetByKey;
DELIMITER //
CREATE PROCEDURE sp_serverPathConfigurationGetByKey 
(
	path_type VARCHAR(50)
)
BEGIN
	
    SELECT tipo_percorso, 
	 	Percorso 
    FROM configurazione_percorsi
	 WHERE tipo_percorso = path_type; 
	
END; //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_serverTabletConfigurationGetLastInsert; 
CREATE PROCEDURE sp_serverTabletConfigurationGetLastInsert
( 
)
BEGIN
      
SELECT
	Id_tablet, 
	IFNULL(mail, "") AS mail, 
	IFNULL(testo_mail, "") AS testo_mail, 
	IFNULL(Host, "") AS host, 
	IFNULL(Password, "") AS Password, 
	IFNULL(porta, 0) AS Porta, 
	IFNULL(Username, "") AS Username, 
	IFNULL(DIsplay_name, "") AS Display_name, 
	email_ufficio, 
	IFNULL(Data_ins, Data_Mod) AS Data_ins,
	Data_Mod
FROM tablet_configurazione ORDER BY id_tablet DESC LIMIT 1; 
			
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_serverReportMobileTestSentToIntervention;
DELIMITER //
CREATE PROCEDURE sp_serverReportMobileTestSentToIntervention (
	IN ReportId SMALLINT, 
	IN ReportYear SMALLINT, 
	OUT Result BIT)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;

	DECLARE `SystemId` INTEGER DEFAULT 0;
	DECLARE `DestinationId` INTEGER DEFAULT 1;
	DECLARE `SubscriptionId` INTEGER DEFAULT NULL;
	DECLARE InterventionDate DATETIME; 
	DECLARE `SystemType` INTEGER DEFAULT 0;
	DECLARE `InterventionType` INTEGER DEFAULT 0;
	DECLARE WarrantySystemExpiration DATE DEFAULT NULL; 
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SELECT Id_impianto, 
			rapporto_mobile_collaudo.Data_intervento, 
			IFNULL(rapporto_mobile_collaudo_rif_tipo_intervento.Id_tipo_intervento, 1)
		INTO SystemId,
		InterventionDate,
		InterventionType
	FROM rapporto_mobile_collaudo 
		LEFT JOIN rapporto_mobile_collaudo_rif_tipo_intervento
			ON rapporto_mobile_collaudo_rif_tipo_intervento.Posizione = rapporto_mobile_collaudo.Tipo_intervento
	WHERE Id_rapporto = ReportId AND Anno = ReportYear;
	
	IF SystemId <> 0 THEN
	
		SELECT Destinazione, 
			impianto.Tipo_impianto,
			IFNULL(impianto.scadenza_garanzia, CAST("1970-01-01" AS DATE))
			INTO DestinationId,
			SystemType,
			WarrantySystemExpiration
		FROM Impianto 
		WHERE Id_impianto = SystemId; 
		
		SELECT impianto_abbonamenti.Id_abbonamenti 
			INTO SubscriptionId
		FROM impianto_abbonamenti 
		WHERE Anno = YEAR(InterventionDate) AND Id_impianto = SystemId; 
		
	END IF;  
	
	
	-- Delete eventualy duplicate
	DELETE FROM rapporto_mobile 
	WHERE Id_rapporto = ReportId AND anno = ReportYear; 


	-- INSERT INTO rapporto mobile
	INSERT INTO rapporto_mobile 
	(
		id_rapporto,
		anno , 
		id_impianto, 
		id_destinazione, 
		id_cliente, 
		Richiesto, 
		mansione, 
		responsabile,
		tipo_intervento, 
		Diritto_chiamata, 
		tipo_diritto_chiamata, 
		relazione, 
		terminato, 
		funzionante, 
		stato, 
		Note_generali,
		Fattura, 
		Data, 
		Commessa, 
		abbonamento, 
		Numero_ordine, 
		Totale, 
		Nr_rapporto, 
		Data_esecuzione, 
		costo, 
		scan, 
		anno_fattura, 
		controllo_periodico,
		prima, 
		numero,
		id_utente, 
		cost_lav, 
		prez_lav, 
		dest_cli, 
		email_invio,
		inviato, 
		visionato, 
		id_ticket, 
		tecnici, 
		appunti, 
		notturno, 
		festivo, 
		su_chiamata, 
		eff_giorn, 
		sost, 
		ripar, 
		`not`, 
		c_not, 
		abbon, 
		garanz,
		man_ordi, 
		fuoriabbon, 
		fuorigaranz,
		man_straord, 
		tipo_impianto,
		ragione_sociale, 
		indirizzo, 
		citta, 
		luogo_lavoro, 
		difetto, 
		id_riferimento,
		mail_responsabile, 
		invia_a_tecnico,
		da_reperibilita_telefonica,
		id_tecnico,
		tipo_rapporto
	)
	SELECT
		rapporto_mobile_collaudo.id_rapporto, -- id_rapporto = id,
		rapporto_mobile_collaudo.anno, -- anno = year, 
		rapporto_mobile_collaudo.id_impianto, -- id_impianto = system_id, 
		IFNULL(DestinationId, 1), -- id_destinazione = destination_id, 
		rapporto_mobile_collaudo.Id_cliente, -- id_cliente = customer_id, 
		rapporto_mobile_collaudo.Richiedente_intervento, -- Richiesto = requesting_intervention, 
		"", -- mansione = responsible_job, 
		"", -- responsabile = responsible,
		InterventionType, -- tipo_intervento = intervention_type, 
		IF(SubscriptionId IS NULL, 0, 1), -- Diritto_chiamata = right_call, 
		0, -- tipo_diritto_chiamata = 0, 
		rapporto_mobile_collaudo.Note, -- relazione = technical_report, 
		0, -- terminato = is_work_finished, 
		0, -- funzionante = system_conditions, 
		1, -- stato = 1, 
		"", -- Note_generali = notes_highlights,
		NULL, -- Fattura = NULL, 
		rapporto_mobile_collaudo.Data, -- Data = CURDATE(), 
		NULL, -- Commessa = NULL, 
		SubscriptionId, -- abbonamento = NULL, 
		NULL, -- Numero_ordine = NULL, 
		0, -- Totale = 0, 
		rapporto_mobile_collaudo.id_rapporto, -- Nr_rapporto = report_number, 
		InterventionDate, -- Data_esecuzione = execution_date, 
		0, -- costo = 0, 
		0, -- scan = 0, 
		NULL, -- anno_fattura = NULL, 
		NULL, -- controllo_periodico = NULL,
		0, -- prima = 0, 
		rapporto_mobile_collaudo.id_rapporto, -- numero = report_number,
		rapporto_mobile_collaudo.Utente_inserimento, -- id_utente = user_id, 
		NULL, -- cost_lav = NULL, 
		NULL, -- prez_lav = NULL, 
		rapporto_mobile_collaudo.Id_cliente, -- dest_cli = customer_id, 
		rapporto_mobile_collaudo.Email, -- email_invio = email_company,
		1, -- inviato = 0, 
		0, -- visionato = 0, 
		NULL, -- id_ticket = NULL, 
		NULL, -- tecnici = NULL, 
		"", -- appunti = clipboard, 
		0, -- notturno = is_nocturnal, 
		0, -- festivo = is_public_holiday, 
		0, -- su_chiamata = is_on_call, 
		0, -- eff_giorn = is_carried_out_in_day, 
		0, -- sost = is_replaced, 
		0, -- ripar = is_repair, 
		0, -- `not` = intervention_detail_custom_text, 
		0, -- c_not = is_custom, 
		IF(SubscriptionId IS NULL, 0, 1), -- abbon = is_subscribed, 
		IF(WarrantySystemExpiration <= CURDATE(), 0, 1), -- garanz = is_under_warranty,
		1, -- man_ordi = ordinary_maintenance, 
		IF(SubscriptionId IS NULL, 1, 0), -- fuoriabbon = is_not_subscribed, 
		IF(WarrantySystemExpiration <= CURDATE(), 1, 0), -- fuorigaranz = is_not_under_warranty,
		0, -- man_straord = extra_ordinary_maintenance, 
		IFNULL(SystemType, 0), -- tipo_impianto = system_type,
		rapporto_mobile_collaudo.ragione_sociale, -- ragione_sociale = company_name, 
		rapporto_mobile_collaudo.Indirizzo, -- indirizzo = address, 
		"", -- citta = city, 
		"", -- luogo_lavoro = work_place, 
		"", -- difetto = problem_detected, 
		0, -- id_riferimento = responsible_id,
		"", -- mail_responsabile = email_responsible, 
		0, -- invia_a_tecnico = send_to_technician,
		0, -- da_reperibilita_telefonica = is_telephone_avaibility,
		rapporto_mobile_collaudo.Operaio_inserimento, -- id_tecnico = technician_sender_id
		3 -- report_type 
	FROM rapporto_mobile_collaudo
	WHERE Id_rapporto = ReportId AND anno = ReportYear; 

	UPDATE rapporto_mobile_collaudo
	SET rapporto_mobile_collaudo.Processato = 1
	WHERE Id_rapporto = ReportId AND anno = ReportYear; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
	  COMMIT;
	  SET Result = 1; 
	END IF;

END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverReportMobileTestGetUnproccessed;
DELIMITER //
CREATE PROCEDURE sp_serverReportMobileTestGetUnproccessed ()
BEGIN
	SELECT 
		`Id_rapporto`,
		`Anno`
	FROM rapporto_mobile_collaudo 
	WHERE Processato = 0; 
	
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_serverInvoicePaymentsGetAutoClosingExpired;
CREATE PROCEDURE sp_serverInvoicePaymentsGetAutoClosingExpired
( )
BEGIN

	SELECT 
		Id_fattura, 
		anno, 
		data_pagamento, 
		id_pagamento, 
		id_tipo_pagamento
	FROM
	(
		SELECT 
			
			fattura.id_fattura,
			fattura.anno, 
			fattura_pagamenti.nota, 
			IFNULL(fattura_pagamenti.`data`, LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY) AS "data_pagamento", 
			IFNULL(fattura_pagamenti.id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY, '%Y%m%d') AS UNSIGNED)) AS "id_pagamento", 
			IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, tipopag_pagamento1.Id_tipo, tipopag_pagamento.Id_tipo) AS "id_tipo_pagamento", 
			fattura_pagamenti.insoluto
		FROM fattura
			INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione AND a.Chiusura_alla_scadenza = TRUE
			INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
			LEFT JOIN fattura_pagamenti ON fattura.id_fattura=fattura_pagamenti.id_fattura AND fattura_pagamenti.anno=fattura.anno AND fattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ 		INTERVAL g.giorni DAY,'%Y%m%d')
			LEFT JOIN tipo_pagamento AS tipopag_pagamento ON a.tipo = tipopag_pagamento.id_tipo
			LEFT JOIN tipo_pagamento AS tipopag_pagamento1 ON fattura_pagamenti.tipo_pagamento = tipopag_pagamento1.id_tipo
		WHERE fattura_pagamenti.id_pagamento IS NULL OR fattura_pagamenti.`data` IS NULL AND fattura_pagamenti.anno > 0

	) AS tmp
	WHERE data_pagamento < NOW() 
	GROUP BY id_fattura, anno, id_pagamento;
	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_serverInvoicePaymentsInsertOrUpdate;
CREATE PROCEDURE sp_serverInvoicePaymentsInsertOrUpdate
( 
	 IN InvoiceId INT(11), 
	 IN InvoiceYear INT(11), 
	 IN Note TEXT, 
	 IN PaymentDate Date, 
	 IN PaymentId INT(11), 
	 IN PaymentTypeId INT(11), 
	 IN Unsolved TINYINT(4)
)
BEGIN

	INSERT INTO fattura_pagamenti
		(id_fattura,anno,nota,data,id_pagamento,tipo_pagamento,insoluto)
	VALUES
		(InvoiceId,InvoiceYear,Note,PaymentDate,PaymentId,PaymentTypeId,Unsolved) 
	ON DUPLICATE KEY UPDATE 
		nota = Note, 
		data = PaymentDate, 
	 	tipo_pagamento = PaymentTypeId,
		insoluto = Unsolved; 
		
	CALL sp_ariesInvoiceEvaluateStatus(InvoiceId, InvoiceYear); 
	                        
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_serverReportMobileRecipientGetByReport;
CREATE PROCEDURE sp_serverReportMobileRecipientGetByReport
( 
	 IN report_id INT(11), 
	 IN report_year INT(11)
)
BEGIN

	SELECT rapporto_mobile_destinatario.id,
		rapporto_mobile_destinatario.id_rapporto,
		rapporto_mobile_destinatario.anno, 
		rapporto_mobile_destinatario.email, 
		rapporto_mobile_destinatario.tipo_email
		
	FROM rapporto_mobile_destinatario
	WHERE id_rapporto = report_id AND anno = report_year;
	                        
END //
DELIMITER ;
DELIMITER //
DROP PROCEDURE IF EXISTS sp_serverReportMobileRecipientGet;
CREATE PROCEDURE sp_serverReportMobileRecipientGet
( 
)
BEGIN

	SELECT rapporto_mobile_destinatario.id,
		rapporto_mobile_destinatario.id_rapporto,
		rapporto_mobile_destinatario.anno, 
		rapporto_mobile_destinatario.email, 
		rapporto_mobile_destinatario.tipo_email
		
	FROM rapporto_mobile_destinatario;
	                        
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_serverChecklistGetForPrint;
DELIMITER //
CREATE PROCEDURE sp_serverChecklistGetForPrint ()
BEGIN
	SELECT 	
		`id`,
		`id_mobile`,
		`data_esecuzione`,
		`id_checklist_model`
		`id_operaio`,
		`id_cliente`,
		`id_responsabile`,
		`id_impianto`,
		`ragione_sociale`,
		`indirizzo`,
		`citta`,
		`responsabile`,
		`impianto_luogo_installazione`,
		`impianto_centrale`,
		`impianto_data_installazione`,
		`impianto_dipartimento`,
		`timestamp_creazione`,
		altro, 
		appunti, 
		responsabile_lavoro, 
		numero_visita, 
		controllo_periodico,
		id_checklist_model,
		filename_firma_cliente, 
		filename_firma_tecnico,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod` 
	FROM CHECKlist
	WHERE stampata = 0; 
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_serverChecklistSetAsPrinted;
DELIMITER //
CREATE PROCEDURE sp_serverChecklistSetAsPrinted (
	IN checklist_id INT(11) 
)
BEGIN
	UPDATE checklist
	SET stampata = 1
	WHERE id = checklist_id; 
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_serverChecklistParagraphGetByChecklist;
DELIMITER //
CREATE PROCEDURE sp_serverChecklistParagraphGetByChecklist (
	IN checklist_id INT(11) 
)
BEGIN
	SELECT 	
		`id`,
		`id_checklist`,
		`id_checklist_model_paragrafo`,
		`nome`,
		`descrizione`,
		`ordine`,
		`utente_mod`,
		`data_mod`
	FROM checklist_paragrafo
	WHERE id_Checklist = checklist_id; 
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_serverChecklistReportGetByChecklist;
DELIMITER //
CREATE PROCEDURE sp_serverChecklistReportGetByChecklist (
	IN checklist_id INT(11) 
)
BEGIN
	SELECT 	
		`id`,
		`id_checklist`,
		`id_rapporto`,
		`anno_rapporto`
	FROM checklist_rapporto
	WHERE id_Checklist = checklist_id; 
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_serverChecklistRowGetByParagraph;
DELIMITER //
CREATE PROCEDURE sp_serverChecklistRowGetByParagraph (
	IN paragraph_id INT(11) 
)
BEGIN
	SELECT 	
		`id`,
		`id_checklist`,
		`id_paragrafo`,
		`json_data`,
		`tipo_riga`,
		`id_checklist_model_elemento`,
		`id_checklist_model_paragrafo`,
		`id_checklist_model`,
		`ordine`,
		`nome`,
		`descrizione`,
		`indicazioni_tecnico`
	FROM checklist_paragrafo_riga
	WHERE id_paragrafo = paragraph_id; 
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_serverChecklistEmployeeGetByChecklist;
DELIMITER //
CREATE PROCEDURE sp_serverChecklistEmployeeGetByChecklist (
	IN checklist_id INT(11) 
)
BEGIN
	SELECT 	
		`id`,
		`id_checklist`,
		`id_tecnico`,
		`ragione_sociale`
	FROM checklist_tecnico
		INNER JOIN operaio ON id_tecnico = id_operaio
	WHERE id_checklist = checklist_id; 
END //
DELIMITER ;




-- ####################### SYSTEMS ##################################################################

DELIMITER //
DROP PROCEDURE IF EXISTS sp_serverSystemGet; 
CREATE PROCEDURE sp_serverSystemGet
( )
BEGIN
        

	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto;
END //
DELIMITER ;




DELIMITER $$

DROP PROCEDURE IF EXISTS sp_serverSystemGetByIds; 
CREATE PROCEDURE sp_serverSystemGetByIds(
	IN idArray MEDIUMTEXT)
BEGIN

SELECT DISTINCT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,"1970-01-01") AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,"1970-01-01") AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,"1970-01-01") AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, "") As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,"1970-01-01") AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,"1970-01-01") AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	  WHERE FIND_IN_SET(Id_impianto, idArray) > 0; 
  
		
END; $$
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_serverSystemGetByTicketStatus; 
CREATE PROCEDURE sp_serverSystemGetByTicketStatus
( 
	statusTicket INT(11)
)
BEGIN
        

	SELECT DISTINCT impianto.Id_impianto,
		impianto.id_cliente, 
		impianto.id_gestore, 
		impianto.id_occupante, 
		CAST(IFNULL(impianto.Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(impianto.Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(impianto.altro, "") AS altro, 
		IFNULL(impianto.Abbonamento, 0) abbonamento, 
		impianto.Tipo_impianto,  
		IFNULL(impianto.Stato, 0) AS Stato , 
		CAST(IFNULL(impianto.Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(impianto.Descrizione, '') As Descrizione, 
		IFNULL(impianto.Destinazione, 0) AS Destinazione , 
		IFNULL(impianto.Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(impianto.Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(impianto.Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(impianto.Persone, 0) AS Persone, 
		impianto.Data_modifica, 
		impianto.Contr, 
		IFNULL(impianto.sub, 0) AS sub, 
		IFNULL(impianto.orario_prog, 0) AS orario_prog, 
		IFNULL(impianto.id_utente, 0) AS id_utente, 
		IFNULL(impianto.auto, 0) AS Auto, 
		IFNULL(impianto.condizione, 0) AS condizione, 
		IFNULL(impianto.eta, 0) AS eta, 
		IFNULL(impianto.Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(impianto.Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(impianto.Checklist, 0) Checklist,
		IFNULL(impianto.Centrale, "") AS Centrale, 
		IFNULL(impianto.gsm, "") AS gsm, 
		IFNULL(impianto.combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(impianto.flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(impianto.flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
		INNER JOIN Ticket 
		ON Impianto.Id_impianto = Ticket.Id_impianto AND Ticket.Stato_ticket = statusTicket;
		
END; //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_serverSystemGetOrderByDescription; 
CREATE PROCEDURE sp_serverSystemGetOrderByDescription
( )
BEGIN
        

	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	ORDER BY Descrizione ASC;
		
END; //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_serverSystemGetById; 
CREATE PROCEDURE sp_serverSystemGetById
( 
  systemId INT
)
BEGIN
        

	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	WHERE (Id_impianto = systemId); 
		
			
END; //
DELIMITER ;


-- ####################### SYSTEMS TYPES ##################################################################


DROP PROCEDURE IF EXISTS sp_serverSystemTypeGetById;
DELIMITER $$
CREATE PROCEDURE `sp_serverSystemTypeGetById`(
type_id INT(11)
)
BEGIN

	SELECT Id_tipo, 
		Nome, 
		Descrizione,
		Utente_mod, 
		Data_mod
	FROM Tipo_impianto
	WHERE Id_tipo = type_id; 

				
END $$
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_serverMunicipalityDelete
DROP PROCEDURE IF EXISTS sp_serverMunicipalityDelete;
DELIMITER //
CREATE  PROCEDURE `sp_serverMunicipalityDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM Comune 
	WHERE id_comune = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverMunicipalityGet
DROP PROCEDURE IF EXISTS sp_serverMunicipalityGet;
DELIMITER //
CREATE  PROCEDURE `sp_serverMunicipalityGet`( 
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	ORDER BY Id_comune;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverMunicipalityGetById
DROP PROCEDURE IF EXISTS sp_serverMunicipalityGetById;
DELIMITER //
CREATE  PROCEDURE `sp_serverMunicipalityGetById`( 
	municipality_id INT
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	WHERE Id_Comune = municipality_id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverMunicipalityGetByPostalCode
DROP PROCEDURE IF EXISTS sp_serverMunicipalityGetByPostalCode;
DELIMITER //
CREATE  PROCEDURE `sp_serverMunicipalityGetByPostalCode`( 
	postal_code VARCHAR(30)
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	WHERE Cap = postal_code;
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_serverMunicipalityInsert
DROP PROCEDURE IF EXISTS sp_serverMunicipalityInsert;
DELIMITER //
CREATE  PROCEDURE `sp_serverMunicipalityInsert`( 
	name VARCHAR(30),
	province varchar(15),
	postal_code varchar(10),
	province_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Province 
	WHERE sigla = province AND id_provincia = province_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM Comune 
		WHERE Nome = Name AND Cap = postal_code; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Municipality name & postal code already exists
		END IF;
	ELSE
		SET Result = -2; # province not found
	END IF;
	
	IF Result = 0 THEN
		INSERT INTO Comune 
		SET 
			Nome = name,
			Provincia = province , 
			Cap = postal_code, 
			Id_Provincia = province_id,
			Data_ins = NOW(),  
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverMunicipalityUpdate
DROP PROCEDURE IF EXISTS sp_serverMunicipalityUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_serverMunicipalityUpdate`( 
	enter_id INTEGER,
	name VARCHAR(30),
	province varchar(15),
	postal_code varchar(10),
	province_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Province 
	WHERE sigla = province AND id_provincia = province_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM Comune 
		WHERE Nome = Name AND Cap = postal_code AND id_comune != enter_id;
		
		IF Result > 0 THEN
			 SET Result = -1; # Municipality name & postal code already exists
		END IF;
	ELSE
		SET Result = -2; # province not found
	END IF;
	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM Comune 
			WHERE id_comune = enter_id;
			
			IF Result = 0 THEN
				SET Result = -3; # Municipality ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		UPDATE Comune 
		SET 
			Nome = name,
			Provincia = province , 
			Cap = postal_code, 
			Id_Provincia = province_id,
			Utente_mod = @USER_ID
		Where id_comune = enter_id;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryDelete
DROP PROCEDURE IF EXISTS sp_serverCountryDelete;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM Nazione 
	WHERE id_Nazione = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryGet
DROP PROCEDURE IF EXISTS sp_serverCountryGet;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryGet`( 
)
BEGIN
	SELECT Id_nazione,
	Nome,
	sigla,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Nazione
	ORDER BY Id_nazione;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryGetById
DROP PROCEDURE IF EXISTS sp_serverCountryGetById;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryGetById`( 
	Country_id INT
)
BEGIN
	SELECT Id_nazione,
	Nome,
	sigla,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Nazione
	WHERE Id_nazione = Country_id
	ORDER BY Id_nazione;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryGetByMunicipality
DROP PROCEDURE IF EXISTS sp_serverCountryGetByMunicipality;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryGetByMunicipality`( 
	municipality_id INT
)
BEGIN


	DECLARE countryId INT(11); 
	
	SELECT Nazione.Id_nazione 
		into countryId 
	FROM comune
		INNER JOIN province ON comune.id_provincia = province.id_provincia 
		INNER JOIN regione ON Regione.id_regione = province.Regione 
		INNER JOIN Nazione on id_nazione = regione.nazione
	WHERE comune.Id_comune = municipality_id; 

	CALL sp_serverCountryGetById(countryId);

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryGetByName
DROP PROCEDURE IF EXISTS sp_serverCountryGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryGetByName`( 
	name VARCHAR(30)
)
BEGIN
	SELECT Id_nazione,
	Nome,
	sigla,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Nazione
	WHERE Nome = name
	ORDER BY Id_nazione;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryInsert
DROP PROCEDURE IF EXISTS sp_serverCountryInsert;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryInsert`( 
	name VARCHAR(45),
	abbreviation varchar(10),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT Count(id_nazione) INTO Result
	FROM Nazione 
	WHERE Nome = Name; 
	
	IF Result > 0 THEN
		 SET Result = -1; # Country name already exists
	END IF;

	
	IF Result = 0 THEN
		INSERT INTO Nazione 
		SET 
			Nome = name,
			sigla = Abbreviation, 
			Data_ins = NOW(), 
			Data_mod = NOW(), 
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCountryUpdate
DROP PROCEDURE IF EXISTS sp_serverCountryUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_serverCountryUpdate`( 
	enter_id INTEGER,
	name VARCHAR(45),
	abbreviation varchar(10),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT Count(Id_nazione) INTO Result
	FROM Nazione 
	WHERE Nome = Name AND Id_nazione != enter_id; 
	
	IF Result > 0 THEN
		 SET Result = -1; # Country name already exists
	END IF;

	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM Nazione 
			WHERE id_Nazione = enter_id;
			
			IF Result = 0 THEN
				SET Result = -2; # Country ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		UPDATE Nazione 
		SET 
			Nome = name,
			sigla = Abbreviation, 
			Utente_mod = @USER_ID
		Where id_Nazione = enter_id;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_serverProvinceDelete
DROP PROCEDURE IF EXISTS sp_serverProvinceDelete;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM province 
	WHERE id_provincia = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverProvinceGet
DROP PROCEDURE IF EXISTS sp_serverProvinceGet;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceGet`( 
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	ORDER BY id_provincia;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverProvinceGetById
DROP PROCEDURE IF EXISTS sp_serverProvinceGetById;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceGetById`( 
	Province_id INT
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	WHERE id_provincia = Province_id;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_serverProvinceGetByAbbreviation
DROP PROCEDURE IF EXISTS sp_serverProvinceGetByAbbreviation;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceGetByAbbreviation`( 
	abbreviation INT
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	WHERE Sigla = abbreviation;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_serverProvinceGetByName
DROP PROCEDURE IF EXISTS sp_serverProvinceGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceGetByName`( 
	name VARCHAR(45)
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	WHERE Nome = name;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverProvinceInsert
DROP PROCEDURE IF EXISTS sp_serverProvinceInsert;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceInsert`( 
	name VARCHAR(45),
	region_id INTEGER,
	abbreviation VARCHAR(15),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Regione 
	WHERE id_regione = region_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM province 
		WHERE Nome = Name; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Province name already exists
		END IF;
	ELSE
		SET Result = -2; # region not found
	END IF;
	
	IF Result = 0 THEN
		INSERT INTO province 
		SET 
			Nome = name,
			Regione = region_id,
			Sigla = abbreviation, 
			Data_ins = NOW(), 
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverProvinceUpdate
DROP PROCEDURE IF EXISTS sp_serverProvinceUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_serverProvinceUpdate`( 
	enter_id INTEGER,
	name VARCHAR(45),
	abbreviation VARCHAR(15),
	region_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM regione 
	WHERE id_regione = region_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM province 
		WHERE Nome = Name AND id_provincia != enter_id; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Province name already exists
		END IF;
	ELSE
		SET Result = -2; # region not found
	END IF;
	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM province 
			WHERE id_provincia = enter_id;
			
			IF Result = 0 THEN
				SET Result = -3; # Province ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		
		START TRANSACTION;
		
		UPDATE Comune 
		SET Provincia = abbreviation
		WHERE Id_provincia = enter_id; 	
		
		UPDATE province 
		SET 
			Nome = name,
			Regione = region_id, 
			Sigla = abbreviation, 
			Utente_mod = @USER_ID
		Where id_provincia = enter_id;
		
		COMMIT;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;




-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationGet
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationGet;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationGet`()
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationGetByCustomerId
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationGetByCustomerId;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationGetByCustomerId`(
	IN customer_id INT
)
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE Id_cliente = customer_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationGetByCustomerIdAndDestinationId
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationGetByCustomerIdAndDestinationId;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationGetByCustomerIdAndDestinationId`(
	IN customer_id INT,
	IN destination_id INT
)
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE Id_cliente = customer_id AND Id_destinazione = destination_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationGetByCustomerIds
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationGetByCustomerIds;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationGetByCustomerIds`(
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT DISTINCT
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE("1970-01-01 00:00:00", "%y-%m-&d %h:%i:%s")) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE FIND_IN_SET(Id_cliente,customer_ids) > 0;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationGetWithoutDistanceAndTime
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationGetWithoutDistanceAndTime;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationGetWithoutDistanceAndTime`()
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE (Km_sede = 0 
		and Tempo_strada = 0 
		and comune IS NOT NULL 
		and indirizzo IS NOT NULL 
		and indirizzo <> "");
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationInsert
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationInsert;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationInsert`(
  IN customer_id INT(11),
  IN province VARCHAR(5),
  IN municipality_id INT(11),
  IN district_id INT(11),
  IN street VARCHAR(50),
  IN street_number SMALLINT(6),
  IN description VARCHAR(105),
  IN stair VARCHAR(6),
  IN other VARCHAR(9),
  IN distance SMALLINT(6),
  IN toll DECIMAL(11,2),
  IN trip_time SMALLINT(6),
  IN is_active BIT,
  IN is_limited_traffic_zone BIT,
  IN notes TEXT,
  IN has_speedway BIT,
  IN is_main_destination BIT,
  IN from_morning TIME,
  IN to_morning TIME,
  IN from_afternoon TIME,
  IN to_afternoon TIME,
  IN floor TINYINT,
  IN intern TINYINT,
  IN speedway_id INT,
  IN latitude DECIMAL (11,8),
  IN longitude DECIMAL (11,8),
  OUT result INT,
  OUT destination_id INT
)
BEGIN
	
	DECLARE tmp_province VARCHAR(5) DEFAULT NULL;
	DECLARE tmp_municipality_id INT(11) DEFAULT NULL;
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SELECT COUNT(Id_cliente)
		INTO result 
	FROM clienti 
	WHERE Id_cliente = customer_id; 
	
	IF result = 0 THEN
		SET result = -1; -- customer not found
	ELSE
	
		IF province IS NOT NULL THEN
		
		  SELECT COUNT(province.Sigla)
		 	INTO result
		  FROM province 
		  WHERE province.Sigla = province;
		    
		END IF; 
		
		IF result = 0 THEN
			SET result = -7; -- province not found
		ELSE
			IF municipality_id IS NOT NULL THEN
			
				SELECT COUNT(Id_comune), comune.provincia
					INTO result, tmp_province 
				FROM comune 
				WHERE comune.Id_comune = municipality_id; 
				
				IF result = 0 THEN
					SET result = -2; -- municipality not found
				ELSE
					IF province <> tmp_province THEN
						SET result = -3; -- invalid province by municipality id
					END IF;			
				END IF; 
				
				IF result > 0 AND district_id IS NOT NULL THEN
				
					SELECT COUNT(Id_frazione), frazione.Id_comune
						INTO result, tmp_municipality_id 
					FROM frazione 
					WHERE frazione.Id_frazione = district_id; 
					
					IF result = 0 THEN
						SET result = -4; -- distirct not found
					ELSE
						IF municipality_id <> tmp_municipality_id THEN
							SET result = -5; -- invalid municipality id by destrict id
						END IF;			
					END IF; 
				
				END IF; 
				
				IF result > 0 AND speedway_id IS NOT NULL THEN
					
					SELECT id_autostrada
						INTO result
					FROM tipo_autostrada 
					WHERE tipo_autostrada.Id_tipo = speedway_id; 
	
					IF result = 0 THEN
						SET result = -6; -- speedway not found
					END IF; 
				END IF; 						
			END IF;
		END IF; 
	END IF;   		
	

	IF result > 0 THEN
	
		SELECT IFNULL(id_destinazione + 1, 1)
			INTO destination_id
		FROM destinazione_cliente 
		WHERE id_cliente = customer_id; 
		
		INSERT INTO destinazione_cliente
		SET  
			Id_cliente = customer_id, 
			Id_destinazione = destination_id, 
			Provincia = province, 
			Comune = municipality_id, 
			Frazione = district_id,
			Indirizzo = street, 
			Numero_civico = street_number, 
			Descrizione = description, 
			Scala = stair, 
			Altro = other, 
			Km_sede = distance, 
			Pedaggio = toll,
			Tempo_strada = trip_time, 
			Attivo = is_active, 
			ztl = is_limited_traffic_zone, 
			Note = notes, 
			Autostrada = has_speedway, 
			Sede_principale = is_main_destination,
			Dalle1 = from_morning,
			Alle1 = to_morning,
			Dalle2 = from_afternoon,
			Alle2 = to_afternoon,
			Piano = stair, 
			Interno = intern, 
			Id_autostrada = speedway_id,
			Longitudine = longitude,
			Latitudine = latitude, 
			Data_ins = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID;
			
			IF is_main_destination THEN
				CALL sp_serverCustomerDestinationSetAsMainDestination(customer_id, destination_id, @Result);
			END IF; 
		 
		SET Result = LAST_INSERT_ID(); 
			
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationResetAllDistance
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationResetAllDistance;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationResetAllDistance`(
)
BEGIN
	UPDATE destinazione_cliente 
	SET tempo_strada = 0,
		km_sede = 0;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_serverCustomerDestinationSetAsMainDestination
DROP PROCEDURE IF EXISTS sp_serverCustomerDestinationSetAsMainDestination;
DELIMITER //
CREATE  PROCEDURE `sp_serverCustomerDestinationSetAsMainDestination`(
	IN customer_id INT,
	IN destination_id INT, 
	OUT result INT
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	UPDATE destinazione_cliente 
	SET Sede_principale = True, 
		Utente_mod = @USER_ID
	WHERE Id_cliente = customer_id AND
			Id_destinazione = destination_id; 
	
	UPDATE destinazione_cliente 
	SET Sede_principale = False, 
		Utente_mod = @USER_ID
	WHERE Id_cliente = customer_id AND
			Id_destinazione <> destination_id;
			
	SET Result = 1; 
	

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_serverReportAttachmentGetByReport
DROP PROCEDURE IF EXISTS sp_serverReportAttachmentGetByReport;
DELIMITER //
CREATE  PROCEDURE `sp_serverReportAttachmentGetByReport`(
	IN report_id INT,
	IN report_year INT
)
BEGIN

	SELECT
		`id`,
		`id_rapporto`,
		`anno_rapporto`,
		`file_path`,
		`file_name`,
		`invia_a_cliente`,
		`timestamp`,
		`utente_ins`
	FROM rapporto_allegati
	WHERE id_rapporto = report_id
		AND anno_rapporto = report_year;

END//
DELIMITER ;
