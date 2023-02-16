CREATE TABLE `magazzino_operazione_sorgente` (
	`id` INT NOT NULL,
	`nome` VARCHAR(100) NOT NULL DEFAULT '',
	`attivo` BIT NULL DEFAULT 1,
	`data_ins` TIMESTAMP NULL DEFAULT NOW(),
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
;


INSERT INTO magazzino_operazione_sorgente VALUES
(1, 'Manuale Aries', 1, NOW()),
(2, 'Rapporto', 1, NOW()),
(3, 'DDT', 1, NOW()),
(4, 'Trasferimento Magazzini', 1, NOW()),
(5, 'Manuale Aries Mobile', 1, NOW()),
(6, 'Fattura Fornitore', 1, NOW()),
(7, 'Fattura', 1, NOW()),
(8, 'DDT Ricevuti', 1, NOW());


INSERT INTO magazzino_operazione_sorgente VALUES
(9, 'Lista di Prelievo', 1, NOW());

ALTER TABLE `magazzino_operazione`
	CHANGE COLUMN `sorgente` `sorgente` INT NULL DEFAULT NULL COMMENT '1 = manuale | 2 = rapporto  | 3 = ddt | 4 = traferimento magazzini | 5 = manuale da mobile | 6 fatt forn | 7 fattura | 8 ddt ricevuto' AFTER `id_magazzino`,
	ADD CONSTRAINT `FK_magazzino_operazione_sorgente` FOREIGN KEY (`sorgente`) REFERENCES `magazzino_operazione_sorgente` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE `magazzino_operazione`
	CHANGE COLUMN `sorgente` `sorgente` INT(11) NOT NULL COMMENT '1 = manuale | 2 = rapporto  | 3 = ddt | 4 = traferimento magazzini | 5 = manuale da mobile | 6 fatt forn | 7 fattura | 8 ddt ricevuto' AFTER `id_magazzino`;




UPDATE `utente_roles` SET `max_utenti_assegnabili`='5' WHERE `app_name`='aries_admin';


INSERT IGNORE INTO `utente_utente_roles` (id_utente, id_utente_roles) VALUES 
(
	(SELECT id_utente FROM utente where nome = 'admin'), 
	(SELECT id FROM utente_roles WHERE `app_name`='aries_admin')
);


INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `pdf`, `fax`, `stampa`, `anteprima`, `Attivo`, `Data_mod`) VALUES ('21', 'MOVIMENTI', '2', b'0', b'1', b'0', b'1', b'1', b'1', '2023-02-15 08:44:30');

INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES ('2', '21', '2', '2016-12-10 07:54:04');