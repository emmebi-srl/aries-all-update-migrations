ALTER TABLE `tipo_evento`
	CHANGE COLUMN `id_tipo` `id_tipo` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT FIRST;

DELETE Evento FROM Evento 
LEFT JOIN Tipo_evento ON Evento.Id_tipo_evento = Tipo_evento.id_tipo
WHERE Tipo_evento.id_tipo IS NULL; 

ALTER TABLE `evento`
	ADD CONSTRAINT `Evento_tipo_evento` FOREIGN KEY (`Id_tipo_evento`) REFERENCES `tipo_evento` (`id_tipo`);
