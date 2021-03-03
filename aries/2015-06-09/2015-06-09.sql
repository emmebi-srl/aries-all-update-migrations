TRUNCATE ticket_evento;
ALTER TABLE `ticket_evento`
	DROP PRIMARY KEY,
	DROP INDEX `tipo_tievent`,
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	ADD PRIMARY KEY (`Id`),
	ADD UNIQUE INDEX `id_ticket_anno` (`id_ticket`, `anno`);
