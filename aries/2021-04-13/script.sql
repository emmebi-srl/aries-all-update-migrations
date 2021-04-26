ALTER TABLE `impianto_componenti_codice`
	ALTER `seriale` DROP DEFAULT;
ALTER TABLE `impianto_componenti_codice`
	CHANGE COLUMN `seriale` `seriale` VARCHAR(150) NOT NULL AFTER `codice`;

ALTER TABLE `magazzino_rapporto_materiale`
	DROP INDEX `id_rapporto_anno_rapporto_id_tab`;


SET @USER_ID = (SELECT id_utente FROM utente WHERE Nome = 'admin' LIMIT 1);

