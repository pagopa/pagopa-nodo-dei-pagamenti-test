Feature: process tests for nodoInviaRPT [REV_NIRPT_01]

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

    # Payment Outcome Phase outcome OK
    Scenario: Execute sendPaymentOutcome request
        Given the Execute activatePaymentNotice request Scenario executed successfully
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
            <entityUniqueIdentifierValue>#id_station#</entityUniqueIdentifierValue>
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

    # test execution
    Scenario: Define RPT
        Given the Execute sendPaymentOutcome request Scenario executed successfully
        And RPT generation

            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#codicePA_old#</pay_i:identificativoDominio>
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
        #DB CHECK-POSITION_PAYMENT_STATUS
        And checks the value PAYING, PAID_NORPT, PAID, NOTICE_GENERATED, NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        #DB CHECK POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        #DB CHECK STATI_RPT
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO_MOD3, RPT_RISOLTA_OK, RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
        #DB CHECK STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3
        # DB CHECK POSITION_SUBJECT
        And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_3 on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        #DB CHECK-POSITION_SERVICE
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns debtor_id under macro NewMod3 with db name nodo_online
        And execution query position_subject_3 to get value on the table POSITION_SUBJECT, with the columns id under macro NewMod3 with db name nodo_online
        And with the query position_service check assert beetwen elem debtor_id in position 0 and elem id with position 0 of the query position_subject_3
        #DB CHECK-POSITION_PAYMENT
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns rpt_id under macro NewMod3 with db name nodo_online
        And execution query rpt to get value on the table RPT, with the columns id under macro NewMod3 with db name nodo_online
        And with the query position_receipt_recipient check assert beetwen elem rpt_id in position 0 and elem id with position 0 of the query rpt
        #DB CHECK-POSITION_TRANSFER
        And execution query position_transfer to get value on the table POSITION_TRANSFER, with the columns transfer_category under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns dati_specifici_riscossione under macro NewMod3 with db name nodo_online
        And with the query position_transfer check assert beetwen elem rpt_id in position 0 and elem dati_specifici_riscossione with position 0 of the query rpt_versamenti
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
        And execution query rt to get value on the table RT, with the columns ID_RICHIESTA under macro NewMod3 with db name nodo_online
        And execution query rpt to get value on the table RPT, with the columns ID_MSG_RICH under macro NewMod3 with db name nodo_online
        And with the query rt check assert beetwen elem ID_RICHIESTA in position 0 and elem ID_MSG_RICH with position 0 of the query rpt
        And execution query rt to get value on the table RT, with the columns SOMMA_VERSAMENTI under macro NewMod3 with db name nodo_online
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns AMOUNT under macro NewMod3 with db name nodo_online
        And with the query rt check assert beetwen elem SOMMA_VERSAMENTI in position 0 and elem AMOUNT with position 0 of the query position_receipt_recipient
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        And checks the value 15376371009_01 of the record at column CANALE of the table RT retrived by the query rt on db nodo_online under macro NewMod3
        #DB CHECK-RT_VERSAMENTI
        And checks the value NotNone of the record at column ID of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns IMPORTO_RT under macro NewMod3 with db name nodo_online
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns AMOUNT under macro NewMod3 with db name nodo_online
        And with the query rt_versamenti check assert beetwen elem IMPORTO_RT in position 0 and elem AMOUNT with position 0 of the query position_receipt_recipient
        And checks the value ESEGUITO of the record at column ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3        
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns causale_versamento under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns causale_versamento under macro NewMod3 with db name nodo_online
        And with the query rt_versamenti check assert beetwen elem causale_versamento in position 0 and elem causale_versamento with position 0 of the query rpt_versamenti        
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns dati_specifici_riscossione under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti to get value on the table RPT_VERSAMENTI, with the columns dati_specifici_riscossione under macro NewMod3 with db name nodo_online
        And with the query rt_versamenti check assert beetwen elem dati_specifici_riscossione in position 0 and elem dati_specifici_riscossione with position 0 of the query rpt_versamenti        
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns COMMISSIONE_APPLICATE_PSP under macro NewMod3 with db name nodo_online
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns fee under macro NewMod3 with db name nodo_online
        And with the query rt_versamenti check assert beetwen elem COMMISSIONE_APPLICATE_PSP in position 0 and elem fee with position 0 of the query position_receipt_recipient        
        And execution query rt_versamenti to get value on the table RT_VERSAMENTI, with the columns fk_RT under macro NewMod3 with db name nodo_online
        And execution query rt to get value on the table RT, with the columns id under macro NewMod3 with db name nodo_online
        And with the query rt_versamenti check assert beetwen elem fk_RT in position 0 and elem id with position 0 of the query rt
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3

        #DB CHECK POSITION_RECEIPT
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column receipt_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        
        #assert creditor == rows4.creditor_reference_id[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns creditor_reference_id under macro NewMod3 with db name nodo_online
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns creditor_reference_id under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem creditor_reference_id in position 0 and elem creditor_reference_id with position 0 of the query position_receipt_recipient
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
        
        #assert outcome == rows4.outcome[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns outcome under macro NewMod3 with db name nodo_online
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns outcome under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem outcome in position 0 and elem outcome with position 0 of the query position_receipt_recipient
        
        #assert amount == rows4.amount[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns payment_amount under macro NewMod3 with db name nodo_online
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns amount under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem payment_amount in position 0 and elem amount with position 0 of the query position_receipt_recipient
        
        #assert description == rows10.description[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns description under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns description under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem description in position 0 and elem description with position 0 of the query position_service
        
        #assert company == rows10.company_name[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns company_name under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns company_name under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem company_name in position 0 and elem company_name with position 0 of the query position_service
        
        #assert office == rows10.office_name[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns office_name under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns office_name under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem office_name in position 0 and elem office_name with position 0 of the query position_service
        
        #assert debtor == rows10.debtor_id[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns debtor_id under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns debtor_id under macro NewMod3 with db name nodo_online
        And with the query position_receipt check assert beetwen elem debtor_id in position 0 and elem debtor_id with position 0 of the query position_service  
        And checks the value $activatePaymentNotice.idPSP of the record at column psp_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3

        #assert pspCompany == rows13.ragione_sociale[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns PSP_COMPANY_NAME under macro NewMod3 with db name nodo_online													
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE under macro NewMod3 with db name nodo_cfg													
        And with the query position_receipt check assert beetwen elem PSP_COMPANY_NAME in position 0 and elem RAGIONE_SOCIALE with position 0 of the query psp													

        #assert pspFiscalCode == rows13.codice_fiscale[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns PSP_FISCAL_CODE under macro NewMod3 with db name nodo_online													
        And execution query psp to get value on the table PSP, with the columns CODICE_FISCALE under macro NewMod3 with db name nodo_cfg													
        And with the query position_receipt check assert beetwen elem PSP_FISCAL_CODE in position 0 and elem CODICE_FISCALE with position 0 of the query psp													

        #assert pspVat == rows13.vat_number[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns PSP_VAT_NUMBER under macro NewMod3 with db name nodo_online													
        And execution query psp to get value on the table PSP, with the columns VAT_NUMBER under macro NewMod3 with db name nodo_cfg													
        And with the query position_receipt check assert beetwen elem PSP_VAT_NUMBER in position 0 and elem VAT_NUMBER with position 0 of the query psp													

        #assert channel == rows4.channel_id[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns channel_id under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns channel_id under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem channel_id in position 0 and elem channel_id with position 0 of the query position_receipt_recipient													

        #assert channelDescription == rows4.payment_channel[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns channel_description under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns payment_channel under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem channel_description in position 0 and elem payment_channel with position 0 of the query position_receipt_recipient													

        #assert payer == rows4.payer_id[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns payer_id under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns payer_id under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem payer_id in position 0 and elem payer_id with position 0 of the query position_receipt_recipient													

        #assert paymentMethod == rows4.payment_method[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns payment_method under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns payment_method under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem payment_method in position 0 and elem payment_method with position 0 of the query position_receipt_recipient													

        #assert fee == rows4.fee[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns FEE under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns FEE under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem FEE in position 0 and elem FEE with position 0 of the query position_receipt_recipient													

        #assert paymentDateTime == rows4.inserted_timestamp[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns PAYMENT_DATE_TIME under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns INSERTED_TIMESTAMP under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem PAYMENT_DATE_TIME in position 0 and elem INSERTED_TIMESTAMP with position 0 of the query position_receipt_recipient													

        #assert applicationDate == rows4.application_date[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns APPLICATION_DATE under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns APPLICATION_DATE under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem APPLICATION_DATE in position 0 and elem APPLICATION_DATE with position 0 of the query position_receipt_recipient													

        #assert transferDate == rows4.transfer_date[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns TRANSFER_DATE under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns TRANSFER_DATE under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem TRANSFER_DATE in position 0 and elem TRANSFER_DATE with position 0 of the query position_receipt_recipient													

        #assert metadata == rows14.metadata[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns METADATA under macro NewMod3 with db name nodo_online													
        And execution query position_payment_plan to get value on the table POSITION_PAYMENT_PLAN, with the columns METADATA under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem METADATA in position 0 and elem METADATA with position 0 of the query position_payment_plan													

        #assert rtID == rows1.id[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns RT_ID under macro NewMod3 with db name nodo_online													
        And execution query rt to get value on the table RT, with the columns ID under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem RT_ID in position 0 and elem ID with position 0 of the query rt													

        #assert fkPayment == rows4.id[0]
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns FK_POSITION_PAYMENT under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns ID under macro NewMod3 with db name nodo_online													
        And with the query position_receipt check assert beetwen elem FK_POSITION_PAYMENT in position 0 and elem ID with position 0 of the query position_receipt_recipient													

        #CHECK DB POSITION_RECEIPT_RECIPIENT
        #And checks the value None of the record at column id of the table POSITION_RECEIPT_RECIPIENT retrived by the query position_payment_plan on db nodo_online under macro NewMod3											
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query position_payment_plan on db nodo_online under macro NewMod3

        #CHECK DB RT_XML
        #assert id4 != null
        And checks the value NotNone of the record at column id of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3											

        #assert fkRT1 == rows1.id[0]
        And execution query rt_xml to get value on the table RT_XML, with the columns FK_RT under macro NewMod3 with db name nodo_online													
        And execution query rt to get value on the table RT, with the columns ID under macro NewMod3 with db name nodo_online													
        And with the query rt_xml check assert beetwen elem FK_RT in position 0 and elem ID with position 0 of the query rt													
        
        #assert tipoFirma == null
        And checks the value None of the record at column tipo_firma of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3											
        #And verify 0 record for the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3

        #assert xmlContent != null
        And checks the value NotNone of the record at column xml_content of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3											

        #assert insertedTimestamp4 != null
        And checks the value NotNone of the record at column inserted_timestamp of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3											

        #assert updatedTimestamp4 != null
        And checks the value NotNone of the record at column updated_timestamp of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3											

        #assert sessionID != null
        And checks the value NotNone of the record at column id_sessione of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3											

        #DB POSITION_RECEIPT_TRANSFER
        #assert fkPositionReceipt == rows12.id[0]
        And execution query position_transfer_2 to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_RECEIPT under macro NewMod3 with db name nodo_online													
        And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns ID under macro NewMod3 with db name nodo_online													
        And with the query position_transfer_2 check assert beetwen elem FK_POSITION_RECEIPT in position 0 and elem ID with position 0 of the query position_receipt													
                        
        #assert fkPositionTransfer == rows11.id[0]
        And execution query position_transfer_2 to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_TRANSFER under macro NewMod3 with db name nodo_online													
        And execution query position_status_n to get value on the table POSITION_TRANSFER, with the columns ID under macro NewMod3 with db name nodo_online													
        And with the query position_transfer_2 check assert beetwen elem FK_POSITION_TRANSFER in position 1 and elem ID with position 0 of the query position_status_n													

        #DB POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column id of the table POSITION_RECEIPT_XML retrived by the query position_status_n on db nodo_online under macro NewMod3											
        And checks the value $iuv of the record at column creditor_reference_id of the table POSITION_RECEIPT_XML retrived by the query position_status_n on db nodo_online under macro NewMod3											
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_RECEIPT_XML retrived by the query position_status_n on db nodo_online under macro NewMod3											
        
        #assert recipientPAFiscalCode == rows4.pa_fiscal_code[0]
        And execution query position_status_n to get value on the table POSITION_RECEIPT_XML, with the columns RECIPIENT_PA_FISCAL_CODE under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns PA_FISCAL_CODE under macro NewMod3 with db name nodo_online													
        And with the query position_status_n check assert beetwen elem RECIPIENT_PA_FISCAL_CODE in position 0 and elem PA_FISCAL_CODE with position 0 of the query position_receipt_recipient													

        #assert recipientBrokerPaID == rows4.broker_pa_id[0]
        And execution query position_status_n to get value on the table POSITION_RECEIPT_XML, with the columns RECIPIENT_BROKER_PA_ID under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns BROKER_PA_ID under macro NewMod3 with db name nodo_online													
        And with the query position_status_n check assert beetwen elem RECIPIENT_BROKER_PA_ID in position 0 and elem BROKER_PA_ID with position 0 of the query position_receipt_recipient													

        #assert recipientStationID == rows4.station_id[0]
        And execution query position_status_n to get value on the table POSITION_RECEIPT_XML, with the columns RECIPIENT_STATION_ID under macro NewMod3 with db name nodo_online													
        And execution query position_receipt_recipient to get value on the table POSITION_PAYMENT, with the columns STATION_ID under macro NewMod3 with db name nodo_online													
        And with the query position_status_n check assert beetwen elem RECIPIENT_STATION_ID in position 0 and elem STATION_ID with position 0 of the query position_receipt_recipient													
        And checks the value NotNone of the record at column xml of the table POSITION_RECEIPT_XML retrived by the query position_status_n on db nodo_online under macro NewMod3											
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_RECEIPT_XML retrived by the query position_status_n on db nodo_online under macro NewMod3											

