ALTER TABLE `checklist_model_impianto`
	DROP INDEX `id_checklist_id_impianto`,
	ADD UNIQUE INDEX `id_impianto` (`id_impianto`);
