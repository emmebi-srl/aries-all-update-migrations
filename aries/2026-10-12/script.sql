-- sp_apiEventSetNotificationStatus received the event ids in a VARCHAR(1000): when many events
-- are waiting to be notified (e.g. after the push service was down), the list was truncated and the
-- dynamic "WHERE Id IN (...)" ended with a trailing comma -> SQL syntax error near ')'.
-- Use MEDIUMTEXT like sp_apiEventSetReminderSent.

DROP PROCEDURE IF EXISTS sp_apiEventSetNotificationStatus;
DELIMITER $$

CREATE PROCEDURE sp_apiEventSetNotificationStatus(
IN idArray MEDIUMTEXT,
IN notificationStatus TINYINT)
BEGIN

  SET @sql = CONCAT('UPDATE Evento
  SET Stato_notifica = ', notificationStatus ,',
  Data_notifica = NOW()
  WHERE Id IN  (',idArray,'); ');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END
$$

DELIMITER ;
-- 1. Anteprima: quanti eventi verrebbero chiusi e da quando sono fermi
SELECT COUNT(*)            AS da_chiudere,
       MIN(Data_mod)       AS piu_vecchio,
       MAX(Data_mod)       AS piu_recente
FROM evento
WHERE Stato_notifica = 1
  AND Data_mod < NOW() - INTERVAL 7 DAY;

-- 2. Aggiornamento: segna come Notified (2) gli eventi ToNotified (1) fermi da più di una settimana
UPDATE evento
SET Stato_notifica = 2,
    Data_notifica  = NOW()
WHERE Stato_notifica = 1
  AND Data_mod < NOW() - INTERVAL 7 DAY;