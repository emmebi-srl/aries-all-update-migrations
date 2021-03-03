INSERT INTO configurazione_percorsi 
	VALUES (CONCAT((SELECT a.Percorso FROM configurazione_percorsi as a WHERE a.Tipo_percorso = 'PRELIEVO'), 'FOTO ARTICOLI\\'), 'PRELIEVO FOTO ARTICOLI'); 

ALTER TABLE `lista_articoli`
	ADD COLUMN `foto_filename` VARCHAR(50) NULL AFTER `causale_scarico`;
