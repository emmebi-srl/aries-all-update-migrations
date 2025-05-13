ALTER TABLE `commessa_articoli_storico`
	DROP FOREIGN KEY `FK__commessa_articoli_storico__commessa_articoli`,
	DROP FOREIGN KEY `FK__commessa_articoli_storico__articolo`;
	
ALTER TABLE `commessa_articoli_storico`
	ADD COLUMN `operazione` VARCHAR(10) NOT NULL DEFAULT 'UPDATE' AFTER `iva`;

ALTER TABLE `rapporto_allegati`
	ADD COLUMN `genera_ticket` BIT(1) NULL DEFAULT b'0' AFTER `invia_a_cliente`;
