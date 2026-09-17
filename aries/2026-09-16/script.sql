SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'campagna_aries_mail'
  AND `COLUMN_NAME` = 'tipo_documento';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD COLUMN `tipo_documento` VARCHAR(30) NULL DEFAULT NULL AFTER `revisione_documento`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE campagna_aries_mail campaignMail
INNER JOIN campagna_aries campaign
  ON campaign.id = campaignMail.id_campagna_aries
INNER JOIN tipo_campagna_aries campaignType
  ON campaignType.id = campaign.id_tipo_campagna
SET campaignMail.tipo_documento = CASE campaignType.rif_applicazione
  WHEN 'quotes_monitoring' THEN 'sollecito_preventivo'
  WHEN 'report_group_reminders' THEN 'sollecito_resoconto'
  ELSE campaignMail.tipo_documento
END
WHERE campaignMail.tipo_documento IS NULL
  AND campaignType.rif_applicazione IN (
    'quotes_monitoring',
    'report_group_reminders'
  );

UPDATE mail
INNER JOIN campagna_aries_mail campaignMail
  ON campaignMail.id_mail = mail.Id
SET mail.Tipo_documento = campaignMail.tipo_documento
WHERE campaignMail.tipo_documento IS NOT NULL
  AND campaignMail.tipo_documento <> '';

DROP PROCEDURE IF EXISTS sp_ariesEmailSetDocumentStatus;
DELIMITER //
CREATE PROCEDURE `sp_ariesEmailSetDocumentStatus`(
  IN `email_id` INT(11)
)
BEGIN
  DECLARE DocumentType VARCHAR(30);
  DECLARE DocumentId VARCHAR(10);
  DECLARE DocumentYear VARCHAR(10);
  DECLARE DocumentReview VARCHAR(10);
  DECLARE StatusId INT(11);
  DECLARE EmailSendDate DATETIME;
  DECLARE SystemId INT(11);
  DECLARE ReminderNumber TINYINT;

  SELECT
    mail.Tipo_documento,
    mail.Id_documento,
    mail.Anno_documento,
    mail.Revisione_documento,
    mail.Id_stato,
    mail.Data_invio
  INTO
    DocumentType,
    DocumentId,
    DocumentYear,
    DocumentReview,
    StatusId,
    EmailSendDate
  FROM mail
  WHERE Id = email_id;

  IF (DocumentType IS NOT NULL)
    AND (StatusId = 1
      OR DocumentType = 'rapporto_mobile_intervento'
      OR DocumentType = 'rapporto_mobile_collaudo') THEN

    IF DocumentType = 'prev' THEN
      UPDATE revisione_preventivo
      SET inviato = 1
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND id_revisione = DocumentReview;

      UPDATE preventivo
      SET stato = 3,
          data_invio = CURDATE()
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND stato IN (5, 6);
    END IF;

    IF DocumentType = 'sollecito_preventivo'
      AND DocumentId IS NOT NULL
      AND NOT EXISTS (
        SELECT 1
        FROM campagna_aries_mail
        WHERE id_mail = email_id
      ) THEN
      UPDATE preventivo
      SET secondo_sollecito = NOW()
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND primo_sollecito IS NOT NULL;

      UPDATE preventivo
      SET primo_sollecito = NOW()
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND primo_sollecito IS NULL;
    END IF;

    IF DocumentType = 'fatt' THEN
      UPDATE fattura
      SET inviato = 1
      WHERE id_fattura = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'tk' THEN
      SELECT IFNULL(Id_impianto, -1)
      INTO SystemId
      FROM Ticket
      WHERE Id = DocumentId;

      UPDATE ticket
      SET Stato_ticket = 2,
          inviato = 1
      WHERE id_impianto = SystemId;
    END IF;

    IF DocumentType = 'COMMESSA' THEN
      UPDATE commessa
      SET inv_com = 1
      WHERE id_commessa = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'reso' THEN
      UPDATE resoconto
      SET inviato = 1,
          data_invio = COALESCE(EmailSendDate, NOW())
      WHERE id_resoconto = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'ordine' THEN
      UPDATE ordine_fornitore
      SET inviato = 1
      WHERE id_Ordine = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'fatt1' THEN
      UPDATE fattura
      SET inviato = 1
      WHERE id_fattura = DocumentId
        AND anno = DocumentYear;

      UPDATE clienti
      SET rc = 1
      WHERE id_cliente = (
        SELECT id_cliente
        FROM fattura
        WHERE id_fattura = DocumentId
          AND anno = DocumentYear
      );
    END IF;

    IF DocumentType = 'rapporto_mobile_intervento' THEN
      UPDATE rapporto_mobile
      SET inviato = 1
      WHERE Id_rapporto = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'rapporto_mobile_collaudo' THEN
      UPDATE rapporto_mobile_collaudo
      SET inviato = 1
      WHERE Id_rapporto = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'cliente_estratto_conto' AND DocumentId IS NOT NULL THEN
      CALL sp_ariesCustomerInvoicesStatementInsert(email_id, DocumentId);
    END IF;
  END IF;
END//
DELIMITER ;
