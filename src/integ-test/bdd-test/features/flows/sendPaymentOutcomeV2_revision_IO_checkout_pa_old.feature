Feature: revision checks for sendPaymentOutcomeV2

   Background:
      Given systems up
      And initial XML nodoVerificaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoVerificaRPT>
         <identificativoPSP>AGID_01</identificativoPSP>
         <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
         <identificativoCanale>97735020584_03</identificativoCanale>
         <password>pwdpwdpwd</password>
         <codiceContestoPagamento>$ccp</codiceContestoPagamento>
         <codificaInfrastrutturaPSP>$codifica</codificaInfrastrutturaPSP>
         <codiceIdRPT>$barcode</codiceIdRPT>
         </ws:nodoVerificaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoVerificaRPT response

   Scenario: nodoAttivaRPT
      Given initial XML nodoAttivaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoAttivaRPT>
         <identificativoPSP>AGID_01</identificativoPSP>
         <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
         <identificativoCanale>97735020584_03</identificativoCanale>
         <password>pwdpwdpwd</password>
         <codiceContestoPagamento>$ccp</codiceContestoPagamento>
         <identificativoIntermediarioPSPPagamento>97735020584</identificativoIntermediarioPSPPagamento>
         <identificativoCanalePagamento>97735020584_02</identificativoCanalePagamento>
         <codificaInfrastrutturaPSP>$codifica</codificaInfrastrutturaPSP>
         <codiceIdRPT>$barcode</codiceIdRPT>
         <datiPagamentoPSP>
         <importoSingoloVersamento>10.00</importoSingoloVersamento>
         <!--Optional:-->
         <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
         <!--Optional:-->
         <bicAppoggio>CCRTIT5TXXX</bicAppoggio>
         <!--Optional:-->
         <soggettoVersante>
         <pag:identificativoUnivocoVersante>
         <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
         <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
         </pag:identificativoUnivocoVersante>
         <pag:anagraficaVersante>Franco Rossi</pag:anagraficaVersante>
         <!--Optional:-->
         <pag:indirizzoVersante>viale Monza</pag:indirizzoVersante>
         <!--Optional:-->
         <pag:civicoVersante>1</pag:civicoVersante>
         <!--Optional:-->
         <pag:capVersante>20125</pag:capVersante>
         <!--Optional:-->
         <pag:localitaVersante>Milano</pag:localitaVersante>
         <!--Optional:-->
         <pag:provinciaVersante>MI</pag:provinciaVersante>
         <!--Optional:-->
         <pag:nazioneVersante>IT</pag:nazioneVersante>
         <!--Optional:-->
         <pag:e-mailVersante>mail@mail.it</pag:e-mailVersante>
         </soggettoVersante>
         <!--Optional:-->
         <ibanAddebito>IT96R0123454321000000012346</ibanAddebito>
         <!--Optional:-->
         <bicAddebito>CCRTIT2TXXX</bicAddebito>
         <!--Optional:-->
         <soggettoPagatore>
         <pag:identificativoUnivocoPagatore>
         <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
         <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
         </pag:identificativoUnivocoPagatore>
         <pag:anagraficaPagatore>Franco Rossi</pag:anagraficaPagatore>
         <!--Optional:-->
         <pag:indirizzoPagatore>viale Monza</pag:indirizzoPagatore>
         <!--Optional:-->
         <pag:civicoPagatore>1</pag:civicoPagatore>
         <!--Optional:-->
         <pag:capPagatore>20125</pag:capPagatore>
         <!--Optional:-->
         <pag:localitaPagatore>Milano</pag:localitaPagatore>
         <!--Optional:-->
         <pag:provinciaPagatore>MI</pag:provinciaPagatore>
         <!--Optional:-->
         <pag:nazionePagatore>IT</pag:nazionePagatore>
         <!--Optional:-->
         <pag:e-mailPagatore>mail@mail.it</pag:e-mailPagatore>
         </soggettoPagatore>
         </datiPagamentoPSP>
         </ws:nodoAttivaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: nodoInviaRPT
      Given initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>77777777777</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>77777777777_05</identificativoStazioneIntermediarioPA>
         <identificativoDominio>#creditor_institution_code#</identificativoDominio>
         <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
         <codiceContestoPagamento>$ccp</codiceContestoPagamento>
         </ppt:intestazionePPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaRPT>
         <password>pwdpwdpwd</password>
         <identificativoPSP>AGID_01</identificativoPSP>
         <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
         <identificativoCanale>97735020584_02</identificativoCanale>
         <tipoFirma></tipoFirma>
         <rpt>$rptAttachment</rpt>
         </ws:nodoInviaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: closePaymentV2
      Given initial json closePaymentV2
         """
         {
            "paymentTokens": [
               "$idPagamento"
            ],
            "outcome": "OK",
            "idPSP": "70000000001",
            "idBrokerPSP": "70000000001",
            "idChannel": "70000000001_03",
            "paymentMethod": "TPAY",
            "transactionId": "#transaction_id#",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2033-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "key": "#key#"
            }
         }
         """

   Scenario: sendPaymentOutcomeV2
      Given the scenario executed successfully
      And initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>70000000001</idPSP>
         <idBrokerPSP>70000000001</idBrokerPSP>
         <idChannel>70000000001_01</idChannel>
         <password>pwdpwdpwd</password>
         <paymentTokens>
         <paymentToken>$ccp</paymentToken>
         </paymentTokens>
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
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # REV_SPO_03

   Scenario: REV_SPO_03 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: REV_SPO_03 (part 2)
      Given the REV_SPO_03 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoAttivaRPT response in nodoInviaRPTResponse

   Scenario: REV_SPO_03 (part 3)
      Given the REV_SPO_03 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: REV_SPO_03 (part 4)
      Given the REV_SPO_03 (part 3) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 5 seconds for expiration

   Scenario: REV_SPO_03 (part 5)
      Given the REV_SPO_03 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: REV_SPO_03 (part 6)
      Given the REV_SPO_03 (part 5) scenario executed successfully
      When job paInviaRT triggered after 0 seconds
      Then checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column BROKER_PA of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_01 of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 10.00 of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 'WISP' of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 'TPAY' of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $closePaymentV2.transactionId of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value v2 of the record at column CLOSE_PAYMENT of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 10.00 of the record at column AMOUNT of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value test of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value company of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value office of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column RECIPIENT_BROKER_PA of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_01 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATUS of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value 10.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value 70000000001_01 of the record at column CANALE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1

   # REV_SPO_04

   Scenario: REV_SPO_04 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: REV_SPO_04 (part 2)
      Given the REV_SPO_04 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoAttivaRPT response in nodoInviaRPTResponse

   Scenario: REV_SPO_04 (part 3)
      Given the REV_SPO_04 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: REV_SPO_04 (part 4)
      Given the REV_SPO_04 (part 3) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      And totalAmount with 5.00 in closePaymentV2
      When PM sends closePaymentV2 to nodo-dei-pagamenti
      Then check outcome is OK of closePaymentV2 response
      And check faultCode is 200 of closePaymentV2 response
      And wait 25 seconds for expiration

   Scenario: REV_SPO_04 (part 5)
      Given the REV_SPO_04 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "iuv_identdominio": "SELECT columns FROM table_name WHERE IUV = '$iuv' and IDENT_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "iuv_iddominio": "SELECT columns FROM table_name WHERE IUV = '$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "position_subject": "SELECT columns FROM table_name WHERE ENTITY_UNIQUE_IDENTIFIER_VALUE = '$sendPaymentOutcomeV2.entityUniqueIdentifierValue' and INSERTED_TIMESTAMP > TO_DATE ('$date','YYYY-MM-DD HH24:MI:SS')"}