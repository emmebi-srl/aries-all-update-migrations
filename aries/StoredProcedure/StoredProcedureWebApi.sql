DROP PROCEDURE IF EXISTS `sp_apiReportGetIdsByYear`;

DELIMITER //

CREATE PROCEDURE `sp_apiReportGetIdsByYear`(quantity INT, current_year INT)
BEGIN

	
	DECLARE id_rapp INT;
	DECLARE id_rapp_mobile INT;
	
	DECLARE start_report_id INT;
	DECLARE counter INT;
	
	
	START TRANSACTION; 
		
	SET counter = 0; 
	
	DROP TABLE IF EXISTS ReportIds;
	CREATE TEMPORARY TABLE ReportIds
	(
		id_rapporto INT, 
		anno INT
	);
	
	SELECT IFNULL(MAX(a.id_rapporto)+1, 1) INTO id_rapp 
	from rapporto as a 
	where anno=current_year;
	
	SELECT IFNULL(max(a.id_rapporto)+1, 1) INTO id_rapp_mobile 
	from rapporto_mobile as a 
	where anno=current_year;
	
	
	if id_rapp>id_rapp_mobile then
	 set start_report_id=id_rapp;
	else
	 set start_report_id=id_rapp_mobile;
	end if;
	
	
   WHILE(counter < quantity) DO
    INSERT INTO ReportIds VALUES (start_report_id + counter, current_year);
    SET counter = counter + 1; 
   END WHILE;

	INSERT INTO rapporto_mobile (id_rapporto, anno, diritto_chiamata, tipo_diritto_chiamata, festivo, su_chiamata, eff_giorn,sost, ripar, `not`, c_not, abbon, garanz, man_ordi, fuorigaranz, man_straord, tipo_impianto,ragione_sociale, indirizzo, citta, luogo_lavoro, difetto, inviato, visionato, fuoriabbon, id_tecnico,
		numero_allegati)
	SELECT id_rapporto ,
			  anno, 
			  "0",
			  "0",
			  "0",
			  "0",
			  "0",
			  "0","0","0", "0","0","0","0","0","0","0","0","0","0","0","0","0", 0, 0 , 0, 0
	FROM ReportIds;


	
	SELECT id_rapporto, 
		anno
	FROM ReportIds; 
	
	COMMIT;
END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS `sp_apiReportGetIds`;

DELIMITER //

CREATE PROCEDURE `sp_apiReportGetIds`(quantity INT)
BEGIN
	CALL sp_apiReportGetIdsByYear(quantity, YEAR(CURDATE())); 
END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS sp_tknGetIDToken;
DELIMITER $$
CREATE PROCEDURE `sp_tknGetIDToken`(IN `id_utente`                       INT, IN `deadline`                       DATETIME, OUT `id_token`                       INT)

BEGIN

  INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);
  SELECT LAST_INSERT_ID() INTO id_token;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_usrGetIDByUsername;
DELIMITER $$

CREATE PROCEDURE `sp_usrGetIDByUsername`(IN `username`                       VARCHAR(60), OUT `id_utente`                       INT)
BEGIN
SELECT utente.id_utente INTO id_utente
FROM utente
WHERE utente.Nome = username;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_tknRefreshTokenExists;
DELIMITER $$

CREATE PROCEDURE `sp_tknRefreshTokenExists`(IN `id_token`                       INT, OUT `FlagFind`                       BIT)
BEGIN
  SET FlagFind = 0; 
	
  SELECT COUNT(id_token)
	INTO 
		FlagFind
  FROM TokenRefresh 
  WHERE TokenRefresh.id_token=id_token;
  
  IF FlagFind then
    DELETE FROM TokenRefresh Where TokenRefresh.id_token=id_token;
  end if;

END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiCustomerGet;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerGet ()
BEGIN

	SELECT DISTINCT
		c.Id_cliente,
		c.Ragione_Sociale,
		c.Ragione_sociale2,
		IFNULL(c.Partita_iva, '') AS partita_iva,
		IFNULL(c.Codice_Fiscale, '') AS codice_fiscale,
		c.Cortese_attenzione,
		c.Data_inserimento,
		c.Stato_cliente,
		c.Tipo_Cliente,
		c.stato_economico,
		c.condizione_pagamento,
		c.Sito_internet,
		c.password,
		c.Utente_sito,
		c.iva,
		c.modi,
		c.rc,
		c.posta,
		c.ex,
		c.tipo_rapporto,
		c.id_utente,
		c.id_agente,
		c.id_abbona,
		c.id_attività as id_attivita,
		c.pec,
		c.codice_univoco,
		c.e_codice_destinatario,
		IFNULL(c.Insolvente, FALSE) AS Insolvente,
		c.data_ultima_modifica
	FROM clienti c
		INNER JOIN impianto ON 
			c.Id_cliente IN (impianto.Id_cliente, impianto.Id_gestore, impianto.Id_occupante);
			
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiCustomerGetByIds;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerGetByIds (
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT DISTINCT 
		c.Id_cliente,
		c.Ragione_Sociale,
		c.Ragione_sociale2,
		IFNULL(c.Partita_iva, '') AS partita_iva,
		IFNULL(c.Codice_Fiscale, '') AS codice_fiscale,
		c.Cortese_attenzione,
		c.Data_inserimento,
		c.Stato_cliente,
		c.Tipo_Cliente,
		c.stato_economico,
		c.condizione_pagamento,
		c.Sito_internet,
		c.password,
		c.Utente_sito,
		c.iva,
		c.modi,
		c.rc,
		c.posta,
		c.ex,
		c.tipo_rapporto,
		c.id_utente,
		c.id_agente,
		c.id_abbona,
		c.id_attività as id_attivita,
		c.pec,
		c.codice_univoco,
		c.e_codice_destinatario,
		IFNULL(c.Insolvente, FALSE) AS Insolvente,
		c.data_ultima_modifica
	FROM clienti c
	WHERE FIND_IN_SET(`c`.`id_cliente`, customer_ids);
			
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiCustomerContactGet;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerContactGet ()
BEGIN


	SELECT DISTINCT id_riferimento, 
		riferimento_clienti.id_cliente, 
		IFNULL(titolo, "") 'titolo', 
		IFNULL(nome, "") 'nome', 
		IFNULL(riferimento_figura.Figura, "") 'figura',
		IFNULL(riferimento_clienti.Telefono, "") 'telefono', 
		IFNULL(riferimento_clienti.altro_telefono, "") 'altro_telefono', 
		IFNULL(riferimento_clienti.mail, "") 'mail',
		riferimento_clienti.Promemoria_cliente
	FROM riferimento_clienti 
		INNER JOIN riferimento_figura ON 
			riferimento_clienti.figura = riferimento_figura.Id_figura;
			
END; //
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_apiCustomerContactGetByCustomers;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerContactGetByCustomers (
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT DISTINCT id_riferimento, 
		riferimento_clienti.id_cliente, 
		IFNULL(titolo, "") 'titolo', 
		IFNULL(nome, "") 'nome', 
		IFNULL(riferimento_figura.Figura, "") 'figura',
		IFNULL(riferimento_clienti.Telefono, "") 'telefono', 
		IFNULL(riferimento_clienti.altro_telefono, "") 'altro_telefono', 
		IFNULL(riferimento_clienti.mail, "") 'mail',
		riferimento_clienti.Promemoria_cliente	
	FROM riferimento_clienti 
		INNER JOIN riferimento_figura ON 
			riferimento_clienti.figura = riferimento_figura.Id_figura
	WHERE FIND_IN_SET(riferimento_clienti.id_cliente, customer_ids);
			
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationGet;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerDestinationGet ()
BEGIN

	SELECT DISTINCT id_destinazione, 
		destinazione_cliente.id_cliente,
		IFNULL(destinazione_cliente.provincia, "") 'provincia',
		IFNULL(comune.nome, "") 'comune',
		IFNULL(frazione.nome, "") 'frazione',
		IFNULL(indirizzo, "") 'indirizzo', 
		IFNULL(numero_civico, 0) 'numero_civico', 
		IFNULL(destinazione_cliente.altro, "") 'altro', 
		comune.cap,
		km_sede, 
		tempo_strada,
		longitudine,
		latitudine,
		destinazione_cliente.sede_principale
	FROM destinazione_cliente  
		LEFT JOIN comune ON
			destinazione_cliente.comune = id_comune
		LEFT JOIN frazione ON
			destinazione_cliente.Frazione = id_frazione;
			
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationGetById;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerDestinationGetById 
(
customer_id INT,
destination_id INT
)
BEGIN

	SELECT DISTINCT id_destinazione, 
		destinazione_cliente.id_cliente,
		IFNULL(destinazione_cliente.provincia, "") 'provincia',
		IFNULL(comune.nome, "") 'comune',
		IFNULL(frazione.nome, "") 'frazione',
		IFNULL(indirizzo, "") 'indirizzo', 
		IFNULL(numero_civico, 0) 'numero_civico', 
		IFNULL(destinazione_cliente.altro, "") 'altro', 
		comune.cap,
		km_sede, 
		tempo_strada,
		longitudine,
		latitudine,
		destinazione_cliente.sede_principale
	FROM destinazione_cliente  
		LEFT JOIN comune ON
			destinazione_cliente.comune = id_comune
		LEFT JOIN frazione ON
			destinazione_cliente.Frazione = id_frazione
	WHERE destinazione_cliente.id_cliente = customer_id AND id_destinazione = destination_id; 
			
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationGetByCustomers;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerDestinationGetByCustomers 
(
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT DISTINCT id_destinazione, 
		destinazione_cliente.id_cliente,
		IFNULL(destinazione_cliente.provincia, "") 'provincia',
		IFNULL(comune.nome, "") 'comune',
		IFNULL(frazione.nome, "") 'frazione',
		IFNULL(indirizzo, "") 'indirizzo', 
		IFNULL(numero_civico, 0) 'numero_civico', 
		IFNULL(destinazione_cliente.altro, "") 'altro', 
		comune.cap,
		km_sede, 
		tempo_strada,
		longitudine,
		latitudine,
		destinazione_cliente.sede_principale
	FROM destinazione_cliente  
		LEFT JOIN comune ON
			destinazione_cliente.comune = id_comune
		LEFT JOIN frazione ON
			destinazione_cliente.Frazione = id_frazione
	WHERE FIND_IN_SET(destinazione_cliente.id_cliente, customer_ids);
			
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationGetBySystemIds;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerDestinationGetBySystemIds 
(system_ids MEDIUMTEXT)
BEGIN
	SELECT DISTINCT id_destinazione, 
		destinazione_cliente.id_cliente,
		IFNULL(destinazione_cliente.provincia, "") 'provincia',
		IFNULL(comune.nome, "") 'comune',
		IFNULL(frazione.nome, "") 'frazione',
		IFNULL(indirizzo, "") 'indirizzo', 
		IFNULL(numero_civico, 0) 'numero_civico', 
		IFNULL(destinazione_cliente.altro, "") 'altro', 
		comune.cap,
		km_sede, 
		tempo_strada,
		longitudine,
		latitudine,
		destinazione_cliente.sede_principale
	FROM impianto
		INNER JOIN destinazione_cliente ON destinazione_cliente.id_cliente = impianto.id_cliente
			AND destinazione_cliente.id_destinazione = impianto.destinazione
		LEFT JOIN comune ON
			destinazione_cliente.comune = id_comune
		LEFT JOIN frazione ON
			destinazione_cliente.Frazione = id_frazione
	WHERE FIND_IN_SET(impianto.id_impianto, system_ids);
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTechnicianGet;
DELIMITER //
CREATE PROCEDURE sp_apiTechnicianGet ()
BEGIN
	SELECT id_operaio, 
	ragione_sociale, 
	mail_account 
	FROM  Operaio 
	WHERE Data_licenziamento is null and Is_tecnico=1;	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemTypeGet;
DELIMITER //
CREATE PROCEDURE sp_apiSystemTypeGet ()
BEGIN
	SELECT id_tipo,
		nome
	FROM tipo_impianto;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiTicketGet;
DELIMITER //
CREATE PROCEDURE sp_apiTicketGet ()
BEGIN
	SELECT `ticket`.`id`                       AS `id`,
		`ticket`.`Id_ticket`                       AS `id_ticket`,
		`ticket`.`anno`                       AS `anno`,
		`ticket`.`Id_impianto`                       AS `id_impianto`,
		`ticket`.`Id_cliente`                       AS `id_cliente`,
		ticket.id_destinazione,
		`ticket`.`Urgenza`                       AS `urgenza`,
		`ticket`.`Descrizione`                       AS `ticket_descrizione`,
		IFNULL(ticket.Data_ticket, ticket.data_ora) AS "data_ticket", 
		ticket.scadenza AS Data_scadenza, 
		ticket.data_ora,
		ticket.data_soluzione, 
		ticket.Causale, 
		ticket.intervento,
		ticket.Comunicazione, 
		ticket.Stato_ticket,
		ticket.tempo, 
		ticket.id_utente, 
		ticket.stampato, 
		ticket.inviato, 
		ticket.data_promemoria,
		ticket.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM ticket
		INNER JOIN stato_promemoria_cliente ON ticket.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE ((`ticket`.`Stato_ticket`                       = '1' OR `ticket`.`Stato_ticket`                       = '2') AND (`ticket`.`Id_impianto`                       IS NOT NULL)); 
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketGetById;
DELIMITER //
CREATE PROCEDURE sp_apiTicketGetById (ticket_id INT)
BEGIN
	SELECT `ticket`.`id`                       AS `id`,
		`ticket`.`Id_ticket`                       AS `id_ticket`,
		`ticket`.`anno`                       AS `anno`,
		`ticket`.`Id_impianto`                       AS `id_impianto`,
		`ticket`.`Id_cliente`                       AS `id_cliente`,
		ticket.id_destinazione,
		`ticket`.`Urgenza`                       AS `urgenza`,
		`ticket`.`Descrizione`                       AS `ticket_descrizione`,
		IFNULL(ticket.Data_ticket, ticket.data_ora) AS "data_ticket", 
		ticket.scadenza AS Data_scadenza, 
		ticket.data_ora,
		ticket.data_soluzione, 
		ticket.Causale, 
		ticket.intervento,
		ticket.Comunicazione, 
		ticket.Stato_ticket,
		ticket.tempo, 
		ticket.id_utente, 
		ticket.stampato, 
		ticket.inviato, 
		ticket.data_promemoria,
		ticket.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM ticket
		INNER JOIN stato_promemoria_cliente ON ticket.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE ticket.id = ticket_id; 
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiTicketGetBySystems;
DELIMITER //
CREATE PROCEDURE sp_apiTicketGetBySystems (
	system_ids MEDIUMTEXT
)
BEGIN
	SELECT `ticket`.`id`                       AS `id`,
		`ticket`.`Id_ticket`                       AS `id_ticket`,
		`ticket`.`anno`                       AS `anno`,
		`ticket`.`Id_impianto`                       AS `id_impianto`,
		`ticket`.`Id_cliente`                       AS `id_cliente`,
		ticket.id_destinazione,
		`ticket`.`Urgenza`                       AS `urgenza`,
		`ticket`.`Descrizione`                       AS `ticket_descrizione`,
		IFNULL(ticket.Data_ticket, ticket.data_ora) AS "data_ticket", 
		ticket.scadenza AS Data_scadenza, 
		ticket.data_ora,
		ticket.data_soluzione, 
		ticket.Causale, 
		ticket.intervento,
		ticket.Comunicazione, 
		ticket.Stato_ticket,
		ticket.tempo, 
		ticket.id_utente, 
		ticket.stampato, 
		ticket.inviato, 
		ticket.data_promemoria,
		ticket.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM ticket
		INNER JOIN stato_promemoria_cliente ON ticket.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE ((`ticket`.`Stato_ticket`                       = '1' OR `ticket`.`Stato_ticket`                       = '2') AND  FIND_IN_SET(`ticket`.`Id_impianto`, system_ids)); 
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiTicketUpdate;
DELIMITER //
CREATE PROCEDURE sp_apiTicketUpdate (
	IN ticket_id INT, 
	IN status_id VARCHAR(50), 
	IN allow_status_id BIT(1)
)
BEGIN
	UPDATE Ticket 
	SET
		stato_ticket = IF(IFNULL(allow_status_id, FALSE), status_id, stato_ticket)
	WHERE id = ticket_id;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemGet;
DELIMITER //
CREATE PROCEDURE sp_apiSystemGet ()
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
		impianto.id_stato_promemoria_garanzia,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
	FROM impianto
		INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
		INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
		INNER JOIN stato_impianto ON id_stato = Stato
		LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
		LEFT JOIN checklist_model_impianto ON impianto.id_impianto = checklist_model_impianto.id_impianto
	WHERE ((`impianto`.`Stato`                       < 4) OR (`impianto`.`Stato`                       > 7))
	GROUP BY `impianto`.`Id_impianto`;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS  sp_apiSystemGetByDistance;
DELIMITER $$ 
CREATE PROCEDURE sp_apiSystemGetByDistance(
	IN latitude DECIMAL(11,8),
	IN longitude DECIMAL(11,8),
	IN distance DECIMAL(8,2)
)
BEGIN 

	SELECT * 
	FROM (
		SELECT 
			`impianto`.`Id_impianto`                       AS `id_impianto`,
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
			destinazione_cliente.latitudine,
			destinazione_cliente.longitudine,
			111.1111 *
    		DEGREES(ACOS(COS(RADIANS(latitude))
			 * COS(RADIANS(destinazione_cliente.latitudine))
			 * COS(RADIANS(longitude - destinazione_cliente.longitudine))
			 + SIN(RADIANS(latitude))
			 * SIN(RADIANS(destinazione_cliente.latitudine)))) AS distanza,
			abbonamento.nome as "abbonamento",
			impianto.id_stato_promemoria_garanzia,
			stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
		FROM impianto
			INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
			INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
			INNER JOIN stato_impianto ON id_stato = Stato
			LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
			INNER JOIN destinazione_cliente ON impianto.Id_cliente = destinazione_cliente.id_cliente AND impianto.Destinazione = destinazione_cliente.Id_destinazione
		WHERE ((`impianto`.`Stato`                       < 4) OR (`impianto`.`Stato`                       > 7)) AND destinazione_cliente.latitudine IS NOT NULL AND destinazione_cliente.latitudine > 0
	) AS result
	WHERE distanza <= distance;
	
	
END $$
DELIMITER ;


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

DROP PROCEDURE IF EXISTS sp_apiSystemGetById;
DELIMITER //
CREATE PROCEDURE sp_apiSystemGetById (id INT)
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
		impianto.id_stato_promemoria_garanzia,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
	FROM impianto
		INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
		INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
		INNER JOIN stato_impianto ON id_stato = Stato
		LEFT JOIN checklist_model_impianto ON impianto.id_impianto = checklist_model_impianto.id_impianto
		LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
	WHERE impianto.id_impianto = id;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemGetBetweenWarrantyDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemGetBetweenWarrantyDates  (
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT `impianto`.`Id_impianto`,
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
		impianto.id_stato_promemoria_garanzia,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
	FROM impianto
		INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
		INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
		INNER JOIN stato_impianto ON id_stato = Stato
		LEFT JOIN checklist_model_impianto ON impianto.id_impianto = checklist_model_impianto.id_impianto
		LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
	WHERE scadenza_garanzia BETWEEN from_date AND to_date;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemGetBetweenWarrantyReminderDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemGetBetweenWarrantyReminderDates  (
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT `impianto`.`Id_impianto`,
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
		impianto.id_stato_promemoria_garanzia,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
	FROM impianto
		INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
		INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
		INNER JOIN stato_impianto ON id_stato = Stato
		LEFT JOIN checklist_model_impianto ON impianto.id_impianto = checklist_model_impianto.id_impianto
		LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
	WHERE data_promemoria_garanzia BETWEEN from_date AND to_date;
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiSystemNoteGet;
DELIMITER //
CREATE PROCEDURE sp_apiSystemNoteGet ()
BEGIN
	SELECT  impianto_note.Id_impianto, 
		impianto_note.Id_nota, 
		impianto_note_descrizione.Nome, 
		impianto_note.Testo 
	FROM impianto_note
		INNER JOIN impianto_note_descrizione ON impianto_note.id_nota = impianto_note_descrizione.id_descrizione; 
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemNoteInsert;
DELIMITER //
CREATE PROCEDURE sp_apiSystemNoteInsert 
(
	IN system_id INT(11), 
	IN note_id INT(11),
	IN name VARCHAR(100),
	IN description TEXT, 
	OUT result SMALLINT
)
BEGIN
	DECLARE note_name VARCHAR(45);
	DECLARE note_occurance SMALLINT;
	DECLARE has_already_note BIT; 
	SET Result = 1;
	
	SELECT id_descrizione, Nome
		INTO note_id, note_name
	FROM impianto_note_descrizione
	WHERE impianto_note_descrizione.nome = name; 
	-- check if note description is already present
	if note_name IS NULL THEN
		INSERT INTO impianto_note_descrizione (nome) VALUES (name); 
		SELECT LAST_INSERT_ID() INTO note_id;
	ELSE
	
		SELECT 
			COUNT(*) > 0 
		INTO 
			has_already_note 
		FROM impianto_note 
		WHERE id_nota = note_id AND id_impianto = system_id;
		
		IF has_already_note THEN
			SET note_name = CONCAT(note_name, ' - ', UNIX_TIMESTAMP());
			
			INSERT INTO impianto_note_descrizione (nome) VALUES (note_name); 
			SELECT LAST_INSERT_ID() INTO note_id;
			
		END IF;  
	
	END IF;
	
	
	
	INSERT INTO impianto_note (id_impianto, id_nota, Testo)
	VALUES (system_id, note_id, description); 

	SELECT 
		impianto_note.Id_impianto,
		impianto_note.Id_nota, 
		impianto_note_descrizione.Nome, 
		impianto_note.Testo 
	FROM impianto_note
		INNER JOIN impianto_note_descrizione ON impianto_note.id_nota = impianto_note_descrizione.id_descrizione
	WHERE impianto_note.Id_impianto = system_id AND impianto_note.id_nota = note_id;
	
END; //
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_apiSystemNoteTypeGet;
DELIMITER //
CREATE PROCEDURE sp_apiSystemNoteTypeGet ()
BEGIN
	SELECT impianto_note_descrizione.Id_descrizione, 
		Nome
	FROM impianto_note_descrizione;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemSupervisionGet;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSupervisionGet ()
BEGIN
	SELECT iv.Id_impianto, 
	iv.Id_vigilante, 
	IFNULL(tipo, 0) as Tipo
	FROM impianto_vigilante AS iv 
	LEFT JOIN impianto_vigilante_collegamenti AS ivc 
	ON iv.Id_impianto = ivc.id_impianto AND iv.Id_vigilante = ivc.id_vigilante; 
END; //
DELIMITER ;
DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemReferenceContactGet;
CREATE PROCEDURE sp_apiSystemReferenceContactGet ()
BEGIN
SELECT id_impianto,
id_cliente,
id_riferimento
	FROM impianto_riferimento ;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSupervisionTypeGet;
DELIMITER //
CREATE PROCEDURE sp_apiSupervisionTypeGet ()
BEGIN
	SELECT Id_tipo, 
	Nome 
	FROM tipo_vigilante;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSupervisionGet;
DELIMITER //
CREATE PROCEDURE sp_apiSupervisionGet ()
BEGIN
	SELECT Id_vigilante,
	IFNULL(tipo, 0) AS Tipo, 
	IFNULL(Descrizione, "") AS Descrizione,
	IFNULL(telefono, "") AS Telefono, 
	IFNULL(altro_telefono, "") AS Altro_telefono,
	IFNULL(cellulare, "") Cellulare, 
	IFNULL(mail,"") Email
	FROM vigilante;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiProductGet;
DELIMITER //
CREATE PROCEDURE sp_apiProductGet ()
BEGIN
	SELECT codice_articolo,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		Desc_brev,
		Tempo_installazione,
		stato_articolo, 
		CAST(Data_inserimento as Datetime) Data_ins, 
		articolo.modifica, 
		barcode,
		unità_misura unita_misura, 
		marca.nome as 'marca', 
		marca.id_marca,
		listino_prezzo.prezzo as "prezzo_interno",
		listino_costo.prezzo as "costo_interno",
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	 FROM articolo 
		LEFT JOIN marca ON marca.id_marca = articolo.marca
		INNER JOIN articolo_listino AS listino_prezzo ON listino_prezzo.id_articolo = articolo.codice_articolo AND listino_prezzo.id_listino = fnc_productInternalPriceId()
		INNER JOIN articolo_listino AS listino_costo ON listino_costo.id_articolo = articolo.codice_articolo AND listino_costo.id_listino = fnc_productInternalCostId();
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiProductSearch;
DELIMITER //
CREATE PROCEDURE sp_apiProductSearch (
	IN product_code VARCHAR(100), 
	IN supplier_product_code VARCHAR(100), 
	IN description VARCHAR(100), 
	IN my_barcode VARCHAR(100)
)
BEGIN
	SELECT DISTINCT codice_articolo,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		Desc_brev,
		Tempo_installazione,
		stato_articolo, 
		CAST(Data_inserimento as Datetime) Data_ins, 
		articolo.modifica, 
		barcode,
		unità_misura unita_misura, 
		marca.nome as 'marca', 
		marca.id_marca,
		IFNULL(listino_prezzo.prezzo, 0) as "prezzo_interno",
		IFNULL(listino_costo.prezzo, 0) as "costo_interno",
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	 FROM articolo 
		LEFT JOIN marca ON marca.id_marca = articolo.marca
		LEFT JOIN articolo_codice ON articolo.codice_articolo = articolo_codice.id_articolo
		LEFT JOIN articolo_listino AS listino_prezzo ON listino_prezzo.id_articolo = articolo.codice_articolo AND listino_prezzo.id_listino = fnc_productInternalPriceId()
		LEFT JOIN articolo_listino AS listino_costo ON listino_costo.id_articolo = articolo.codice_articolo AND listino_costo.id_listino = fnc_productInternalCostId()
	 WHERE (product_code IS NOT NULL AND codice_articolo LIKE CONCAT("%", product_code, "%"))
		OR (supplier_product_code IS NOT NULL AND Codice_fornitore LIKE CONCAT("%", supplier_product_code, "%"))
		OR (description IS NOT NULL AND Desc_brev LIKE CONCAT("%", description, "%"))
		OR (my_barcode IS NOT NULL AND barcode LIKE CONCAT("%", my_barcode, "%"))
		OR (supplier_product_code IS NOT NULL AND articolo_codice.codice LIKE CONCAT("%", supplier_product_code, "%"))
		OR (my_barcode IS NOT NULL AND articolo_codice.codice LIKE CONCAT("%", my_barcode, "%"))
	ORDER BY Desc_brev;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiProductGetByCodes;
DELIMITER //
CREATE PROCEDURE sp_apiProductGetByCodes (
	IN product_codes MEDIUMTEXT
)
BEGIN
	SELECT DISTINCT codice_articolo,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		Desc_brev,
		Tempo_installazione,
		stato_articolo, 
		CAST(Data_inserimento as Datetime) Data_ins, 
		articolo.modifica, 
		barcode,
		unità_misura unita_misura, 
		marca.nome as 'marca', 
		marca.id_marca,
		listino_prezzo.prezzo as "prezzo_interno",
		listino_costo.prezzo as "costo_interno",
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	 FROM articolo 
		LEFT JOIN marca ON marca.id_marca = articolo.marca
		LEFT JOIN articolo_codice ON articolo.codice_articolo = articolo_codice.id_articolo
		INNER JOIN articolo_listino AS listino_prezzo ON listino_prezzo.id_articolo = articolo.codice_articolo AND listino_prezzo.id_listino = fnc_productInternalPriceId()
		INNER JOIN articolo_listino AS listino_costo ON listino_costo.id_articolo = articolo.codice_articolo AND listino_costo.id_listino = fnc_productInternalCostId()
	 WHERE FIND_IN_SET(`articolo`.`codice_articolo`, product_codes);
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiProductUpdate;
DELIMITER //
CREATE PROCEDURE sp_apiProductUpdate (
	IN product_code VARCHAR(11), 
	IN my_barcode VARCHAR(50), 
	IN allow_my_barcode BIT(1),
	IN depot_shelf VARCHAR(50), 
	IN allow_depot_shelf BIT(1),
	IN depot_shelf_tier VARCHAR(50), 
	IN allow_depot_shelf_tier BIT(1),
	IN depot_position_description VARCHAR(255), 
	IN allow_depot_position_description BIT(1)
)
BEGIN
	UPDATE Articolo 
	SET
		barcode = IF(IFNULL(allow_my_barcode, FALSE), my_barcode, barcode),
		scaffaliera_magazzino = IF(IFNULL(allow_depot_shelf, FALSE), depot_shelf, scaffaliera_magazzino),
		ripiano_magazzino = IF(IFNULL(allow_depot_shelf_tier, FALSE), depot_shelf_tier, ripiano_magazzino),
		descrizione_posizione_magazzino = IF(IFNULL(allow_depot_position_description, FALSE), depot_position_description, descrizione_posizione_magazzino)
	WHERE codice_articolo = product_code;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiProductStatusGet;
DELIMITER //
CREATE PROCEDURE sp_apiProductStatusGet ()
BEGIN
	SELECT id_stato, 
	nome, 
	bloccato
	FROM articolo_stato; 
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiReportGet;
DELIMITER //
CREATE PROCEDURE sp_apiReportGet ()
BEGIN
	SELECT Id_rapporto,
		anno, 
		Id_impianto, 
		id_destinazione, 
		id_cliente, 
		Stato as id_stato,
		stato_rapporto.nome as stato,
		CAST(Data_esecuzione AS DATETIME) Data_esecuzione, 
		CONCAT(IFNULL(relazione, ""), "\nNOTE IN EVIDENZA: ", IFNULL(note_generali, ""),
			"\nAPPUNTI: ", IFNULL(appunti, "")) relazione,
		IFNULL(note_generali, "") note_generali,
		stato_rapporto.fatturato,
		rapporto.numero_allegati
	FROM  rapporto
		INNER JOIN stato_rapporto ON stato_rapporto.Id_stato = rapporto.stato
	WHERE id_impianto IS NOT NULL;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiInvoiceOpenedGet;
DELIMITER //
CREATE PROCEDURE sp_apiInvoiceOpenedGet ()
BEGIN
	SELECT 1;
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionInsert; 
CREATE PROCEDURE sp_apiReportMobileInterventionInsert  (
	id INT, 
	`year` INT,
	system_id INT,  
	customer_id INT,  
	requesting_intervention VARCHAR(30),
	responsible_job VARCHAR(30),
	responsible VARCHAR(30), 
	intervention_type TINYINT, 
	right_call BIT, 
	technical_report TEXT, 
	notes_highlights TEXT, 
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
	clipboard TEXT,
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
	
	IF(system_id>0) THEN 
		SELECT abbonamento, destinazione
		INTO subscription_id, destination_id
		FROM Impianto 
		WHERE id_impianto = system_id; 
	END IF; 
	
	IF(destination_id=0) THEN 
		SET destination_id = 1;  
	END IF; 
	
	SELECT rapporto_mobile_intervento_rif_tipo_intervento.Id_tipo_intervento 
		INTO
			ref_interventionType
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
		`not`                       = intervention_detail_custom_text, 
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
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionCheckExistence; 
CREATE PROCEDURE sp_apiReportMobileInterventionCheckExistence 
(
	id INT, 
	`year`                       INT,
	OUT result BIT 
)
BEGIN
   	
	SELECT IFNULL(COUNT(id_rapporto),0)
	INTO
	result 
	FROM rapporto_mobile 
	WHERE id_rapporto= id AND anno = `year`                       AND inviato = 1; 

END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionDelete; 
CREATE PROCEDURE sp_apiReportMobileInterventionDelete 
(
	id INT, 
	`year`                       INT
)
BEGIN
 	
	DELETE 
	FROM rapporto_mobile 
	WHERE id_rapporto= id AND anno = `year`; 
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionWorkDelete; 
CREATE PROCEDURE sp_apiReportMobileInterventionWorkDelete 
(
	id INT, 
	`year`                       INT
)
BEGIN 	
	DELETE 
	FROM rapporto_mobile_lavoro 
	WHERE id_rapporto= id AND anno_rapporto = `year`; 		
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionTicketDeleteByReport; 
CREATE PROCEDURE sp_apiReportMobileInterventionTicketDeleteByReport 
(
	id INT, 
	`year`                       INT
)
BEGIN
	
	DELETE 
	FROM rapporto_mobile_ticket 
	WHERE id_rapporto= id AND anno_rapporto = `year`; 
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionProductDeleteByReport; 
CREATE PROCEDURE sp_apiReportMobileInterventionProductDeleteByReport 
(
	id INT, 
	`year`                       INT
)
BEGIN	
	DELETE 
	FROM rapporto_mobile_materiale 
	WHERE id_rapporto= id AND anno_rapporto = `year`; 
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionTechnicianDelete; 
CREATE PROCEDURE sp_apiReportMobileInterventionTechnicianDelete 
(
	id INT, 
	`year`                       INT
)
BEGIN	
	DELETE 
	FROM rapporto_mobile_tecnico
	WHERE id_rapporto= id AND anno_rapporto = `year`; 
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileRecipientDelete; 
CREATE PROCEDURE sp_apiReportMobileRecipientDelete 
(
	id INT, 
	`year`                       INT
)
BEGIN	
	DELETE 
	FROM rapporto_mobile_destinatario
	WHERE id_rapporto= id AND anno = `year`; 
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileEventDelete; 
CREATE PROCEDURE sp_apiReportMobileEventDelete 
(
	id INT, 
	`year`                       INT
)
BEGIN	
	DELETE 
	FROM rapporto_mobile_evento
	WHERE id_rapporto= id AND anno = `year`; 
END; //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionSignatureDeleteByReport; 
CREATE PROCEDURE sp_apiReportMobileInterventionSignatureDeleteByReport 
(
	id INT, 
	`year`                       INT
)
BEGIN	
	DELETE FROM rapporto_mobile_firma
	WHERE id_rapporto = id AND anno_rapporto = `year`;
	
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionSignatureInsert; 
CREATE PROCEDURE sp_apiReportMobileInterventionSignatureInsert 
(
	id INT, 
	`year`                       INT,
	technician_signature BLOB, 
	customer_signature BLOB
)
BEGIN	

	INSERT INTO rapporto_mobile_firma
	SET id_rapporto = id,
	  anno_rapporto = `year`,
	  firma_tecnico = technician_signature, 
	  firma_cliente = customer_signature; 
	
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionCancelInsertOperation; 
CREATE PROCEDURE sp_apiReportMobileInterventionCancelInsertOperation (
	id INT, 
	`year`                       INT
)
BEGIN	
	CALL sp_apiReportMobileInterventionProductDeleteByReport(id, `year`); 
	CALL sp_apiReportMobileInterventionTicketDeleteByReport(id, `year`); 
	CALL sp_apiReportMobileInterventionWorkDelete(id, `year`); 
	CALL sp_apiReportMobileInterventionDelete(id, `year`); 
	CALL sp_apiReportMobileInterventionTechnicianDelete(id, `year`); 
	CALL sp_apiReportMobileInterventionSignatureDeleteByReport(id, `year`); 
	CALL sp_apiReportMobileRecipientDelete(id, `year`); 
	CALL sp_apiReportAttachmentDeleteByReport(id, `year`); 
	
	INSERT INTO rapporto_mobile 
	(id_rapporto, anno, diritto_chiamata, tipo_diritto_chiamata, 
	festivo, su_chiamata, eff_giorn,sost, ripar, `not`, c_not, 
	abbon, garanz, man_ordi, fuorigaranz, man_straord, 
	tipo_impianto,ragione_sociale, indirizzo, citta, 
	luogo_lavoro, difetto, inviato, visionato, fuoriabbon, numero_allegati)
	VALUES
	(id ,`year`, "0","0","0","0","0","0","0","0", "0","0","0","0","0","0","0","0","0","0","0","0","0",'1', 0, 0 );

	
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionWorkInsert; 
CREATE PROCEDURE sp_apiReportMobileInterventionWorkInsert 
(
	id INT, 
	`year`                       INT,
	work_description TINYINT,
	material_use DeCIMAL(11,2), 
	right_call BIT, 
	travel_consuntive BIT, 
	expense_consuntive BIT, 
	expense DECIMAL(11,2), 
	first_period_start TIME,
	second_period_start TIME, 
	first_period_end TIME, 
	second_period_end TIME, 
	technicians VARCHAR(100), 
	total_hours VARCHAR(45) , 
	extra_consuntive  BIT, 
	extra_text VARCHAR(35), 
	extra_expense DECIMAL(11,2),
	vans_number TINYINT
)
BEGIN
        
		
	INSERT INTO rapporto_mobile_lavoro
	SET id_rapporto = id,
		anno_rapporto = `year`, 
		controllo_periodico = work_description,
		materiale_uso = material_use, 
		diritto_chiamata = right_call, 
		viaggio_consuntivo = travel_consuntive,
		spese_consuntivo = expense_consuntive, 
		spese = expense, 
		ora_inizio_primo_periodo = first_period_start, 
		ora_fine_primo_periodo = first_period_end,
		ora_inizio_secondo_periodo = second_period_start, 
		ora_fine_secondo_periodo = second_period_end,
		tecnici = technicians, 
		totale_ore = total_hours, 
		extra_consuntivo = extra_consuntive, 
		extra_testo = extra_text,
		extra = extra_expense,
		numero_furgoni = vans_number;
		
END; //
DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiEventGet;
CREATE PROCEDURE sp_apiEventGet
()
BEGIN
        
	SELECT Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		IFNULL(impianto_abbonamenti_mesi.impianto,  Evento.Id_riferimento) id_riferimento,
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione, 
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Stato_notifica, 
		Evento.Data_notifica,
		Evento.Promemoria_inviato,
		Evento.Eliminato,
		Evento.Data_ins, 
		Evento.Data_mod,  
		evento_gruppo_evento.Id_gruppo_evento AS Id_gruppo,
		evento_gruppo.Id_impianto AS Id_impianto,
		evento_gruppo.Id_cliente AS Id_cliente
	FROM Evento
		LEFT JOIN evento_gruppo_evento
		ON evento_gruppo_evento.Id_evento = Evento.Id AND tipo_associazione = 1
		LEFT JOIN evento_gruppo
		ON evento_gruppo_evento.Id_gruppo_evento = Evento_gruppo.Id
		LEFT JOIN impianto_abbonamenti_mesi 
		ON evento.Id_riferimento = impianto_abbonamenti_mesi.id AND
			evento.Id_tipo_evento = 1; 

END //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiEventSetExecStatus;
CREATE PROCEDURE sp_apiEventSetExecStatus
(

	IN event_ids MEDIUMTEXT,
	IN exec_status BIT,
	IN report_id INT, 
	IN report_year INT
)
BEGIN

	START TRANSACTION; 

	SET @stmt = CONCAT("INSERT INTO splitArrayData(array_values) VALUES (", REPLACE(serializedArray, ",","),(") , ");");
	
	DROP TEMPORARY TABLE IF EXISTS splitArrayData;
	CREATE TEMPORARY TABLE splitArrayData (
		array_index INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		array_values VARCHAR(64) NOT NULL DEFAULT ""
	) ENGINE = innoDB;
	
	PREPARE sttmnt FROM @stmt;
	EXECUTE sttmnt;
	DEALLOCATE PREPARE sttmnt;
	
	SET @stmt = "";
	

	UPDATE evento
	SET evento.Eseguito = exec_status
	WHERE FIND_IN_SET(evento.Id, event_ids);
	
	INSERT INTO evento_rapporto (Id_evento, Id_rapporto, Anno_rapporto)
	SELECT array_values, 
		report_id, 
		report_year
	FROM splitArrayData;
	
	COMMIT;
	
END //
DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiEventGetFromDate;
CREATE PROCEDURE sp_apiEventGetFromDate
(	from_date DATETIME )
BEGIN
        
	SELECT Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		IFNULL(impianto_abbonamenti_mesi.impianto,  Evento.Id_riferimento) id_riferimento,
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione, 
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Stato_notifica, 
		Evento.Data_notifica, 
		Evento.Promemoria_inviato,
		Evento.Eliminato,
		Evento.Data_ins, 
		Evento.Data_mod,  
		evento_gruppo_evento.Id_gruppo_evento AS Id_gruppo,
		evento_gruppo.Id_impianto AS Id_impianto,
		evento_gruppo.Id_cliente AS Id_cliente
	FROM Evento
		LEFT JOIN evento_gruppo_evento
		ON evento_gruppo_evento.Id_evento = Evento.Id AND tipo_associazione = 1
		LEFT JOIN evento_gruppo
		ON evento_gruppo_evento.Id_gruppo_evento = Evento_gruppo.Id
		LEFT JOIN impianto_abbonamenti_mesi 
		ON evento.Id_riferimento = impianto_abbonamenti_mesi.id AND
			evento.Id_tipo_evento = 1
	WHERE IFNULL(evento.Data_mod, evento.Data_Ins) >= from_date; 

	
END //
DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiEventGetBetweenDates;
CREATE PROCEDURE sp_apiEventGetBetweenDates
(
	from_date DATETIME,
	to_date DATETIME
)
BEGIN
        
	SELECT Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		IFNULL(impianto_abbonamenti_mesi.impianto,  Evento.Id_riferimento) id_riferimento,
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione, 
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Stato_notifica, 
		Evento.Data_notifica, 
		Evento.Promemoria_inviato,
		Evento.Eliminato,
		Evento.Data_ins, 
		Evento.Data_mod,  
		evento_gruppo_evento.Id_gruppo_evento AS Id_gruppo,
		evento_gruppo.Id_impianto AS Id_impianto,
		evento_gruppo.Id_cliente AS Id_cliente
	FROM Evento
		LEFT JOIN evento_gruppo_evento
		ON evento_gruppo_evento.Id_evento = Evento.Id AND tipo_associazione = 1
		LEFT JOIN evento_gruppo
		ON evento_gruppo_evento.Id_gruppo_evento = Evento_gruppo.Id
		LEFT JOIN impianto_abbonamenti_mesi 
		ON evento.Id_riferimento = impianto_abbonamenti_mesi.id AND
			evento.Id_tipo_evento = 1
	WHERE TIMESTAMP(`Data_esecuzione`,`Ora_inizio_esecuzione`) BETWEEN from_date AND to_date; 
	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEventGetByNotifStatus;
CREATE PROCEDURE sp_apiEventGetByNotifStatus
(	notification_status SMALLINT )
BEGIN
    
	UPDATE evento 
	SET data_notifica = NULL 
	WHERE stato_notifica = 1 AND data_notifica IS NOT NULL; 
		
		
	SELECT Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		IFNULL(impianto_abbonamenti_mesi.impianto,  Evento.Id_riferimento) id_riferimento,
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione, 
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Stato_notifica, 
		Evento.Data_notifica, 
		Evento.Promemoria_inviato,
		Evento.Eliminato,
		Evento.Data_ins, 
		Evento.Data_mod,  
		evento_gruppo_evento.Id_gruppo_evento AS Id_gruppo,
		evento_gruppo.Id_impianto AS Id_impianto,
		evento_gruppo.Id_cliente AS Id_cliente
	FROM Evento
		LEFT JOIN evento_gruppo_evento
		ON evento_gruppo_evento.Id_evento = Evento.Id AND tipo_associazione = 1
		LEFT JOIN evento_gruppo
		ON evento_gruppo_evento.Id_gruppo_evento = Evento_gruppo.Id
		LEFT JOIN impianto_abbonamenti_mesi 
		ON evento.Id_riferimento = impianto_abbonamenti_mesi.id AND
			evento.Id_tipo_evento = 1
	WHERE evento.Stato_notifica = notification_status; 
		
END //
DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiEventTypeGet;
CREATE PROCEDURE sp_apiEventTypeGet
()
BEGIN   
	SELECT id_tipo, 
			nome,
			tipo_evento.Id_tipologia ,
			tipologia_tipo_evento.Rif_applicazione as "Rif_applicazione_tipologia"
	FROM Tipo_evento
		INNER JOIN tipologia_tipo_evento
		ON tipo_evento.Id_tipologia = tipologia_tipo_evento.Id;	
END //
DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiEventEmployeeGet;
CREATE PROCEDURE sp_apiEventEmployeeGet
()
BEGIN   
	SELECT Evento_operaio.Id, 
		Evento_operaio.Id_evento,
		Evento_operaio.id_operaio,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione
	FROM Evento_operaio
		INNER JOIN Evento 
		ON Evento_operaio.Id_evento = Evento.Id;

END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEventEmployeeGetFromDate;
CREATE PROCEDURE sp_apiEventEmployeeGetFromDate
(	from_date DATETIME )
BEGIN
        
	SELECT Evento_operaio.Id, 
		Evento_operaio.Id_evento,
		Evento_operaio.id_operaio,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione
	FROM Evento_operaio
		INNER JOIN Evento 
		ON Evento_operaio.Id_evento = Evento.Id
	WHERE IFNULL(Evento.Data_mod, Evento.Data_Ins) >= from_date;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEventEmployeeGetByNotifStatus;
CREATE PROCEDURE sp_apiEventEmployeeGetByNotifStatus
(	notification_status SMALLINT )
BEGIN
        
	SELECT Evento_operaio.Id, 
		Evento_operaio.Id_evento,
		Evento_operaio.id_operaio,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione
	FROM Evento_operaio
		INNER JOIN Evento 
		ON Evento_operaio.Id_evento = Evento.Id
	WHERE Evento.stato_notifica = notification_status; 
		
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationDaysToAvoidGet;
CREATE PROCEDURE sp_apiCustomerDestinationDaysToAvoidGet
()
BEGIN   
	SELECT id_destinazione,
		id_cliente, 
		id_giorno
	FROM destinazione_giorni; 	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiNotificationTypeGet;
CREATE PROCEDURE sp_apiNotificationTypeGet
()
BEGIN   
	SELECT id,
		descrizione, 
		id_traduzione,
		rif_applicazioni
	FROM tipo_notifica
	WHERE abilitato = 1; 	
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiEventSetNotificationStatus; 
DELIMITER $$

CREATE PROCEDURE sp_apiEventSetNotificationStatus(
IN idArray VARCHAR(1000),
IN notificationStatus TINYINT)
BEGIN

  SET @sql = CONCAT('UPDATE Evento 
  SET Stato_notifica = ', notificationStatus ,',
  Data_notifica = NOW()
  WHERE Id IN  (',idArray,'); ');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiEventSetReminderSent; 
DELIMITER $$

CREATE PROCEDURE sp_apiEventSetReminderSent(
IN idArray MEDIUMTEXT,
IN isReminderSent BIT)
BEGIN
  UPDATE Evento 
  SET Promemoria_inviato = isReminderSent
  WHERE FIND_IN_SET(Id, idArray);
END
$$

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_apiReportMobileTestInsert; 
CREATE PROCEDURE sp_apiReportMobileTestInsert  (
	`report_id`                       SMALLINT,
	`report_year`                       SMALLINT,
	`customer_id`                       INT,
	`system_id`                       INT,
	`address`                       VARCHAR(255),
	`telephone_number`                       VARCHAR(20),
	`fax_number`                       VARCHAR(20),
	`tax_fiscal_code`                       VARCHAR(20),
	`request_from`                       VARCHAR(30),
	`email`                       VARCHAR(35),
	`email_responsible`                       VARCHAR(35),
	`enter_date`                       DATETIME,
	`vehicle_description`                       VARCHAR(100),
	`ref_intervention_type`                       INT(11),
	`ref_system_type`                       INT(11),
	`company_name`                       VARCHAR(100),
	`system_type_and_model`                       VARCHAR(100),
	`system_status`                       VARCHAR(100),
	`enter_test_check_1`                       BIT,
	`enter_test_check_2`                       BIT,
	`enter_test_check_3`                       BIT,
	`enter_test_check_4`                       BIT,
	`enter_test_check_5`                       BIT,
	`enter_test_check_6`                       BIT,
	`enter_test_check_7`                       BIT,
	`enter_test_check_8`                       BIT,
	`enter_test_check_9`                       BIT,
	`enter_test_check_10`                       BIT,
	`enter_test_check_11`                       BIT,
	`enter_test_check_12`                       BIT,
	`enter_test_check_13`                       BIT,
	`enter_test_check_14`                       BIT,
	`enter_test_check_15`                       BIT,
	`enter_test_check_16`                       BIT,
	`enter_test_check_17`                       BIT,
	`enter_test_check_18`                       BIT,
	`enter_test_check_19`                       BIT,
	`enter_test_check_20`                       BIT,
	`enter_test_check_21`                       BIT,
	`enter_test_check_22`                       BIT,
	`enter_test_check_23`                       BIT,
	`enter_test_check_24`                       BIT,
	`enter_test_check_25`                       BIT,
	`enter_test_check_26`                       BIT,
	`enter_test_check_27`                       BIT,
	`enter_test_check_28`                       BIT,
	`enter_test_check_29`                       BIT,
	`enter_test_check_30`                       BIT,
	`enter_test_check_31`                       BIT,
	`enter_test_check_32`                       BIT,
	`enter_test_check_33`                       BIT,
	`enter_test_check_34`                       BIT,
	`enter_test_check_35`                       BIT,
	`enter_test_check_36`                       BIT,
	`enter_test_check_37`                       BIT,
	`enter_test_check_38`                       BIT,
	`enter_test_check_39`                       BIT,
	`enter_test_check_40`                       BIT,
	`enter_test_check_41`                       BIT,
	`enter_test_check_42`                       BIT,
	`enter_test_check_43`                       BIT,
	`enter_test_check_44`                       BIT,
	`enter_test_check_45`                       BIT,
	`enter_test_check_46_1`                       BIT,
	`enter_test_check_47_1`                       BIT,
	`enter_test_check_48_1`                       BIT,
	`enter_test_check_46_2`                       BIT,
	`enter_test_check_47_2`                       BIT,
	`enter_test_check_48_2`                       BIT,
	`enter_test_check_46_3`                       BIT,
	`enter_test_check_47_3`                       BIT,
	`enter_test_check_48_3`                       BIT,
	`test_amount_1`                       DECIMAL(11,2),
	`test_amount_2`                       DECIMAL(11,2),
	`test_amount_3`                       DECIMAL(11,2),
	`test_amount_4`                       DECIMAL(11,2),
	`test_amount_5`                       DECIMAL(11,2),
	`test_amount_6`                       DECIMAL(11,2),
	`test_amount_7`                       DECIMAL(11,2),
	`test_amount_8`                       DECIMAL(11,2),
	`test_amount_9`                       DECIMAL(11,2),
	`test_amount_10`                       DECIMAL(11,2),
	`test_amount_11`                       DECIMAL(11,2),
	`test_amount_12`                       DECIMAL(11,2),
	`test_amount_13`                       DECIMAL(11,2),
	`test_amount_14`                       DECIMAL(11,2),
	`test_amount_15`                       DECIMAL(11,2),
	`test_amount_16`                       DECIMAL(11,2),
	`test_amount_17`                       DECIMAL(11,2),
	`test_amount_18`                       DECIMAL(11,2),
	`test_amount_19`                       DECIMAL(11,2),
	`test_amount_20`                       DECIMAL(11,2),
	`test_amount_21`                       DECIMAL(11,2),
	`test_amount_22`                       DECIMAL(11,2),
	`test_amount_23`                       DECIMAL(11,2),
	`test_amount_24`                       DECIMAL(11,2),
	`test_amount_25`                       DECIMAL(11,2),
	`test_amount_26`                       DECIMAL(11,2),
	`test_amount_27`                       DECIMAL(11,2),
	`test_amount_28`                       DECIMAL(11,2),
	`test_amount_29`                       DECIMAL(11,2),
	`test_amount_30`                       DECIMAL(11,2),
	`test_amount_31`                       DECIMAL(11,2),
	`test_amount_32`                       DECIMAL(11,2),
	`test_amount_33`                       DECIMAL(11,2),
	`test_amount_34`                       DECIMAL(11,2),
	`test_amount_35`                       DECIMAL(11,2),
	`test_amount_36`                       DECIMAL(11,2),
	`test_amount_37`                       DECIMAL(11,2),
	`test_amount_38`                       DECIMAL(11,2),
	`test_amount_39`                       DECIMAL(11,2),
	`test_amount_40`                       DECIMAL(11,2),
	`test_amount_41`                       DECIMAL(11,2),
	`test_amount_42`                       DECIMAL(11,2),
	`test_amount_43`                       DECIMAL(11,2),
	`test_amount_44`                       DECIMAL(11,2),
	`test_amount_45`                       DECIMAL(11,2),
	`test_amount_46_1`                       DECIMAL(11,2),
	`test_amount_47_1`                       DECIMAL(11,2),
	`test_amount_48_1`                       DECIMAL(11,2),
	`test_amount_46_2`                       DECIMAL(11,2),
	`test_amount_47_2`                       DECIMAL(11,2),
	`test_amount_48_2`                       DECIMAL(11,2),
	`test_amount_46_3`                       DECIMAL(11,2),
	`test_amount_47_3`                       DECIMAL(11,2),
	`test_amount_48_3`                       DECIMAL(11,2),
	`notes`                       TEXT,
	`execution_date`                       DATE,
	`first_start_time`                       TIME,
	`first_end_time`                       TIME,
	`second_start_time`                       TIME,
	`second_end_time`                       TIME,
	`intervention_hours`                       VARCHAR(30),
	`trip_hours`                       DECIMAL(11,2),
	`total_hours`                       DECIMAL(11,2),
	`hourly_price`                       DECIMAL(11,2),
	`work_notes`                       VARCHAR(255),
	`trips_number`                       TINYINT,
	`trip_kms`                       SMALLINT,
	`total_kms`                       SMALLINT,
	`km_price`                       DECIMAL(11,2),
	`total_trips_price`                       DECIMAL(11,2),
	`total_hours_price`                       DECIMAL(11,2),
	`total_products_price`                       DECIMAL(11,2),
	`total_taxable_price`                       DECIMAL(11,2),
	`vat`                       DECIMAL(11,2),
	`total_price`                       DECIMAL(11,2),
	`insertion_user`                       SMALLINT,
	`insertion_employee`                       SMALLINT, 
	creation_timestamp DATETIME, 
	delivery_timestamp DATETIME,
	OUT Result INT
)
BEGIN

	
	IF(system_id>0) THEN 
	
		SELECT id_cliente
		INTO Result
		FROM Impianto 
		WHERE id_impianto = system_id; 

	
		IF(Result IS NULL) THEN 
			SET Result = -1; -- System not found
		ELSE
			IF(Result <> customer_id) THEN
				SET Result = -2;  -- not found link customer - system
			ELSE
				SET Result = 1; 
			END IF; 
		END IF; 
		
		
	ELSE
	
		SELECT id_cliente
		INTO Result
		FROM Clienti 
		WHERE Id_cliente = customer_id; 
		
		IF Result IS NULL THEN
			SET Result = -3; -- customer not found
		END IF;
		
	END IF; 
	
	IF Result IS NULL OR Result >= 0 THEN 
	
		SET Result = 1; 
			
		INSERT INTO rapporto_mobile_collaudo SET 
			`Id_rapporto`=`report_id`,
			`Anno`=`report_year`,
			`Id_cliente`=`customer_id`,
			`Id_impianto`=`system_id`,
			`Indirizzo`=`address`,
			`Telefono`=`telephone_number`,
			`Fax`=`fax_number`,
			`Partita_iva_cod_fisc`=`tax_fiscal_code`,
			`Richiedente_intervento`=`request_from`,
			`Email`=`email`,
			`Email_responsabile`=`email_responsible`,
			`Data`=`enter_date`,
			`Descrizione_veicolo`=`vehicle_description`,
			`Tipo_intervento`=`ref_intervention_type`,
			`Tipo_impianto`=`ref_system_type`,
			`Ragione_sociale`=`company_name`,
			`Tipo_modello_impianto`=`system_type_and_model`,
			`Stato_impianto`=`system_status`,
			`Test_check_1`=`enter_test_check_1`,
			`Test_check_2`=`enter_test_check_2`,
			`Test_check_3`=`enter_test_check_3`,
			`Test_check_4`=`enter_test_check_4`,
			`Test_check_5`=`enter_test_check_5`,
			`Test_check_6`=`enter_test_check_6`,
			`Test_check_7`=`enter_test_check_7`,
			`Test_check_8`=`enter_test_check_8`,
			`Test_check_9`=`enter_test_check_9`,
			`Test_check_10`=`enter_test_check_10`,
			`Test_check_11`=`enter_test_check_11`,
			`Test_check_12`=`enter_test_check_12`,
			`Test_check_13`=`enter_test_check_13`,
			`Test_check_14`=`enter_test_check_14`,
			`Test_check_15`=`enter_test_check_15`,
			`Test_check_16`=`enter_test_check_16`,
			`Test_check_17`=`enter_test_check_17`,
			`Test_check_18`=`enter_test_check_18`,
			`Test_check_19`=`enter_test_check_19`,
			`Test_check_20`=`enter_test_check_20`,
			`Test_check_21`=`enter_test_check_21`,
			`Test_check_22`=`enter_test_check_22`,
			`Test_check_23`=`enter_test_check_23`,
			`Test_check_24`=`enter_test_check_24`,
			`Test_check_25`=`enter_test_check_25`,
			`Test_check_26`=`enter_test_check_26`,
			`Test_check_27`=`enter_test_check_27`,
			`Test_check_28`=`enter_test_check_28`,
			`Test_check_29`=`enter_test_check_29`,
			`Test_check_30`=`enter_test_check_30`,
			`Test_check_31`=`enter_test_check_31`,
			`Test_check_32`=`enter_test_check_32`,
			`Test_check_33`=`enter_test_check_33`,
			`Test_check_34`=`enter_test_check_34`,
			`Test_check_35`=`enter_test_check_35`,
			`Test_check_36`=`enter_test_check_36`,
			`Test_check_37`=`enter_test_check_37`,
			`Test_check_38`=`enter_test_check_38`,
			`Test_check_39`=`enter_test_check_39`,
			`Test_check_40`=`enter_test_check_40`,
			`Test_check_41`=`enter_test_check_41`,
			`Test_check_42`=`enter_test_check_42`,
			`Test_check_43`=`enter_test_check_43`,
			`Test_check_44`=`enter_test_check_44`,
			`Test_check_45`=`enter_test_check_45`,
			`Test_check_46_1`=`enter_test_check_46_1`,
			`Test_check_47_1`=`enter_test_check_47_1`,
			`Test_check_48_1`=`enter_test_check_48_1`,
			`Test_check_46_2`=`enter_test_check_46_2`,
			`Test_check_47_2`=`enter_test_check_47_2`,
			`Test_check_48_2`=`enter_test_check_48_2`,
			`Test_check_46_3`=`enter_test_check_46_3`,
			`Test_check_47_3`=`enter_test_check_47_3`,
			`Test_check_48_3`=`enter_test_check_48_3`,
			`Test_quantita_1`=`test_amount_1`,
			`Test_quantita_2`=`test_amount_2`,
			`Test_quantita_3`=`test_amount_3`,
			`Test_quantita_4`=`test_amount_4`,
			`Test_quantita_5`=`test_amount_5`,
			`Test_quantita_6`=`test_amount_6`,
			`Test_quantita_7`=`test_amount_7`,
			`Test_quantita_8`=`test_amount_8`,
			`Test_quantita_9`=`test_amount_9`,
			`Test_quantita_10`=`test_amount_10`,
			`Test_quantita_11`=`test_amount_11`,
			`Test_quantita_12`=`test_amount_12`,
			`Test_quantita_13`=`test_amount_13`,
			`Test_quantita_14`=`test_amount_14`,
			`Test_quantita_15`=`test_amount_15`,
			`Test_quantita_16`=`test_amount_16`,
			`Test_quantita_17`=`test_amount_17`,
			`Test_quantita_18`=`test_amount_18`,
			`Test_quantita_19`=`test_amount_19`,
			`Test_quantita_20`=`test_amount_20`,
			`Test_quantita_21`=`test_amount_21`,
			`Test_quantita_22`=`test_amount_22`,
			`Test_quantita_23`=`test_amount_23`,
			`Test_quantita_24`=`test_amount_24`,
			`Test_quantita_25`=`test_amount_25`,
			`Test_quantita_26`=`test_amount_26`,
			`Test_quantita_27`=`test_amount_27`,
			`Test_quantita_28`=`test_amount_28`,
			`Test_quantita_29`=`test_amount_29`,
			`Test_quantita_30`=`test_amount_30`,
			`Test_quantita_31`=`test_amount_31`,
			`Test_quantita_32`=`test_amount_32`,
			`Test_quantita_33`=`test_amount_33`,
			`Test_quantita_34`=`test_amount_34`,
			`Test_quantita_35`=`test_amount_35`,
			`Test_quantita_36`=`test_amount_36`,
			`Test_quantita_37`=`test_amount_37`,
			`Test_quantita_38`=`test_amount_38`,
			`Test_quantita_39`=`test_amount_39`,
			`Test_quantita_40`=`test_amount_40`,
			`Test_quantita_41`=`test_amount_41`,
			`Test_quantita_42`=`test_amount_42`,
			`Test_quantita_43`=`test_amount_43`,
			`Test_quantita_44`=`test_amount_44`,
			`Test_quantita_45`=`test_amount_45`,
			`Test_quantita_46_1`=`test_amount_46_1`,
			`Test_quantita_47_1`=`test_amount_47_1`,
			`Test_quantita_48_1`=`test_amount_48_1`,
			`Test_quantita_46_2`=`test_amount_46_2`,
			`Test_quantita_47_2`=`test_amount_47_2`,
			`Test_quantita_48_2`=`test_amount_48_2`,
			`Test_quantita_46_3`=`test_amount_46_3`,
			`Test_quantita_47_3`=`test_amount_47_3`,
			`Test_quantita_48_3`=`test_amount_48_3`,
			`Note`=`notes`,
			`Data_intervento`=`execution_date`,
			`Ora_inizio_intervento_1`=`first_start_time`,
			`Ora_fine_intervento_1`=`first_end_time`,
			`Ora_inizio_intervento_2`=`second_start_time`,
			`Ora_fine_intervento_2`=`second_end_time`,
			`Ore_intervento`=`intervention_hours`,
			`Ore_Viaggio`=`trip_hours`,
			`Ore_totali`=`total_hours`,
			`Prezzo_ora`=`hourly_price`,
			`Note_viaggio`=`work_notes`,
			`Numero_viaggi`=`trips_number`,
			`Km_percorsi`=`trip_kms`,
			`Km_complessivi`=`total_kms`,
			`Prezzo_km`=`km_price`,
			`Totale_prezzo_viaggio`=`total_trips_price`,
			`Totale_prezzo_orario`=`total_hours_price`,
			`Totale_prezzo_materiale`=`total_products_price`,
			`Imponibile`=`total_taxable_price`,
			`Iva`=`vat`,
			`Totale_prezzo`=`total_price`,
			`Utente_inserimento`=`insertion_user`,
			`Operaio_inserimento`=`insertion_employee`, 
			timestamp_creazione = creation_timestamp,
			timestamp_invio = delivery_timestamp;
	END IF;
	 
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileTestCheckExistence; 
CREATE PROCEDURE sp_apiReportMobileTestCheckExistence 
(
	report_id INT, 
	report_year INT,
	OUT result BIT 
)
BEGIN
   	
	SELECT IFNULL(COUNT(id_rapporto),0)
	INTO
		result 
	FROM rapporto_mobile_collaudo 
	WHERE id_rapporto = report_id AND anno = report_year; 

END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileTestCancelInsertOperation; 
CREATE PROCEDURE sp_apiReportMobileTestCancelInsertOperation (
	report_id INT, 
	`report_year`                       INT
)
BEGIN	
	CALL sp_apiReportMobileTestDelete(report_id, `report_year`); 
	CALL sp_apiReportMobileInterventionTechnicianDelete(report_id, `report_year`); 
	CALL sp_apiReportMobileInterventionWorkDelete(report_id, `report_year`); 
	CALL sp_apiReportMobileInterventionSignatureDeleteByReport(report_id, `report_year`); 
	CALL sp_apiReportMobileRecipientDelete(id, `year`); 
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileTestDelete; 
CREATE PROCEDURE sp_apiReportMobileTestDelete 
(
	report_id INT, 
	`report_year`                       INT
)
BEGIN	
	DELETE 
	FROM rapporto_mobile_collaudo
	WHERE id_rapporto= report_id AND anno = `report_year`; 
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEmployeeShiftInsert; 
CREATE PROCEDURE sp_apiEmployeeShiftInsert 
(
	IN user_id INT,  
	IN employee_id INT,
	IN source_detection TINYINT, 
	IN timestamp_detection DATETIME, 
	IN latitude DECIMAL(11,8), 
	IN longitude DECIMAL(11,8),
	OUT result INT
)
BEGIN	
	DECLARE `_rollback`                       BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback`                       = 1;
	
	SELECT COUNT(Id_utente) 
		INTO result 
	FROM Utente
	Where Id_utente = user_id; 
	
	IF result = 0 THEN 
		SET result = -1; -- user not found	
	ELSE
		SELECT COUNT(Id_operaio) 
			INTO result 
		FROM Operaio
		Where Id_operaio = employee_id; 
		
		IF result = 0 THEN 
			SET result = -2; -- employee not found	
		END IF; 
	END IF; 
	
	IF result > 0 THEN
	
		INSERT INTO Operaio_spostamenti
		SET
			Id_utente = user_id, 
			Id_operaio = employee_id, 
			Data_rilevazione = timestamp_detection, 
			Sorgente_rilevazione = source_detection, 
			Latitudine = latitude, 
			Longitudine = longitude;
	
		SET result = 1; 
	
	END IF; 
	
	IF `_rollback`                       THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelGet;
CREATE PROCEDURE sp_apiChecklistModelGet
(	)
BEGIN
        
	SELECT Checklist_model.Id_check, 
		checklist_model.nome,
		checklist_model.descrizione, 
		checklist_model.note, 
		IFNULL(checklist_model.tipo_impianto, 0) tipo_impianto,
		checklist_model.Stato
	FROM Checklist_model;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelGetFromDate;
CREATE PROCEDURE sp_apiChecklistModelGetFromDate
(	from_date DATETIME )
BEGIN
        
	SELECT Checklist_model.Id_check, 
		checklist_model.nome,
		checklist_model.descrizione, 
		checklist_model.note, 
		IFNULL(checklist_model.tipo_impianto, 0) tipo_impianto,
		checklist_model.Stato
	FROM Checklist_model 
	WHERE IFNULL(Checklist_model.Data_mod, Checklist_model.Data_Ins) >= from_date;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelParagraphGet;
CREATE PROCEDURE sp_apiChecklistModelParagraphGet
(	)
BEGIN
        
	SELECT checklist_model_paragrafo.Id, 
		checklist_model_paragrafo.Id_checklist,
		checklist_model_paragrafo.nome,
		checklist_model_paragrafo.descrizione, 
		checklist_model_paragrafo.ordine
	FROM checklist_model_paragrafo;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelParagraphGetFromDate;
CREATE PROCEDURE sp_apiChecklistModelParagraphGetFromDate
(	from_date DATETIME )
BEGIN
        
	SELECT checklist_model_paragrafo.Id, 
			checklist_model_paragrafo.Id_checklist,
		checklist_model_paragrafo.nome,
		checklist_model_paragrafo.descrizione, 
		checklist_model_paragrafo.ordine
	FROM checklist_model_paragrafo 
	WHERE IFNULL(checklist_model_paragrafo.Data_mod, checklist_model_paragrafo.Data_Ins) >= from_date;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelSystemGet;
CREATE PROCEDURE sp_apiChecklistModelSystemGet
(	)
BEGIN
        
	SELECT checklist_model_impianto.Id_checklist,
		checklist_model_impianto.Id_impianto
	FROM checklist_model_impianto;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelSystemGetFromDate;
CREATE PROCEDURE sp_apiChecklistModelSystemGetFromDate
(	from_date DATETIME )
BEGIN
        
	SELECT checklist_model_impianto.Id_checklist,
		checklist_model_impianto.Id_impianto
	FROM checklist_model_impianto 
	WHERE checklist_model_impianto.Data_Ins >= from_date;
		
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelParagraphElementGet;
CREATE PROCEDURE sp_apiChecklistModelParagraphElementGet
(	)
BEGIN
        
	SELECT 
		checklist_model_elemento.Id as "id_elemento",
		checklist_model_elemento.Id_paragrafo,
		checklist_model_elemento.id_checklist, 
		checklist_model_elemento.Posizione,
		checklist_model_elemento.nome,
		IFNULL(checklist_model_elemento.descrizione, "") descrizione,
		checklist_model_elemento.indicazioni, 
		checklist_model_elemento.tipo_elemento
	FROM checklist_model_elemento;
		
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistModelParagraphElementGetFromDate;
CREATE PROCEDURE sp_apiChecklistModelParagraphElementGetFromDate
(	from_date DATETIME )
BEGIN
        
	SELECT 
		checklist_model_elemento.Id as "id_elemento",
		checklist_model_elemento.Id_paragrafo,
		checklist_model_elemento.id_checklist, 
		checklist_model_elemento.Posizione,
		checklist_model_elemento.nome,
		IFNULL(checklist_model_elemento.descrizione, "") descrizione,
		checklist_model_elemento.indicazioni, 
		checklist_model_elemento.tipo_elemento	
	FROM checklist_model_elemento
	WHERE IFNULL(checklist_model_elemento.Data_mod, checklist_model_elemento.Data_Ins) >= from_date;
		
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEmployeeShiftLastForEachEmployee;
CREATE PROCEDURE sp_apiEmployeeShiftLastForEachEmployee
()
BEGIN
	SELECT 
		Id,
		Id_operaio, 
		Id_utente, 
		Latitudine, 
		Longitudine, 
		Data_rilevazione, 
		Sorgente_rilevazione, 
		Data_ins		
	FROM 
		(SELECT 
			operaio_spostamenti.Id,
			operaio_spostamenti.Id_operaio, 
			operaio_spostamenti.Id_utente, 
			operaio_spostamenti.Latitudine, 
			operaio_spostamenti.Longitudine, 
			operaio_spostamenti.Data_rilevazione, 
			operaio_spostamenti.Sorgente_rilevazione, 
			operaio_spostamenti.Data_ins		
		FROM operaio_spostamenti
			INNER JOIN operaio ON operaio.Id_operaio = operaio_spostamenti.id_operaio
				AND operaio.Data_licenziamento IS NULL
		WHERE Latitudine > 0 and Longitudine > 0
		ORDER BY Data_rilevazione DESC) AS employee_shift
	GROUP BY Id_operaio;

END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEmployeeShiftGetByBymployee;
CREATE PROCEDURE sp_apiEmployeeShiftGetByBymployee
(
employee_id INT(11),
start_date DATETIME
)
BEGIN
	SELECT 
		Id,
		Id_operaio, 
		Id_utente, 
		Latitudine, 
		Longitudine, 
		Data_rilevazione, 
		Sorgente_rilevazione, 
		Data_ins		
	FROM  operaio_spostamenti 
	WHERE id_operaio = employee_id AND Data_ins >= start_date
	ORDER BY Data_rilevazione desc; 

END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSubscriptionGet;
CREATE PROCEDURE sp_apiSubscriptionGet
(
start_date DATETIME
)
BEGIN
	SELECT 
		Id_abbonamento,
		Anno, 
		Nome, 
		Descrizione, 
		Generale
	FROM  Abbonamento; 

END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiInvoicePaymentsGetByPaymentStatus;
CREATE PROCEDURE sp_apiInvoicePaymentsGetByPaymentStatus
(
	payment_status BIT(1)
)
BEGIN

	SELECT 
		
		fattura.id_fattura,
		fattura.anno, 
		fattura.id_cliente,
		
		ROUND(fattura.importo_totale/a.mesi - (
	SELECT IF(SUM(importo) IS NULL,0, SUM(importo))
	FROM fattura_acconto
	WHERE fattura_acconto.id_fattura=fattura.id_fattura AND fattura_acconto.anno=fattura.anno AND fattura_acconto.id_pagamento = DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d'))+((bollo+incasso+trasporto)*((22+100)/100))/a.mesi, 2) AS "importo_rata", 

			IFNULL(fattura_pagamenti.`data`, LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY) AS "data_pagamento", 
			IFNULL(fattura_pagamenti.id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY, '%Y%m%d')  AS UNSIGNED)) AS "id_pagamento", 
			a.nome AS "condizione_pagamento", 
			IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, tipopag_pagamento1.nome, tipopag_pagamento.nome) AS "tipo_pagamento", 
			IF(fattura_pagamenti.tipo_pagamento IS NOT NULL, tipopag_pagamento1.Id_tipo, tipopag_pagamento.Id_tipo) AS "id_tipo_pagamento", 
			fattura_pagamenti.insoluto
	FROM fattura
		INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione
		INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
		LEFT JOIN fattura_pagamenti ON fattura.id_fattura=fattura_pagamenti.id_fattura AND fattura_pagamenti.anno=fattura.anno AND fattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d')
		LEFT JOIN tipo_pagamento AS tipopag_pagamento ON a.tipo = tipopag_pagamento.id_tipo
		LEFT JOIN tipo_pagamento AS tipopag_pagamento1 ON fattura_pagamenti.tipo_pagamento = tipopag_pagamento1.id_tipo
	WHERE fattura_pagamenti.data IS NULL AND fattura.anno <> 0
	GROUP BY fattura.id_fattura, fattura.anno, Data_pagamento
	ORDER BY fattura.anno desc, fattura.id_fattura desc;
	

	
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemStatusGet;
CREATE PROCEDURE sp_apiSystemStatusGet
(
)
BEGIN
	SELECT 
		Id_stato,
		Nome, 
		Descrizione 
	FROM stato_impianto; 

END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemSubscriptionGet;
CREATE PROCEDURE sp_apiSystemSubscriptionGet
(
)
BEGIN
	SELECT *
	FROM 
		(
			SELECT impianto_abbonamenti.Id_impianto,
				impianto_abbonamenti.Id_abbonamenti Id_abbonamento, 
				impianto_abbonamenti.anno, 
				IFNULL(impianto_uscita.Importo_abbonamento, 0) Importo_abbonamento,
				IFNULL(Manutenzione, 0) Tempo_manutenzione, 
				IFNULL(Reperibilità, false) Reperibilita
			FROM impianto_abbonamenti
				LEFT JOIN impianto_uscita 
				ON impianto_abbonamenti.Id_impianto = impianto_uscita.Id_impianto
					AND impianto_abbonamenti.Id_abbonamenti = impianto_uscita.id_abbonamento
			ORDER BY anno DESC, id_impianto DESC
		) AS impianto_abbonamenti_ordinato
	GROUP BY Id_impianto;

END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemOperationGet;
CREATE PROCEDURE sp_apiSystemOperationGet
(
)
BEGIN

	SELECT 
		impianto_operazione.Id_impianto,
		impianto_operazione.Id_operazione, 
		operazioni_articoli.Nome, 
		impianto_operazione.Descrizione 
	FROM impianto_operazione
		INNER JOIN operazioni_articoli ON impianto_operazione.id_operazione = operazioni_articoli.Id_operazione;
	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemOperationInsert;
CREATE PROCEDURE sp_apiSystemOperationInsert
(
	IN system_id INT(11), 
	IN operation_id INT(11), 
	IN name VARCHAR(100), 
	IN description TEXT, 
	OUT result SMALLINT
)
BEGIN
	
	DECLARE operation_name VARCHAR(45);
	DECLARE has_already_operation BIT; 
	SET Result = 1;
	
	SELECT id_operazione, Nome
		INTO operation_id, operation_name
	FROM operazioni_articoli
	WHERE operazioni_articoli.nome = name; 
	
	if operation_name IS NULL THEN
		INSERT INTO operazioni_articoli (nome, descrizione) VALUES (name, description); 
		SELECT LAST_INSERT_ID() INTO operation_id;
	ELSE
	
		SELECT 
			COUNT(*) > 0 
		INTO 
			has_already_operation
		FROM impianto_operazione 
		WHERE id_operazione = operation_id AND id_impianto = system_id;
		
		IF has_already_operation THEN
			SET operation_name = CONCAT(operation_name, ' - ', UNIX_TIMESTAMP());
				
			INSERT INTO operazioni_articoli (nome, descrizione) VALUES (operation_name, description); 
			SELECT LAST_INSERT_ID() INTO operation_id;
		END IF;  
	
	END IF;
	
	INSERT INTO impianto_operazione (id_impianto, id_operazione, descrizione)
	VALUES (system_id, operation_id, description); 

	SELECT 
		impianto_operazione.Id_impianto,
		impianto_operazione.Id_operazione, 
		operazioni_articoli.Nome, 
		impianto_operazione.Descrizione 
	FROM impianto_operazione
		INNER JOIN operazioni_articoli ON impianto_operazione.id_operazione = operazioni_articoli.Id_operazione
	WHERE impianto_operazione.Id_impianto = system_id AND impianto_operazione.id_operazione = operation_id;
	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemPeriodicCheckGetNextBySystems;
CREATE PROCEDURE sp_apiSystemPeriodicCheckGetNextBySystems
(
	IN system_ids MEDIUMTEXT 
)
BEGIN

	SELECT * 
	FROM
	(
		SELECT impianto_abbonamenti_mesi.Id, 
			impianto AS Id_impianto, 
			mese,
			anno,
			abbonamenti AS Id_abbonamento, 
			da_eseguire, 
			eseguito_il, 
			prezzo,
			impianto_abbonamenti_mesi.id_stato_promemoria,
			stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
		FROM impianto_abbonamenti_mesi
			INNER JOIN stato_promemoria_cliente ON impianto_abbonamenti_mesi.id_stato_promemoria = stato_promemoria_cliente.id
		WHERE Eseguito_il IS NULL AND FIND_IN_SET(`impianto_abbonamenti_mesi`.`impianto`, system_ids)
		ORDER BY IFNULL(da_eseguire, LAST_DAY(STR_TO_DATE(CONCAT(Anno,'-', mese, '-', '01'), '%Y-%m-%d'))) ASC 
		
	) AS subquery
	GROUP BY Id_impianto;
	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemPeriodicCheckGetBetweenExpectedExecutionDates;
CREATE PROCEDURE sp_apiSystemPeriodicCheckGetBetweenExpectedExecutionDates
(
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT impianto_abbonamenti_mesi.Id, 
		impianto AS Id_impianto, 
		mese,
		anno,
		abbonamenti AS Id_abbonamento, 
		da_eseguire, 
		eseguito_il, 
		prezzo,
		impianto_abbonamenti_mesi.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_abbonamenti_mesi
		INNER JOIN stato_promemoria_cliente ON impianto_abbonamenti_mesi.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE da_eseguire BETWEEN from_date AND to_date
	ORDER BY da_eseguire;
END //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiSystemPeriodicCheckGetBetweenReminderDates;
CREATE PROCEDURE sp_apiSystemPeriodicCheckGetBetweenReminderDates
(
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT impianto_abbonamenti_mesi.Id, 
		impianto AS Id_impianto, 
		mese,
		anno,
		abbonamenti AS Id_abbonamento, 
		da_eseguire, 
		eseguito_il, 
		prezzo,
		impianto_abbonamenti_mesi.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_abbonamenti_mesi
		INNER JOIN stato_promemoria_cliente ON impianto_abbonamenti_mesi.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE data_promemoria BETWEEN from_date AND to_date
	ORDER BY data_promemoria;
END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEmployeeInsertLightContractor;
CREATE PROCEDURE sp_apiEmployeeInsertLightContractor
(
	IN company_name VARCHAR(50) ,
	IN insert_user_id SMALLINT, 
	OUT result INT
)
BEGIN

	INSERT INTO operaio
	SET 
		Ragione_sociale = company_name,
		d_nas= '1970-01-01',
		collaboratore = 1, 
		Tipo_operaio = 4,
		is_cassa = 0, 
		is_tecnico = 1,
		Data_ins = NOW(), 
		Utente_ins = insert_user_id;
		
	SELECT LAST_INSERT_ID() INTO result;
	
	SELECT id_operaio, 
		ragione_sociale, 
		mail_account 
	FROM  Operaio 
	WHERE Id_operaio = result;	

END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEmployeeGet;
CREATE PROCEDURE sp_apiEmployeeGet ()
BEGIN
	SELECT id_operaio, 
	ragione_sociale, 
	mail_account 
	FROM  Operaio 
	WHERE Data_licenziamento is null and Is_tecnico=1;	
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiEventSetPerformed;
CREATE PROCEDURE sp_apiEventSetPerformed (
	IN event_id INT(11)
)
BEGIN
	DECLARE group_id INT(11); 
	DECLARE events_number_open INT(11);
	DECLARE events_number_close INT(11);
	
	SELECT Id_gruppo_evento 
		INTO group_id
	FROM evento_gruppo_evento
	WHERE tipo_associazione = 1 AND id_evento = event_id;
	
	UPDATE evento
	SET Data_mod = NOW(), 
		Eseguito = 1 
	WHERE evento.id = event_id;
	
	SELECT COUNT(Eseguito)
		INTO events_number_open
	FROM evento
		INNER JOIN evento_gruppo_evento 	
		ON tipo_associazione = 1 AND Id_gruppo_evento = group_id AND Evento.Id = evento_gruppo_evento.id_evento
	WHERE Evento.Eseguito = 0;
	
	SELECT COUNT(Eseguito)
		INTO events_number_close
	FROM evento
		INNER JOIN evento_gruppo_evento 	
		ON tipo_associazione = 1 AND Id_gruppo_evento = group_id AND Evento.Id = evento_gruppo_evento.id_evento
	WHERE Evento.Eseguito = 1;
	
	
	
	IF events_number_open = 0 then
		UPDATE evento_gruppo
		SET Data_mod = NOW(), 
			Id_stato = 3 
		WHERE id = group_id;
	ELSE
		IF events_number_close = 0 then
			UPDATE evento_gruppo
			SET Data_mod = NOW(), 
				Id_stato = 1 
			WHERE id = group_id;
		ELSE 
			UPDATE evento_gruppo
			SET Data_mod = NOW(), 
				Id_stato = 2
			WHERE id = group_id;
		END IF;
	END IF;
	
END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportMobileEventInsert;
CREATE PROCEDURE sp_apiReportMobileEventInsert
(
	IN report_id INT(11) ,
	IN report_year INT(11) ,
	IN event_id INT(11) 
)
BEGIN

	INSERT INTO rapporto_mobile_evento
	SET 
		Id_rapporto = report_id,
		anno = report_year,
		Id_evento = event_id;
		

	CALL sp_apiEventSetPerformed(event_id);

END //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiTabletConfigurationGetLastInsert; 
CREATE PROCEDURE sp_apiTabletConfigurationGetLastInsert
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
		messaggio_non_abbonato,
		email_ufficio,
		admin_password,
		IFNULL(Data_ins, Data_Mod) AS Data_ins,
		Data_Mod
	FROM tablet_configurazione ORDER BY id_tablet DESC LIMIT 1; 
				
END; //
DELIMITER ;


-- Report daily

DROP PROCEDURE IF EXISTS `sp_apiReportDailyInsert`;

DELIMITER //

CREATE PROCEDURE `sp_apiReportDailyInsert`(
	`employee_id`                       INT(11),
	`report_date`                       DATE,
	`user_id`                       MEDIUMINT(9),
	OUT `result`                       INT)
MainLabel:BEGIN

	SET result = 1;
	
	SELECT COUNT(Id_operaio) 
		INTO result
	FROM Operaio
	WHERE Id_operaio = employee_id; 
	
	IF result = 0 THEN
		SET result = -1; -- employee not found
		LEAVE MainLabel; 
	END IF;  
	
	SELECT COUNT(id_utente) 
		INTO result
	FROM Utente
	WHERE utente.Id_utente = user_id;
	
	IF result = 0 THEN 
		SET result = -2; -- user not found
		LEAVE MainLabel; 
	END IF;

	IF result = 1 THEN
	
		INSERT INTO rapporto_giornaliero 
		SET 
			Id_operaio = employee_id,  
			data_rapporto = report_date,
			data_ins = NOW(), 
			utente_ins = user_id;
			
		SELECT LAST_INSERT_ID() INTO result; 
			
	END IF; 
	
END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS `sp_apiReportDailyDelete`;
DELIMITER //
CREATE PROCEDURE sp_apiReportDailyDelete(
	`report_daily_id`                       INT(11))
BEGIN	

	CALL sp_apiReportDailyActivityDeleteByReportDaily(report_daily_id);

	DELETE FROM rapporto_giornaliero  
	WHERE rapporto_giornaliero.Id = report_daily_id;
		
END
//
DELIMITER ; 



DROP PROCEDURE IF EXISTS `sp_apiReportDailyActivityInsert`;

DELIMITER //

CREATE PROCEDURE `sp_apiReportDailyActivityInsert`(
	`report_daily_id`                       INT(11),
	`work_type`                       INT(11),
	`work_description`                       VARCHAR(200),
	`start_time`                       TIME,
	`end_time`                       TIME,
	`notes`                       TEXT,
	`user_id`                       MEDIUMINT(9),
	OUT `result`                       INT)
MainLabel:BEGIN

	SET result = 1;
	
	SELECT COUNT(report_daily_id) 
		INTO result
	FROM rapporto_giornaliero
	WHERE rapporto_giornaliero.Id = report_daily_id; 
	
	IF result = 0 THEN
		SET result = -1; -- report daily not found
		LEAVE MainLabel; 
	END IF;  
	
	SELECT COUNT(id_utente) 
		INTO result
	FROM Utente
	WHERE utente.Id_utente = user_id;
	
	IF result = 0 THEN 
		SET result = -2; -- user not found
		LEAVE MainLabel; 
	END IF;

	IF result = 1 THEN
	
		INSERT INTO rapporto_giornaliero_attivita 
		SET 
			`Id_rapporto_giornaliero`                       = report_daily_id,
			`tipo_lavoro`= work_type,
			`descrizione_lavoro`                       = work_description,
			`ora_inizio`                       = start_time,
			`ora_fine`                       = end_time,
			`note`                       = notes,
			data_ins = NOW(), 
			utente_ins = user_id;
			
		SELECT LAST_INSERT_ID() INTO result; 
			
	END IF; 
	
END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS `sp_apiReportDailyActivityDeleteByReportDaily`;
DELIMITER //
CREATE PROCEDURE sp_apiReportDailyActivityDeleteByReportDaily(
	`report_daily_id`                       INT(11))
BEGIN

	CALL sp_apiReportDailyActivityReportDeleteByReportDaily(report_daily_id);
	CALL sp_apiReportDailyActivityPositionDeleteByReportDaily(report_daily_id);

	DELETE FROM rapporto_giornaliero_attivita  
	WHERE Id_rapporto_giornaliero = report_daily_id;
		
END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS `sp_apiReportDailyActivityReportDeleteByReportDaily`;
DELIMITER //
CREATE PROCEDURE sp_apiReportDailyActivityReportDeleteByReportDaily(
	`report_daily_id`                       INT(11))
BEGIN	

	DELETE FROM rapporto_giornaliero_attivita_rapporto  
	WHERE Id_rapporto_giornaliero = report_daily_id;
		
END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS `sp_apiReportDailyActivityPositionDeleteByReportDaily`;
DELIMITER //
CREATE PROCEDURE sp_apiReportDailyActivityPositionDeleteByReportDaily(
	`report_daily_id`                       INT(11))
BEGIN	

	DELETE FROM rapporto_giornaliero_attivita_posizione 
	WHERE Id_rapporto_giornaliero = report_daily_id;
		
END
//
DELIMITER ; 


DROP PROCEDURE IF EXISTS `sp_apiReportDailyActivityTypeGet`;
DELIMITER //
CREATE PROCEDURE sp_apiReportDailyActivityTypeGet()
BEGIN	

	SELECT Id, 
		Nome 
	FROM rapporto_giornaliero_tipo_attivita;
		
END
//
DELIMITER ; 







-- ************************** CHECKLIST *********************************************************************

DROP PROCEDURE IF EXISTS sp_apiChecklistInsert;
DELIMITER //
CREATE PROCEDURE sp_apiChecklistInsert 
(
	mobile_id INT(11),
	execution_date DATE,
	model_id INT(11),
	employee_id INT(11),
	customer_id INT(11),
	responsable_id INT(11),
	responsable VARCHAR(150),
	system_id INT(11),
	company_name VARCHAR(150),
	address VARCHAR(150),
	city VARCHAR(150),
	system_installation_place VARCHAR(150),
	system_central VARCHAR(150),
	system_installation_date DATE,
	system_department VARCHAR(150),
	creation_timestamp DATETIME,
	user_id INT(11), 
	others TEXT, 
	notes TEXT, 
	visit_number TINYINT, 
	periodic_check TINYINT, 
	responsable_job VARCHAR(150),
	OUT result INT(11)
)
MainLabel:BEGIN


	SET Result = 1; 
	
	IF Result 
	THEN

		INSERT INTO checklist
		SET 
			`id_mobile`                       = mobile_id,
			`data_esecuzione`                       = execution_date,
			`id_checklist_model`                       = model_id,
			`id_operaio`                       = employee_id,
			`id_cliente`                       = customer_id,
			`id_responsabile`                       = responsable_id,
			`id_impianto`                       =  system_id,
			responsabile = responsable,
			`ragione_sociale`                       = company_name,
			`indirizzo`                       = address,
			`citta`                       = city,
			`impianto_luogo_installazione`                       = system_installation_place,
			`impianto_centrale`                       = system_central, 
			`impianto_data_installazione`                       = system_installation_date,
			`impianto_dipartimento`                       = system_department, 
			`timestamp_creazione`                       = creation_timestamp, 
			altro = others, 
			appunti = notes, 
			responsabile_lavoro = responsable_job, 
			numero_visita = visit_number, 
			controllo_periodico = periodic_check,
			`utente_ins`                       = user_id,
			`utente_mod`                       = user_id,
			`data_ins`                       = NOW(),
			`data_mod`                       = NOW();

		SET result = LAST_INSERT_ID();
	END IF;  
			
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiChecklistUpdate;
DELIMITER //
CREATE PROCEDURE sp_apiChecklistUpdate
(
	enter_id INT(11),
	customer_id INT(11),
	responsable_id INT(11),
	responsable VARCHAR(150),
	system_id INT(11),
	company_name VARCHAR(150),
	address VARCHAR(150),
	city VARCHAR(150),
	system_installation_place VARCHAR(150),
	system_central VARCHAR(150),
	system_installation_date DATE,
	system_department VARCHAR(150),
	user_id INT(11), 
	others TEXT,
	visit_number TINYINT, 
	periodic_check TINYINT, 
	responsable_job VARCHAR(150),
	OUT result INT(11)
)
MainLabel:BEGIN


	SET Result = 1; 
	
	IF Result 
	THEN

		UPDATE checklist
		SET 
			`id_cliente`                       = customer_id,
			`id_responsabile`                       = responsable_id,
			`id_impianto`                       =  system_id,
			responsabile = responsable,
			`ragione_sociale`                       = company_name,
			`indirizzo`                       = address,
			`citta`                       = city,
			`impianto_luogo_installazione`                       = system_installation_place,
			`impianto_centrale`                       = system_central, 
			`impianto_data_installazione`                       = system_installation_date,
			`impianto_dipartimento`                       = system_department, 
			altro = others,
			responsabile_lavoro = responsable_job, 
			numero_visita = visit_number, 
			controllo_periodico = periodic_check,
			`utente_mod`                       = user_id,
			`data_mod`                       = NOW(),
			stampata = 0
		WHERE Id = enter_id;

		SET result = 1;
	END IF;  
			
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiChecklistSaveSignaturesRefs;
DELIMITER //
CREATE PROCEDURE sp_apiChecklistSaveSignaturesRefs
(
	checklist_id INT(11),
	customer_filename VARCHAR(50), 
	technician_filename VARCHAR(50)
)
BEGIN

	UPDATE checklist 
	SET 
		`filename_firma_cliente`                       = customer_filename,
		`filename_firma_tecnico`                       = technician_filename
	WHERE Id = checklist_id; 
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiChecklistDelete;
DELIMITER $$
CREATE PROCEDURE `sp_apiChecklistDelete`(
	enter_id INT(11),
	OUT result  TINYINT
)
BEGIN

	SET result = 0; 
	
	CALL sp_apiChecklistParagraphDeleteByChecklist(enter_id, result);
	CALL sp_apiChecklistEmployeeDeleteByChecklist(enter_id, result);
	CALL sp_apiChecklistReportDeleteByChecklist(enter_id, result);

	DELETE FROM checklist 
	WHERE id = enter_id;

	SET result = 1; 
				
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiChecklistParagraphInsert;
DELIMITER //
CREATE PROCEDURE sp_apiChecklistParagraphInsert 
(
	`checklist_id`                       INT(11),
	`paragraph_model_id`                       INT(11),
	`name`                       VARCHAR(150),
	`description`                       TEXT,
	`my_order`                       INT(11),
	user_id INT(11), 
	OUT result INT(11)
)
MainLabel:BEGIN


	SET Result = 1; 
	
	IF Result 
	THEN

		INSERT INTO checklist_paragrafo
		SET 
			id_checklist = checklist_id,
			id_checklist_model_paragrafo = paragraph_model_id,
			nome = name,
			descrizione = description,
			ordine = my_order,
			utente_mod= user_id,
			data_mod = NOW();

		SET result = LAST_INSERT_ID();
	END IF;  
			
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiChecklistParagraphDeleteByChecklist;
DELIMITER $$
CREATE PROCEDURE `sp_apiChecklistParagraphDeleteByChecklist`(
	enter_id INT(11),
	OUT result  TINYINT
)
BEGIN

	SET result = 0; 
	
	CALL sp_apiChecklistParagraphRowDeleteByChecklist(enter_id, result);

	DELETE FROM checklist_paragrafo 
	WHERE id_checklist = enter_id;

	SET result = 1; 
				
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiChecklistParagraphRowDeleteByChecklist;
DELIMITER $$
CREATE PROCEDURE `sp_apiChecklistParagraphRowDeleteByChecklist`(
	enter_id INT(11),
	OUT result  TINYINT
)
BEGIN

	SET result = 0; 
	
	DELETE FROM checklist_paragrafo_riga
	WHERE id_checklist = enter_id;

	SET result = 1; 
				
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiChecklistReportDeleteByChecklist;
DELIMITER $$
CREATE PROCEDURE `sp_apiChecklistReportDeleteByChecklist`(
	enter_id INT(11),
	OUT result  TINYINT
)
BEGIN

	SET result = 0; 
	
	DELETE FROM checklist_rapporto
	WHERE id_checklist = enter_id;

	SET result = 1; 
				
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiChecklistEmployeeDeleteByChecklist;
DELIMITER $$
CREATE PROCEDURE `sp_apiChecklistEmployeeDeleteByChecklist`(
	enter_id INT(11),
	OUT result  TINYINT
)
BEGIN

	SET result = 0; 
	
	DELETE FROM checklist_tecnico
	WHERE id_checklist = enter_id;

	SET result = 1; 
				
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiWarehouseProductGetBy;
DELIMITER //
CREATE PROCEDURE sp_apiWarehouseProductGetBy (
	IN product_code VARCHAR(11), 
	IN warehouse_id INT(11)
)
BEGIN
	SELECT p1.* 
	FROM (
		SELECT IF(magazzino.tipo_magazzino = tipo_magazzino.id_tipo, Id, -1) Id, 
			Id_articolo, 
			tipo_magazzino.id_tipo as tipo_magazzino, 
			tipo_magazzino.nome,
			IF(magazzino.tipo_magazzino = tipo_magazzino.id_tipo, Giacenza, 0.00) Giacenza,		
			Data_ins, 
			Utente_ins, 
			tipo_magazzino.prior
		 FROM magazzino,tipo_magazzino 
		 WHERE (IF(product_code IS NULL, True, Id_articolo) = IFNULL(product_code, True))
			AND (IF(warehouse_id IS NULL, True, tipo_magazzino.id_tipo) = IFNULL(warehouse_id, True))
			AND tipo_magazzino.disabilitato = 0
		 ORDER BY Id DESC
	) AS p1
	GROUP BY id_articolo, tipo_magazzino
	ORDER BY Id_articolo, prior;


END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiWarehouseOperationGetById;
DELIMITER //
CREATE PROCEDURE sp_apiWarehouseOperationGetById (
	IN operation_id INT(11)
)
BEGIN	
	SELECT Id_operazione, 
		Articolo, 
		Id_magazzino,
		causale,
		causale_magazzino.Nome,
		Quantità as Quantita,		
		Data
	 FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale_magazzino.Id_causale = causale
	 WHERE Id_operazione = operation_id;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiWarehouseOperationInsert;
DELIMITER //
CREATE PROCEDURE sp_apiWarehouseOperationInsert (
	IN product_code VARCHAR(11),
	IN warehouse_id INT(11),
	IN quantity FLOAT(11,2),
	IN operation_date DATE,
	IN causal_id INT(11), 
	IN user_id INT(11),
	OUT operation_id BIGINT(11)
)
BEGIN	
	SET @USER_ID = user_id;

	IF causal_id IS NULL THEN 
		SELECT id_causale 
			INTO causal_id
		FROM causale_magazzino
		WHERE Operazione = IF(quantity >= 0, 1, 2) AND tipo_magazzino = warehouse_id;
	END IF;
	
	IF quantity < 0 THEN
		SET quantity = quantity * -1; 
	END IF;
	
	CALL sp_ariesDepotOperationsInsert(
		quantity,
		product_code,
		warehouse_id,
		operation_date,
		5,
		causal_id,
		operation_id
	); 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSupplierGetById;
DELIMITER //
CREATE PROCEDURE sp_apiSupplierGetById (
	IN supplier_id INT(11)
)
BEGIN
	SELECT 
		`Id_fornitore`,
		`Ragione_Sociale`,
		`Ragione_Sociale2`,
		`Partita_iva`,
		`Codice_Fiscale`,
		`Data_inserimento`,
		stato_fornitore.id_stato, 
		stato_fornitore.nome AS 'Stato', 
		stato_economico.id_stato AS 'Id_stato_economico',
		stato_economico.nome, 
		condizione_pagamento.id_condizione,
		condizione_pagamento.nome as condizione_pagamento,
		`Sito_internet`,
		`password`,
		`Utente_sito`,
		tipo_iva.Id_iva,
		tipo_iva.nome as 'iva',
		tipo_fornitore.Id_tipo AS 'Id_tipo_fornitore',
		tipo_fornitore.nome as 'Tipo_fornitore',
		`modi`,
		`id_tiporapp`,
		Fornitore.`id_utente`,
		`costruttore`,
		`id_attività`                       as 'id_attivita',
		tipo_attivita.nome AS 'attivita',
		`cod_fornitore`
	FROM fornitore 
		INNER JOIN stato_fornitore ON stato_fornitore.id_stato = fornitore.stato_fornitore
		LEFT JOIN tipo_attivita ON tipo_attivita.id_tipo = fornitore.id_attività
		LEFT JOIN stato_economico ON stato_economico.id_stato = fornitore.stato_economico
		LEFT JOIN condizione_pagamento ON condizione_pagamento.id_condizione = fornitore.condizione_pagamento
		LEFT JOIN tipo_iva ON tipo_iva.Id_iva = fornitore.iva
		LEFT JOIN tipo_fornitore ON tipo_fornitore.Id_tipo = fornitore.tipo_fornitore
	WHERE fornitore.id_fornitore = supplier_id;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSupplierContactGetBySupplier;
DELIMITER //
CREATE PROCEDURE sp_apiSupplierContactGetBySupplier (
	IN supplier_id INT(11)
)
BEGIN
	SELECT 
		`Id_fornitore`,
		Id_pubblico,
		`Id_riferimento`,
		`Nome`,
		`figura`,
		`Telefono`,
		`altro_telefono`,
		`telefono2`,
		`fax`,
		`mail`,
		`centralino`,
		`fatturazione`,
		`nota`,
		`titolo`,
		`esterno`,
		`sito`,
		`skype`,
		`rif_esterno`,
		`sito_utente`,
		`sito_passwd`,
		`mail_pec`
	FROM riferimento_fornitore 
	WHERE riferimento_fornitore.id_fornitore = supplier_id;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSupplierDestinationGetBySupplier;
DELIMITER //
CREATE PROCEDURE sp_apiSupplierDestinationGetBySupplier (
	IN supplier_id INT(11)
)
BEGIN
	SELECT 
		`id_fornitore`,
		`Id_destinazione`,
		comune.Id_provincia,
		comune.Provincia,
		comune.id_comune,
		comune.nome AS 'bomune',
		comune.cap AS 'cap',
		Frazione.Id_frazione,
		Frazione.nome AS 'frazione',
		`Indirizzo`,
		`numero_civico`,
		`Descrizione`,
		`scala`,
		`Altro`,
		`attivo`,
		`Note`,
		`Sede_principale`,
		`piano`,
		`interno`,
		`fcap`,
		`id_autostrada`
	FROM destinazione_fornitore 
		LEFT JOIN comune ON comune.id_comune = destinazione_fornitore.comune
		LEFT JOIN frazione ON frazione.id_frazione = destinazione_fornitore.Frazione
	WHERE destinazione_fornitore.id_fornitore = supplier_id;
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiSystemProductGetExpiring;
DELIMITER //
CREATE PROCEDURE sp_apiSystemProductGetExpiring (
)
BEGIN

	DECLARE start_date DATE; 
	DECLARE end_date DATE; 
		
	DECLARE months_number SMALLINT;
	SELECT IFNULL(Numero_mesi, 1) INTO months_number 
	FROM servizio_alert_configurazione 
	WHERE Id = 1;


	SET start_date = CAST(DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 MONTH),'%Y-%m-01') AS DATE);
	SET end_date = LAST_DAY(DATE_ADD(NOW(), INTERVAL months_number MONTH));

	SELECT Id_impianto, 
		Id_articolo, 
		Data_scadenza, 
		Data_installazione, 
		impianto_componenti.Id AS Posizione, 
		Data_dismesso, 
		BOX,
		impianto_componenti.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_componenti
		INNER JOIN stato_promemoria_cliente ON impianto_componenti.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE (data_scadenza < end_date)
	ORDER BY data_scadenza DESC;

END; //
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_apiSystemProductGetMobileSync;
DELIMITER //
CREATE PROCEDURE sp_apiSystemProductGetMobileSync(
)
BEGIN
	SELECT Id_impianto, 
		Id_articolo,
		Data_scadenza, 
		Data_installazione, 
		impianto_componenti.Id AS Posizione, 
		Data_dismesso, 
		COUNT(*) AS quantita,
		BOX,
		impianto_componenti.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_componenti
		INNER JOIN stato_promemoria_cliente ON impianto_componenti.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE data_dismesso IS NULL
	GROUP BY id_impianto, id_articolo, Data_scadenza;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiConfigurationPathGetByKey;
DELIMITER //
CREATE PROCEDURE sp_apiConfigurationPathGetByKey (
	IN path_key VARCHAR(50)
)
BEGIN
	SELECT Tipo_percorso, 
		Percorso
	FROM configurazione_percorsi
	WHERE Tipo_percorso = path_key;

END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemSImTopUpGetToNotify;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSImTopUpGetToNotify (
)
BEGIN

	DECLARE end_date DATE; 
	
	DECLARE months_number SMALLINT;
	SELECT IFNULL(Numero_mesi, 1) INTO months_number 
	FROM servizio_alert_configurazione 
	WHERE Id = 2;
	
	SET end_date = LAST_DAY(DATE_ADD(NOW(), INTERVAL months_number MONTH));

	SELECT impianto_ricarica_tipo.id,
		impianto_ricarica_tipo.Id_impianto, 
		impianto_ricarica_tipo.Tipo_ricarica, 
		Tipo_ricarica.Nome AS 'nome_tipo_ricarica', 
		impianto_ricarica_tipo.`nota`,
		impianto_ricarica_tipo.`importo`,
		impianto_ricarica_tipo.`durata`,
		impianto_ricarica_tipo.`numero`,
		impianto_ricarica_tipo.`intestatario`,
		impianto_ricarica_tipo.`acarico`,
		impianto_ricarica_tipo.`data_attivazione`,
		impianto_ricarica_tipo.`data_rinnovo`,
		impianto_ricarica_tipo.`data_scadenza`,
		impianto_ricarica_tipo.`data_ultimo_promemoria`,
		impianto_ricarica_tipo.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_ricarica_tipo
		INNER JOIN stato_promemoria_cliente ON impianto_ricarica_tipo.id_stato_promemoria = stato_promemoria_cliente.id
		INNER JOIN Tipo_ricarica ON Tipo_ricarica.Id_tipo = impianto_ricarica_tipo.Tipo_ricarica
	WHERE (data_scadenza < end_date) 
		OR (data_rinnovo < end_date) 
		OR (data_scadenza IS NULL AND data_rinnovo IS NULL)
	ORDER BY data_scadenza DESC, data_rinnovo DESC;

END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpGetBetweenExpirationDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSimTopUpGetBetweenExpirationDates (
	from_date DATE,
	to_date DATE
)
BEGIN

	SELECT impianto_ricarica_tipo.id,
		impianto_ricarica_tipo.Id_impianto, 
		impianto_ricarica_tipo.Tipo_ricarica, 
		Tipo_ricarica.Nome AS 'nome_tipo_ricarica', 
		impianto_ricarica_tipo.`nota`,
		impianto_ricarica_tipo.`importo`,
		impianto_ricarica_tipo.`durata`,
		impianto_ricarica_tipo.`numero`,
		impianto_ricarica_tipo.`intestatario`,
		impianto_ricarica_tipo.`acarico`,
		impianto_ricarica_tipo.`data_attivazione`,
		impianto_ricarica_tipo.`data_rinnovo`,
		impianto_ricarica_tipo.`data_scadenza`,
		impianto_ricarica_tipo.`data_ultimo_promemoria`,
		impianto_ricarica_tipo.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_ricarica_tipo
		INNER JOIN stato_promemoria_cliente ON impianto_ricarica_tipo.id_stato_promemoria = stato_promemoria_cliente.id
		INNER JOIN Tipo_ricarica ON Tipo_ricarica.Id_tipo = impianto_ricarica_tipo.Tipo_ricarica
	WHERE data_scadenza BETWEEN from_date AND to_date; 
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpGetBetweenRenewDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSimTopUpGetBetweenRenewDates (
	from_date DATE,
	to_date DATE
)
BEGIN

	SELECT impianto_ricarica_tipo.id,
		impianto_ricarica_tipo.Id_impianto, 
		impianto_ricarica_tipo.Tipo_ricarica, 
		Tipo_ricarica.Nome AS 'nome_tipo_ricarica', 
		impianto_ricarica_tipo.`nota`,
		impianto_ricarica_tipo.`importo`,
		impianto_ricarica_tipo.`durata`,
		impianto_ricarica_tipo.`numero`,
		impianto_ricarica_tipo.`intestatario`,
		impianto_ricarica_tipo.`acarico`,
		impianto_ricarica_tipo.`data_attivazione`,
		impianto_ricarica_tipo.`data_rinnovo`,
		impianto_ricarica_tipo.`data_scadenza`,
		impianto_ricarica_tipo.`data_ultimo_promemoria`,
		impianto_ricarica_tipo.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_ricarica_tipo
		INNER JOIN stato_promemoria_cliente ON impianto_ricarica_tipo.id_stato_promemoria = stato_promemoria_cliente.id
		INNER JOIN Tipo_ricarica ON Tipo_ricarica.Id_tipo = impianto_ricarica_tipo.Tipo_ricarica
	WHERE data_rinnovo BETWEEN from_date AND to_date; 
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpGetBetweenReminderDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSimTopUpGetBetweenReminderDates (
	from_date DATE,
	to_date DATE
)
BEGIN

	SELECT impianto_ricarica_tipo.id,
		impianto_ricarica_tipo.Id_impianto, 
		impianto_ricarica_tipo.Tipo_ricarica, 
		Tipo_ricarica.Nome AS 'nome_tipo_ricarica', 
		impianto_ricarica_tipo.`nota`,
		impianto_ricarica_tipo.`importo`,
		impianto_ricarica_tipo.`durata`,
		impianto_ricarica_tipo.`numero`,
		impianto_ricarica_tipo.`intestatario`,
		impianto_ricarica_tipo.`acarico`,
		impianto_ricarica_tipo.`data_attivazione`,
		impianto_ricarica_tipo.`data_rinnovo`,
		impianto_ricarica_tipo.`data_scadenza`,
		impianto_ricarica_tipo.`data_ultimo_promemoria`, 
		impianto_ricarica_tipo.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_ricarica_tipo
		INNER JOIN stato_promemoria_cliente ON impianto_ricarica_tipo.id_stato_promemoria = stato_promemoria_cliente.id
		INNER JOIN Tipo_ricarica ON Tipo_ricarica.Id_tipo = impianto_ricarica_tipo.Tipo_ricarica
	WHERE data_promemoria BETWEEN from_date AND to_date; 
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemProductGet;
DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpGet;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSimTopUpGet (
)
BEGIN
	SELECT impianto_ricarica_tipo.id,
		impianto_ricarica_tipo.Id_impianto, 
		impianto_ricarica_tipo.Tipo_ricarica, 
		Tipo_ricarica.Nome AS 'nome_tipo_ricarica', 
		impianto_ricarica_tipo.`nota`,
		impianto_ricarica_tipo.`importo`,
		impianto_ricarica_tipo.`durata`,
		impianto_ricarica_tipo.`numero`,
		impianto_ricarica_tipo.`intestatario`,
		impianto_ricarica_tipo.`acarico`,
		impianto_ricarica_tipo.`data_attivazione`,
		impianto_ricarica_tipo.`data_rinnovo`,
		impianto_ricarica_tipo.`data_scadenza`,
		impianto_ricarica_tipo.`data_ultimo_promemoria`,
		impianto_ricarica_tipo.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_ricarica_tipo
		INNER JOIN stato_promemoria_cliente ON impianto_ricarica_tipo.id_stato_promemoria = stato_promemoria_cliente.id
		INNER JOIN Tipo_ricarica ON Tipo_ricarica.Id_tipo = impianto_ricarica_tipo.Tipo_ricarica;

END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpdateRequireReminder; 
DROP PROCEDURE IF EXISTS sp_apiSystemSimTopUpdateReminderStatus; 
DELIMITER $$

CREATE PROCEDURE sp_apiSystemSimTopUpdateReminderStatus(
IN id_array MEDIUMTEXT,
IN status_ref VARCHAR(50))
BEGIN
	DECLARE new_status_id INT;

	SELECT id
	INTO new_status_id
	FROM stato_promemoria_cliente
	WHERE rif_applicazioni = status_ref;

	UPDATE impianto_ricarica_tipo 
	SET id_stato_promemoria = new_status_id,
		data_ultimo_promemoria = NOW()
	WHERE FIND_IN_SET(Id, id_array);
END
$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiServiceAlertConfigurationGetById;
DELIMITER //
CREATE PROCEDURE sp_apiServiceAlertConfigurationGetById (
	IN service_id INT(11)
)
BEGIN
	SELECT `Id`,
		`Nome`,
		`Cartella`,
		`Tipo_intervallo`,
		`Valore`,
		Oggetto_email, 
		Corpo_email,
		Data_ultima_esecuzione,
		`Data_mod`,
		`Utente_mod`
	FROM servizio_alert_configurazione
	WHERE Id = service_id;

END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiServiceAlertExecutionInsert;
DELIMITER //
CREATE PROCEDURE sp_apiServiceAlertExecutionInsert (
	`service_id`                       INT(11),
	`exec_date`                       DATETIME,
	`filename`                       VARCHAR(50),
	`error` MEDIUMTEXT
)
BEGIN
	INSERT INTO servizio_alert_esecuzione 
	SET Id_servizio = service_id, 
		data_esecuzione = exec_date,
		Filename = filename,
		Errore = error;
		
	IF (error IS NULL OR error = '') THEN
		UPDATE servizio_alert_configurazione 
		SET Data_ultima_esecuzione = NOW()
		WHERE Id = service_id;
	END IF;

END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketGetExpiring;
DELIMITER //
CREATE PROCEDURE sp_apiTicketGetExpiring (
)
BEGIN
	DECLARE start_date DATE; 
	DECLARE end_date DATE; 

	DECLARE months_number SMALLINT;
	SELECT IFNULL(Numero_mesi, 1) INTO months_number 
	FROM servizio_alert_configurazione 
	WHERE Id = 4;

	SET start_date = CAST(DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 MONTH),'%Y-%m-01') AS DATE);
	SET end_date = LAST_DAY(DATE_ADD(NOW(), INTERVAL months_number MONTH));

	SELECT `ticket`.`id`                       AS `id`,
		`ticket`.`Id_ticket`                       AS `id_ticket`,
		`ticket`.`anno`                       AS `anno`,
		`ticket`.`Id_impianto`                       AS `id_impianto`,
		`ticket`.`Id_cliente`                       AS `id_cliente`,
		ticket.id_destinazione,
		`ticket`.`Urgenza`                       AS `urgenza`,
		`ticket`.`Descrizione`                       AS `ticket_descrizione`,
		IFNULL(ticket.Data_ticket, ticket.data_ora) AS "data_ticket", 
		ticket.scadenza AS Data_scadenza, 
		ticket.data_ora,
		ticket.data_soluzione, 
		ticket.Causale, 
		ticket.intervento,
		ticket.Comunicazione, 
		ticket.Stato_ticket,
		ticket.tempo, 
		ticket.id_utente, 
		ticket.stampato, 
		ticket.inviato, 
		ticket.data_promemoria,
		ticket.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM ticket
		INNER JOIN stato_promemoria_cliente ON ticket.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE (`ticket`.`Stato_ticket`                       IN (1,2) and ticket.scadenza < end_date)
	ORDER BY ticket.scadenza DESC; 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketGetBetweenExpirationDates;
DELIMITER //
CREATE PROCEDURE sp_apiTicketGetBetweenExpirationDates (
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT `ticket`.`id`                       AS `id`,
		`ticket`.`Id_ticket`                       AS `id_ticket`,
		`ticket`.`anno`                       AS `anno`,
		`ticket`.`Id_impianto`                       AS `id_impianto`,
		`ticket`.`Id_cliente`                       AS `id_cliente`,
		ticket.id_destinazione,
		`ticket`.`Urgenza`                       AS `urgenza`,
		`ticket`.`Descrizione`                       AS `ticket_descrizione`,
		IFNULL(ticket.Data_ticket, ticket.data_ora) AS "data_ticket", 
		ticket.scadenza AS Data_scadenza, 
		ticket.data_ora,
		ticket.data_soluzione, 
		ticket.Causale, 
		ticket.intervento,
		ticket.Comunicazione, 
		ticket.Stato_ticket,
		ticket.tempo, 
		ticket.id_utente, 
		ticket.stampato, 
		ticket.inviato, 
		ticket.data_promemoria,
		ticket.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM ticket
		INNER JOIN stato_promemoria_cliente ON ticket.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE scadenza BETWEEN from_date AND to_date
	ORDER BY ticket.scadenza DESC; 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketGetBetweenReminderDates;
DELIMITER //
CREATE PROCEDURE sp_apiTicketGetBetweenReminderDates (
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT `ticket`.`id`                       AS `id`,
		`ticket`.`Id_ticket`                       AS `id_ticket`,
		`ticket`.`anno`                       AS `anno`,
		`ticket`.`Id_impianto`                       AS `id_impianto`,
		`ticket`.`Id_cliente`                       AS `id_cliente`,
		ticket.id_destinazione,
		`ticket`.`Urgenza`                       AS `urgenza`,
		`ticket`.`Descrizione`                       AS `ticket_descrizione`,
		IFNULL(ticket.Data_ticket, ticket.data_ora) AS "data_ticket", 
		ticket.scadenza AS Data_scadenza, 
		ticket.data_ora,
		ticket.data_soluzione, 
		ticket.Causale, 
		ticket.intervento,
		ticket.Comunicazione, 
		ticket.Stato_ticket,
		ticket.tempo, 
		ticket.id_utente, 
		ticket.stampato, 
		ticket.inviato, 
		ticket.data_promemoria,
		ticket.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM ticket
		INNER JOIN stato_promemoria_cliente ON ticket.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE data_promemoria BETWEEN from_date AND to_date
	ORDER BY ticket.data_promemoria DESC; 
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiServiceAlertGeneralConfigurationGetLast;
DELIMITER //
CREATE PROCEDURE sp_apiServiceAlertGeneralConfigurationGetLast (
)
BEGIN
	SELECT
		`Id`,
		`Email_host`,
		`Email_username`,
		`Email_password`,
		`Email_port`,
		`Email_ssl`,
		Email_from,
		`Data_ins`,
		`Utente_ins`
	FROM servizio_alert_configurazione_generale
	ORDER BY Id DESC
	LIMIT 1;
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiServiceAlertRecipientGetByService;
DELIMITER //
CREATE PROCEDURE sp_apiServiceAlertRecipientGetByService (
	IN service_id INT(11)
)
BEGIN
	SELECT
		`Id`,
		`Id_servizio`,
		`Email`,
		`Data_ins`,
		`Utente_ins`                       
	FROM servizio_alert_ricevente
	WHERE Id_servizio = service_id
	ORDER BY Email;

END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiChecklistModelElementDefValueGet;
DELIMITER //
CREATE PROCEDURE sp_apiChecklistModelElementDefValueGet ( 
)
BEGIN
	SELECT 	
		IFNULL(checklist_model_elemento_def_valore.Id, -1) AS Id,
		checklist_model_elemento_def_valore.id_elemento,
		tipo_checklist_model_elemento_def_valore.Id as Id_tipo_def_val,
		tipo_checklist_model_elemento_def_valore.Nome AS Label,
		tipo_checklist_model_elemento_def_valore.Field As Field,
		tipo_checklist_model_elemento_def_valore.Field_type As Field_type,
		checklist_model_elemento_def_valore.Value,
		IFNULL(checklist_model_elemento_def_valore.Data_mod, NOW()) AS Data_mod,
		IFNULL(Utente_mod, @USER_ID) AS Utente_mod
	FROM checklist_model_elemento_def_valore
		INNER JOIN tipo_checklist_model_elemento_def_valore
		ON checklist_model_elemento_def_valore.Id_tipo_def_val = tipo_checklist_model_elemento_def_valore.Id;
END; //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistCheckExistence; 
CREATE PROCEDURE sp_apiChecklistCheckExistence 
(
	mobile_id INT(11),
	OUT result INT(11) 
)
BEGIN
   	
	SET result = 0;

END; //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistGet; 
CREATE PROCEDURE sp_apiChecklistGet
(
)
BEGIN
	SELECT
		`id`,
		`id_mobile`,
		`data_esecuzione`,
		`id_checklist_model`,
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
		`numero_visita`,
		`controllo_periodico`,
		`altro`,
		`responsabile_lavoro`,
		`appunti`,
		`filename_firma_cliente`,
		`filename_firma_tecnico`,
		visionata, 
		stampata, 
		inviata,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod`
	FROM checklist
	ORDER BY visionata;
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistGetById; 
CREATE PROCEDURE sp_apiChecklistGetById
(
	IN enter_id INT(11)
)
BEGIN
	SELECT
		`id`,
		`id_mobile`,
		`data_esecuzione`,
		`id_checklist_model`,
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
		`numero_visita`,
		`controllo_periodico`,
		`altro`,
		`responsabile_lavoro`,
		`appunti`,
		`filename_firma_cliente`,
		`filename_firma_tecnico`,
		visionata, 
		stampata, 
		inviata,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod`
	FROM checklist
	WHERE id = enter_id;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistParagraphGetByChecklistIds; 
CREATE PROCEDURE sp_apiChecklistParagraphGetByChecklistIds
(
	IN checklist_ids MEDIUMTEXT
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
	WHERE FIND_IN_SET(id_checklist, checklist_ids)
	ORDER BY ordine;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiChecklistParagraphRowGetByChecklistIds; 
CREATE PROCEDURE sp_apiChecklistParagraphRowGetByChecklistIds
(
	IN checklist_ids MEDIUMTEXT
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
	WHERE FIND_IN_SET(id_checklist, checklist_ids)
	ORDER BY ordine;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiUserGet;
DELIMITER //
CREATE PROCEDURE sp_apiUserGet ()
BEGIN
	SELECT `Id_utente`,
		Utente.Nome as Nome,
		Utente.Descrizione as Descrizione,
		Utente.mail,
		`Firma`,
		Utente.calendario as calendario,
		`smtp`,
		`porta`,
		`mssl`,
		`nome_utente_mail`,
		`password_mail`,
		utente.tipo_utente as Id_tipo_utente,
		tipo_utente.nome as Tipo_utente,
		`conferma`, 
		Password, 
		Salt
	FROM utente 
		INNER JOIN tipo_utente ON utente.tipo_utente = tipo_utente.id_tipo;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiUserGetById; 
CREATE PROCEDURE sp_apiUserGetById
(
	IN user_id INT(11)
)
BEGIN
	SELECT `Id_utente`,
		Utente.Nome as Nome,
		Utente.Descrizione as Descrizione,
		Utente.mail,
		`Firma`,
		Utente.calendario as calendario,
		`smtp`,
		`porta`,
		`mssl`,
		`nome_utente_mail`,
		`password_mail`,
		utente.tipo_utente as Id_tipo_utente,
		tipo_utente.nome as Tipo_utente,
		`conferma`
	FROM utente 
		INNER JOIN tipo_utente ON utente.tipo_utente = tipo_utente.id_tipo
	WHERE Id_utente = user_id;
END; //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiUserRefreshTokenDelete; 
CREATE PROCEDURE sp_apiUserRefreshTokenDelete
(
	IN id_token INT(11)
)
BEGIN
	DELETE FROM TokenRefresh Where TokenRefresh.id_token=id_token;
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_ariesChecklistLinkToSystem; 
CREATE  PROCEDURE `sp_ariesChecklistLinkToSystem`( 
	IN enter_id INT(11),
	IN user_id INT(11),
	OUT result INT(11)
)
BEGIN
	DECLARE `_rollback`                       BOOL DEFAULT 0;
	DECLARE system_id INT(11);
	DECLARE new_checklist_id INT(11);
	DECLARE checklist_model_id INT(11);
	DECLARE cursor_id INT(11);
	DECLARE cursor_row_id INT(11);
	DECLARE paragraph_id INT(11); 
	DECLARE exit_paragraph_loop BOOLEAN;
	DECLARE exit_row_loop BOOLEAN;
	DECLARE paragraph_cursos CURSOR FOR SELECT id FROM checklist_paragrafo WHERE id_checklist = enter_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_paragraph_loop = TRUE;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback`                       = 1;
	
	START TRANSACTION;
	
	SELECT checklist.id_impianto, 
			checklist.id_checklist_model
		INTO system_id, 
			checklist_model_id
	FROM checklist
	WHERE id = enter_id;
	
	-- Checklist model insert
	INSERT INTO checklist_model (`Id_check_parent`,
		`nome`,
		`descrizione`,
		`note`,
		`tipo_impianto`,
		`Stato`,
		`Data_ins`,
		`Utente_ins`)
	SELECT
		checklist_model_id,
		`nome`,
		`descrizione`,
		`note`                       ,
		`tipo_impianto`,
		`Stato`,
		NOW(),
		user_id
	FROM checklist_model 
	WHERE Id_check = checklist_model_id;
		
	SET new_checklist_id = LAST_INSERT_ID();
	SET Result = new_checklist_id;
		
	-- association system - checklist model
	DELETE FROM checklist_model_impianto WHERE Id_impianto = system_id;
	INSERT INTO `checklist_model_impianto`                       (`id_checklist`, `id_impianto`, `Data_ins`,`Utente_ins`)
	VALUES (new_checklist_id, system_id, NOW(), user_id);
		
	-- open the cursor
	OPEN paragraph_cursos;
	
	-- start looping
	paragrah_loop: LOOP
		
		-- read the name from next row into the variables 
		FETCH  paragraph_cursos INTO cursor_id;
		IF exit_paragraph_loop THEN
			CLOSE paragraph_cursos;
			LEAVE paragrah_loop;
		END IF;
		
		-- paragraph insert
		INSERT INTO `checklist_model_paragrafo`                       (`id_checklist`, `nome`, `descrizione`, `ordine`, `Data_ins`,
			`Data_mod`, `Utente_ins`, Utente_mod)
		SELECT
			new_checklist_id,
			`nome`,
			`descrizione`,
			`ordine`,
			NOW(),
			NOW(), 
			user_id, 
			user_id
		FROM checklist_paragrafo
		WHERE checklist_paragrafo.id = cursor_id;	
		
		SET paragraph_id = LAST_INSERT_ID();
		
		-- ###################################### ROWS INSERT ################################
		BEGIN
			DECLARE row_id INT(11);
			DECLARE rows_cursor CURSOR FOR SELECT id FROM checklist_paragrafo_riga WHERE id_paragrafo = cursor_id;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_row_loop = TRUE;
			
			-- open the cursor
			OPEN rows_cursor;
	
			-- start looping
			row_loop: LOOP
			
				-- read the name from next row into the variables 
				FETCH  rows_cursor INTO cursor_row_id;
				IF exit_row_loop THEN
					CLOSE rows_cursor;
					LEAVE row_loop;
				END IF;

				-- row insert
				INSERT INTO `checklist_model_elemento`                       (
					`Id_paragrafo`,
					`Id_checklist`,
					`Posizione`,
					`tipo_elemento`,
					`nome`,
					`descrizione`,
					`indicazioni`,
					Id_elemento,
					`Data_ins`,
					`Data_mod`,
					`Utente_ins`,
					`Utente_mod`)
				SELECT
					paragraph_id,
					new_checklist_id,
					ordine,
					tipo_riga,
					nome,
					descrizione,
					indicazioni_tecnico,
					null,
					NOW(),
					NOW(), 
					user_id, 
					user_id
				FROM checklist_paragrafo_riga
				WHERE checklist_paragrafo_riga.id = cursor_row_id;	
				
				SET row_id = LAST_INSERT_ID(); 	
				
				INSERT INTO checklist_model_elemento_def_valore (
					`Id_elemento`,
					`Id_tipo_def_val`,
					`Label`,
					`Field`,
					`Value`,
					`Data_mod`,
					`Utente_mod`)
				SELECT 
					row_id, 
					checklist_model_elemento_def_valore.id_tipo_def_val, 
					checklist_model_elemento_def_valore.Label, 
					checklist_model_elemento_def_valore.Field, 
					checklist_model_elemento_def_valore.Value,
					NOW(), 
					user_id
				FROM checklist_model_elemento_def_valore 
					INNER JOIN checklist_paragrafo_riga 
					ON checklist_paragrafo_riga.id_checklist_model_elemento = checklist_model_elemento_def_valore.id_elemento
				WHERE checklist_paragrafo_riga.id = cursor_row_id;
								
			END LOOP row_loop;
		END;
	END LOOP paragrah_loop;

	
	IF `_rollback`                       THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiUserRolesGetyUserId;
DELIMITER //
CREATE PROCEDURE sp_apiUserRolesGetyUserId (
	IN user_id INT(11)
)
BEGIN
	SELECT 
		utente_roles.id, 
		utente_utente_roles.id_utente,
		nome, 
		descrizione,
		app_name
	FROM utente_roles
		INNER JOIN utente_utente_roles ON utente_utente_roles.id_utente_roles = utente_roles.id
	WHERE id_utente = user_id;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiUserRolesGetyUsers;
DELIMITER //
CREATE PROCEDURE sp_apiUserRolesGetyUsers (
	IN user_ids MEDIUMTEXT
)
BEGIN
	SELECT 
		utente_roles.id, 
		utente_utente_roles.id_utente,
		nome, 
		descrizione,
		app_name
	FROM utente_roles
		INNER JOIN utente_utente_roles ON utente_utente_roles.id_utente_roles = utente_roles.id
	WHERE FIND_IN_SET(id_utente, user_ids);
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiReportMobileInterventionSaveSignaturesRefs;
DELIMITER //
CREATE PROCEDURE sp_apiReportMobileInterventionSaveSignaturesRefs
(
	report_id INT(11),
	report_year INT(11),
	customer_filename VARCHAR(50), 
	technician_filename VARCHAR(50), 
	ddt_signature_filename VARCHAR(50)
)
BEGIN

	UPDATE rapporto_mobile 
	SET 
		`filename_firma_cliente`                       = customer_filename,
		`filename_firma_tecnico`                       = technician_filename, 
		filename_firma_per_ddt = ddt_signature_filename
	WHERE Id_rapporto = report_id AND Anno = report_year; 
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiReportMobileTestSaveSignaturesRefs;
DELIMITER //
CREATE PROCEDURE sp_apiReportMobileTestSaveSignaturesRefs
(
	report_id INT(11),
	report_year INT(11),
	customer_filename VARCHAR(50), 
	technician_filename VARCHAR(50)
)
BEGIN

	UPDATE rapporto_mobile_collaudo
	SET 
		`filename_firma_cliente`                       = customer_filename,
		`filename_firma_tecnico`                       = technician_filename
	WHERE Id_rapporto = report_id AND Anno = report_year; 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiEmailSetReadFlag;
DELIMITER //
CREATE PROCEDURE sp_apiEmailSetReadFlag
(
	email_id INT(11),
	read_value BIT(1)
)
BEGIN

	UPDATE mail
	SET 
		Letto = read_value
	WHERE Id = email_id; 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesInvoiceGetForDeadlineAlert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceGetForDeadlineAlert`(

)
BEGIN
	SELECT
		`Id`,
		`Id_fattura`,
		`anno`,
		1 as `Id_bollettario`,
		`id_cliente`,
		`id_destinazione`,
		`destinazione`,
		`Data_registrazione`,
		CAST(IFNULL(data_modifica ,'1970-01-01') AS DATETIME) data_modifica,
		`data`,
		`cond_pagamento`,
		`banca`                       ,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`iban`,
		`abi`,
		`cab`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`inviato`,
		CAST(IFNULL(pagato_il ,'00:00:00') AS TIME) pagato_il,
		IFNULL(`tramite`, 0) tramite,
		`insoluto`,
		`stampato`,
		`subappalto`,
		IFNULL(`id_utente`, 0) id_utente,
		`scont_mat`,
		IFNULL(`id_iv`, 0) id_iv,
		CAST(IFNULL(data_invio_promemoria ,'1970-01-01') AS DATETIME) data_invio_promemoria,
		IFNULL(`controllo_promemoria`, 1) controllo_promemoria,
		`area_attivita`,
		IFNULL(`nostra`, 0) nostra,
		`data_ultima_modifica`,
		importo_imponibile, 
		importo_iva,
		importo_totale,
		costo_totale,
		id_documento_ricezione
	FROM Fattura
	WHERE CURDATE() > DATE_ADD(Fattura.data, INTERVAL 5 DAY) AND Inviato = 0 AND (Anno > 2019 OR Anno = 0) 
	ORDER BY DATA ASC;
END//
DELIMITER ;





DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportAttachmentInsert; 
CREATE PROCEDURE sp_apiReportAttachmentInsert 
(
	report_id INT(11), 
	`report_year`                       INT(11),
	`file_name`                       VARCHAR(250), 
	file_path MEDIUMTEXT,
	send_to_customer BIT(1),
	generate_ticket BIT(1),
	`timestamp`                       TIMESTAMP,
	`user_id`                       INT(11)
)
BEGIN	

	INSERT INTO rapporto_allegati
	SET `id_rapporto`= report_id,
		`anno_rapporto`                       = report_year,
		`file_path`                       = file_path,
		`file_name`                       = file_name,
		`timestamp`                       = timestamp,
		`utente_ins`                       = user_id,
		invia_a_cliente = send_to_customer,
		genera_ticket = generate_ticket
		;
	
END; //
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiReportAttachmentDeleteByReport; 
CREATE PROCEDURE sp_apiReportAttachmentDeleteByReport 
(
	id INT, 
	`year`                       INT
)
BEGIN
	
	DELETE 
	FROM rapporto_allegati 
	WHERE id_rapporto= id AND anno_rapporto = `year`; 
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiSupplierGetByIds;
DELIMITER //
CREATE PROCEDURE sp_apiSupplierGetByIds (
	IN supplier_ids MEDIUMTEXT
)
BEGIN


	SELECT DISTINCT
		`Id_fornitore`,
		`Ragione_Sociale`,
		`Ragione_Sociale2`,
		`Partita_iva`,
		`Codice_Fiscale`,
		`Data_inserimento`,
		stato_fornitore.id_stato, 
		stato_fornitore.nome AS 'Stato', 
		stato_economico.id_stato AS 'Id_stato_economico',
		stato_economico.nome, 
		condizione_pagamento.id_condizione,
		condizione_pagamento.nome as condizione_pagamento,
		`Sito_internet`,
		`password`,
		`Utente_sito`,
		tipo_iva.Id_iva,
		tipo_iva.nome as 'iva',
		tipo_fornitore.Id_tipo AS 'Id_tipo_fornitore',
		tipo_fornitore.nome as 'Tipo_fornitore',
		`modi`,
		`id_tiporapp`,
		Fornitore.`id_utente`,
		`costruttore`,
		`id_attività`                       as 'id_attivita',
		tipo_attivita.nome AS 'attivita',
		`cod_fornitore`
	FROM fornitore 
		INNER JOIN stato_fornitore ON stato_fornitore.id_stato = fornitore.stato_fornitore
		LEFT JOIN tipo_attivita ON tipo_attivita.id_tipo = fornitore.id_attività
		LEFT JOIN stato_economico ON stato_economico.id_stato = fornitore.stato_economico
		LEFT JOIN condizione_pagamento ON condizione_pagamento.id_condizione = fornitore.condizione_pagamento
		LEFT JOIN tipo_iva ON tipo_iva.Id_iva = fornitore.iva
		LEFT JOIN tipo_fornitore ON tipo_fornitore.Id_tipo = fornitore.tipo_fornitore
	WHERE FIND_IN_SET(fornitore.id_fornitore, supplier_ids);
			
END; //
DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS sp_apiCompanyInvalidateLicence; 
CREATE PROCEDURE sp_apiCompanyInvalidateLicence 
()
BEGIN
	
	UPDATE azienda
	SET license = 'GfbYgCInF9YsnqhVEvdFKRIdJGDYfnuJ196QlupiESHehGfXq2cidboHdmtnMwqx9HO6cCJGfu5PydeN59Q1ahKDpxqRaW9mkrNn';
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiCustomerReminderConfigGetById;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerReminderConfigGetById (
	IN service_id INT(11)
)
BEGIN
	SELECT `Id`,
		`Nome`,
		`Tipo_intervallo`,
		`Valore`,
		Oggetto_email, 
		Corpo_email,
		Testo_sms,
		abilita_sms,
		abilita_email,
		Data_ultima_esecuzione,
		`Data_mod`,
		`Utente_mod`
	FROM cliente_promemoria_configurazione
	WHERE Id = service_id;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiCustomerReminderConfigExecutedNow;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerReminderConfigExecutedNow (
	IN service_id INT(11)
)
BEGIN
	UPDATE cliente_promemoria_configurazione
	SET Data_ultima_esecuzione = NOW()
	WHERE Id = service_id;
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiCustomerReminderGeneralConfigurationGetLast;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerReminderGeneralConfigurationGetLast (
)
BEGIN
	SELECT
		`Id`,
		`Email_host`,
		`Email_username`,
		`Email_password`,
		`Email_port`,
		`Email_ssl`,
		Email_from,
		Sms_host,
		Sms_endpoint,
		Sms_password,
		Sms_host,
		`Data_ins`,
		`Utente_ins`
	FROM cliente_promemoria_configurazione_generale
	ORDER BY Id DESC
	LIMIT 1;
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiCompanyGetLast;
DELIMITER //
CREATE PROCEDURE sp_apiCompanyGetLast (
)
BEGIN
	SELECT `id_azienda`,
		`titolare`,
		`ragione_sociale`,
		`settore`,
		`indirizzo`,
		`comune`,
		`provincia`,
		`telefono`,
		`cellulare`,
		`partita_iva`,
		`regImprese`,
		`alboProvinciale`,
		`ciaa`,
		`ciaa_n`,
		`albo_provincia`,
		`albo_n`,
		`numero`,
		`sito_internet`,
		`fax`,
		`e_mail`,
		`cod_fis`,
		`numero_rea`,
		`posizione_inps`,
		`posizione_inail`,
		`codice_ateco`,
		`assicu_rct`,
		`frazione`,
		`capi_soc`,
		`data`,
		`abilitazione`,
		`smtp`,
		`porta`,
		`mssl`,
		`utente_mail`,
		`password`,
		`nome_mail`,
		`banca`,
		`iban`,
		`listino`,
		`sconto`,
		`tipo_sconto`,
		`stampa_ragione`,
		`stampa_ri`,
		`giorni_promemoria`,
		`cap2`,
		`stampante_promemoria`,
		`mail_amministrazione`,
		`intestazione_promemoria`,
		`host_caldav`,
		`nome_caldav`,
		`license`,
		`abilita_convalida_rapporto`,
		`tele_fatt`,
		`circolare_per_garanzia`,
		`notifica_attesa`,
		`passaggio_nonaccettato`,
		`percorso_default_aggiornamento`,
		`giorni_avviso_rapporto`,
		`regime_fiscale`,
		'TO_REMOVE' AS aries_web_host,
		`Data_fine`,
		`Data_ins`,
		`Data_mod`,
		`Utente_ins`,
		`Utente_mod`,
		`email_provider_caldav`
	FROM Azienda ORDER BY Id_azienda DESC LIMIT 1; 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemSearch;
DELIMITER //
CREATE PROCEDURE sp_apiSystemSearch (
	IN system_id VARCHAR(200), 
	IN company_name VARCHAR(200), 
	IN description VARCHAR(200)
)
BEGIN
	SELECT `impianto`.`Id_impianto` AS `id_impianto`,
		`impianto`.`Id_cliente` AS `id_cliente`,
		`impianto`.`Abbonamento` AS `id_abbonamento`, 
		impianto.Destinazione AS Id_destinazione, 
		`impianto`.`Data_Funzione` AS `data_funzione`, 
		`impianto`.`scadenza_garanzia` AS `Scadenza_Garanzia`,
		`impianto`.`Tipo_impianto` AS `tipo_impianto`,
		`tipo_impianto`.`Nome` AS `tipo_impianto_descrizione`,
		`impianto`.`Stato` AS `stato`,
		`stato_impianto`.`Nome` AS `stato_descrizione`,
		`impianto`.`Descrizione` AS `descrizione`, 
		`impianto`.`centrale` AS `centrale`, 
		`impianto`.`gsm` AS `gsm`, 
		`impianto`.`combinatore_telefonico` AS `combinatore_telefonico`,
		`impianto`.`orario_prog` AS `orario_prog`,
		clienti.ragione_sociale AS `ragione_sociale`,
		checklist_model_impianto.id_checklist,
		abbonamento.nome as abbonamento,
		impianto.id_stato_promemoria_garanzia,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria_garanzia
	FROM `impianto`
		LEFT JOIN checklist_model_impianto ON impianto.id_impianto = checklist_model_impianto.id_impianto
		INNER JOIN clienti ON impianto.id_cliente = clienti.id_cliente
		INNER JOIN stato_promemoria_cliente ON impianto.id_stato_promemoria_garanzia = stato_promemoria_cliente.id
		INNER JOIN tipo_impianto ON id_tipo = Tipo_impianto
		INNER JOIN stato_impianto ON id_stato = Stato
		LEFT JOIN abbonamento ON impianto.abbonamento = abbonamento.id_abbonamento
	WHERE ((`impianto`.`Stato` < 4) OR (`impianto`.`Stato` > 7))
		AND  (
			(description IS NOT NULL AND impianto.descrizione LIKE CONCAT("%", description, "%"))
			OR (system_id IS NOT NULL AND impianto.id_impianto LIKE CONCAT("%", system_id, "%"))
			OR (company_name IS NOT NULL AND Clienti.ragione_sociale LIKE CONCAT("%", company_name, "%"))
		)
	GROUP BY `impianto`.`Id_impianto`
	ORDER BY Clienti.ragione_sociale
	LIMIT 100;
END; //
DELIMITER ;





DROP PROCEDURE IF EXISTS sp_apiDownloadFileHistoryInsert;
DELIMITER //
CREATE  PROCEDURE `sp_apiDownloadFileHistoryInsert`(
	IN `user_id` INT(11),
	IN `employee_id` INT(11),
	IN `file_path` VARCHAR(500),
	IN `file_name` VARCHAR(100),
	IN `application_ref` VARCHAR(50),
	OUT result INT(11)
)
BEGIN
	INSERT INTO storico_download_file
	SET `id_utente` = user_id,
		`id_operaio` = employee_id,
		`rif_applicazione` = application_ref,
		`file_path` = file_path,
		`file_name` = file_name;

	SET result = 1;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiReportGroupGet;
DELIMITER //
CREATE  PROCEDURE `sp_apiReportGroupGet`()
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
		`Nota`,
		`fattura`,
		`anno_fattura`,
		`id_utente`,
		tipo_resoconto.id_tipo AS id_tipo_resoconto,
		tipo_resoconto.nome AS tipo_resoconto,
		IFNULL(inviato, 0) AS inviato,
		`nota_fine`,
		IFNULL(stm, 0) as stm,
		`fat_SpeseRap`,
		`prezzo_manutenzione`,
		`resoconto_totali`.costo_manutenzione,
		`costo_diritto_chiamata`,
		`prezzo_diritto_chiamata`,
		`costo_lavoro`,
		`prezzo_lavoro`,
		`costo_viaggio`,
		`prezzo_viaggio`,
		`costo_materiale`,
		`prezzo_materiale`,
		`costo_totale`,
		`prezzo_totale`,
		promemoria_inviato,
		data_invio_promemoria
	FROM resoconto
		INNER JOIN resoconto_totali ON resoconto.id_resoconto = resoconto_totali.id_resoconto AND resoconto.anno = resoconto_totali.anno
		INNER JOIN stato_resoconto ON resoconto.stato = stato_resoconto.id_stato
		INNER JOIN tipo_resoconto ON resoconto.tipo_resoconto = tipo_resoconto.id_tipo;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiReportGroupGetToRemind;
DELIMITER //
CREATE  PROCEDURE `sp_apiReportGroupGetToRemind`(
	IN reminder_days INT(11)
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
		`Nota`,
		`fattura`,
		`anno_fattura`,
		`id_utente`,
		tipo_resoconto.id_tipo AS id_tipo_resoconto,
		tipo_resoconto.nome AS tipo_resoconto,
		IFNULL(inviato, 0) AS inviato,
		`nota_fine`,
		IFNULL(stm, 0) as stm,
		`fat_SpeseRap`,
		`prezzo_manutenzione`,
		`resoconto_totali`.costo_manutenzione,
		`costo_diritto_chiamata`,
		`prezzo_diritto_chiamata`,
		`costo_lavoro`,
		`prezzo_lavoro`,
		`costo_viaggio`,
		`prezzo_viaggio`,
		`costo_materiale`,
		`prezzo_materiale`,
		`costo_totale`,
		`prezzo_totale`,
		promemoria_inviato,
		data_invio_promemoria
	FROM resoconto
		INNER JOIN resoconto_totali ON resoconto.id_resoconto = resoconto_totali.id_resoconto AND resoconto.anno = resoconto_totali.anno
		INNER JOIN stato_resoconto ON resoconto.stato = stato_resoconto.id_stato
		INNER JOIN tipo_resoconto ON resoconto.tipo_resoconto = tipo_resoconto.id_tipo
		INNER JOIN (
			SELECT CAST(id_documento AS UNSIGNED) AS id_resoconto, CAST(anno_documento AS UNSIGNED) AS anno_resoconto
			FROM mail
			WHERE tipo_documento = 'reso' AND id_documento IS NOT NULL AND anno_documento IS NOT NULL AND DATE(DATA_invio) = DATE_SUB(CURRENT_DATE, INTERVAL reminder_days DAY)
		) AS tmp_reso_email ON tmp_reso_email.id_resoconto = resoconto.id_resoconto AND tmp_reso_email.anno_resoconto = resoconto.anno
		
	WHERE resoconto.inviato = 1 AND resoconto.promemoria_inviato = 0 AND resoconto.stato IN (1, 3);
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketUpdateRequireReminder; 
DROP PROCEDURE IF EXISTS sp_apiTicketUpdateReminderStatus; 
DELIMITER $$

CREATE PROCEDURE sp_apiTicketUpdateReminderStatus(
	IN id_array MEDIUMTEXT,
	IN status_ref VARCHAR(50))
BEGIN
	DECLARE new_status_id INT;

	SELECT id
	INTO new_status_id
	FROM stato_promemoria_cliente
	WHERE rif_applicazioni = status_ref;

	UPDATE ticket 
	SET id_stato_promemoria = new_status_id,
		data_ultimo_promemoria = NOW()
	WHERE FIND_IN_SET(Id, id_array);
END
$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemProductUpdateRequireReminder; 
DROP PROCEDURE IF EXISTS sp_apiSystemProductUpdateReminderStatus; 
DELIMITER $$

CREATE PROCEDURE sp_apiSystemProductUpdateReminderStatus(
IN id_array MEDIUMTEXT,
IN status_ref VARCHAR(50))
BEGIN
	DECLARE new_status_id INT;

	SELECT id
	INTO new_status_id
	FROM stato_promemoria_cliente
	WHERE rif_applicazioni = status_ref;

	UPDATE impianto_componenti 
	SET id_stato_promemoria = new_status_id,
		data_ultimo_promemoria = NOW()
	WHERE FIND_IN_SET(Id_impianto_componenti, id_array);
END
$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemProductGetBetweenExpirationDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemProductGetBetweenExpirationDates (
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT Id_impianto, 
		Id_articolo,
		Data_scadenza, 
		Data_installazione, 
		impianto_componenti.Id AS Posizione, 
		Data_dismesso, 
		COUNT(*) AS quantita,
		BOX,
		impianto_componenti.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_componenti
		INNER JOIN stato_promemoria_cliente ON impianto_componenti.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE scadenza BETWEEN from_date AND to_date
	GROUP BY id_impianto, id_articolo, Data_scadenza;
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_apiSystemProductGetBetweenReminderDates;
DELIMITER //
CREATE PROCEDURE sp_apiSystemProductGetBetweenReminderDates (
	from_date DATE,
	to_date DATE
)
BEGIN
	SELECT Id_impianto, 
		Id_articolo,
		Data_scadenza, 
		Data_installazione, 
		impianto_componenti.Id AS Posizione, 
		Data_dismesso, 
		COUNT(*) AS quantita,
		BOX,
		impianto_componenti.id_stato_promemoria,
		stato_promemoria_cliente.rif_applicazioni as rif_stato_promemoria
	FROM impianto_componenti
		INNER JOIN stato_promemoria_cliente ON impianto_componenti.id_stato_promemoria = stato_promemoria_cliente.id
	WHERE data_promemoria BETWEEN from_date AND to_date
	GROUP BY id_impianto, id_articolo, Data_scadenza;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemComponentsUpdateRequireReminder;
DROP PROCEDURE IF EXISTS sp_apiSystemComponentsUpdateReminderStatus;
DELIMITER //
CREATE PROCEDURE sp_apiSystemComponentsUpdateReminderStatus(
	IN system_id INT,
	IN product_code VARCHAR(50),
	IN expiration_date DATE,
	IN status_ref varchar(50)
	)
BEGIN
	DECLARE new_status_id INT;

	SELECT id
	INTO new_status_id
	FROM stato_promemoria_cliente
	WHERE rif_applicazioni = status_ref;

	UPDATE impianto_componenti 
	SET id_stato_promemoria = new_status_id,
		data_ultimo_promemoria = NOW()
	WHERE Data_scadenza = expiration_date
		AND id_impianto = system_id
		AND id_articolo = product_code;
END; //

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiSystemUpdateRequireWarrantyReminder; 
DROP PROCEDURE IF EXISTS sp_apiSystemUpdateWarrantyReminderStatus; 
DELIMITER $$

CREATE PROCEDURE sp_apiSystemUpdateWarrantyReminderStatus(
	IN id_array MEDIUMTEXT,
	IN status_ref VARCHAR(50)
)
BEGIN
	DECLARE new_status_id INT;

	SELECT id
	INTO new_status_id
	FROM stato_promemoria_cliente
	WHERE rif_applicazioni = status_ref;

	UPDATE impianto
	SET id_stato_promemoria_garanzia = new_status_id,
		data_ultimo_promemoria_garanzia = NOW()
	WHERE FIND_IN_SET(Id_impianto, id_array);
END
$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiSystemPeriodicCheckUpdateRequireReminder; 
DROP PROCEDURE IF EXISTS sp_apiSystemPeriodicCheckUpdateReminderStatus; 
DELIMITER $$

CREATE PROCEDURE sp_apiSystemPeriodicCheckUpdateReminderStatus(
IN id_array MEDIUMTEXT,
IN status_ref VARCHAR(50))
BEGIN
	DECLARE new_status_id INT;

	SELECT id
	INTO new_status_id
	FROM stato_promemoria_cliente
	WHERE rif_applicazioni = status_ref;

	UPDATE impianto_abbonamenti_mesi
	SET id_stato_promemoria = new_status_id,
		data_ultimo_promemoria = NOW()
	WHERE FIND_IN_SET(Id, id_array);
	END
$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketStatusGet;
DELIMITER //
CREATE PROCEDURE sp_apiTicketStatusGet (
)
BEGIN
	SELECT Id_stato,
		nome,
		descrizione,
		colore,
		aperto
	FROM Stato_ticket;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_apiTicketAttachmentGetByTicketIds;
DELIMITER //
CREATE PROCEDURE sp_apiTicketAttachmentGetByTicketIds (
	IN ticket_ids MEDIUMTEXT
)
BEGIN
	SELECT ticket_allegati.*
	FROM ticket_allegati
		INNER JOIN ticket ON ticket_allegati.id_ticket = ticket.id_ticket AND ticket_allegati.anno_ticket = ticket.anno
	WHERE FIND_IN_SET(`ticket`.`id`, ticket_ids)
	GROUP BY ticket_allegati.id_ticket, ticket_allegati.anno_ticket
	ORDER BY ticket_allegati.timestamp;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiReportAttachmentGetByReport;
DELIMITER //
CREATE PROCEDURE sp_apiReportAttachmentGetByReport (
	IN report_id INT,
	IN report_year INT
)
BEGIN
	SELECT rapporto_allegati.*
	FROM rapporto_allegati
	WHERE rapporto_allegati.id_rapporto = report_id and rapporto_allegati.anno_rapporto = report_year
	ORDER BY rapporto_allegati.timestamp;
END; //
DELIMITER ;