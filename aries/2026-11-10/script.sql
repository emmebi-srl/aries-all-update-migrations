-- Customer reminder "Estratto conto cliente": every month (DayOfMonth, default day 20) the
-- CustomerReminders service sends, through a campaign of type customer_invoices_statement, the
-- customer invoices statement PDF (same data as the Delphi Promemoria.rav "report2") to the
-- customer billing contact (riferimento_clienti.Fatturazione = 1). Customers without a billing
-- contact with an email are skipped.

-- Reminder configuration (Id 10, read by CustomerInvoicesStatementReminderJob).
-- Tipo_intervallo 1 = DayOfMonth, Valore = day of the month. The last execution is set to now so
-- that the first run happens on the next configured day, not right after the deploy.
INSERT IGNORE INTO `cliente_promemoria_configurazione`
  (`Id`, `Nome`, `Tipo_intervallo`, `Valore`, `Data_ultima_esecuzione`,
   `Oggetto_email`, `Corpo_email`, `Testo_sms`, `abilita_sms`, `abilita_email`,
   `modalita_consegna`, `id_campagna_aries`, `Data_mod`, `Utente_mod`)
VALUES (
  10,
  'PROMEMORIA ESTRATTO CONTO CLIENTE',
  1,
  20,
  CURRENT_TIMESTAMP,
  'Estratto conto',
  'Gentile cliente,\r\nin allegato il vostro estratto conto aggiornato.',
  '',
  b'0',
  b'0',
  1,
  NULL,
  CURRENT_TIMESTAMP,
  1
);

-- Campaign type and its placeholders (CampaignMailDataDto.PlaceholderInvoicesStatement*).
INSERT INTO `tipo_campagna_aries`
  (`uuid`, `nome`, `rif_applicazione`, `disiscrizione_abilitata`)
VALUES
  ('38928eac-9515-43ad-9b23-177b3d407ea3', 'Estratto conto cliente', 'customer_invoices_statement', 0)
ON DUPLICATE KEY UPDATE
  `nome` = VALUES(`nome`);

INSERT INTO `campagna_aries_segnaposto`
  (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
VALUES
  ('3d096d41-7e6b-45f5-9a14-2ec6f05a8e3a', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'customer_invoices_statement' LIMIT 1), 'customer_name', 'Ragione sociale cliente', ''),
  ('1abcf11c-d8f3-4c27-b319-b38e2ccc462c', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'customer_invoices_statement' LIMIT 1), 'statement_date', 'Data estratto conto', ''),
  ('1d34e15d-e822-4df1-a286-888e9487270e', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'customer_invoices_statement' LIMIT 1), 'statement_total_amount', 'Totale da pagare (scaduto + in scadenza)', ''),
  ('a12ba653-c354-4bcc-8001-2359c9926049', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'customer_invoices_statement' LIMIT 1), 'statement_expired_amount', 'Totale rate scadute', ''),
  ('e27243fd-1424-4c4a-b60a-7f2692ff8a77', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'customer_invoices_statement' LIMIT 1), 'statement_expiring_amount', 'Totale rate in scadenza', '')
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);

-- The web API contacts now expose the billing flag (CustomerContactDto.IsBilling).
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
		riferimento_clienti.Promemoria_cliente,
		riferimento_clienti.Fatturazione AS fatturazione
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
		riferimento_clienti.Promemoria_cliente,
		riferimento_clienti.Fatturazione AS fatturazione
	FROM riferimento_clienti
		INNER JOIN riferimento_figura ON
			riferimento_clienti.figura = riferimento_figura.Id_figura
	WHERE FIND_IN_SET(riferimento_clienti.id_cliente, customer_ids);
END; //
DELIMITER ;
