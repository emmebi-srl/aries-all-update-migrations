-- Internal alert "Anteprima estratti conto" (Id 6, CustomerInvoicesStatementPreviewAlertJob in the
-- PeriodicReports service): an HTML email to the alert recipients (servizio_alert_ricevente) with the
-- invoices statements the customer reminder 10 is going to send, grouped by customer, with the
-- invoices and the addresses, and "NESSUN DESTINATARIO TROVATO" for the customers without a billing
-- contact. Tipo_intervallo 5 = DaysBefore (N days before the day of the statements, only for this
-- alert) or 1 = DayOfMonth (fixed day). Default: 7 days before. The last execution is set to now so
-- that it doesn't run right after the deploy. Without recipients it doesn't run: they are added only
-- for Emmebi.
INSERT IGNORE INTO `servizio_alert_configurazione`
  (`Id`, `Nome`, `Cartella`, `Tipo_intervallo`, `Valore`, `Numero_mesi`, `Data_ultima_esecuzione`,
   `Oggetto_email`, `Corpo_email`, `Data_mod`, `Utente_mod`)
VALUES (
  6,
  'Anteprima estratti conto',
  'ANTEPRIMA ESTRATTI CONTO',
  5,
  7,
  0,
  CURRENT_TIMESTAMP,
  '[ARIES] ANTEPRIMA ESTRATTI CONTO',
  'Di seguito gli estratti conto che verranno inviati ai clienti.',
  CURRENT_TIMESTAMP,
  1
);

DROP PROCEDURE IF EXISTS sp_tmp;
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN
	DECLARE is_emmebi BIT(1) DEFAULT 0;

	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda
	WHERE partita_iva = '04371390263';

	IF is_emmebi THEN
		INSERT IGNORE INTO `servizio_alert_ricevente` (`Id_servizio`, `Email`, `Utente_ins`)
		VALUES
			(6, 'amministrazione@emmebi.tv.it', 1),
			(6, 'info@emmebi.tv.it', 1);
	END IF;
END
$$

DELIMITER ;

CALL sp_tmp();
DROP PROCEDURE IF EXISTS sp_tmp;
