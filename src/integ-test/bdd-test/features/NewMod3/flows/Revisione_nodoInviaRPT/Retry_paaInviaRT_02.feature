Feature: process tests for nodoInviaRPT [Retry_paaInviaRT_02]

    Background:
        Given systems up
        And EC old version
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
            <noticeNumber>#notice_number_old#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # Verify phase
    Scenario: Execute verifyPaymentNotice request
        Given nodo-dei-pagamenti has config parameter scheduler.jobName_paRetryPaInviaRtNegative.enabled set to false
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
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    # test execution
    Scenario: Define RPT
        Given the Execute activatePaymentNotice request scenario executed successfully
        And RPT generation
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
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
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
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
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
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#pspFittizio#</identificativoPSP>
            <identificativoIntermediarioPSP>#pspFittizio#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleFittizio#</identificativoCanale>
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
        Given the Excecute nodoInviaRPT Scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>$verifyPaymentNotice.idPSP</idPSP>
            <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
            <idChannel>$verifyPaymentNotice.idChannel</idChannel>
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
            <entityUniqueIdentifierValue>RCCGLD09P09H501E</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>Gesualdo;Riccitelli</fullName>
            <!--Optional:-->
            <streetName>via del gesu</streetName>
            <!--Optional:-->
            <civicNumber>11</civicNumber>
            <!--Optional:-->
            <postalCode>00186</postalCode>
            <!--Optional:-->
            <city>Roma</city>
            <!--Optional:-->
            <stateProvinceRegion>RM</stateProvinceRegion>
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
        And initial XML paaInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaInviaRTRisposta>
            <paaInviaRTRisposta>
            <delay>10000</delay>
            <esito>OK</esito>
            </paaInviaRTRisposta>
            </ws:paaInviaRTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200
        And check outcome is OK of sendPaymentOutcome response
        And wait 65 seconds for expiration

    Scenario: DB check
        Given the Execute sendPaymentOutcome request Scenario executed successfully
        Then checks the value NotNone of the record at column id of the table RETRY_PA_INVIA_RT retrived by the query retry_pa_invia_rt_only_ccp on db nodo_online under macro NewMod3

        And checks the value #creditor_institution_code_old# of the record at column id_dominio of the table RETRY_PA_INVIA_RT retrived by the query retry_pa_invia_rt_only_ccp on db nodo_online under macro NewMod3

        #DB CHECK-POSITION_PAYMENT_STATUS
        And checks the value PAYING, PAYING_RPT, PAID, NOTICE_GENERATED, NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #DB CHECK-STATI_RPT
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO_MOD3, RPT_RISOLTA_OK, RT_GENERATA_NODO, RT_INVIATA_PA, RT_ESITO_SCONOSCIUTO_PA of the record at column STATO of the table STATI_RPT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3
        #DB CHECK-STATI_RPT_SNAPSHOT
        And checks the value RT_ESITO_SCONOSCIUTO_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_SUBJECT
        And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
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
        And execution query position_payment_noticeNumb to get value on the table POSITION_PAYMENT, with the columns amount,fee,outcome,channel_id,payment_channel,payer_id,payment_method,id,inserted_timestamp,application_date,transfer_date,creditor_reference_id,pa_fiscal_code,broker_pa_id,station_id under macro NewMod3 with db name nodo_online
        And through the query position_payment_noticeNumb retrieve param amount at position 0 and save it under the key amount
        And through the query position_payment_noticeNumb retrieve param fee at position 1 and save it under the key fee
        And through the query position_payment_noticeNumb retrieve param outcome at position 2 and save it under the key outcome
        And through the query position_payment_noticeNumb retrieve param channel_id at position 3 and save it under the key channel_id
        And through the query position_payment_noticeNumb retrieve param payment_channel at position 4 and save it under the key payment_channel
        And through the query position_payment_noticeNumb retrieve param payer_id at position 5 and save it under the key payer_id
        And through the query position_payment_noticeNumb retrieve param payment_method at position 6 and save it under the key payment_method
        And through the query position_payment_noticeNumb retrieve param id at position 7 and save it under the key id
        And through the query position_payment_noticeNumb retrieve param inserted_timestamp at position 8 and save it under the key inserted_timestamp
        And through the query position_payment_noticeNumb retrieve param application_date at position 9 and save it under the key application_date
        And through the query position_payment_noticeNumb retrieve param transfer_date at position 10 and save it under the key transfer_date
        And through the query position_payment_noticeNumb retrieve param creditor_reference_id at position 11 and save it under the key creditor_reference_id
        And through the query position_payment_noticeNumb retrieve param pa_fiscal_code at position 12 and save it under the key pa_fiscal_code
        And through the query position_payment_noticeNumb retrieve param broker_pa_id at position 13 and save it under the key broker_pa_id
        And through the query position_payment_noticeNumb retrieve param station_id at position 14 and save it under the key station_id
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column CCP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column IDENT_DOMINIO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $iuv of the record at column IUV of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value #canaleFittizio# of the record at column CANALE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And execution query rt to get value on the table RT, with the columns ID_RICHIESTA under macro NewMod3 with db name nodo_online
        And through the query rt retrieve param ID_MSG_RICH at position 0 and save it under the key ID_RICHIESTA
        And checks the value $ID_RICHIESTA of the record at column ID_MSG_RICH of the table RPT retrived by the query rpt on db nodo_online under macro NewMod3
        #DB CHECK-RT_VERSAMENTI
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns causale_versamento,dati_specifici_riscossione under macro NewMod3 with db name nodo_online
        And through the query rpt_versamenti retrieve param causale_versamento at position 0 and save it under the key causale_versamento
        And through the query rpt_versamenti retrieve param dati_specifici_riscossione at position 1 and save it under the key dati_specifici_riscossione
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $amount of the record at column IMPORTO_RT of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $causale_versamento of the record at column causale_versamento of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $dati_specifici_riscossione of the record at column dati_specifici_riscossione of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $fee of the record at column commissione_applicate_psp of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_RECEIPT
        And execution query psp to get value on the table psp, with the columns ragione_sociale,codice_fiscale,vat_number under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
        And through the query psp retrieve param codice_fiscale at position 1 and save it under the key codice_fiscale
        And through the query psp retrieve param vat_number at position 2 and save it under the key vat_number
        And execution query payment_status to get value on the table POSITION_SERVICE, with the columns description,company_name,office_name,debtor_id under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param description at position 0 and save it under the key description
        And through the query payment_status retrieve param company_name at position 1 and save it under the key company_name
        And through the query payment_status retrieve param office_name at position 2 and save it under the key office_name
        And through the query payment_status retrieve param debtor_id at position 3 and save it under the key debtor_id
        And execution query payment_status to get value on the table POSITION_PAYMENT_PLAN, with the columns metadata under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param metadata at position 0 and save it under the key metadata
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column receipt_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $creditor_reference_id of the record at column creditor_reference_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $outcome of the record at column outcome of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $amount of the record at column payment_amount of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $description of the record at column description of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $company_name of the record at column company_name of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column office_name of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $debtor_id of the record at column debtor_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $codice_fiscale of the record at column psp_fiscal_code of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        #And checks the value $vat_number of the record at column psp_vat_number of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $channel_id of the record at column channel_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $payment_channel of the record at column channel_description of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $payer_id of the record at column payer_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $payment_method of the record at column payment_method of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $fee of the record at column fee of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column metadata of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $id of the record at column fk_position_payment of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        # #DB CHECK-POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status on db nodo_online under macro NewMod3
        # #DB CHECK-RT_XML
        And execution query rpt to get value on the table RT_XML, with the columns FK_RT under macro NewMod3 with db name nodo_online
        And through the query rpt retrieve param ID at position 0 and save it under the key FK_RT
        And checks the value $FK_RT of the record at column ID of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        # #DB CHECK-POSITION_RECEIPT_XML
        And checks the value $iuv of the record at column creditor_reference_id of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $pa_fiscal_code of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $broker_pa_id of the record at column recipient_broker_pa_id of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $station_id of the record at column recipient_station_id of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column xml of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        #POSITION_RECEIPT_XML query
        And execution query payment_status_pay to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve xml prx_xml at position 0 and save it under the key prx_xml
        #POSITION_PAYMENT query
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param pp1_broker_pa_id at position 5 and save it under the key pp1_broker_pa_id
        And through the query payment_status_pay retrieve param pp1_station_id at position 6 and save it under the key pp1_station_id
        And through the query payment_status_pay retrieve param pp1_payment_token at position 4 and save it under the key pp1_payment_token
        And through the query payment_status_pay retrieve param pp1_notice_id at position 2 and save it under the key pp1_notice_id
        And through the query payment_status_pay retrieve param pp1_pa_fiscal_code at position 1 and save it under the key pp1_pa_fiscal_code
        And through the query payment_status_pay retrieve param pp1_outcome at position 14 and save it under the key pp1_outcome
        And through the query payment_status_pay retrieve param pp1_creditor_reference_id at position 3 and save it under the key pp1_creditor_reference_id
        And through the query payment_status_pay retrieve param pp1_amount at position 12 and save it under the key pp1_amount
        And through the query payment_status_pay retrieve param pp1_psp_id at position 8 and save it under the key pp1_psp_id
        And through the query payment_status_pay retrieve param pp1_channel_id at position 10 and save it under the key pp1_channel_id
        #POSITION_SERVICE query
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns DESCRIPTION, COMPANY_NAME under macro NewMod3 with db name nodo_online
        And through the query position_service retrieve param ps_description at position 0 and save it under the key ps_description
        And through the query position_service retrieve param ps_company_name at position 1 and save it under the key ps_company_name
        #POSITION_SUBJECT / POSITION_SERVICE query
        And execution query position_subject_service to get value on the table POSITION_SUBJECT, with the columns su.ENTITY_UNIQUE_IDENTIFIER_TYPE, su.ENTITY_UNIQUE_IDENTIFIER_VALUE, su.FULL_NAME, su.STREET_NAME, su.CIVIC_NUMBER, su.POSTAL_CODE, su.CITY, su.STATE_PROVINCE_REGION, su.COUNTRY, su.EMAIL under macro NewMod3 with db name nodo_online
        And through the query position_subject_service retrieve param pss_entity_unique_identifier_type at position 0 and save it under the key pss_entity_unique_identifier_type
        And through the query position_subject_service retrieve param pss_entity_unique_identifier_value at position 1 and save it under the key pss_entity_unique_identifier_value
        And through the query position_subject_service retrieve param pss_full_name at position 2 and save it under the key pss_full_name
        And through the query position_subject_service retrieve param pss_street_name at position 3 and save it under the key pss_street_name
        And through the query position_subject_service retrieve param pss_civic_number at position 4 and save it under the key pss_civic_number
        And through the query position_subject_service retrieve param pss_postal_code at position 5 and save it under the key pss_postal_code
        And through the query position_subject_service retrieve param pss_city at position 6 and save it under the key pss_city
        And through the query position_subject_service retrieve param pss_state_province_region at position 7 and save it under the key pss_state_province_region
        And through the query position_subject_service retrieve param pss_country at position 8 and save it under the key pss_country
        And through the query position_subject_service retrieve param pss_email at position 9 and save it under the key pss_email
        #POSITION_TRANSFER query
        And execution query position_transfer to get value on the table POSITION_TRANSFER, with the columns TRANSFER_IDENTIFIER, AMOUNT, PA_FISCAL_CODE_SECONDARY, IBAN, REMITTANCE_INFORMATION, TRANSFER_CATEGORY under macro NewMod3 with db name nodo_online
        And through the query position_transfer retrieve param pt_transfer_identifier at position 0 and save it under the key pt_transfer_identifier
        And through the query position_transfer retrieve param pt_amount at position 1 and save it under the key pt_amount
        And through the query position_transfer retrieve param pt_pa_fiscal_code_secondary at position 2 and save it under the key pt_pa_fiscal_code_secondary
        And through the query position_transfer retrieve param pt_iban at position 3 and save it under the key pt_iban
        And through the query position_transfer retrieve param pt_remittance_information at position 4 and save it under the key pt_remittance_information
        And through the query position_transfer retrieve param pt_transfer_category at position 5 and save it under the key pt_transfer_category
        #checks on XML
        And check value $prx_xml.idPA is equal to value $pp1_pa_fiscal_code
        And check value $prx_xml.idBrokerPA is equal to value $pp1_broker_pa_id
        And check value $prx_xml.idStation is equal to value $pp1_station_id
        And check value $prx_xml.receiptId is equal to value $pp1_payment_token
        And check value $prx_xml.noticeNumber is equal to value $pp1_notice_id
        And check value $prx_xml.fiscalCode is equal to value $pp1_pa_fiscal_code
        And check value $prx_xml.outcome is equal to value $pp1_outcome
        And check value $prx_xml.creditorReferenceId is equal to value $pp1_creditor_reference_id

        #And check value $prx_xml.paymentAmount is equal to value $pp1_amount

        And check value $prx_xml.description is equal to value $ps_description
        And check value $prx_xml.companyName is equal to value $ps_company_name
        And check value $prx_xml.entityUniqueIdentifierType is equal to value $pss_entity_unique_identifier_type
        And check value $prx_xml.entityUniqueIdentifierValue is equal to value $pss_entity_unique_identifier_value
        And check value $prx_xml.fullName is equal to value $pss_full_name
        And check value $prx_xml.streetName is equal to value $pss_street_name
        And check value $prx_xml.civicNumber is equal to value $pss_civic_number
        And check value $prx_xml.postalCode is equal to value $pss_postal_code
        And check value $prx_xml.city is equal to value $pss_city
        And check value $prx_xml.stateProvinceRegion is equal to value $pss_state_province_region
        And check value $prx_xml.country is equal to value $pss_country

        #And check value $prx_xml.e-mail is equal to value $pss_email
        And check value $prx_xml.idTransfer is equal to value $pt_transfer_identifier
        #And check value $prx_xml.transferAmount is equal to value $pt_amount

        And check value $prx_xml.fiscalCodePA is equal to value $pt_pa_fiscal_code_secondary
        And check value $prx_xml.IBAN is equal to value $pt_iban
        And check value $prx_xml.remittanceInformation is equal to value $pt_remittance_information
        And check value $prx_xml.transferCategory is equal to value $pt_transfer_category
        And check value $prx_xml.idPSP is equal to value $pp1_psp_id
        And check value $prx_xml.idChannel is equal to value $pp1_channel_id
        #check xml rt
        And execution query rt to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        #position_payment
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns BROKER_PA_ID, STATION_ID, PAYMENT_TOKEN, NOTICE_ID, PA_FISCAL_CODE, OUTCOME, CREDITOR_REFERENCE_ID, AMOUNT, PSP_ID, CHANNEL_ID, PAYMENT_CHANNEL, PAYMENT_METHOD, FEE, INSERTED_TIMESTAMP, APPLICATION_DATE, TRANSFER_DATE under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 0 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 1 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 2 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 3 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 4 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 5 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 6 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 7 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 9 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 10 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 11 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 12 and save it under the key FEE
        #psp
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        #checks on XML
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value $PSP_ID
        And check value $xml_rt.tipoIdentificativoUnivoco is equal to value $xml_rpt.tipoIdentificativoUnivoco
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        #And check value $xml_rt.importoTotalePagato is equal to value $AMOUNT
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value $PAYMENT_TOKEN
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

    @runnable
    Scenario: retry paainviart [Retry_paaInviaRT_02]
        Given the DB check scenario executed successfully
        And nodo-dei-pagamenti has config parameter scheduler.jobName_paRetryPaInviaRtNegative.enabled set to true
        When job paRetryPaInviaRtNegative triggered after 5 seconds
        Then verify the HTTP status code of paRetryPaInviaRtNegative response is 200
        And wait 15 seconds for expiration
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query retry_pa_invia_rt_only_ccp on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_PAYMENT_STATUS
        And checks the value PAYING, PAYING_RPT, PAID, NOTICE_GENERATED, NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #DB CHECK-STATI_RPT
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO_MOD3, RPT_RISOLTA_OK, RT_GENERATA_NODO, RT_INVIATA_PA, RT_ESITO_SCONOSCIUTO_PA, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3
        #DB CHECK-STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_SUBJECT
        And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
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
        And execution query position_payment_noticeNumb to get value on the table POSITION_PAYMENT, with the columns amount,fee,outcome,channel_id,payment_channel,payer_id,payment_method,id,inserted_timestamp,application_date,transfer_date,creditor_reference_id,pa_fiscal_code,broker_pa_id,station_id under macro NewMod3 with db name nodo_online
        And through the query position_payment_noticeNumb retrieve param amount at position 0 and save it under the key amount
        And through the query position_payment_noticeNumb retrieve param fee at position 1 and save it under the key fee
        And through the query position_payment_noticeNumb retrieve param outcome at position 2 and save it under the key outcome
        And through the query position_payment_noticeNumb retrieve param channel_id at position 3 and save it under the key channel_id
        And through the query position_payment_noticeNumb retrieve param payment_channel at position 4 and save it under the key payment_channel
        And through the query position_payment_noticeNumb retrieve param payer_id at position 5 and save it under the key payer_id
        And through the query position_payment_noticeNumb retrieve param payment_method at position 6 and save it under the key payment_method
        And through the query position_payment_noticeNumb retrieve param id at position 7 and save it under the key id
        And through the query position_payment_noticeNumb retrieve param inserted_timestamp at position 8 and save it under the key inserted_timestamp
        And through the query position_payment_noticeNumb retrieve param application_date at position 9 and save it under the key application_date
        And through the query position_payment_noticeNumb retrieve param transfer_date at position 10 and save it under the key transfer_date
        And through the query position_payment_noticeNumb retrieve param creditor_reference_id at position 11 and save it under the key creditor_reference_id
        And through the query position_payment_noticeNumb retrieve param pa_fiscal_code at position 12 and save it under the key pa_fiscal_code
        And through the query position_payment_noticeNumb retrieve param broker_pa_id at position 13 and save it under the key broker_pa_id
        And through the query position_payment_noticeNumb retrieve param station_id at position 14 and save it under the key station_id
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column CCP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column IDENT_DOMINIO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $iuv of the record at column IUV of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value $amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value #canaleFittizio# of the record at column CANALE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And execution query rt to get value on the table RT, with the columns ID_RICHIESTA under macro NewMod3 with db name nodo_online
        And through the query rt retrieve param ID_MSG_RICH at position 0 and save it under the key ID_RICHIESTA
        And checks the value $ID_RICHIESTA of the record at column ID_MSG_RICH of the table RPT retrived by the query rpt on db nodo_online under macro NewMod3
        #DB CHECK-RT_VERSAMENTI
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns causale_versamento,dati_specifici_riscossione under macro NewMod3 with db name nodo_online
        And through the query rpt_versamenti retrieve param causale_versamento at position 0 and save it under the key causale_versamento
        And through the query rpt_versamenti retrieve param dati_specifici_riscossione at position 1 and save it under the key dati_specifici_riscossione
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $amount of the record at column IMPORTO_RT of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $causale_versamento of the record at column causale_versamento of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $dati_specifici_riscossione of the record at column dati_specifici_riscossione of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value $fee of the record at column commissione_applicate_psp of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_RECEIPT
        And execution query psp to get value on the table psp, with the columns ragione_sociale,codice_fiscale,vat_number under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
        And through the query psp retrieve param codice_fiscale at position 1 and save it under the key codice_fiscale
        And through the query psp retrieve param vat_number at position 2 and save it under the key vat_number
        And execution query payment_status to get value on the table POSITION_SERVICE, with the columns description,company_name,office_name,debtor_id under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param description at position 0 and save it under the key description
        And through the query payment_status retrieve param company_name at position 1 and save it under the key company_name
        And through the query payment_status retrieve param office_name at position 2 and save it under the key office_name
        And through the query payment_status retrieve param debtor_id at position 3 and save it under the key debtor_id
        And execution query payment_status to get value on the table POSITION_PAYMENT_PLAN, with the columns metadata under macro NewMod3 with db name nodo_online
        And through the query payment_status retrieve param metadata at position 0 and save it under the key metadata
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column receipt_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $creditor_reference_id of the record at column creditor_reference_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $outcome of the record at column outcome of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $amount of the record at column payment_amount of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $description of the record at column description of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $company_name of the record at column company_name of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column office_name of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $debtor_id of the record at column debtor_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $codice_fiscale of the record at column psp_fiscal_code of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        #And checks the value $vat_number of the record at column psp_vat_number of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $channel_id of the record at column channel_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $payment_channel of the record at column channel_description of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $payer_id of the record at column payer_id of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $payment_method of the record at column payment_method of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $fee of the record at column fee of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column metadata of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $id of the record at column fk_position_payment of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3
        # #DB CHECK-POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status on db nodo_online under macro NewMod3
        # #DB CHECK-RT_XML
        And execution query rpt to get value on the table RT_XML, with the columns FK_RT under macro NewMod3 with db name nodo_online
        And through the query rpt retrieve param ID at position 0 and save it under the key FK_RT
        And checks the value $FK_RT of the record at column ID of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        # #DB CHECK-POSITION_RECEIPT_XML
        And checks the value $iuv of the record at column creditor_reference_id of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $pa_fiscal_code of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $broker_pa_id of the record at column recipient_broker_pa_id of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $station_id of the record at column recipient_station_id of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column xml of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
        And restore initial configurations
