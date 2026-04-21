ALTER TABLE `impianto_accettazione_proposta_abbonamento`
    ADD COLUMN `prezzo_diritto_chiamata` DECIMAL(10,2) NULL
    AFTER `prezzo_singola_manutenzione`;

UPDATE `impianto_accettazione_proposta_abbonamento`
SET `prezzo_diritto_chiamata` = 72.00
WHERE `prezzo_diritto_chiamata` IS NULL;

ALTER TABLE `impianto_accettazione_proposta_abbonamento`
    MODIFY COLUMN `prezzo_diritto_chiamata` DECIMAL(10,2) NOT NULL;
