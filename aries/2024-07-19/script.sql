
ALTER TABLE `tipo_intervento`
	ADD COLUMN `prezzo_da_abbonamento` BIT NULL DEFAULT 0 AFTER `studi_settore`;



UPDATE tipo_intervento SET prezzo_da_abbonamento = 1 where id_tipo in (6, 9);
