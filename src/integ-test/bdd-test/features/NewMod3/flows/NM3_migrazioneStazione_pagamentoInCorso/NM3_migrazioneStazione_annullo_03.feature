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
            <idChannel>#canale_old#</idChannel>
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
            <idChannel>#canale_old#</idChannel>
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
        And checks the value iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
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

    # mod3CancelV1 trigger
    Scenario: Execute mod3CancelV1
        Given the Execute station version update scenario executed successfully
        When job mod3CancelV1 triggered after 6 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200


    # test execution
    Scenario: Execution db check
        Given the Execute mod3CancelV1 scenario executed successfully
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
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        #RT_VERSAMENTI
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns s.ID,s.IMPORTO_RT,s.ESITO,s.CAUSALE_VERSAMENTO,s.DATI_SPECIFICI_RISCOSSIONE,s.COMMISSIONE_APPLICATE_PSP,s.FK_RT,s.INSERTED_TIMESTAMP,s.UPDATED_TIMESTAMP under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns s.CAUSALE_VERSAMENTO,s.DATI_SPECIFICI_RISCOSSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value 0 of the record at column IMPORTO_RT of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value SENDPAYMENTOUTCOME:KO of the record at column s.ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column s.INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column s.UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        #POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
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
        And verify 0 record for the table POSITION_RECEIPT_TRANSFER retrived by the query position_receipt_transfer on db nodo_online under macro NewMod3
        #POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        #STATI_RPT/SNAPSHOT
        And wait 30 seconds for expiration
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_KO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stato on db nodo_online under macro AppIO
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query stato on db nodo_online under macro AppIO
        #POSITION_PAYMENT_STATUS/SNAPSHOT
        And checks the value PAYING,PAYING_RPT,FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        #POSITION_STATUS/SNAPSHOT
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO

    #DB update 2
    Scenario: Execute station version update 2
        Given the Execution db check scenario executed successfully
        Then updates through the query stationUpdate of the table STAZIONI the parameter VERSIONE with 1 under macro sendPaymentResultV2 on db nodo_cfg