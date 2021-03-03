DROP TABLE file_calendario;
ALTER TABLE `ticket`
	CHANGE COLUMN `unique_id` `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `data_promemoria`;
