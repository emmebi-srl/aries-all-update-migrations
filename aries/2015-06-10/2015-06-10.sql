DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp() 
BEGIN

	DECLARE res TINYINT DEFAULT 0;
	
	SELECT COUNT(*) = 0
	INTO res
	FROM information_schema.COLUMNS
	WHERE TABLE_NAME = 'ticket'
		AND TABLE_SCHEMA = DATABASE()
		AND COLUMN_NAME = 'unique_id';

	IF res THEN
		ALTER TABLE `ticket`
		ADD COLUMN `unique_id` INT NOT NULL AUTO_INCREMENT,
		ADD UNIQUE INDEX `unique_id` (`unique_id`);
	END IF;
	
	SELECT COUNT(*) = 0
	INTO res
	FROM information_schema.COLUMNS
	WHERE TABLE_NAME = 'impianto_abbonamenti_mesi'
		AND TABLE_SCHEMA = DATABASE()
		AND COLUMN_NAME = 'unique_id';
	
	IF res THEN
		ALTER TABLE `impianto_abbonamenti_mesi`
		ADD COLUMN `unique_id` INT NOT NULL AUTO_INCREMENT,
		ADD UNIQUE INDEX `unique_id` (`unique_id`);
	END IF;
	
END $$
DELIMITER ;
CALL tmp();
DROP PROCEDURE tmp;

CREATE TABLE IF NOT EXISTS evento_tecnici (
	id_evento INT NOT NULL,
	id_tecnico INT NOT NULL,
	dataora_inizio TIMESTAMP,
	dataora_fine TIMESTAMP,
	PRIMARY KEY(id_evento, id_tecnico),
	FOREIGN KEY (id_evento) REFERENCES evento(id_evento) 
		ON UPDATE CASCADE 
		ON DELETE CASCADE,
	FOREIGN KEY (id_tecnico) REFERENCES operaio(id_operaio) 
		ON UPDATE CASCADE 
		ON DELETE CASCADE
) ENGINE = innoDB;