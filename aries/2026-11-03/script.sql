-- WhatsApp accepts variable names of at most 20 characters when sending a template: a placeholder with a
-- longer name uses this one in the WhatsApp Manager templates. NULL = same name as the placeholder.
ALTER TABLE `campagna_aries_segnaposto`
	ADD COLUMN `override_whatsapp_nome` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Nome della variabile nei template WhatsApp; NULL = nome' AFTER `nome`;

UPDATE `campagna_aries_segnaposto`
SET `override_whatsapp_nome` = 'maintenance_number'
WHERE `nome` = 'subscription_maintenance_number'
	AND `id_tipo_campagna` = (SELECT id FROM tipo_campagna_aries WHERE uuid = '83ddae04-d05b-4211-8df5-76791801a1e6');

UPDATE `campagna_aries_segnaposto`
SET `override_whatsapp_nome` = 'maintenance_price'
WHERE `nome` = 'subscription_maintenance_price'
	AND `id_tipo_campagna` = (SELECT id FROM tipo_campagna_aries WHERE uuid = '83ddae04-d05b-4211-8df5-76791801a1e6');
