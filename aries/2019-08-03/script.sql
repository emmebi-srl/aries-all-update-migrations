CREATE TABLE `xml_caratteri_speciali_replacement` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`search_string` VARCHAR(50) NOT NULL,
	`replace_string` VARCHAR(50) NOT NULL,
	`is_regexp` BIT NOT NULL,
	`enabled` BIT NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `search_string` (`search_string`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO xml_caratteri_speciali_replacement (search_string, replace_string, is_regexp, enabled)
    VALUES ("&", "e", 0, 1),
    ("'", "", 0, 1),
    ("\"", "", 0, 1),
    ("<", "minore", 0, 1),
    (">", "maggiore", 0, 1),
    ("%", " per cento", 0, 1),
	("n°", "n.", 0, 1);