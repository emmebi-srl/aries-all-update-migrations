ALTER TABLE `tipo_magazzino`
	ADD COLUMN `disabilitato` BIT NOT NULL DEFAULT b'0' AFTER `reso`;
