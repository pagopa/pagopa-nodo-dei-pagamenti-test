Feature: flux checks for sendPaymentResult

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
            "identificativoPsp": "70000000001",
            "tipoVersamento": "BPAY",
            "identificativoIntermediario": "70000000001",
            "identificativoCanale": "70000000001_03",
            "pspTransactionId": "resSPR_200OK",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2033-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "transactionId": "#transaction_id#",
               "outcomePaymentGateway": "EFF",
               "authorizationCode": "resOK"
            }
         }
         """

   Scenario: sendPaymentOutcome
      Given initial XML sendPaymentOutcome
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeReq>
         <idPSP>70000000001</idPSP>
         <idBrokerPSP>70000000001</idBrokerPSP>
         <idChannel>70000000001_03</idChannel>
         <password>pwdpwdpwd</password>
         <paymentToken>$idPagamento</paymentToken>
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
         <fullName>SPOname_$idPagamento</fullName>
         <!--Optional:-->
         <streetName>SPOstreet</streetName>
         <!--Optional:-->
         <civicNumber>SPOcivic</civicNumber>
         <!--Optional:-->
         <postalCode>SPOpostal</postalCode>
         <!--Optional:-->
         <city>SPOcity</city>
         <!--Optional:-->
         <stateProvinceRegion>SPOstate</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>SPOprova@test.it</e-mail>
         </payer>
         <applicationDate>2021-12-12</applicationDate>
         <transferDate>2021-12-11</transferDate>
         </details>
         </nod:sendPaymentOutcomeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # T_SPR_15

   Scenario: T_SPR_15 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_15 (nodoInviaRPT)
      Given the T_SPR_15 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_15 (informazioniPagamento)
      Given the T_SPR_15 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_15 (closePayment)
      Given the T_SPR_15 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_16

   Scenario: T_SPR_16 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_16 (nodoInviaRPT)
      Given the T_SPR_16 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_16 (informazioniPagamento)
      Given the T_SPR_16 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_16 (closePayment)
      Given the T_SPR_16 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And authorizationCode with resTim in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 10 seconds for expiration

   Scenario: T_SPR_16 (sendPaymentOutcome)
      Given the T_SPR_16 (closePayment) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATE,NOTICE_STORED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_17

   Scenario: T_SPR_17 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_17 (nodoInviaRPT)
      Given the T_SPR_17 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_17 (informazioniPagamento)
      Given the T_SPR_17 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_17 (closePayment)
      Given the T_SPR_17 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And authorizationCode with resMal in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 20 seconds for expiration

   Scenario: T_SPR_17 (sendPaymentOutcome)
      Given the T_SPR_17 (closePayment) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_18

   Scenario: T_SPR_18 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_18 (nodoInviaRPT)
      Given the T_SPR_18 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_18 (informazioniPagamento)
      Given the T_SPR_18 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_18 (closePayment)
      Given the T_SPR_18 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And authorizationCode with resKO in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ANNULLATA_WISP,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_19

   Scenario: T_SPR_19 (nodoAttivaRPT)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_19 (nodoInviaRPT)
      Given the T_SPR_19 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_19 (informazioniPagamento)
      Given the T_SPR_19 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_19 (closePayment)
      Given the T_SPR_19 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And authorizationCode with resTim in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response

   Scenario: T_SPR_19 (mod3CancelV1)
      Given the T_SPR_19 (closePayment) scenario executed successfully
      When job mod3CancelV1 triggered after 20 seconds
      Then nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      And wait 10 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ANNULLATA_WISP,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_20

   Scenario: T_SPR_20 (nodoAttivaRPT)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_20 (nodoInviaRPT)
      Given the T_SPR_20 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_20 (informazioniPagamento)
      Given the T_SPR_20 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_20 (closePayment)
      Given the T_SPR_20 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And authorizationCode with resMal in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response

   Scenario: T_SPR_20 (mod3CancelV1)
      Given the T_SPR_20 (closePayment) scenario executed successfully
      When job mod3CancelV1 triggered after 20 seconds
      Then nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      And wait 10 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ANNULLATA_WISP,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_21

   Scenario: T_SPR_21 (nodoAttivaRPT)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_21 (nodoInviaRPT)
      Given the T_SPR_21 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_21 (informazioniPagamento)
      Given the T_SPR_21 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_21 (closePayment)
      Given the T_SPR_21 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And authorizationCode with resIrr in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response

   Scenario: T_SPR_21 (mod3CancelV1)
      Given the T_SPR_21 (closePayment) scenario executed successfully
      When job mod3CancelV1 triggered after 20 seconds
      Then nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      And wait 10 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value CANCELLED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value INSERTED,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ANNULLATA_WISP,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_22

   Scenario: T_SPR_22 (nodoAttivaRPT)
      Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
      And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
      And wait 10 seconds for expiration
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_22 (nodoInviaRPT)
      Given the T_SPR_22 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_22 (annullamentoRptMaiRichiesteDaPm)
      Given the T_SPR_22 (nodoInviaRPT) scenario executed successfully
      When job annullamentoRptMaiRichiesteDaPm triggered after 70 seconds
      Then wait 0 seconds for expiration

   Scenario: T_SPR_22 (closePayment)
      Given the T_SPR_22 (mod3CancelV1) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is KO of closePayment response
      And check faultCode is 400 of closePayment response
      And check descrizione is Esito non accettabile a token scaduto
      Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 10
      And wait 10 seconds for expiration
      And checks the value None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ANNULLATA_WISP,RT_GENERATA_NODO,RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_23

   Scenario: T_SPR_23 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_23 (nodoInviaRPT)
      Given the T_SPR_23 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_23 (informazioniPagamento)
      Given the T_SPR_23 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_23 (closePayment)
      Given the T_SPR_23 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_200KO in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 70 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query token_psptransactionid on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_24

   Scenario: T_SPR_24 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_24 (nodoInviaRPT)
      Given the T_SPR_24 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_24 (informazioniPagamento)
      Given the T_SPR_24 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_24 (closePayment)
      Given the T_SPR_24 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_400 in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 70 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 77777777777_05 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_25

   Scenario: T_SPR_25 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_25 (nodoInviaRPT)
      Given the T_SPR_25 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_25 (informazioniPagamento)
      Given the T_SPR_25 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_25 (closePayment)
      Given the T_SPR_25 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_404 in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 70 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 77777777777_05 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_26

   Scenario: T_SPR_26 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_26 (nodoInviaRPT)
      Given the T_SPR_26 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_26 (informazioniPagamento)
      Given the T_SPR_26 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_26 (closePayment)
      Given the T_SPR_26 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_408 in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 70 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 77777777777_05 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_27

   Scenario: T_SPR_27 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_27 (nodoInviaRPT)
      Given the T_SPR_27 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_27 (informazioniPagamento)
      Given the T_SPR_27 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_27 (closePayment)
      Given the T_SPR_27 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_422 in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 70 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 77777777777_05 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

   # T_SPR_28

   Scenario: T_SPR_28 (nodoAttivaRPT)
      Given the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoAttivaRPT response
      And save nodoAttivaRPT response in nodoAttivaRPTResponse

   Scenario: T_SPR_28 (nodoInviaRPT)
      Given the T_SPR_28 (nodoAttivaRPT) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
      And save nodoInviaRPT response in nodoInviaRPTResponse

   Scenario: T_SPR_28 (informazioniPagamento)
      Given the T_SPR_28 (nodoInviaRPT) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_28 (closePayment)
      Given the T_SPR_28 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_400 in closePayment
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And wait 90 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value NotNone,None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column IUV of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column CCP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $closePayment.pspTransactionId of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001 of the record at column PSP_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 77777777777_05 of the record at column STAZIONE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 70000000001_01 of the record at column CANALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And update through the query update_noticeid_iddominio of the table POSITION_RETRY_SENDPAYMENTRESULT the parameter PSP_TRANSACTION_ID with resSPR_200OK under macro AppIO on db nodo_online
      And wait 90 seconds for expiration
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED,None of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value PAYING,None of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pafiscalcode on db nodo_online under macro AppIO
      And checks the value None of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query noticeid_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP,None of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv_iddominio on db nodo_online under macro AppIO

# da aggiungere in query_AutomationTest.json
# "AppIO" : {"noticeid_pafiscalcode": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and PA_FISCAL_CODE = '#creditor_institution_code#' ORDER BY ID ASC",
#            "token_psptransactionid": "SELECT columns FROM table_name WHERE PAYMENT_TOKEN = '$idPagamento' and PSP_TRANSACTION_ID = '$closePayment.pspTransactionId' ORDER BY ID ASC",
#            "noticeid_iddominio": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#            "iuv_iddominio": "SELECT columns FROM table_name WHERE IUV = '$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#            "update_noticeid_iddominio": "UPDATE table_name SET param = 'value' WHERE NOTICE_ID ='002$iuv' and ID_DOMINIO = '#creditor_institution_code#'"}