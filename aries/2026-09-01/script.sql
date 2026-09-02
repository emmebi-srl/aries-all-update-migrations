SET @quote_template_mappings = '[{"predefined_quote_id":1,"purpose":"REVAMPING","source_quote_id":1,"source_quote_year":2026},{"predefined_quote_id":1,"purpose":"NEW_SYSTEM","source_quote_id":2,"source_quote_year":2026},{"predefined_quote_id":2,"purpose":"NEW_SYSTEM","source_quote_id":3,"source_quote_year":2026},{"predefined_quote_id":3,"purpose":"NEW_SYSTEM","source_quote_id":4,"source_quote_year":2026},{"predefined_quote_id":3,"purpose":"REPLACEMENT","source_quote_id":6,"source_quote_year":2026},{"predefined_quote_id":3,"purpose":"PERIODIC_CHECK","source_quote_id":7,"source_quote_year":2026}]';

UPDATE `agente_ai_configurazione`
SET `configurazione_json` = CASE
    WHEN `configurazione_json` IS NULL
        OR TRIM(`configurazione_json`) = ''
        OR TRIM(`configurazione_json`) = '{}'
    THEN CONCAT('{"quote_template_mappings":', @quote_template_mappings, '}')
    WHEN RIGHT(TRIM(`configurazione_json`), 1) = '}'
    THEN CONCAT(
        LEFT(
            TRIM(`configurazione_json`),
            CHAR_LENGTH(TRIM(`configurazione_json`)) - 1
        ),
        ',"quote_template_mappings":',
        @quote_template_mappings,
        '}'
    )
    ELSE `configurazione_json`
END
WHERE `codice` = 'gestore_rapporti'
  AND (
      `configurazione_json` IS NULL
      OR `configurazione_json` NOT LIKE '%"quote_template_mappings"%'
  );

-- La quinta regola ricevuta duplica esattamente la chiave (3, NEW_SYSTEM)
-- della quarta ma indica il preventivo 5/2026. Non viene attivata finché non
-- è disponibile un criterio distinto, per evitare una selezione non deterministica.
