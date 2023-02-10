Feature: process tests for NM3 with station migration from V1 to V2

    Background:
        Given systems up
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC old version

    # Verify phase
    Scenario: Execute verifyPaymentNotice request
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    # Activate Phase
    Scenario: Execute activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>002$iuv</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentResponse
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3

    Scenario: Define RPT
        Given the Execute activatePaymentNotice request scenario executed successfully
        And RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>$activatePaymentNotice.fiscalCode</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>##id_station_old##</pay_i:identificativoStazioneRichiedente>
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

    Scenario: Execute nodoInviaRPT request
        Given the Define RPT scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>$activatePaymentNotice.fiscalCode</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>$activatePaymentNotice.fiscalCode</identificativoDominio>
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
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check redirect is 0 of nodoInviaRPT response
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3


    #DB update
    Scenario: Execute station version update
        Given the Execute nodoInviaRPT request scenario executed successfully
        Then updates through the query stationUpdate of the table STAZIONI the parameter VERSIONE with 2 under macro sendPaymentResultV2 on db nodo_cfg

    #refresh pa e stazioni
    Scenario: Execute refresh pa e stazioni
        Given the Execute station version update scenario executed successfully
        Then refresh job PA triggered after 10 seconds

    # mod3CancelV1 trigger
    Scenario: Execute mod3CancelV1
        Given the Execute refresh pa e stazioni scenario executed successfully
        When job mod3CancelV1 triggered after 6 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    @test
    # test execution
    Scenario: Execution db check
        Given the Execute mod3CancelV1 scenario executed successfully
        When job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of paInviaRt response is 200
        And updates through the query stationUpdate of the table STAZIONI the parameter VERSIONE with 1 under macro sendPaymentResultV2 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And PSP waits 5 seconds for expiration
        #RT
        Then execution query rt to get value on the table RT, with the columns ID_SESSIONE,CCP,IDENT_DOMINIO,IUV,COD_ESITO,DATA_RICEVUTA,DATA_RICHIESTA,ID_RICEVUTA,ID_RICHIESTA,SOMMA_VERSAMENTI,INSERTED_TIMESTAMP,UPDATED_TIMESTAMP,CANALE,ID under macro NewMod3 with db name nodo_online
        And execution query rpt to get value on the table RPT, with the columns CCP,IDENT_DOMINIO,IUV,ID_MSG_RICH,CANALE under macro NewMod3 with db name nodo_online
        And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns AMOUNT,FEE,PAYMENT_TOKEN,NOTICE_ID,PA_FISCAL_CODE,OUTCOME,CHANNEL_ID,PAYMENT_CHANNEL,PAYER_ID,PAYMENT_METHOD,ID,APPLICATION_DATE,CREDITOR_REFERENCE_ID,BROKER_PA_ID,STATION_ID under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And with the query rt check assert beetwen elem CCP in position 1 and elem CCP with position 0 of the query rpt
        And with the query rt check assert beetwen elem IDENT_DOMINIO in position 2 and elem IDENT_DOMINIO with position 1 of the query rpt
        And with the query rt check assert beetwen elem IUV in position 3 and elem IUV with position 2 of the query rpt
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And with the query rt check assert beetwen elem ID_RICHIESTA in position 8 and elem ID_MSG_RICH with position 3 of the query rpt
        And checks the value 0 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And with the query rt check assert beetwen elem CANALE in position 12 and elem CANALE with position 4 of the query rpt
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        #RT_VERSAMENTI
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns * under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns s.CAUSALE_VERSAMENTO,s.DATI_SPECIFICI_RISCOSSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #And with the query rt_versamenti check assert beetwen elem IMPORTO_RT in position 1 and elem AMOUNT with position 0 of the query payment_status
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And with the query rt_versamenti check assert beetwen elem CAUSALE_VERSAMENTO in position 4 and elem CAUSALE_VERSAMENTO with position 0 of the query rpt_versamenti
        And with the query rt_versamenti check assert beetwen elem DATI_SPECIFICI_RISCOSSIONE in position 5 and elem DATI_SPECIFICI_RISCOSSIONE with position 1 of the query rpt_versamenti
        And with the query rt_versamenti check assert beetwen elem COMMISSIONE_APPLICATE_PSP in position 6 and elem FEE with position 1 of the query payment_status
        And with the query rt_versamenti check assert beetwen elem FK_RT in position 7 and elem ID with position 13 of the query rt
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #POSITION_RECEIPT
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns RECEIPT_ID,s.NOTICE_ID,s.PA_FISCAL_CODE,s.CREDITOR_REFERENCE_ID,s.PAYMENT_TOKEN,s.OUTCOME,s.PAYMENT_AMOUNT,s.DESCRIPTION,s.COMPANY_NAME,s.OFFICE_NAME,s.DEBTOR_ID,s.PSP_ID,s.PSP_COMPANY_NAME,s.PSP_FISCAL_CODE,s.PSP_VAT_NUMBER,s.CHANNEL_ID,s.CHANNEL_DESCRIPTION,s.PAYER_ID,s.PAYMENT_METHOD,s.FEE,s.PAYMENT_DATE_TIME,s.APPLICATION_DATE,s.TRANSFER_DATE,s.METADATA,s.RT_ID,s.FK_POSITION_PAYMENT,s.ID under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID under macro NewMod3 with db name nodo_online
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE,CODICE_FISCALE,VAT_NUMBER under macro NewMod3 with db name nodo_cfg
        And execution query position_payment_plan to get value on the table POSITION_PAYMENT_PLAN, with the columns METADATA under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem RECEIPT_ID in position 0 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt check assert beetwen elem NOTICE_ID in position 1 and elem NOTICE_ID with position 3 of the query payment_status
        And with the query position_receipt check assert beetwen elem PA_FISCAL_CODE in position 2 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt check assert beetwen elem CREDITOR_REFERENCE_ID in position 3 and elem CREDITOR_REFERENCE_ID with position 12 of the query payment_status
        And with the query position_receipt check assert beetwen elem PAYMENT_TOKEN in position 4 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt check assert beetwen elem OUTCOME in position 5 and elem OUTCOME with position 5 of the query payment_status
        And with the query position_receipt check assert beetwen elem AMOUNT in position 6 and elem AMOUNT with position 0 of the query payment_status
        And with the query position_receipt check assert beetwen elem DESCRIPTION in position 7 and elem DESCRIPTION with position 0 of the query position_service
        And with the query position_receipt check assert beetwen elem COMPANY_NAME in position 8 and elem COMPANY_NAME with position 1 of the query position_service
        And with the query position_receipt check assert beetwen elem OFFICE_NAME in position 9 and elem OFFICE_NAME with position 2 of the query position_service
        And with the query position_receipt check assert beetwen elem DEBTOR_ID in position 10 and elem DEBTOR_ID with position 3 of the query position_service
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And with the query position_receipt check assert beetwen elem PSP_COMPANY_NAME in position 12 and elem PSP_COMPANY_NAME with position 0 of the query psp
        And with the query position_receipt check assert beetwen elem PSP_FISCAL_CODE in position 13 and elem PSP_FISCAL_CODE with position 1 of the query psp
        And with the query position_receipt check assert beetwen elem PSP_VAT_NUMBER in position 14 and elem PSP_VAT_NUMBER with position 2 of the query psp
        And with the query position_receipt check assert beetwen elem CHANNEL_ID in position 15 and elem CHANNEL_ID with position 6 of the query payment_status
        And with the query position_receipt check assert beetwen elem CHANNEL_DESCRIPTION in position 16 and elem PAYMENT_CHANNEL with position 7 of the query payment_status
        And with the query position_receipt check assert beetwen elem PAYER_ID in position 17 and elem PAYER_ID with position 8 of the query payment_status
        And with the query position_receipt check assert beetwen elem PAYMENT_METHOD in position 18 and elem PAYMENT_METHOD with position 9 of the query payment_status
        And with the query position_receipt check assert beetwen elem FEE in position 19 and elem FEE with position 1 of the query payment_status
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And with the query position_receipt check assert beetwen elem APPLICATION_DATE in position 21 and elem APPLICATION_DATE with position 11 of the query payment_status
        And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And with the query position_receipt check assert beetwen elem METADATA in position 23 and elem METADATA with position 0 of the query position_payment_plan
        And with the query position_receipt check assert beetwen elem RT_ID in position 24 and elem METADATA with position 13 of the query rt
        And with the query position_receipt check assert beetwen elem FK_POSITION_PAYMENT in position 25 and elem METADATA with position 10 of the query payment_status
        #RT_XML
        And execution query rt_xml to get value on the table RT_XML, with the columns ID,CCP,IDENT_DOMINIO,IUV,FK_RT,TIPO_FIRMA,XML_CONTENT,INSERTED_TIMESTAMP,UPDATED_TIMESTAMP,ID_SESSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And with the query rt_xml check assert beetwen elem CCP in position 1 and elem CCP with position 0 of the query rpt
        And with the query rt_xml check assert beetwen elem IDENT_DOMINIO in position 2 and elem IDENT_DOMINIO with position 1 of the query rpt
        And with the query rt_xml check assert beetwen elem iuv in position 3 and elem iuv with position 2 of the query rpt
        And with the query rt_xml check assert beetwen elem FK_RT in position 4 and elem iuv with position 13 of the query rt
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And with the query rt_xml check assert beetwen elem ID_SESSIONE in position 9 and elem iuv with position 0 of the query rt
        #POSITION_RECEIPT_TRANSFER
        And execution query position_receipt_transfer to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_RECEIPT,s.FK_POSITION_TRANSFER under macro NewMod3 with db name nodo_online
        And execution query position_transfer to get value on the table POSITION_TRANSFER, with the columns ID under macro NewMod3 with db name nodo_online
        And with the query position_receipt_transfer check assert beetwen elem RECEIPT in position 0 and elem ID with position 26 of the query position_receipt
        And verify 1 record for the table POSITION_RECEIPT_TRANSFER retrived by the query position_receipt_transfer on db nodo_online under macro NewMod3
        And with the query position_receipt_transfer check assert beetwen elem TRANSFER in position 1 and elem ID with position 0 of the query position_transfer
        #POSITION_RECEIPT_XML
        And execution query position_receipt_xml to get value on the table POSITION_RECEIPT_XML, with the columns ID,PA_FISCAL_CODE,NOTICE_ID,CREDITOR_REFERENCE_ID,PAYMENT_TOKEN,RECIPIENT_PA_FISCAL_CODE,RECIPIENT_BROKER_PA_ID,RECIPIENT_STATION_ID,XML,INSERTED_TIMESTAMP,FK_POSITION_RECEIPT under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And with the query position_receipt_xml check assert beetwen elem PA_FISCAL_CODE in position 1 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem NOTICE_ID in position 2 and elem NOTICE_ID with position 3 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem CREDITOR_REFERENCE_ID in position 3 and elem CREDITOR_REFERENCE_ID with position 12 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem PAYMENT_TOKEN in position 4 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_PA_FISCAL_CODE in position 5 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_BROKER_PA_ID in position 6 and elem RECIPIENT_BROKER_PA_ID with position 13 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_STATION_ID in position 7 and elem RECIPIENT_STATION_ID with position 14 of the query payment_status
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And with the query position_receipt_xml check assert beetwen elem FK_POSITION_RECEIPT in position 10 and elem ID with position 26 of the query position_receipt