ALTER TABLE `utente`
	DROP INDEX `Index_calendario`,
	DROP FOREIGN KEY `FK_calendario`;

ALTER TABLE `ticket`
	ADD COLUMN `Id` INT NULL AUTO_INCREMENT AFTER `data_promemoria`,
	ADD UNIQUE INDEX `Id` (`Id`);

TRUNCATE TABLE Tipo_evento; 
INSERT IGNORE INTO tipo_evento (nome,  colore) VALUES
('CONTROLLO PERIODICO', '$00DBB5C3'),
('TICKET', 'clyellow'),
('PAGAMENTI', 'clwhite'),
('DIPENDENTE', 'clMenuHighlight'),
('CORSO', 'clMaroon'),
('AUTOMEZZI', '$0000B3FF'),
('TECNICO', 'clblue'); 



select * from tipo_evento; 