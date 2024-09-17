
CREATE TABLE `stato_promemoria_cliente` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(100) NOT NULL,
	`colore` VARCHAR(25) NOT NULL,
	`data_ins` TIMESTAMP NOT NULL DEFAULT NOW(),
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
;


INSERT INTO stato_promemoria_cliente (nome, colore) values ('DA GESTIRE', '$FF0000'), ('DA INVIARE', '$C0C0C0'), ('INVIATO', '$00FFFF'), ('COMPLETATO', '$00FF00'), ('ANNULLATO', '$000080');

ALTER TABLE `ticket`
	ADD COLUMN `id_stato_promemoria` INT NOT NULL DEFAULT 1 AFTER `data_ultimo_promemoria`,
	ADD CONSTRAINT `FK_ticket_stato_promemoria_cliente` FOREIGN KEY (`id_stato_promemoria`) REFERENCES `stato_promemoria_cliente` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `impianto_componenti`
	ADD COLUMN `id_stato_promemoria`  INT NOT NULL DEFAULT 1 AFTER `data_ultimo_promemoria`,
	ADD CONSTRAINT `FK_impianto_componenti_stato_promemoria_cliente` FOREIGN KEY (`id_stato_promemoria`) REFERENCES `stato_promemoria_cliente` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `impianto_abbonamenti_mesi`
	ADD COLUMN `id_stato_promemoria`  INT NOT NULL DEFAULT 1 AFTER `data_ultimo_promemoria`,
	ADD CONSTRAINT `FK_impianto_abbonamenti_mesi_stato_promemoria_cliente` FOREIGN KEY (`id_stato_promemoria`) REFERENCES `stato_promemoria_cliente` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `impianto`
	ADD COLUMN `id_stato_promemoria_garanzia`  INT NOT NULL DEFAULT 1 AFTER `data_ultimo_promemoria_garanzia`,
	ADD CONSTRAINT `FK_impianto_stato_promemoria_garanzia_cliente` FOREIGN KEY (`id_stato_promemoria_garanzia`) REFERENCES `stato_promemoria_cliente` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `impianto_ricarica_tipo`
	ADD COLUMN `id_stato_promemoria`  INT NOT NULL DEFAULT 1 AFTER `data_ultimo_promemoria`,
	ADD CONSTRAINT `FK_impianto_ricarica_tipo_stato_promemoria_cliente` FOREIGN KEY (`id_stato_promemoria`) REFERENCES `stato_promemoria_cliente` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;


UPDATE ticket SET id_stato_promemoria = 2 WHERE richiedi_invio_promemoria = 1 AND data_ultimo_promemoria IS NULL;
UPDATE ticket SET id_stato_promemoria = 3 WHERE data_ultimo_promemoria IS NOT NULL;

UPDATE impianto_componenti SET id_stato_promemoria = 2 WHERE richiedi_invio_promemoria = 1 AND data_ultimo_promemoria IS NULL;
UPDATE impianto_componenti SET id_stato_promemoria = 3 WHERE data_ultimo_promemoria IS NOT NULL;

UPDATE impianto_abbonamenti_mesi SET id_stato_promemoria = 2 WHERE richiedi_invio_promemoria = 1 AND data_ultimo_promemoria IS NULL;
UPDATE impianto_abbonamenti_mesi SET id_stato_promemoria = 3 WHERE data_ultimo_promemoria IS NOT NULL;

UPDATE impianto SET id_stato_promemoria_garanzia = 2 WHERE richiedi_invio_promemoria_garanzia = 1 AND data_ultimo_promemoria_garanzia IS NULL;
UPDATE impianto SET id_stato_promemoria_garanzia = 3 WHERE data_ultimo_promemoria_garanzia IS NOT NULL;

UPDATE impianto_ricarica_tipo SET id_stato_promemoria = 2 WHERE richiedi_invio_promemoria = 1 AND data_ultimo_promemoria IS NULL;
UPDATE impianto_ricarica_tipo SET id_stato_promemoria = 3 WHERE data_ultimo_promemoria IS NOT NULL;

ALTER TABLE `stato_promemoria_cliente`
	ADD COLUMN `rif_applicazioni` VARCHAR(50) NOT NULL AFTER `colore`;


UPDATE stato_promemoria_cliente SET rif_applicazioni = 'to_handle' where id = 1;
UPDATE stato_promemoria_cliente SET rif_applicazioni = 'to_send' where id = 2;
UPDATE stato_promemoria_cliente SET rif_applicazioni = 'sent' where id = 3;
UPDATE stato_promemoria_cliente SET rif_applicazioni = 'completed' where id = 4;
UPDATE stato_promemoria_cliente SET rif_applicazioni = 'canceled' where id = 5;


ALTER TABLE `ticket`
	DROP COLUMN `richiedi_invio_promemoria`;

ALTER TABLE `impianto_componenti`
	DROP COLUMN `richiedi_invio_promemoria`;

ALTER TABLE `impianto_abbonamenti_mesi`
	DROP COLUMN `richiedi_invio_promemoria`;

ALTER TABLE `impianto`
	DROP COLUMN `richiedi_invio_promemoria_garanzia`;

ALTER TABLE `impianto_ricarica_tipo`
	DROP COLUMN `richiedi_invio_promemoria`;
