SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'resoconto'
  AND `COLUMN_NAME` = 'data_invio';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `resoconto` ADD COLUMN `data_invio` DATETIME NULL DEFAULT NULL AFTER `inviato`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE `resoconto`
INNER JOIN (
  SELECT
    CAST(`Id_documento` AS UNSIGNED) AS `id_resoconto`,
    CAST(`Anno_documento` AS UNSIGNED) AS `anno_resoconto`,
    MAX(`Data_invio`) AS `data_invio`
  FROM `mail`
  WHERE `Tipo_documento` = 'reso'
    AND `Id_documento` IS NOT NULL
    AND `Anno_documento` IS NOT NULL
    AND `Id_stato` = 1
    AND `Data_invio` IS NOT NULL
  GROUP BY
    CAST(`Id_documento` AS UNSIGNED),
    CAST(`Anno_documento` AS UNSIGNED)
) AS `ultima_mail_resoconto`
  ON `ultima_mail_resoconto`.`id_resoconto` = `resoconto`.`id_resoconto`
  AND `ultima_mail_resoconto`.`anno_resoconto` = `resoconto`.`anno`
SET `resoconto`.`data_invio` = `ultima_mail_resoconto`.`data_invio`
WHERE `resoconto`.`data_invio` IS NULL;

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

DROP PROCEDURE IF EXISTS sp_apiReportGroupGetToRemind;
DELIMITER //
CREATE PROCEDURE `sp_apiReportGroupGetToRemind`(
  IN maximum_reminder_count INT(11),
  IN reminder_window_days INT(11)
)
BEGIN
  SELECT
    resoconto.`id_resoconto`,
    resoconto.`anno`,
    resoconto.`data`,
    resoconto.`Descrizione`,
    resoconto.`Numero_ordine`,
    resoconto.`Id_cliente`,
    stato_resoconto.`Id_stato` AS `id_stato_resoconto`,
    stato_resoconto.`nome` AS `stato_resoconto`,
    resoconto.`Nota`,
    resoconto.`fattura`,
    resoconto.`anno_fattura`,
    resoconto.`id_utente`,
    tipo_resoconto.`id_tipo` AS `id_tipo_resoconto`,
    tipo_resoconto.`nome` AS `tipo_resoconto`,
    IFNULL(resoconto.`inviato`, 0) AS `inviato`,
    resoconto.`data_invio`,
    resoconto.`nota_fine`,
    IFNULL(resoconto.`stm`, 0) AS `stm`,
    resoconto.`fat_SpeseRap`,
    resoconto_totali.`prezzo_manutenzione`,
    resoconto_totali.`costo_manutenzione`,
    resoconto_totali.`costo_diritto_chiamata`,
    resoconto_totali.`prezzo_diritto_chiamata`,
    resoconto_totali.`costo_lavoro`,
    resoconto_totali.`prezzo_lavoro`,
    resoconto_totali.`costo_viaggio`,
    resoconto_totali.`prezzo_viaggio`,
    resoconto_totali.`costo_materiale`,
    resoconto_totali.`prezzo_materiale`,
    resoconto_totali.`costo_totale`,
    resoconto_totali.`prezzo_totale`,
    resoconto.`promemoria_inviato`,
    resoconto.`data_invio_promemoria`,
    COALESCE(resoconto.`numero_promemoria_inviati`, 0) AS `numero_promemoria_inviati`
  FROM resoconto
  INNER JOIN resoconto_totali
    ON resoconto.id_resoconto = resoconto_totali.id_resoconto
    AND resoconto.anno = resoconto_totali.anno
  INNER JOIN stato_resoconto
    ON resoconto.stato = stato_resoconto.id_stato
  INNER JOIN tipo_resoconto
    ON resoconto.tipo_resoconto = tipo_resoconto.id_tipo
  WHERE resoconto.inviato = 1
    AND resoconto.data_invio IS NOT NULL
    AND resoconto.stato NOT IN (2, 3, 5, 6, 7)
    AND COALESCE(resoconto.numero_promemoria_inviati, 0) < maximum_reminder_count
    AND CURRENT_DATE BETWEEN
      DATE(TIMESTAMPADD(
        MONTH,
        COALESCE(resoconto.numero_promemoria_inviati, 0) + 1,
        resoconto.data_invio
      ))
      AND DATE(TIMESTAMPADD(
        DAY,
        reminder_window_days,
        TIMESTAMPADD(
          MONTH,
          COALESCE(resoconto.numero_promemoria_inviati, 0) + 1,
          resoconto.data_invio
        )
      ));
END//
DELIMITER ;
