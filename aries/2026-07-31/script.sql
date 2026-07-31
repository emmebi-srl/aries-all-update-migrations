ALTER DATABASE
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_general_ci;

ALTER TABLE `rapporto_mobile`
	DEFAULT CHARACTER SET utf8mb4
	COLLATE utf8mb4_general_ci,
	MODIFY COLUMN `relazione` TEXT
		CHARACTER SET utf8mb4
		COLLATE utf8mb4_general_ci
		NULL,
	MODIFY COLUMN `Note_Generali` VARCHAR(1000)
		CHARACTER SET utf8mb4
		COLLATE utf8mb4_general_ci
		NULL DEFAULT NULL,
	MODIFY COLUMN `APPUNTI` TEXT
		CHARACTER SET utf8mb4
		COLLATE utf8mb4_general_ci
		NULL;

DELIMITER //

DROP PROCEDURE IF EXISTS `sp_apiReportMobileInterventionInsert`//

CREATE PROCEDURE `sp_apiReportMobileInterventionInsert` (
	id INT,
	`year` INT,
	system_id INT,
	customer_id INT,
	requesting_intervention VARCHAR(30),
	responsible_job VARCHAR(30),
	responsible VARCHAR(30),
	intervention_type TINYINT,
	right_call BIT,
	technical_report TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
	notes_highlights TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
	is_work_finished BIT,
	system_conditions TINYINT,
	execution_date DATE,
	report_number INT,
	user_id INT,
	email_company VARCHAR(45),
	is_nocturnal BIT,
	is_public_holiday BIT,
	is_on_call BIT,
	is_carried_out_in_day BIT,
	is_replaced BIT,
	is_repair BIT,
	is_custom BIT,
	intervention_detail_custom_text VARCHAR(45),
	is_under_warranty BIT,
	is_subscribed BIT,
	is_not_under_warranty BIT,
	is_not_subscribed BIT,
	ordinary_maintenance BIT,
	extra_ordinary_maintenance BIT,
	system_type INT,
	company_name VARCHAR(60),
	address VARCHAR(100),
	city VARCHAR(100),
	work_place VARCHAR(255),
	problem_detected VARCHAR(100),
	email_responsible VARCHAR(100),
	responsible_id INT,
	send_to_technician INT,
	clipboard TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
	is_telephone_avaibility BIT,
	technician_sender_id MEDIUMINT,
	creation_timestamp DATETIME,
	delivery_timestamp DATETIME,
	telephone_avaibility_timestamp DATETIME,
	has_ddt_signature BIT(1),
	attachments_number SMALLINT,
	report_type SMALLINT
)
BEGIN
	DECLARE subscription_id INT;
	DECLARE destination_id INT;
	DECLARE ref_interventionType TINYINT;

	SET subscription_id = 0;
	SET destination_id = 0;

	IF(system_id > 0) THEN
		SELECT abbonamento, destinazione
		INTO subscription_id, destination_id
		FROM Impianto
		WHERE id_impianto = system_id;
	END IF;

	IF(destination_id = 0) THEN
		SET destination_id = 1;
	END IF;

	SELECT rapporto_mobile_intervento_rif_tipo_intervento.Id_tipo_intervento
	INTO ref_interventionType
	FROM rapporto_mobile_intervento_rif_tipo_intervento
	WHERE rapporto_mobile_intervento_rif_tipo_intervento.Posizione = intervention_type;

	INSERT INTO rapporto_mobile SET
		id_rapporto = id,
		anno = year,
		id_impianto = system_id,
		id_destinazione = destination_id,
		id_cliente = customer_id,
		Richiesto = requesting_intervention,
		mansione = responsible_job,
		responsabile = responsible,
		tipo_intervento = IFNULL(ref_interventionType, 2),
		Diritto_chiamata = right_call,
		tipo_diritto_chiamata = 0,
		relazione = technical_report,
		terminato = is_work_finished,
		funzionante = system_conditions,
		stato = 1,
		Note_generali = notes_highlights,
		Fattura = NULL,
		Data = CURDATE(),
		Commessa = NULL,
		abbonamento = NULL,
		Numero_ordine = NULL,
		Totale = 0,
		Nr_rapporto = report_number,
		Data_esecuzione = execution_date,
		costo = 0,
		scan = 0,
		anno_fattura = NULL,
		controllo_periodico = NULL,
		prima = 0,
		numero = report_number,
		id_utente = user_id,
		cost_lav = NULL,
		prez_lav = NULL,
		dest_cli = customer_id,
		email_invio = email_company,
		inviato = 0,
		visionato = 0,
		id_ticket = NULL,
		tecnici = NULL,
		appunti = clipboard,
		notturno = is_nocturnal,
		festivo = is_public_holiday,
		su_chiamata = is_on_call,
		eff_giorn = is_carried_out_in_day,
		sost = is_replaced,
		ripar = is_repair,
		`not` = intervention_detail_custom_text,
		c_not = is_custom,
		abbon = is_subscribed,
		garanz = is_under_warranty,
		man_ordi = ordinary_maintenance,
		fuoriabbon = IFNULL(is_not_subscribed, 0),
		fuorigaranz = IFNULL(is_not_under_warranty, 0),
		man_straord = extra_ordinary_maintenance,
		tipo_impianto = system_type,
		ragione_sociale = company_name,
		indirizzo = address,
		citta = city,
		luogo_lavoro = work_place,
		difetto = problem_detected,
		id_riferimento = responsible_id,
		mail_responsabile = email_responsible,
		invia_a_tecnico = send_to_technician,
		da_reperibilita_telefonica = is_telephone_avaibility,
		id_tecnico = technician_sender_id,
		timestamp_creazione = creation_timestamp,
		timestamp_invio = delivery_timestamp,
		timestamp_reperibilita = telephone_avaibility_timestamp,
		usa_altra_firma_su_ddt = has_ddt_signature,
		tipo_rapporto = report_type,
		numero_allegati = attachments_number;
END//

DELIMITER ;
