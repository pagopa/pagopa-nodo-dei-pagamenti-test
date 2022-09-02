Feature: idempotency checks for sendPaymentOutcomeV2

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

   Scenario: closePayment
      Given initial json closePayment
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

   # IDMP_SPO_11

   Scenario: IDMP_SPO_11 (part 1)
      Given nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_11 (part 2)
      Given the IDMP_SPO_11 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_11 (part 3)
      Given the IDMP_SPO_11 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_11 (part 4)
      Given the IDMP_SPO_11 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_11 (part 5)
      Given the IDMP_SPO_11 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $nodoInviaRPT.identificativoDominio of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value 002$nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $ccp of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_12

   Scenario: IDMP_SPO_12 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_12 (part 2)
      Given the IDMP_SPO_12 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_12 (part 3)
      Given the IDMP_SPO_12 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_12 (part 4)
      Given the IDMP_SPO_12 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_12 (part 5)
      Given the IDMP_SPO_12 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idPSP with Empty in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_13

   Scenario: IDMP_SPO_13 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_13 (part 2)
      Given the IDMP_SPO_13 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_13 (part 3)
      Given the IDMP_SPO_13 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_13 (part 4)
      Given the IDMP_SPO_13 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_13 (part 5)
      Given the IDMP_SPO_13 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentToken with 798c6a817ed9482fa5659c45f4a25f286 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value 798c6a817ed9482fa5659c45f4a25f286 of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_14

   Scenario: IDMP_SPO_14 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_14 (part 2)
      Given the IDMP_SPO_14 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_14 (part 3)
      Given the IDMP_SPO_14 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_14 (part 4)
      Given the IDMP_SPO_14 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_14 (part 5)
      Given the IDMP_SPO_14 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idBrokerPSP with 60000000001 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $ccp of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_15

   Scenario: IDMP_SPO_15 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_15 (part 2)
      Given the IDMP_SPO_15 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_15 (part 3)
      Given the IDMP_SPO_15 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_15 (part 4)
      Given the IDMP_SPO_15 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_15 (part 5)
      Given the IDMP_SPO_15 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_15 (part 6)
      Given the IDMP_SPO_15 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.1

   Scenario: IDMP_SPO_16.1 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_16.1 (part 2)
      Given the IDMP_SPO_16.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_16.1 (part 3)
      Given the IDMP_SPO_16.1 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_16.1 (part 4)
      Given the IDMP_SPO_16.1 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_16.1 (part 5)
      Given the IDMP_SPO_16.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.1 (part 6)
      Given the IDMP_SPO_16.1 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idPSP with 60000000001 in sendPaymentOutcomeV2
      And idBrokerPSP with 60000000001 in sendPaymentOutcomeV2
      And idChannel with 60000000001_01 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,NotNone of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.2

   Scenario: IDMP_SPO_16.2 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_16.2 (part 2)
      Given the IDMP_SPO_16.2 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_16.2 (part 3)
      Given the IDMP_SPO_16.2 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_16.2 (part 4)
      Given the IDMP_SPO_16.2 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_16.2 (part 5)
      Given the IDMP_SPO_16.2 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.2 (part 6)
      Given the IDMP_SPO_16.2 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentMethod with cash in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_16.3

   Scenario: IDMP_SPO_16.3 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_16.3 (part 2)
      Given the IDMP_SPO_16.3 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_16.3 (part 3)
      Given the IDMP_SPO_16.3 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_16.3 (part 4)
      Given the IDMP_SPO_16.3 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_16.3 (part 5)
      Given the IDMP_SPO_16.3 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_16.3 (part 6)
      Given the IDMP_SPO_16.3 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And streetName with street3 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa_token on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_17

   Scenario: IDMP_SPO_17 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_17 (part 2)
      Given the IDMP_SPO_17 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_17 (part 3)
      Given the IDMP_SPO_17 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_17 (part 4)
      Given the IDMP_SPO_17 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_17 (part 5)
      Given the IDMP_SPO_17 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $nodoInviaRPT.identificativoDominio of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $ccp of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And update through the query update_validto of the table IDEMPOTENCY_CACHE the parameter VALID_TO with $date_plus_1_min under macro NewMod1 on db nodo_online
      And wait 65 seconds for expiration

   Scenario: IDMP_SPO_17 (part 6)
      Given the IDMP_SPO_17 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
      And wait 10 seconds for expiration
      And checks the value NotNone,None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value $ccp of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_22

   Scenario: IDMP_SPO_22 (part 1)
      Given nodo-dei-pagamenti has config parameter useIdempotency set to false
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And saving nodoAttivaRPT request in nodoAttivaRPTReq
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_22 (part 2)
      Given the IDMP_SPO_22 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_22 (part 4)
      Given the IDMP_SPO_22 (part 3) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_22 (part 5)
      Given the IDMP_SPO_22 (part 4) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_22 (part 6)
      Given the IDMP_SPO_22 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_22 (part 7)
      Given the IDMP_SPO_22 (part 6) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
      And nodo-dei-pagamenti has config parameter useIdempotency set to true
      And wait 10 seconds for expiration

   # IDMP_SPO_26

   Scenario: IDMP_SPO_26 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And saving nodoAttivaRPT request in nodoAttivaRPTReq
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_26 (part 2)
      Given the IDMP_SPO_26 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_26 (part 3)
      Given the IDMP_SPO_26 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_26 (part 4)
      Given the IDMP_SPO_26 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_26 (part 5)
      Given the IDMP_SPO_26 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idempotencyKey with None in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

   # IDMP_SPO_27

   Scenario: IDMP_SPO_27 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And saving nodoAttivaRPT request in nodoAttivaRPTReq
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: IDMP_SPO_27 (part 2)
      Given the IDMP_SPO_27 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: IDMP_SPO_27 (part 3)
      Given the IDMP_SPO_27 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: IDMP_SPO_27 (part 4)
      Given the IDMP_SPO_27 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: IDMP_SPO_27 (part 5)
      Given the IDMP_SPO_27 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: IDMP_SPO_27 (part 6)
      Given the IDMP_SPO_27 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idempotencyKey with #idempotency_key2# in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"idempotency_spov2" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$sendPaymentOutcomeV2.idempotencyKey'",
#              "# idempotency_aip" : "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$nodoAttivaRPTReq.idempotencyKey'",
#              "noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "noticeid_pa_token": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and ID_DOMINIO = '#creditor_institution_code#' AND PAYMENT_TOKEN = '$idPagamento' ORDER BY ID ASC",
#              "update_validto" : "UPDATE table_name SET param = TO_DATE('value', 'YYYY-MM-DD HH24:MI:SS') WHERE IDEMPOTENCY_KEY = '$sendPaymentOutcomeV2.idempotencyKey' AND PSP_ID = '$sendPaymentOutcomeV2.idPSP"}