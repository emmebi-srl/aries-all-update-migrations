ALTER TABLE `campagna_aries_mail`
    ADD COLUMN `data_prevista_invio` DATETIME NULL AFTER `mail`;

UPDATE `campagna_aries_mail`
SET `data_prevista_invio` = IFNULL(`data_invio`, NOW())
WHERE `data_prevista_invio` IS NULL;

ALTER TABLE `campagna_aries_mail`
    MODIFY COLUMN `data_prevista_invio` DATETIME NOT NULL,
    MODIFY COLUMN `data_invio` DATETIME NULL;
