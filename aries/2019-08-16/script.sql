ALTER TABLE `fattura_pagamenti`
	ADD COLUMN `id_prima_nota` INT NULL DEFAULT NULL AFTER `insoluto`,
	ADD CONSTRAINT `FK_fattura_pagamenti_prima_nota` FOREIGN KEY (`id_prima_nota`) REFERENCES `prima_nota` (`Id_prima_nota`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `fornfattura_pagamenti`
	ADD COLUMN `id_prima_nota` INT NULL DEFAULT NULL AFTER `insoluto`,
	ADD CONSTRAINT `FK_fornfattura_pagamenti_prima_nota` FOREIGN KEY (`id_prima_nota`) REFERENCES `prima_nota` (`Id_prima_nota`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `fattura_pagamenti`
	ADD COLUMN `id_trasferimento_verso` INT NULL DEFAULT NULL AFTER `id_prima_nota`,
	ADD CONSTRAINT `FK_fattura_pagamenti_prima_nota_trasf` FOREIGN KEY (`id_trasferimento_verso`) REFERENCES `prima_nota` (`Id_prima_nota`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `fornfattura_pagamenti`
	ADD COLUMN `id_trasferimento_verso` INT NULL DEFAULT NULL AFTER `id_prima_nota`,
	ADD CONSTRAINT `FK_fornfattura_pagamenti_prima_nota_trasf` FOREIGN KEY (`id_trasferimento_verso`) REFERENCES `prima_nota` (`Id_prima_nota`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `fattura_pagamenti`
	DROP FOREIGN KEY `FK_fattura_pagamenti_prima_nota_trasf`,
	DROP FOREIGN KEY `FK_fattura_pagamenti_prima_nota`;
ALTER TABLE `fattura_pagamenti`
	ADD COLUMN `anno_prima_nota` INT(11) NULL DEFAULT NULL AFTER `id_prima_nota`,
	ADD COLUMN `anno_trasferimento_verso` INT(11) NULL DEFAULT NULL AFTER `id_trasferimento_verso`,
	ADD CONSTRAINT `FK_fattura_pagamenti_prima_nota_trasf` FOREIGN KEY (`id_trasferimento_verso`, `anno_trasferimento_verso`) REFERENCES `prima_nota` (`Id_prima_nota`, `anno`) ON UPDATE CASCADE ON DELETE SET NULL,
	ADD CONSTRAINT `FK_fattura_pagamenti_prima_nota` FOREIGN KEY (`id_prima_nota`, `anno_prima_nota`) REFERENCES `prima_nota` (`Id_prima_nota`, `anno`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `fornfattura_pagamenti`
	DROP FOREIGN KEY `FK_fornfattura_pagamenti_prima_nota_trasf`,
	DROP FOREIGN KEY `FK_fornfattura_pagamenti_prima_nota`;
ALTER TABLE `fornfattura_pagamenti`
	ADD COLUMN `anno_prima_nota` INT(11) NULL DEFAULT NULL AFTER `id_prima_nota`,
	ADD COLUMN `anno_trasferimento_verso` INT(11) NULL DEFAULT NULL AFTER `id_trasferimento_verso`,
	ADD CONSTRAINT `FK_fornfattura_pagamenti_prima_nota_trasf` FOREIGN KEY (`id_trasferimento_verso`, `anno_trasferimento_verso`) REFERENCES `prima_nota` (`Id_prima_nota`, `anno`) ON UPDATE CASCADE ON DELETE SET NULL,
	ADD CONSTRAINT `FK_fornfattura_pagamenti_prima_nota` FOREIGN KEY (`id_prima_nota`, `anno_prima_nota`) REFERENCES `prima_nota` (`Id_prima_nota`, `anno`) ON UPDATE CASCADE ON DELETE SET NULL;

DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN


	DECLARE done INT DEFAULT 0;
	DECLARE V_id_prima_nota_transfer INT;
	DECLARE V_anno_prima_nota_transfer INT;
	DECLARE V_transfer_counter INT;
	DECLARE V_id_prima_nota INT;
	DECLARE V_anno_prima_nota INT;
	DECLARE V_id_fattura INT;
	DECLARE V_anno_fattura INT;
	DECLARE V_spesa INT;
	DECLARE V_data DATE;
	DECLARE V_id_pagamento INT;
	DECLARE V_transfer_type INT;
	DECLARE V_curA CURSOR FOR SELECT Id_prima_nota, anno, id_fattura,
			anno_fattura, id_pagamento, spesa, data
		FROM prima_nota
		where id_pagamento IS NOT NULL AND id_pagamento <> 0 AND id_fattura IS NOT NULL;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	SELECT id_tipo
	INTO V_transfer_type
	FROM tipo_spesa
	WHERE nome = 'TRASFERIMENTO VERSO';
	
	OPEN V_curA;
	loopA: LOOP
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		FETCH V_curA INTO V_Id_prima_nota, V_anno_prima_nota, V_id_fattura,
			V_anno_fattura, V_id_pagamento, V_spesa, V_data;
		
		UPDATE fattura_pagamenti
		SET id_prima_nota = V_id_prima_nota,
			anno_prima_nota = V_anno_prima_nota
		WHERE id_fattura = V_id_fattura AND anno = V_anno_fattura AND id_pagamento = V_id_pagamento;
		
		SELECT count(id_prima_nota), 
			id_prima_nota,
			anno
		INTO
			V_transfer_counter,
			V_id_prima_nota_transfer,
			V_anno_prima_nota_transfer
		FROM prima_nota
		WHERE spesa = V_spesa AND data = V_data AND tipo_spesa = V_transfer_type;
		
		If V_transfer_counter = 1 then
			UPDATE fattura_pagamenti
			SET id_trasferimento_verso = V_id_prima_nota_transfer,
				anno_trasferimento_verso = V_anno_prima_nota_transfer
			WHERE id_fattura = V_id_fattura
				AND anno = V_anno_fattura
				AND id_pagamento = V_id_pagamento;
		END IF;
		
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;

DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN


	DECLARE done INT DEFAULT 0;
	DECLARE V_id_prima_nota_transfer INT;
	DECLARE V_anno_prima_nota_transfer INT;
	DECLARE V_transfer_counter INT;
	DECLARE V_id_prima_nota INT;
	DECLARE V_anno_prima_nota INT;
	DECLARE V_id_fattura INT;
	DECLARE V_anno_fattura INT;
	DECLARE V_spesa INT;
	DECLARE V_data DATE;
	DECLARE V_id_pagamento INT;
	DECLARE V_transfer_type INT;
	DECLARE V_curA CURSOR FOR SELECT Id_prima_nota, anno, id_fornfattura,
			anno_fornfattura, id_pagamento, spesa, data
		FROM prima_nota
		where id_pagamento IS NOT NULL AND id_pagamento <> 0 AND id_fornfattura IS NOT NULL;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	SELECT id_tipo
	INTO V_transfer_type
	FROM tipo_spesa
	WHERE nome = 'TRASFERIMENTO VERSO';
	
	OPEN V_curA;
	loopA: LOOP
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		FETCH V_curA INTO V_Id_prima_nota, V_anno_prima_nota, V_id_fattura,
			V_anno_fattura, V_id_pagamento, V_spesa, V_data;
		
		UPDATE fornfattura_pagamenti
		SET id_prima_nota = V_id_prima_nota,
			anno_prima_nota = V_anno_prima_nota
		WHERE id_fattura = V_id_fattura AND anno = V_anno_fattura AND id_pagamento = V_id_pagamento;
		
		SELECT count(id_prima_nota), 
			id_prima_nota,
			anno
		INTO
			V_transfer_counter,
			V_id_prima_nota_transfer,
			V_anno_prima_nota_transfer
		FROM prima_nota
		WHERE spesa = V_spesa AND data = V_data AND tipo_spesa = V_transfer_type;
		
		If V_transfer_counter = 1 then
			UPDATE fornfattura_pagamenti
			SET id_trasferimento_verso = V_id_prima_nota_transfer,
				anno_trasferimento_verso = V_anno_prima_nota_transfer
			WHERE id_fattura = V_id_fattura
				AND anno = V_anno_fattura
				AND id_pagamento = V_id_pagamento;
		END IF;
		
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;

ALTER TABLE `fattura_totali_iva`
	DROP FOREIGN KEY `fk_fattura_totali_fattura`,
	DROP FOREIGN KEY `fk_fattura_totali_id_iva`;
ALTER TABLE `fattura_totali_iva`
	ADD CONSTRAINT `fk_fattura_totali_fattura` FOREIGN KEY (`id_fattura`, `anno`) REFERENCES `fattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `fk_fattura_totali_id_iva` FOREIGN KEY (`id_iva`) REFERENCES `tipo_iva` (`Id_iva`) ON UPDATE CASCADE;
