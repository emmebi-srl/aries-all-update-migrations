CREATE TABLE `cliente_estratto_conto` (
	`id` INT NOT NULL,
	`id_cliente` INT NOT NULL,
	`id_email` INT NOT NULL,
	`data_ins` TIMESTAMP NOT NULL,
	`utente_ins` INT NOT NULL,
	PRIMARY KEY (`id_cliente_estratto_conto`),
	CONSTRAINT `FK_cliente_estratto_conto_clienti` FOREIGN KEY (`id_cliente`) REFERENCES `clienti` (`Id_cliente`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT `FK_cliente_estratto_conto_email` FOREIGN KEY (`id_email`) REFERENCES `mail` (`Id`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT `FK_cliente_estratto_conto_utente` FOREIGN KEY (`utente_ins`) REFERENCES `utente` (`Id_utente`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='latin1_swedish_ci'
;

ALTER TABLE `cliente_estratto_conto`
	CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT FIRST;


INSERT INTO cliente_estratto_conto  (id_cliente, id_email, data_ins, utente_ins)
SELECT id_documento, id, Data_ins, utente_ins 
FROM mail
WHERE mail.Tipo_documento = 'sollecito_fattura' AND id_documento IS NOT NULL;



UPDATE mail
SET tipo_documento = 'cliente_estratto_conto'
WHERE mail.Tipo_documento = 'sollecito_fattura' AND id_documento IS NOT NULL;

