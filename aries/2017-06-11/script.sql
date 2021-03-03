TRUNCATE TABLE tipo_checklist_elemento;
INSERT INTO `tipo_checklist_elemento` VALUES (1, 'SI NO NA', NULL, 'toogle_null_confirm');
INSERT INTO `tipo_checklist_elemento` VALUES (2, 'SI NO', NULL, 'toogle_confirm');
INSERT INTO `tipo_checklist_elemento` VALUES (3, 'NOTE', NULL, 'note');
INSERT INTO `tipo_checklist_elemento` VALUES (4, 'INTESTAZIONE', 'CAMPO DI TESTO', 'header');
INSERT INTO `tipo_checklist_elemento` VALUES (5, 'INFO CENTRALE', 'MARCA, MODELLO, POSIZIONE', 'central_info');
INSERT INTO `tipo_checklist_elemento` VALUES (6, 'MASTER/SLAVE', 'MASTER, SLAVE, NOTA', 'master_slave');
INSERT INTO `tipo_checklist_elemento` VALUES (7, 'SPECIFICHE BATTERIE', 'QUANTITA, Ah, MESE, ANNO', 'battery_specifications');
INSERT INTO `tipo_checklist_elemento` VALUES (8, 'MISURE STRUMNETALI', 'TENSIONE BATTERIA A RIPOSO E IN ALLARME', 'instrumental_measures');
INSERT INTO `tipo_checklist_elemento` VALUES (9, 'INFO ALIMENTATORE', 'MARCA, MODELLO, POSIZIONE, Ah', 'power_supply_info');
INSERT INTO `tipo_checklist_elemento` VALUES (10, 'SISTEMA PER ASPIRAZIONE', 'MARCA, MODELLO, POSIZIONE, Ah', 'suction_system');
INSERT INTO `tipo_checklist_elemento` VALUES (11, 'DATA & NOTE', 'DATA E NOTE', 'date_note');
INSERT INTO `tipo_checklist_elemento` VALUES (12, 'REGISTRATORE', 'IP INTERNO, IP ESTRENO, SERIAL NUMBER, PORTE, USERNAME, PASSWORD, PIMG, PEER TO, SNPM VERSIONE', 'recorder');

