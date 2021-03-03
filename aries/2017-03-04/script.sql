ALTER TABLE `tablet_configurazione`
	ADD COLUMN `admin_password` VARCHAR(20) NOT NULL DEFAULT 'admin' AFTER `display_name`,
	ADD COLUMN `messaggio_non_abbonato` TEXT NULL AFTER `admin_password`;
