
DELETE cmp
FROM checklist_model_paragrafo cmp LEFT JOIN checklist_model cm ON 
cmp.id_checklist = cm.id_check
WHERE cm.id_check IS null;

ALTER TABLE `checklist_model_paragrafo`
	ADD CONSTRAINT `FK_checklist_model_paragrafo_checklist_model` FOREIGN KEY (`id_checklist`) REFERENCES `checklist_model` (`id_check`) ON UPDATE CASCADE ON DELETE CASCADE;


DELETE cme
FROM checklist_model_elemento cme LEFT JOIN checklist_model_paragrafo cmp ON 
cmp.id = cme.Id_paragrafo
WHERE cmp.id IS null;

ALTER TABLE `checklist_model_elemento`
	ADD CONSTRAINT `FK_checklist_model_elemento_id_paragrafo` FOREIGN KEY (`Id_paragrafo`) REFERENCES `checklist_model_paragrafo` (`Id`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `checklist_model_elemento`
	ADD CONSTRAINT `FK_checklist_model_elemento_id_check` FOREIGN KEY (`Id_checklist`) REFERENCES `checklist_model` (`Id_check`) ON UPDATE CASCADE ON DELETE  CASCADE;

	

ALTER TABLE `checklist_paragrafo`
	ADD CONSTRAINT `FK_checklist_paragrafo_paragrafo_model` FOREIGN KEY (`id_checklist_model_paragrafo`) REFERENCES `checklist_model_paragrafo` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;
