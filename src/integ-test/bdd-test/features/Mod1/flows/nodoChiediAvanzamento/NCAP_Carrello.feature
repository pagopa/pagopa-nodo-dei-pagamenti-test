Feature: NCAP

    #TODO: FARE ULTERIORI CHECK SUL MESSAGGIO DI RISPOSTA DELLA nodoChiediAvanzamentoPagamento

    Background:
        Given systems up

    Scenario: Execute nodoInviaCarrelloRPT (Phase 1)
        Given nodo-dei-pagamenti has config parameter useCountChiediAvanzamento set to true
        And nodo-dei-pagamenti has config parameter maxChiediAvanzamento set to 3
        And initial XML nodoInviaCarrelloRPT
        """
        """
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 2)
        Given the Execute nodoInviaCarrelloRPT (Phase 1) scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento is 200
        And check error is ACK_UNKNOWN of avanzamentoPagamento response
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 3)
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 2) scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento is 200
        And check error is ACK_UNKNOWN of avanzamentoPagamento response
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 4)
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 3) scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento is 200
        And check error is KO of avanzamentoPagamento response
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    #[NCAP_Carrello_01]
    Scenario: Execute nodoInoltraPagamento (Phase 5) [NCAP_Carrello_01]
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 4) scenario executed successfully
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_INVIATO_A_PSP, CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoNotificaAnnullamento (Phase 6) [NCAP_Carrello_01]
        Given the Execute nodoInoltraPagamento (Phase 5) [NCAP_Carrello_01] scenario executed successfully
        When WISP sends REST GET notificaAnnullamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento is 200 of notificaAnnullamento response
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_INVIATO_A_PSP, CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And restore initial configurations

    #[NCAP_Carrello_02]
    Scenario: Execute nodoInoltraPagamento (Phase 3) [NCAP_Carrello_02]
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 2) scenario executed successfully
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_INVIATO_A_PSP, CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 4) [NCAP_Carrello_02]
        Given the Execute nodoInoltraPagamento (Phase 3) [NCAP_Carrello_02] scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200

    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 5) [NCAP_Carrello_02]
        Given the Execute nodoInoltraPagamento (Phase 4) [NCAP_Carrello_02] scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200
        And restore initial configurations

    # [NCAP_Carrello_03]
    Scenario: Execute nodoNotificaAnnullamento (Phase 4) [NCAP_Carrello_03]
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 4) scenario executed successfully
        When WISP sends REST GET notificaAnnullamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        And wait 10 seconds for expiration
        Then verify the HTTP status code of notificaAnnullamento response is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_ANNULLATA_WISP, RT_GENERATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1


    Scenario: Execute nodoInoltraEsito (Phase 5) [NCAP_Carrello_03]
        Given the Execute nodoNotificaAnnullamento (Phase 4) [NCAP_Carrello_03] scenario executed successfully
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        """
        Then verify the HTTP status code of inoltroEsito/mod1 is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_ANNULLATA_WISP, RT_GENERATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And restore initial configurations

    #[NCAP_Carrello_04]
    Scenario: Execute nodoNotificaAnnullamento (Phase 3) [NCAP_Carrello_04]
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 2) scenario executed successfully
        When WISP sends REST GET notificaAnnullamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        And wait 10 seconds for expiration
        Then verify the HTTP status code of notificaAnnullamento response is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_ANNULLATA_WISP, RT_GENERATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 4) [NCAP_Carrello_04]
        Given the Execute nodoNotificaAnnullamento (Phase 3) [NCAP_Carrello_04] scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200
        And restore initial configurations

    #[NCAP_Carrello_05]
    Scenario: Execute nodoInoltraEsito (Phase 3) [NCAP_Carrello_05]
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 2) scenario executed successfully
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        """
        Then verify the HTTP status code of inoltroEsito/mod1 is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_INVIATO_A_PSP, CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And restore initial configurations

    #[NCAP_Carrello_06]
    Scenario: Execute nodoInoltraEsito (Phase 3) [NCAP_Carrello_06]
        Given the Execute nodoChiediAvanzamentoPagamento (Phase 2) scenario executed successfully
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        """
        Then verify the HTTP status code of inoltroEsito/mod1 is 200
        # check STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI retrived by the query rpt_stati on db nodo_online under macro Mod1
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table RPT_STATI_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTA_NODO, CART_ACCETTATA_NODO, CART_PARCHEGGIATA_NODO, CART_INVIATO_A_PSP, CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And restore initial configurations

      