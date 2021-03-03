CREATE DATABASE IF NOT EXISTS `global_translation`; 

use global_translation; 
DROP TABLE IF EXISTS  projects; 
CREATE TABLE `projects` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`description` VARCHAR(50) NOT NULL,
	`enabled` BIT(1) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `description` (`description`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS  language; 
CREATE TABLE IF NOT EXISTS `language` (
	`id` INT NOT NULL AUTO_INCREMENT,
	lcid INT NOT NULL,
	parent_lcid INT , 
	`description` VARCHAR(50) NOT NULL,
	`enabled` BIT NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
DROP TABLE IF EXISTS  translation; 
CREATE TABLE IF NOT EXISTS `translation` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`lcid` INT NOT NULL,
	`translation_id` INT NOT NULL,
	`value` TEXT NOT NULL,
	`timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`insertion_operator` VARCHAR(50) NOT NULL,
	`edit_operator` VARCHAR(50),
	PRIMARY KEY (`id`),
	UNIQUE INDEX `lcid_translation_id` (`lcid`, `translation_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
DROP TABLE IF EXISTS  project_translation; 
CREATE TABLE IF NOT EXISTS `project_translation` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`id_translation` INT NOT NULL DEFAULT '0',
	`id_project` INT NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id_project` (`id_project`, `id_translation`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


INSERT INTO projects (description, enabled) VALUES ("Aries", 1);

INSERT INTO language (lcid, description, enabled) VALUES (1040, 'Italian', 1); 

INSERT INTO translation(lcid, translation_id, value, insertion_operator)
VALUES(1040, 1, 'Attenzione, sono stati aggiunti nuovi eventi al tuo calendario!', 'Alex Gola');

INSERT INTO project_translation (id_translation, id_project) VALUES (1, 1); 