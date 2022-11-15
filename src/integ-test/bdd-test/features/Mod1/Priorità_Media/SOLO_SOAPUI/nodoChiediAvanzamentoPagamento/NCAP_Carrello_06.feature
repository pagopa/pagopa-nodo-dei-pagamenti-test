Feature: NCAP


    Background:
        Given systems up

    Scenario: RPT generation
        Given nodo-dei-pagamenti has config parameter useCountChiediAvanzamento set to true
        And nodo-dei-pagamenti has config parameter maxChiediAvanzamento set to 1
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #codicePA# and notice number $1noticeNumber
        And RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.1</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>11</pay_i:civicoVersante>
            <pay_i:capVersante>00186</pay_i:capVersante>
            <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
            <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
            <pay_i:capPagatore>00186</pay_i:capPagatore>
            <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
            <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1carrello</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
            <listaRPT>
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <requireLightPayment>01</requireLightPayment>
            <multiBeneficiario>0</multiBeneficiario>
            </ws:nodoInviaCarrelloRPT>
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
            <identificativoCarrello>$1carrello</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$1carrello</parametriPagamentoImmediato>
            </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # check STATI_RPT table
        And replace iuv content with $1iuv content
        And replace pa content with #creditor_institution_code_old# content
        And replace noticeNumber content with $1carrello content
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati_pa on db nodo_online under macro Mod1
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati_pa on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTO_NODO, CART_ACCETTATO_NODO, CART_PARCHEGGIATO_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_PARCHEGGIATO_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    @runnable
    Scenario: Execute nodoChiediAvanzamentoPagamento
        Given the RPT generation scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati_pa on db nodo_online under macro Mod1
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati_pa on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTO_NODO, CART_ACCETTATO_NODO, CART_PARCHEGGIATO_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_PARCHEGGIATO_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1

    Scenario: Execute nodoInoltraPagamentoMod1
        Given the Execute nodoChiediAvanzamentoPagamento scenario executed successfully
        When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BBT",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "mobile",
                "mobileToken": "123ABC456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati_pa on db nodo_online under macro Mod1
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati_pa on db nodo_online under macro Mod1
        #check STATI_CARRELLO table
        And checks the value CART_RICEVUTO_NODO, CART_ACCETTATO_NODO, CART_PARCHEGGIATO_NODO,CART_INVIATO_A_PSP,CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO retrived by the query stati_carrello on db nodo_online under macro Mod1
        And checks the value CART_ACCETTATO_PSP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query stati_carrello on db nodo_online under macro Mod1
        # check POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS retrived by the query position_payment on db nodo_online under macro Mod1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro Mod1
        And restore initial configurations

