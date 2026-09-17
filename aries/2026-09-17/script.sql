INSERT INTO `cliente_promemoria_segnaposto`
  (`id_cliente_promemoria_configurazione`, `nome`, `descrizione`)
VALUES
  (8, '{report_group_total_price}', 'Prezzo totale resoconto')
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);

INSERT INTO `cliente_promemoria_segnaposto`
  (`id_cliente_promemoria_configurazione`, `nome`, `descrizione`)
VALUES
  (9, '{quote_total_price}', 'Prezzo totale preventivo')
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);

INSERT INTO `campagna_aries_segnaposto`
  (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
SELECT
  '7ee24bc2-4f3f-4536-9b76-65c560aec008',
  `id`,
  'quote_total_price',
  'Prezzo totale preventivo',
  ''
FROM `tipo_campagna_aries`
WHERE `rif_applicazione` = 'quotes_monitoring'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);

INSERT INTO `campagna_aries_segnaposto`
  (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
SELECT
  '9f0b92fa-58dc-4b65-a6c0-df38f7bc4e08',
  `id`,
  'report_group_total_price',
  'Prezzo totale resoconto',
  ''
FROM `tipo_campagna_aries`
WHERE `rif_applicazione` = 'report_group_reminders'
LIMIT 1
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);
