Feature: T001_CARRELLO_5_RPT

    Background:
        Given systems up

    Scenario: Execute nodoInviaCarrelloRPT - [T001_CARRELLO_5_RPT]
        Given RPT generation
        """"""
        And RT generation
        """"""
        And RPT2 generation
        """"""
        And RT2 generation
        """"""
        And RPT3 generation
        """"""
        And RT3 generation
        """"""
        And RPT4 generation
        """"""
        And RT4 generation
        """"""
        And RPT5 generation
        """"""
        And RT5 generation
        """"""
        And initial XML nodoInviaCarrelloRPT
        """"""
        And initial XML pspChiediListaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspChiediListaRTResponse>
            <pspChiediListaRTResponse>
            <elementoListaRTResponse>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$carrello</codiceContestoPagamento>
            </elementoListaRTResponse>
            </pspChiediListaRTResponse>
            </ws:pspChiediListaRTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspChiediRT
            """
            <soapenv:Envelope
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspChiediRTResponse>
            <pspChiediRTResponse>
            <rt>$rtAttachment</rt>
            </pspChiediRTResponse>
            </ws:pspChiediRTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaCarrelloRPTResponse>
            <pspInviaCarrelloRPTResponse>
            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
            <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
            </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
            And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
            And PSP replies to nodo-dei-pagamenti with the pspChiediRT
            And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
            When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
            And job pspChiediListaAndChiediRt triggered after 5 seconds
            And job paInviaRt triggered after 10 seconds
            And wait 10 seconds for expiration
            Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
            And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETTATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
            And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
            And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
