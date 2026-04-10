ALTER TABLE `tipo_campagna_aries`
    ADD COLUMN `avviso_disiscrizione` TEXT NULL AFTER `rif_applicazione`;
UPDATE `tipo_campagna_aries` SET `avviso_disiscrizione`='Confermando la disiscrizione, l’impianto sarà considerato non abbonato per il futuro, salvo successivi contatti o richieste dirette del cliente.' WHERE  `rif_applicazione`='system_subscription';
