DROP PROCEDURE IF EXISTS sp_mobileGetAriesCallInformations;
DELIMITER //
CREATE PROCEDURE `sp_mobileGetAriesCallInformations`(IN `DateLastExecution` DATETIME)
	
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

	DROP TEMPORARY TABLE IF EXISTS TempCustomerSubscribers;
	CREATE TEMPORARY TABLE TempCustomerSubscribers 
		SELECT c.id_cliente AS IDCostumer,
			c.ragione_sociale AS CompanyName, 
			IF(ia.id_impianto IS NOT NULL, true, false) AS IsSubscriber
		FROM clienti AS c
			INNER JOIN impianto AS i ON i.id_cliente = c.id_cliente
			LEFT JOIN impianto_abbonamenti AS ia ON ia.anno = YEAR(CURDATE()) 
				AND ia.data_ultima_modifica >= DateLastExecution
			AND i.id_impianto = ia.id_impianto
				
		GROUP BY C.ID_Cliente;
	
	DROP TEMPORARY TABLE IF EXISTS TempCustomerSubscriberUnsolved;
	CREATE TEMPORARY TABLE TempCustomerSubscriberUnsolved 
		SELECT c.id_cliente AS IDCostumer, 
			c.ragione_sociale AS CompanyName,
			IF(vw_mobileinvoicesoutstanding.id_cliente IS NOT NULL, TRUE, FALSE) AS IsUnsolved,
			IF(IsSubscriber = TRUE, TRUE, FALSE) AS IsSubscriber
		FROM clienti AS c
			LEFT JOIN vw_mobileinvoicesoutstanding ON vw_mobileinvoicesoutstanding.id_cliente = c.id_cliente
			LEFT JOIN TempCustomerSubscribers ON TempCustomerSubscribers.idcostumer = c.id_cliente
		WHERE vw_mobileinvoicesoutstanding.id_cliente IS NOT NULL 
			OR TempCustomerSubscribers.idcostumer IS NOT NULL;
	
	SELECT CompanyName,
		riferimento_clienti.Nome AS ReferenceType,
		IsUnsolved,
		IsSubscriber,
		Telefono AS Phone, 
		Altro_Telefono AS MobilePhone 
	FROM TempCustomerSubscriberUnsolved 
		INNER JOIN Riferimento_Clienti ON idcostumer = id_cliente
			AND Riferimento_Clienti.`mod` >= DateLastExecution 
	WHERE ((Telefono IS NOT NULL AND telefono <> '')
		OR (altro_telefono IS NOT NULL AND altro_telefono <> ''));

END //
DELIMITER ;

DROP TABLE IF EXISTS `tablet_posizioni`;
CREATE TABLE `tablet_posizioni` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_tablet` INT(11) NOT NULL DEFAULT '0',
	`posizione` POINT NOT NULL,
	`data_rilevazione` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`sorgente_rilevazione` TINYINT(4) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `id_tablet` (`id_tablet`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

DROP PROCEDURE IF EXISTS `sp_mobileAddTechnicianGPSCoordinates`;
DELIMITER //
CREATE DEFINER=`root`@`%` PROCEDURE `sp_mobileAddTechnicianGPSCoordinates`(IN `MACAddress` VARCHAR(17), IN `Latitude` DOUBLE, IN `Longitude` DOUBLE, IN `DetectionDate` DATETIME, IN `DetectionSource` TINYINT, OUT `SuccessfullInsert` BIT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	DECLARE TabletId INT;
	SELECT Id INTO TabletId FROM Tablet WHERE tablet.mec_address=MACAddress;
	IF TabletId IS NULL
	THEN
		SELECT 0 INTO SuccessfullInsert;
	ELSE
		INSERT INTO tablet_posizioni (id_tablet, posizione, Data_Rilevazione, Sorgente_Rilevazione) 
			VALUES (TabletId,POINT(Latitude, Longitude), DetectionDate, DetectionSource);
		SELECT ROW_COUNT() INTO SuccessfullInsert;
	END IF;
END //
DELIMITER ;
