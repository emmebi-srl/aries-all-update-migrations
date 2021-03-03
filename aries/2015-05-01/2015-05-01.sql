DROP PROCEDURE IF EXISTS sp_tknRefreshTokenExists;
DELIMITER &&
CREATE PROCEDURE `sp_tknRefreshTokenExists`(IN `id_token` INT, OUT `FlagFind` INT)
BEGIN
  SET @rowno = 0;
  
  SELECT @rowno+1 into @rowno FROM TokenRefresh WHERE TokenRefresh.id_token=id_token;
  
  IF @rowno = 0 then
    SET FlagFind=@rowno;
  ELSE
    DELETE FROM TokenRefresh Where TokenRefresh.id_token=id_token;
    SET FlagFind=@rowno;
  end if;

END && 
DELIMITER;

ALTER TABLE `tokenrefresh`
	DROP FOREIGN KEY `FK_TokenRefresh_id_utente`;
