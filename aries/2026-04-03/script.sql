ALTER TABLE `campagna_aries_mail`
	ADD COLUMN `disiscritto` BIT(1) NOT NULL DEFAULT b'0' AFTER `interagito`;
