Feature: Flows checks for nodoInviaCarrelloRPT [PAG-1642_02]

    Background:
        Given systems up


    Scenario: RPT generation
        Given nodo-dei-pagamenti has config parameter scheduler.jobName_paInviaRt.enabled set to false
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
        And RPT1 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:importoTotaleDaVersare>1.50</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>1.50</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
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

        And RPT2 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.1</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_secondary#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_secondary#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:importoTotaleDaVersare>1.50</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>1.50</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """


    Scenario: Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML paaInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaInviaRTRisposta>
            <paaInviaRTRisposta>
            <esito>OK</esito>
            </paaInviaRTRisposta>
            </ws:paaInviaRTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaInviaRT

        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
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
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <rpt>$rpt1Attachment</rpt>
            </elementoListaRPT>
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_secondary#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <rpt>$rpt2Attachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <requireLightPayment>01</requireLightPayment>
            <multiBeneficiario>1</multiBeneficiario>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Then retrieve session token from $nodoInviaCarrelloRPTResponse.url

    Scenario: update column valid_to UPDATED_TIMESTAMP
        Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
        #And generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And change date Today to remove minutes 20
        And replace iuv content with $1iuv content
        Then update through the query DB_GEST_ANN_update1 with date $date under macro Mod1Mb on db nodo_online
        #And replace iuv content with $2iuv content
        And replace pa1 content with #creditor_institution_code_secondary# content
        And update through the query DB_GEST_ANN_update2 with date $date under macro Mod1Mb on db nodo_online
        And wait 10 seconds for expiration


    Scenario: Trigger annullamentoRptMaiRichiesteDaPm
        Given the update column valid_to UPDATED_TIMESTAMP scenario executed successfully
        And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
        When job annullamentoRptMaiRichiesteDaPm triggered after 15 seconds
        Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200
        And wait 130 seconds for expiration
        And replace pa1 content with #creditor_institution_code_secondary# content


        #DB-CHECK-STATI_RPT
        And replace iuv content with $1iuv content

        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query DB_GEST_ANN_stati_rpt_pa1 on db nodo_online under macro Mod1Mb

        #DB-CHECK-STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt_pa1 on db nodo_online under macro Mod1Mb

        #DB-CHECK-STATI_CARRELLO
        And checks the value CART_RICEVUTO_NODO, CART_ACCETTATO_NODO, CART_PARCHEGGIATO_NODO, CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO retrived by the query DB_GEST_ANN_stati_payment_token on db nodo_online under macro Mod1Mb

        #DB-CHECK-STATI_CARRELLO_SNAPSHOT
        And checks the value CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query DB_GEST_ANN_stati_payment_token on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_PAYMENT_STATUS
        And checks the value PAYING, CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query DB_GEST_ANN_stati_position_payment_status on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query DB_GEST_ANN_stati_position_payment_status on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_STATUS
        And execution query DB_GEST_ANN_stati_position_payment_status to get value on the table POSITION_PAYMENT_STATUS, with the columns NOTICE_ID under macro Mod1Mb with db name nodo_online
        And through the query DB_GEST_ANN_stati_position_payment_status retrieve param NOTICE_ID at position 0 and save it under the key NOTICE_ID
        And checks the value PAYING, INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query DB_GEST_ANN_notice_number on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query DB_GEST_ANN_notice_number on db nodo_online under macro Mod1Mb


    Scenario: Execute activateIOPayment
        Given the Trigger annullamentoRptMaiRichiesteDaPm scenario executed successfully
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>#psp_AGID#</idPSP>
            <idBrokerPSP>#broker_AGID#</idBrokerPSP>
            <idChannel>#canale_AGID#</idChannel>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <qrCode>
            <fiscalCode>$nodoInviaCarrelloRPT.identificativoDominio</fiscalCode>
            <noticeNumber>$1noticeNumber</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <!--expirationTime>60000</expirationTime-->
            <amount>1.50</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>responseFull</paymentNote>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>IOname_</fullName>
            <!--Optional:-->
            <streetName>IOstreet</streetName>
            <!--Optional:-->
            <civicNumber>IOcivic</civicNumber>
            <!--Optional:-->
            <postalCode>IOcode</postalCode>
            <!--Optional:-->
            <city>IOcity</city>
            <!--Optional:-->
            <stateProvinceRegion>IOstate</stateProvinceRegion>
            <!--Optional:-->
            <country>DE</country>
            <!--Optional:-->
            <e-mail>IO.test.prova@gmail.com</e-mail>
            </payer>
            </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And restore initial configurations


    Scenario: Trigger paInviaRt
        Given the Execute activateIOPayment scenario executed successfully
        When job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        #DB-CHECK-STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt_pa1 on db nodo_online under macro Mod1Mb

    Scenario: Execute nodoChiediInformazioniPagamento1
        Given the Trigger paInviaRt scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check email field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response
        And check enteBeneficiario field exists in informazioniPagamento response

    #And check $1iuv field exists in informazioniPagamento response
    #And check #creditor_institution_code# field exists in informazioniPagamento response


    Scenario: Execute nodoInoltroEsitoCarta
        Given the Execute nodoChiediInformazioniPagamento1 scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$activateIOPaymentResponse.paymentToken",
                "RRN": 15156056,
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoPsp": "#psp#",
                "identificativoCanale": "#canale#",
                "importoTotalePagato": 1.5,
                "timestampOperazione": "2021-07-09T17:06:03.100+01:00",
                "codiceAutorizzativo": "resOK",
                "esitoTransazioneCarta": "00"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is OK of inoltroEsito/carta response

@check
    Scenario: Execute sendPaymentOutcome request
        Given the Execute nodoInoltroEsitoCarta scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>postal</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        #DB-CHECK-STATI_RPT
        And replace iuv content with $1iuv content
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO,  RT_GENERATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO,  RT_GENERATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query DB_GEST_ANN_stati_rpt_pa1 on db nodo_online under macro Mod1Mb

        #DB-CHECK-STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt_pa1 on db nodo_online under macro Mod1Mb

        #DB-CHECK-STATI_CARRELLO
        And checks the value CART_RICEVUTO_NODO, CART_ACCETTATO_NODO, CART_PARCHEGGIATO_NODO, CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO retrived by the query DB_GEST_ANN_stati_payment_token on db nodo_online under macro Mod1Mb

        #DB-CHECK-STATI_CARRELLO_SNAPSHOT
        And checks the value CART_ANNULLATO_WISP of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query DB_GEST_ANN_stati_payment_token on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_PAYMENT_STATUS

        And replace pa content with #creditor_institution_code# content

        And replace noticeNumber content with $1noticeNumber content
        And checks the value PAYING, CANCELLED, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED, NOTICE_SENT, NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoCarrello, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken, $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value nodoInviaCarrelloRPT, annullamentoRptMaiRichiesteDaPm, activateIOPayment, nodoInoltraEsitoPagamentoCarta, nodoInoltraEsitoPagamentoCarta, sendPaymentOutcome, sendPaymentOutcome, sendPaymentOutcome, sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED, NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_STATUS
        And execution query DB_GEST_ANN_stati_position_payment_status to get value on the table POSITION_PAYMENT_STATUS, with the columns NOTICE_ID under macro Mod1Mb with db name nodo_online
        And through the query DB_GEST_ANN_stati_position_payment_status retrieve param NOTICE_ID at position 0 and save it under the key NOTICE_ID
        And checks the value PAYING, INSERTED, PAID, NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query DB_GEST_ANN_notice_number on db nodo_online under macro Mod1Mb

        #DB-CHECK-POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query DB_GEST_ANN_notice_number on db nodo_online under macro Mod1Mb
        And restore initial configurations