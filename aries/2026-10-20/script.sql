-- Subscription campaigns: the annual fee accepted from the landing page is the phone availability
-- (reperibilità telefonica h24), not the call right (diritto di chiamata). Rename the acceptance columns.

ALTER TABLE `impianto_accettazione_proposta_abbonamento`
	CHANGE COLUMN `prezzo_diritto_chiamata` `prezzo_reperibilita` DECIMAL(10,2) NOT NULL,
	CHANGE COLUMN `data_accettazione_fatturazione_immediata_diritto_chiamata` `data_accettazione_fatturazione_immediata_reperibilita` DATETIME NOT NULL;
