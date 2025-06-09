ALTER TABLE `riferimento_clienti`
	ADD COLUMN `id_pubblico` BINARY(16) NULL AFTER `Id`,
	ADD UNIQUE INDEX `unique_id_pubblico` (`id_pubblico`);
	
ALTER TABLE `riferimento_clienti`
	CHANGE COLUMN `id_pubblico` `id_pubblico` CHAR(36) NULL DEFAULT NULL AFTER `Id`;

UPDATE riferimento_clienti
SET id_pubblico = UUID();


ALTER TABLE `riferimento_fornitore`
	ADD COLUMN `id_pubblico` BINARY(16) NULL FIRST,
	ADD UNIQUE INDEX `unique_id_pubblico` (`id_pubblico`);
	
ALTER TABLE `riferimento_fornitore`
	CHANGE COLUMN `id_pubblico` `id_pubblico` CHAR(36) NULL DEFAULT NULL FIRST;

UPDATE riferimento_fornitore
SET id_pubblico = UUID();


	
ALTER TABLE `operaio`
	ADD COLUMN `id_pubblico` BINARY(16) NULL AFTER id_operaio,
	ADD UNIQUE INDEX `unique_id_pubblico` (`id_pubblico`);
	
ALTER TABLE `operaio`
	CHANGE COLUMN `id_pubblico` `id_pubblico` CHAR(36) NULL DEFAULT NULL AFTER id_operaio;

UPDATE operaio
SET id_pubblico = UUID();
