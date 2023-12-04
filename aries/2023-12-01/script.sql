ALTER TABLE `rapporto_mobile_destinatario`
	ADD COLUMN `id_mail` INT(11) NULL AFTER `tipo_email`,
	ADD CONSTRAINT `FK_rapporto_mobile_destinatario_mail` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`Id`) ON UPDATE CASCADE ON DELETE NO ACTION;

UPDATE rapporto_mobile_destinatario 
	INNER JOIN mail ON  mail.Id_documento = rapporto_mobile_destinatario.id_rapporto AND  mail.anno_documento = rapporto_mobile_destinatario.anno AND mail.tipo_documento IN ('rapporto_mobile_intervento', 'rapporto_mobile_collaudo')
SET rapporto_mobile_destinatario.id_mail = mail.id;


DELETE rmd FROM rapporto_mobile_destinatario rmd
	INNER JOIN rapporto r ON r.Id_rapporto = rmd.id_rapporto  AND r.Anno = rmd.anno
	
WHERE r.id_tipo_rapporto = 1