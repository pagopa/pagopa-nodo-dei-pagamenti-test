Feature: flux / semantic checks for sendPaymentOutcomeV2

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
            "paymentMethod": "BPAY",
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

   # SEM_SPO_7.1

   Scenario: SEM_SPO_7.1 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_7.1 (part 2)
      Given the SEM_SPO_7.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_7.1 (part 3)
      Given the SEM_SPO_7.1 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_7.1 (part 4)
      Given the SEM_SPO_7.1 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_7.1 (part 5)
      Given the SEM_SPO_7.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idChannel with 70000000001_08 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_21

   Scenario: SEM_SPO_21 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_21 (part 2)
      Given the SEM_SPO_21 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_21 (part 3)
      Given the SEM_SPO_21 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_21 (part 4)
      Given the SEM_SPO_21 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_21 (part 5)
      Given the SEM_SPO_21 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1

   # SEM_SPO_23

   Scenario: SEM_SPO_23 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_23 (part 2)
      Given the SEM_SPO_23 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_23 (part 3)
      Given the SEM_SPO_23 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_23 (part 4)
      Given the SEM_SPO_23 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_23 (part 5)
      Given the SEM_SPO_23 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_23 (part 6)
      Given the SEM_SPO_23 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # SEM_SPO_23.1

   Scenario: SEM_SPO_23.1 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_23.1 (part 2)
      Given the SEM_SPO_23.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_23.1 (part 3)
      Given the SEM_SPO_23.1 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_23.1 (part 4)
      Given the SEM_SPO_23.1 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_23.1 (part 5)
      Given the SEM_SPO_23.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_23.1 (part 6)
      Given the SEM_SPO_23.1 (part 5) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # SEM_SPO_28

   Scenario: SEM_SPO_28 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_28 (part 2)
      Given the SEM_SPO_28 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_28 (part 3)
      Given the SEM_SPO_28 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_28 (part 4)
      Given the SEM_SPO_28 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_28 (part 5)
      Given the SEM_SPO_28 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And outcome with KO in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome KO non accettabile of sendPaymentOutcomeV2 response

   # SEM_SPO_29

   Scenario: SEM_SPO_29 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_29 (part 2)
      Given the SEM_SPO_29 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_29 (part 3)
      Given the SEM_SPO_29 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_29 (part 4)
      Given the SEM_SPO_29 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 5 seconds for expiration

   Scenario: SEM_SPO_29 (part 5)
      Given the SEM_SPO_29 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And fee with 3.00 in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_31

   Scenario: SEM_SPO_31 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_31 (part 2)
      Given the SEM_SPO_31 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_31 (part 3)
      Given the SEM_SPO_31 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_31 (part 4)
      Given the SEM_SPO_31 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 002011451292109621 under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_31 (part 5)
      Given the SEM_SPO_31 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And update through the query update_noticeidrandom_pa of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 002$iuv under macro NewMod1 on db nodo_online

   # SEM_SPO_32

   Scenario: SEM_SPO_32 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_32 (part 2)
      Given the SEM_SPO_32 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_32 (part 3)
      Given the SEM_SPO_32 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_32 (part 4)
      Given the SEM_SPO_32 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_32 (part 5)
      Given the SEM_SPO_32 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response

   # SEM_SPO_33

   Scenario: SEM_SPO_33 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_33 (part 2)
      Given the SEM_SPO_33 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_33 (part 3)
      Given the SEM_SPO_33 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_33 (part 4)
      Given the SEM_SPO_33 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_ACCEPTED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_33 (part 5)
      Given the SEM_SPO_33 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_33.1

   Scenario: SEM_SPO_33.1 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_33.1 (part 2)
      Given the SEM_SPO_33.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_33.1 (part 3)
      Given the SEM_SPO_33.1 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_33.1 (part 4)
      Given the SEM_SPO_33.1 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_UNKNOWN under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_33.1 (part 5)
      Given the SEM_SPO_33.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And checks the value None of the record at column ID of the table NMU_CANCEL_UTILITY retrived by the query transationid on db nodo_online under macro NewMod1

   # SEM_SPO_35.1

   Scenario: SEM_SPO_35.1 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_35.1 (part 2)
      Given the SEM_SPO_35.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_35.1 (part 3)
      Given the SEM_SPO_35.1 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.1 (part 4)
      Given the SEM_SPO_35.1 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter ACTIVATION_PENDING with Y under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.1 (part 5)
      Given the SEM_SPO_35.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.2

   Scenario: SEM_SPO_35.2 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_35.2 (part 2)
      Given the SEM_SPO_35.2 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_35.2 (part 3)
      Given the SEM_SPO_35.2 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.2 (part 4)
      Given the SEM_SPO_35.2 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYING under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.2 (part 5)
      Given the SEM_SPO_35.2 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.4

   Scenario: SEM_SPO_35.4 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_35.4 (part 2)
      Given the SEM_SPO_35.4 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_35.4 (part 3)
      Given the SEM_SPO_35.4 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.4 (part 4)
      Given the SEM_SPO_35.4 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SENT under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.4 (part 5)
      Given the SEM_SPO_35.4 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.5

   Scenario: SEM_SPO_35.5 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_35.5 (part 2)
      Given the SEM_SPO_35.5 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_35.5 (part 3)
      Given the SEM_SPO_35.5 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.5 (part 4)
      Given the SEM_SPO_35.5 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SEND_ERROR under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.5 (part 5)
      Given the SEM_SPO_35.5 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.6

   Scenario: SEM_SPO_35.6 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_35.6 (part 2)
      Given the SEM_SPO_35.6 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_35.6 (part 3)
      Given the SEM_SPO_35.6 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_35.6 (part 4)
      Given the SEM_SPO_35.6 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_token_pa of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_REFUSED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_35.6 (part 5)
      Given the SEM_SPO_35.6 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_36

   Scenario: SEM_SPO_36 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_36 (part 2)
      Given the SEM_SPO_36 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_36 (part 3)
      Given the SEM_SPO_36 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_36 (part 4)
      Given the SEM_SPO_36 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_36 (part 5)
      Given the SEM_SPO_36 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

   # SEM_SPO_36.1

   Scenario: SEM_SPO_36.1 (part 1)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: SEM_SPO_36.1 (part 2)
      Given the SEM_SPO_36.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: SEM_SPO_36.1 (part 3)
      Given the SEM_SPO_36.1 (part 2) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: SEM_SPO_36.1 (part 4)
      Given the SEM_SPO_36.1 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check outcome is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And update through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online
      And wait 10 seconds for expiration

   Scenario: SEM_SPO_36.1 (part 5)
      Given the SEM_SPO_36.1 (part 4) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"update_token_pa" : "UPDATE table_name SET param = 'value' WHERE PAYMENT_TOKEN ='$idPagamento' and PA_FISCAL_CODE='#creditor_institution_code#",
#              "update_noticeid_pa": "UPDATE table_name SET param = 'value' WHERE NOTICE_ID ='002$iuv' and PA_FISCAL_CODE='#creditor_institution_code#'",
#              "update_noticeidrandom_pa": "UPDATE table_name SET param = 'value' WHERE NOTICE_ID ='002011451292109621' and PA_FISCAL_CODE='#creditor_institution_code#'",
#              "noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "transactionid": "SELECT columns FROM table_name WHERE TRANSACTION_ID = '$closePayment.transactionId'"}