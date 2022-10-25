Feature: process tests for nodoInviaRPT [REV_NIRPT_02]

    Background:
        Given systems up
        And EC old version
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>40000000001</idPSP>
            <idBrokerPSP>40000000001</idBrokerPSP>
            <idChannel>40000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>#notice_number_old#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>

            """

    # Verify phase
    Scenario: Execute verifyPaymentNotice request
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>40000000001</idPSP>
            <idBrokerPSP>40000000001</idBrokerPSP>
            <idChannel>40000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <!--expirationTime>60000</expirationTime-->
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    # test execution
    Scenario: Define RPT
        Given the Execute activatePaymentNotice request Scenario executed successfully
        And RPT generation

            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
<<<<<<< HEAD
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
=======
            <pay_i:identificativoDominio>#codicePA_old#</pay_i:identificativoDominio>
>>>>>>> origin/feature/gherkin-with-behavetag
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
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
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

    Scenario: Excecute nodoInviaRPT
        Given the Define RPT scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
            <identificativoDominio>44444444444</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>15376371009</identificativoPSP>
            <identificativoIntermediarioPSP>15376371009</identificativoIntermediarioPSP>
            <identificativoCanale>15376371009_01</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    # Payment Outcome Phase outcome OK
    Scenario: Execute sendPaymentOutcome request
        Given the Excecute nodoInviaRPT scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>40000000001</idPSP>
            <idBrokerPSP>40000000001</idBrokerPSP>
            <idChannel>40000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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
        #  When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti check field <outcome> = OK
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 10 seconds for expiration

        #DB CHECK-POSITION_PAYMENT_STATUS
        #And checks the value PAYING, PAYING_RPT, PAID, NOTICE_GENERATED, NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3

        #DB CHECK-STATI_RPT
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO_MOD3, RPT_RISOLTA_OK, RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3

        #DB CHECK-STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_SUBJECT
        And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value F of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value RCCGLD09P09H501E of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value Gesualdo;Riccitelli of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value via del gesu of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value 11 of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value 00186 of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value Roma of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value RM of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value IT of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value gesualdo.riccitelli@poste.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_SERVICE
        And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
        And checks the value $DEBTOR_ID of the record at column ID of the table POSITION_SERVICE retrived by the query position_subject_2 on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_PAYMENT
        And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns RPT_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param ID at position 0 and save it under the key RPT_ID
        And checks the value $RPT_ID of the record at column ID of the table RPT retrived by the query rpt on db nodo_online under macro NewMod3


        #DB CHECK-POSITION_TRANSFER
        And execution query payment_status to get value on the table POSITION_TRANSFER, with the columns TRANSFER_CATEGORY under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param TRANSFER_CATEGORY at position 0 and save it under the key TRANSFER_CATEGORY
        And checks the value $TRANSFER_CATEGORY of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RPT_VERSAMENTI retrived by the query rpt_versamenti on db nodo_online under macro NewMod3

        #DB CHECK-RT
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column CCP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column IDENT_DOMINIO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $iuv of the record at column IUV of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 15376371009_01 of the record at column CANALE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And execution query rt to get value on the table RT, with the columns ID_RICHIESTA under macro NewMod3 with db name nodo_online
        And through the query rt retrieve param ID_MSG_RICH at position 0 and save it under the key ID_RICHIESTA
        And checks the value $ID_RICHIESTA of the record at column ID_MSG_RICH of the table RPT retrived by the query rpt on db nodo_online under macro NewMod3
        And execution query rt to get value on the table RT, with the columns SOMMA_VERSAMENTI under macro NewMod3 with db name nodo_online
        And through the query rt retrieve param AMOUNT at position 0 and save it under the key SOMMA_VERSAMENTI
        And checks the value $SOMMA_VERSAMENTI of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3

        #DB CHECK-RT_VERSAMENTI
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns IMPORTO_RT under macro NewMod3 with db name nodo_online
        And through the query rt_versamenti retrieve param AMOUNT at position 0 and save it under the key IMPORTO_RT
        And checks the value $IMPORTO_RT of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column COMMISSIONE_CARICO_PA of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns COMMISSIONE_APPLICATE_PSP under macro NewMod3 with db name nodo_online
        And through the query rt_versamenti retrieve param FEE at position 0 and save it under the key COMMISSIONE_APPLICATE_PSP
        And checks the value $COMMISSIONE_APPLICATE_PSP of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_RECEIPT
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $verifyPaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns CREDITOR_REFERENCE_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param CREDITOR_REFERENCE_ID at position 0 and save it under the key CREDITOR_REFERENCE_ID
        And checks the value $CREDITOR_REFERENCE_ID of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns OUTCOME under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param OUTCOME at position 0 and save it under the key OUTCOME
        And checks the value $OUTCOME of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns PAYMENT_AMOUNT under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param AMOUNT at position 0 and save it under the key PAYMENT_AMOUNT
        And checks the value $PAYMENT_AMOUNT of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns DESCRIPTION under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param DESCRIPTION at position 0 and save it under the key DESCRIPTION
        And checks the value $DESCRIPTION of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns COMPANY_NAME under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param COMPANY_NAME at position 0 and save it under the key COMPANY_NAME
        And checks the value $COMPANY_NAME of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
        And checks the value $DEBTOR_ID of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query payment_status on db nodo_online under macro NewMod3

        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns PAYMENT_METHOD under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param PAYMENT_METHOD at position 0 and save it under the key PAYMENT_METHOD
        And checks the value $PAYMENT_METHOD of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3

        And execution query payment_status to get value on the table POSITION_RECEIPT, with the columns FEE under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param FEE at position 0 and save it under the key FEE
        And checks the value $FEE of the record at column FEE of the table POSITION_PAYMENT retrived by the query position_receipt_recipient on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status on db nodo_online under macro NewMod3

        #DB CHECK-RT_XML
        And execution query rpt to get value on the table RT_XML, with the columns FK_RT under macro NewMod3 with db name nodo_online
        And through the query rpt retrieve param ID at position 0 and save it under the key FK_RT
        And checks the value $FK_RT of the record at column ID of the table RT retrived by the query rt on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_RECEIPT_RECIPIENT
        And execution query position_receipt_transfer to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_RECEIPT under macro NewMod3 with db name nodo_online
        And through the query position_receipt_transfer retrieve param ID at position 0 and save it under the key FK_POSITION_RECEIPT
        And checks the value $FK_POSITION_RECEIPT of the record at column ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3

        And execution query position_receipt_transfer to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_TRANSFER under macro NewMod3 with db name nodo_online
        And through the query position_receipt_transfer retrieve param ID at position 0 and save it under the key FK_POSITION_TRANSFER
        And checks the value $FK_POSITION_TRANSFER of the record at column ID of the table POSITION_TRANSFER retrived by the query payment_status on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_RECEIPT_XML
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
