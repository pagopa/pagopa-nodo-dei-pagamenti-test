Feature: generazioneRicevute_flows_DB_GR_71_74

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr_old# and application code NA
        And RPT1 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
            <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>#ccp1#</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
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
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$1noticeNumber</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activatePaymentNotice (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <expirationTime>6000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: Execute nodoInviaRPT (Phase 3)
        Given the Execute activatePaymentNotice (Phase 2) scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rpt1Attachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML pspInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaRPTResponse>
            <pspInviaRPTResponse>
            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
            </pspInviaRPTResponse>
            </ws:pspInviaRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url

    Scenario: Execute sendPaymentOutcome - OK (Phase 4) [DB_GR_71-72]
        Given the Execute nodoInviaRPT (Phase 3) scenario executed successfully
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
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
            <outcome>OK</outcome>
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>John Doe</fullName>
            <streetName>street</streetName>
            <civicNumber>12</civicNumber>
            <postalCode>89020</postalCode>
            <city>city</city>
            <stateProvinceRegion>MI</stateProvinceRegion>
            <country>IT</country>
            <e-mail>john.doe@test.it</e-mail>
            </payer>
            <applicationDate>2021-10-01</applicationDate>
            <transferDate>2021-10-02</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        #DB CHECK-POSITION_RECEIPT_XML [DB_GR_71]
        And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value #creditor_institution_code_old# of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value #creditor_institution_code_old# of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value #id_station_old# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3

        #DB CHECK-RT_XML [DB_GR_72]
        And checks the value $1ccp of the record at column CCP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value #creditor_institution_code_old# of the record at column IDENT_DOMINIO of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value $1iuv of the record at column IUV of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value $sessionToken of the record at column ID_SESSIONE of the table RT_XMl retrived by the query rt_xml on db nodo_online under macro NewMod3
        
    Scenario: Execute sendPaymentOutcome - KO (Phase 3) [DB_GR_73]
        Given the Execute nodoInviaRPT (Phase 3) scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
            <outcome>KO</outcome>
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
            <fullName>Full name</fullName>
            <!--Optional:-->
            <streetName>Street name</streetName>
            <!--Optional:-->
            <civicNumber>Civic number</civicNumber>
            <!--Optional:-->
            <postalCode>Postal code</postalCode>
            <!--Optional:-->
            <city>City</city>
            <!--Optional:-->
            <stateProvinceRegion>State province region</stateProvinceRegion>
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
        Then check esito is OK of sendPaymentOutcome response
        
        #DB CHECK-RT_XML [DB_GR_73]
        And checks the value $1ccp of the record at column CCP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value #creditor_institution_code_old# of the record at column IDENT_DOMINIO of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value $1iuv of the record at column IUV of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value $sessionToken of the record at column ID_SESSIONE of the table RT_XMl retrived by the query rt_xml on db nodo_online under macro NewMod3

    Scenario: Execute TriggerPollerAnnulli (Phase 3)
        Given the Execute nodoInviaRPT (Phase 2) scenario executed successfully
        And wait $activatePaymentNotice.expirationTime seconds for expiration
        When job mod3CancelV1 triggered after 5 seconds
        And wait 5 seconds for expiration
        
        #DB CHECK-RT_XML [DB_GR_74]
        And checks the value $1ccp of the record at column CCP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value #creditor_institution_code_old# of the record at column IDENT_DOMINIO of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value $1iuv of the record at column IUV of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value $sessionToken of the record at column ID_SESSIONE of the table RT_XMl retrived by the query rt_xml on db nodo_online under macro NewMod3
