ALTER TABLE `tipo_magazzino`
	ADD COLUMN `disabilitato` BIT NOT NULL DEFAULT b'0' AFTER `reso`;

ALTER TABLE `fornitore_listino`
	DROP FOREIGN KEY `fornitore_listino_ibfk_3`,
	DROP FOREIGN KEY `fornitore_listino_ibfk_4`;
ALTER TABLE `fornitore_listino`
	ADD CONSTRAINT `FK_fornitore_listino_acquisto` FOREIGN KEY (`acquisto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fornitore_listino_netto` FOREIGN KEY (`netto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fornitore_listino_speciale` FOREIGN KEY (`Speciale`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fornitore_listino_ultimo` FOREIGN KEY (`ultimo`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `fornitore_listino`
	DROP FOREIGN KEY `FK_fornitore_listino_acquisto`,
	DROP FOREIGN KEY `FK_fornitore_listino_netto`,
	DROP FOREIGN KEY `FK_fornitore_listino_speciale`,
	DROP FOREIGN KEY `FK_fornitore_listino_ultimo`;
ALTER TABLE `fornitore_listino`
	ADD CONSTRAINT `FK_fornitore_listino_acquisto` FOREIGN KEY (`acquisto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fornitore_listino_netto` FOREIGN KEY (`netto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fornitore_listino_speciale` FOREIGN KEY (`Speciale`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fornitore_listino_ultimo` FOREIGN KEY (`ultimo`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT;




DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE V_ragione_sociale VARCHAR(200);
	DECLARE V_id_fornitore INT(11);
	DECLARE V_acquisto INT(11);
	DECLARE V_netto INT(11);
	DECLARE V_speciale INT(11);
	DECLARE V_ultimo INT(11);
	DECLARE price_name VARCHAR(150);
	DECLARE net_name VARCHAR(150);
	DECLARE last_name VARCHAR(150);
	DECLARE special_name VARCHAR(150);
	DECLARE V_curA CURSOR FOR SELECT fornitore.id_fornitore, ragione_sociale,
		acquisto, netto, speciale, ultimo
	FROM fornitore
	INNER JOIN fornitore_listino ON fornitore.id_fornitore = fornitore_listino.id_fornitore;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_fornitore, V_ragione_sociale, V_acquisto, V_netto, V_speciale, V_ultimo;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		SET price_name = CONCAT(V_id_fornitore,substring(V_ragione_sociale,1,8),"Prezzo");
		SET net_name = CONCAT(V_id_fornitore,substring(V_ragione_sociale,1,8),"Netto");
		SET last_name = CONCAT(V_id_fornitore,substring(V_ragione_sociale,1,8),"Ultimo");
		SET special_name = CONCAT(V_id_fornitore,substring(V_ragione_sociale,1,8),"Speciale");

		UPDATE listino SET Nome = price_name WHERE id_listino = V_acquisto;
		UPDATE listino SET Nome = net_name WHERE id_listino = V_netto;
		UPDATE listino SET Nome = last_name WHERE id_listino = V_ultimo;
		UPDATE listino SET Nome = special_name WHERE id_listino = V_speciale;

	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;
