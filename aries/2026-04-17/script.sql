ALTER TABLE `impianto_accettazione_proposta_abbonamento`
    ADD COLUMN `data_accettazione_termini_abbonamento` DATETIME NULL
    AFTER `data_accettazione_termini_condizioni`;

UPDATE `impianto_accettazione_proposta_abbonamento`
SET `data_accettazione_termini_abbonamento` = `data_accettazione_termini_condizioni`
WHERE `data_accettazione_termini_abbonamento` IS NULL;

ALTER TABLE `impianto_accettazione_proposta_abbonamento`
    MODIFY COLUMN `data_accettazione_termini_abbonamento` DATETIME NOT NULL;
