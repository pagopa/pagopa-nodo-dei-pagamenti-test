Feature: flow checks for closePayment - PA old

   Background:
      Given systems up

   Scenario: nodoVerificaRPT
      Given initial XML nodoVerificaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoVerificaRPT>
         <identificativoPSP>#psp_AGID#</identificativoPSP>
         <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
         <identificativoCanale>#canale_AGID#</identificativoCanale>
         <password>#password#</password>
         <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
         <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
         <codiceIdRPT>
         <aim:aim128>
         <aim:CCPost>#ccPoste#</aim:CCPost>
         <aim:CodStazPA>02</aim:CodStazPA>
         <aim:AuxDigit>0</aim:AuxDigit>
         <aim:CodIUV>#iuv#</aim:CodIUV>
         </aim:aim128>
         </codiceIdRPT>
         </ws:nodoVerificaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paaVerificaRPT
         """"
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:paaVerificaRPTRisposta>
         <paaVerificaRPTRisposta>
         <esito>OK</esito>
         <datiPagamentoPA>
         <importoSingoloVersamento>1.00</importoSingoloVersamento>
         <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
         <bicAccredito>BSCTCH22</bicAccredito>
         <enteBeneficiario>
         <pag:identificativoUnivocoBeneficiario>
         <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
         <pag:codiceIdentificativoUnivoco>66666666666_05</pag:codiceIdentificativoUnivoco>
         </pag:identificativoUnivocoBeneficiario>
         <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
         <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
         <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
         <pag:indirizzoBeneficiario>"paaVerificaRPT"</pag:indirizzoBeneficiario>
         <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
         <pag:capBeneficiario>jyr</pag:capBeneficiario>
         <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
         <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
         <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
         </enteBeneficiario>
         <credenzialiPagatore>of8</credenzialiPagatore>
         <causaleVersamento>prova/RFDB/$iuv/TESTO/causale del versamento</causaleVersamento>
         </datiPagamentoPA>
         </paaVerificaRPTRisposta>
         </ws:paaVerificaRPTRisposta>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
      When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoVerificaRPT response

   Scenario: nodoAttivaRPT
      Given initial XML nodoAttivaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoAttivaRPT>
         <identificativoPSP>#psp_AGID#</identificativoPSP>
         <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
         <identificativoCanale>#canale_AGID#</identificativoCanale>
         <password>#password#</password>
         <codiceContestoPagamento>$ccp</codiceContestoPagamento>
         <identificativoIntermediarioPSPPagamento>#broker_AGID#</identificativoIntermediarioPSPPagamento>
         <identificativoCanalePagamento>#canale_AGID_02#</identificativoCanalePagamento>
         <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
         <codiceIdRPT>
         <aim:aim128>
         <aim:CCPost>#ccPoste#</aim:CCPost>
         <aim:CodStazPA>02</aim:CodStazPA>
         <aim:AuxDigit>0</aim:AuxDigit>
         <aim:CodIUV>$iuv</aim:CodIUV>
         </aim:aim128>
         </codiceIdRPT>
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
      And initial XML paaAttivaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:paaAttivaRPTRisposta>
         <paaAttivaRPTRisposta>
         <esito>OK</esito>
         <datiPagamentoPA>
         <importoSingoloVersamento>$nodoAttivaRPT.importoSingoloVersamento</importoSingoloVersamento>
         <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
         <bicAccredito>BSCTCH22</bicAccredito>
         <enteBeneficiario>
         <pag:identificativoUnivocoBeneficiario>
         <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
         <pag:codiceIdentificativoUnivoco>66666666666_05</pag:codiceIdentificativoUnivoco>
         </pag:identificativoUnivocoBeneficiario>
         <pag:denominazioneBeneficiario>97735020584</pag:denominazioneBeneficiario>
         <pag:codiceUnitOperBeneficiario>#canale_AGID_02#</pag:codiceUnitOperBeneficiario>
         <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
         <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
         <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
         <pag:capBeneficiario>gt</pag:capBeneficiario>
         <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
         <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
         <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
         </enteBeneficiario>
         <credenzialiPagatore>i</credenzialiPagatore>
         <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
         </datiPagamentoPA>
         </paaAttivaRPTRisposta>
         </ws:paaAttivaRPTRisposta>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: nodoInviaRPT
      Given RPT generation
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
         <pay_i:importoTotaleDaVersare>$nodoAttivaRPT.importoSingoloVersamento</pay_i:importoTotaleDaVersare>
         <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>$ccp</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
         <pay_i:datiSingoloVersamento>
         <pay_i:importoSingoloVersamento>$nodoAttivaRPT.importoSingoloVersamento</pay_i:importoSingoloVersamento>
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
      And initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
         <identificativoDominio>#creditor_institution_code#</identificativoDominio>
         <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
         <codiceContestoPagamento>$ccp</codiceContestoPagamento>
         </ppt:intestazionePPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaRPT>
         <password>#password#</password>
         <identificativoPSP>#psp_AGID#</identificativoPSP>
         <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
         <identificativoCanale>#canale_AGID_02#</identificativoCanale>
         <tipoFirma></tipoFirma>
         <rpt>$rptAttachment</rpt>
         </ws:nodoInviaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoInviaRPT response
      And retrieve session token from $nodoInviaRPTResponse.url

   Scenario: closePayment
      Given initial json v1/closepayment
         """
         {
            "paymentTokens": [
               "$sessionToken"
            ],
            "outcome": "OK",
            "identificativoPsp": "#psp#",
            "tipoVersamento": "BPAY",
            "identificativoIntermediario": "#id_broker_psp#",
            "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
            "pspTransactionId": "#psp_transaction_id#",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2012-04-23T18:25:43Z",
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
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentToken>$ccp</paymentToken>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>5.00</fee>
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

   Scenario: pspNotifyPayment timeout
      Given initial XML pspNotifyPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <pfn:pspNotifyPaymentRes>
         <delay>10000</delay>
         </pfn:pspNotifyPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

   Scenario: pspNotifyPayment malformata
      Given initial XML pspNotifyPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <pfn:pspNotifyPaymentRes>
         <outcome>OO</outcome>
         </pfn:pspNotifyPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

   Scenario: closePayment KO
      Given initial json v1/closepayment
         """
         {
            "paymentTokens": [
               "$sessionToken"
            ],
            "outcome": "KO"
         }
         """

   # FLUSSO_OLD_CP_01
   Scenario: FLUSSO_OLD_CP_01 (part 1)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 16000
      And the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_01 (part 2)
      Given the FLUSSO_OLD_CP_01 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_01 (part 3)
      Given the FLUSSO_OLD_CP_01 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 002$nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #id_station_old# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 10 of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value BPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      #And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # PM_SESSION_DATA
      And verify 1 record for the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column ID_SESSIONE of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value RPT of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value 12 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value None of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value $transaction_id of the record at column ID_TRANSAZIONE_PM_BPAY of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value $psp_transaction_id of the record at column ID_TRANSAZIONE_PSP_BPAY of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value EFF of the record at column OUTCOME_PAYMENT_GATEWAY of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value 2 of the record at column COMMISSIONE of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      And checks the value resOK of the record at column CODICE_AUTORIZZATIVO_BPAY of the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      # POSITION_ACTIVATE
      And verify 1 record for the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 002$nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value $ccp of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column DUE_DATE of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 10 of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column UPDATED_BY of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And check datetime plus number of date default_durata_estensione_token_IO of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_SERVICE
      And verify 1 record for the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 002$nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value Pagamento BPAY of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #ragione_sociale# of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column UPDATED_BY of the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT_PLAN
      And verify 1 record for the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 002$nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 10 of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column UPDATED_BY of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_TRANSFER
      And verify 1 record for the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE_SECONDARY of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 002$nodoInviaRPT.identificativoUnivocoVersamento of the record at column NOTICE_ID of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value IT96R0123454321000000012345 of the record at column IBAN of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value pagamento fotocopie pratica RPT of the record at column REMITTANCE_INFORMATION of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 10 of the record at column AMOUNT of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 1/abc of the record at column TRANSFER_CATEGORY of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 1 of the record at column TRANSFER_IDENTIFIER of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value Y of the record at column VALID of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column UPDATED_BY of the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT
      And verify 1 record for the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CANALE of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #psp# of the record at column PSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #id_broker_psp# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value BPAY of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 4 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_01 (part 4)
      Given the FLUSSO_OLD_CP_01 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
      And checks the value 5 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO

   # FLUSSO_OLD_CP_02
   Scenario: FLUSSO_OLD_CP_02 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_02 (part 2)
      Given the FLUSSO_OLD_CP_02 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_02 (part 3)
      Given the FLUSSO_OLD_CP_02 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test @prova
   Scenario: FLUSSO_OLD_CP_02 (part 4)
      Given the FLUSSO_OLD_CP_02 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      And outcome with KO in sendPaymentOutcome
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is KO of sendPaymentOutcome response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
      And check description is Esito discorde of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 0 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 4 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_03
   Scenario: FLUSSO_OLD_CP_03 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_03 (part 2)
      Given the FLUSSO_OLD_CP_03 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_03 (part 3)
      Given the FLUSSO_OLD_CP_03 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 0 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # PM_SESSION_DATA
      And verify 0 record for the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      # POSITION_ACTIVATE
      And verify 0 record for the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_SERVICE
      And verify 0 record for the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT_PLAN
      And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_TRANSFER
      And verify 0 record for the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT
      And verify 1 record for the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #canale_AGID_02# of the record at column CANALE of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #broker_AGID# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value PO of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_03 (part 4)
      Given the FLUSSO_OLD_CP_03 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      And outcome with KO in sendPaymentOutcome
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcome response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response
      And check description is token unknown of sendPaymentOutcome response
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 0 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 0 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 0 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value Annullato da WISP of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 0 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_04
   Scenario: FLUSSO_OLD_CP_04 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_04 (part 2)
      Given the FLUSSO_OLD_CP_04 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_04 (part 3)
      Given the FLUSSO_OLD_CP_04 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_04 (part 4)
      Given the FLUSSO_OLD_CP_04 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcome response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response
      And check description is token unknown of sendPaymentOutcome response
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 0 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 0 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 0 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value Annullato da WISP of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 0 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_05
   Scenario: FLUSSO_OLD_CP_05 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_05 (part 2)
      Given the FLUSSO_OLD_CP_05 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_05 (part 3)
      Given the FLUSSO_OLD_CP_05 (part 2) scenario executed successfully
      And the pspNotifyPayment timeout scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 12 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 3 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_05 (part 4)
      Given the FLUSSO_OLD_CP_05 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 7 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_06
   Scenario: FLUSSO_OLD_CP_06 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_06 (part 2)
      Given the FLUSSO_OLD_CP_06 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_06 (part 3)
      Given the FLUSSO_OLD_CP_06 (part 2) scenario executed successfully
      And the pspNotifyPayment malformata scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 12 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 3 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_06 (part 4)
      Given the FLUSSO_OLD_CP_06 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 7 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_07
   Scenario: FLUSSO_OLD_CP_07 (part 1)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_07 (part 2)
      Given the FLUSSO_OLD_CP_07 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_07 (part 3)
      Given the FLUSSO_OLD_CP_07 (part 2) scenario executed successfully
      And the pspNotifyPayment timeout scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 12 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 3 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_07 (part 4)
      Given the FLUSSO_OLD_CP_07 (part 3) scenario executed successfully
      When job mod3CancelV1 triggered after 0 seconds
      And job paInviaRt triggered after 5 seconds
      Then verify the HTTP status code of mod3CancelV1 response is 200
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      # POSITION & PAYMENT STATUS
      And verify 2 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_08
   Scenario: FLUSSO_OLD_CP_08 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
      And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
      And the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_08 (part 2)
      Given the FLUSSO_OLD_CP_08 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When job annullamentoRptMaiRichiesteDaPm triggered after 65 seconds
      Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_08 (part 3)
      Given the FLUSSO_OLD_CP_08 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then verify the HTTP status code of v1/closepayment response is 404
      And check esito is KO of v1/closepayment response
      And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 10
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT
      And verify 1 record for the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #canale_AGID_02# of the record at column CANALE of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #broker_AGID# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value PO of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_09
   Scenario: FLUSSO_OLD_CP_09 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
      And the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_09 (part 2)
      Given the FLUSSO_OLD_CP_09 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      And wait 62 seconds for expiration
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 4 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_09 (part 3)
      Given the FLUSSO_OLD_CP_09 (part 2) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 10
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_09.1
   Scenario: FLUSSO_OLD_CP_09.1 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
      And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
      And the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_09.1 (part 2)
      Given the FLUSSO_OLD_CP_09.1 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      And wait 62 seconds for expiration
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 4 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO

   Scenario: FLUSSO_OLD_CP_09.1 (part 3)
      Given the FLUSSO_OLD_CP_09.1 (part 2) scenario executed successfully
      When job annullamentoRptMaiRichiesteDaPm triggered after 0 seconds
      Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_09.1 (part 4)
      Given the FLUSSO_OLD_CP_09.1 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 10
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_10
   Scenario: FLUSSO_OLD_CP_10 (part 1)
      Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
      And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
      And the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_10 (part 2)
      Given the FLUSSO_OLD_CP_10 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When job annullamentoRptMaiRichiesteDaPm triggered after 65 seconds
      Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_10 (part 3)
      Given the FLUSSO_OLD_CP_10 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then verify the HTTP status code of v1/closepayment response is 404
      And check esito is KO of v1/closepayment response
      And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 10
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT
      And verify 1 record for the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #canale_AGID_02# of the record at column CANALE of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #broker_AGID# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value PO of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_11
   Scenario: FLUSSO_OLD_CP_11 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_11 (part 2)
      Given the FLUSSO_OLD_CP_11 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_11 (part 3)
      Given the FLUSSO_OLD_CP_11 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response

   Scenario: FLUSSO_OLD_CP_11 (part 4)
      Given the FLUSSO_OLD_CP_11 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with $psp_transaction_id in v1/closepayment
      And transactionId with $transaction_id in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 422
      And check esito is KO of v1/closepayment response
      And check descrizione is Esito già acquisito of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_11 (part 5)
      Given the FLUSSO_OLD_CP_11 (part 4) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_12
   Scenario: FLUSSO_OLD_CP_12 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_12 (part 2)
      Given the FLUSSO_OLD_CP_12 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_12 (part 3)
      Given the FLUSSO_OLD_CP_12 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: FLUSSO_OLD_CP_12 (part 4)
      Given the FLUSSO_OLD_CP_12 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      And pspTransactionId with $psp_transaction_id in v1/closepayment
      And transactionId with $transaction_id in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      And job paInviaRt triggered after 0 seconds
      Then verify the HTTP status code of v1/closepayment response is 404
      And check esito is KO of v1/closepayment response
      And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT
      And verify 1 record for the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #canale_AGID_02# of the record at column CANALE of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #broker_AGID# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value PO of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_13
   Scenario: FLUSSO_OLD_CP_13 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_13 (part 2)
      Given the FLUSSO_OLD_CP_13 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_13 (part 3)
      Given the FLUSSO_OLD_CP_13 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response

   Scenario: FLUSSO_OLD_CP_13 (part 4)
      Given the FLUSSO_OLD_CP_13 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      And pspTransactionId with $psp_transaction_id in v1/closepayment
      And transactionId with $transaction_id in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 422
      And check esito is KO of v1/closepayment response
      And check descrizione is Esito già acquisito of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_13 (part 5)
      Given the FLUSSO_OLD_CP_13 (part 4) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_14
   Scenario: FLUSSO_OLD_CP_14 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_14 (part 2)
      Given the FLUSSO_OLD_CP_14 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_14 (part 3)
      Given the FLUSSO_OLD_CP_14 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: FLUSSO_OLD_CP_14 (part 4)
      Given the FLUSSO_OLD_CP_14 (part 3) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with $psp_transaction_id in v1/closepayment
      And transactionId with $transaction_id in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 404
      And check esito is KO of v1/closepayment response
      And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response


   # FLUSSO_OLD_CP_15
   Scenario: FLUSSO_OLD_CP_15 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_15 (part 2)
      Given the FLUSSO_OLD_CP_15 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_15 (part 3)
      Given the FLUSSO_OLD_CP_15 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration

   Scenario: FLUSSO_OLD_CP_15 (part 4)
      Given the FLUSSO_OLD_CP_15 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      And outcome with KO in sendPaymentOutcome
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcome response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
      And check description is Esito discorde of sendPaymentOutcome response
   @test @prova
   Scenario: FLUSSO_OLD_CP_15 (part 5)
      Given the FLUSSO_OLD_CP_15 (part 4) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_16
   Scenario: FLUSSO_OLD_CP_16 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_16 (part 2)
      Given the FLUSSO_OLD_CP_16 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_16 (part 3)
      Given the FLUSSO_OLD_CP_16 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration

   Scenario: FLUSSO_OLD_CP_16 (part 4)
      Given the FLUSSO_OLD_CP_16 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_16 (part 5)
      Given the FLUSSO_OLD_CP_16 (part 4) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcome response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
      And check faultString is L'esito del pagamento risulta già acquisito dal sistema pagoPA. of sendPaymentOutcome response


   # FLUSSO_OLD_CP_17
   Scenario: FLUSSO_OLD_CP_17 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_17 (part 2)
      Given the FLUSSO_OLD_CP_17 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_17 (part 3)
      Given the FLUSSO_OLD_CP_17 (part 2) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO


   # FLUSSO_OLD_CP_18
   Scenario: FLUSSO_OLD_CP_18 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_18 (part 2)
      Given the FLUSSO_OLD_CP_18 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_18 (part 3)
      Given the FLUSSO_OLD_CP_18 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration

   Scenario: FLUSSO_OLD_CP_18 (part 4)
      Given the FLUSSO_OLD_CP_18 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      And job paInviaRt triggered after 5 seconds
      Then check outcome is OK of sendPaymentOutcome response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RECEIPT
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RT_VERSAMENTI
      And verify 1 record for the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1 of the record at column PROGRESSIVO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 10 of the record at column IMPORTO_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value pagamento fotocopie pratica RPT of the record at column CAUSALE_VERSAMENTO of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 1/abc of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column FK_RT of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query esito on db nodo_online under macro Mod1
      And verify 1 record for the table RT_XML retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 8 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_18 (part 5)
      Given the FLUSSO_OLD_CP_18 (part 4) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 422
      And check esito is KO of v1/closepayment response
      And check descrizione is Esito già acquisito of v1/closepayment response


   # FLUSSO_OLD_CP_19
   Scenario: FLUSSO_OLD_CP_19 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_19 (part 2)
      Given the FLUSSO_OLD_CP_19 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_19 (part 3)
      Given the FLUSSO_OLD_CP_19 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_19 (part 4)
      Given the FLUSSO_OLD_CP_19 (part 3) scenario executed successfully
      When PM sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of avanzamentoPagamento response is 200
      And check esito is OK of avanzamentoPagamento response


   # FLUSSO_OLD_CP_20
   Scenario: FLUSSO_OLD_CP_20 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_20 (part 2)
      Given the FLUSSO_OLD_CP_20 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_20 (part 3)
      Given the FLUSSO_OLD_CP_20 (part 2) scenario executed successfully
      And the pspNotifyPayment timeout scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 12 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_20 (part 4)
      Given the FLUSSO_OLD_CP_20 (part 3) scenario executed successfully
      When PM sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of avanzamentoPagamento response is 200
      And check esito is PARKED of avanzamentoPagamento response


   # FLUSSO_OLD_CP_21
   Scenario: FLUSSO_OLD_CP_21 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_21 (part 2)
      Given the FLUSSO_OLD_CP_21 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_21 (part 3)
      Given the FLUSSO_OLD_CP_21 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration

   Scenario: FLUSSO_OLD_CP_21 (part 4)
      Given the FLUSSO_OLD_CP_21 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_21 (part 5)
      Given the FLUSSO_OLD_CP_21 (part 4) scenario executed successfully
      When PM sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of avanzamentoPagamento response is 200
      And check esito is OK of avanzamentoPagamento response


   # FLUSSO_OLD_CP_22
   Scenario: FLUSSO_OLD_CP_22 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_22 (part 2)
      Given the FLUSSO_OLD_CP_22 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_22 (part 3)
      Given the FLUSSO_OLD_CP_22 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_22 (part 4)
      Given the FLUSSO_OLD_CP_22 (part 3) scenario executed successfully
      When PM sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of avanzamentoPagamento response is 200
      And check esito is KO of avanzamentoPagamento response


   # FLUSSO_OLD_CP_23/24
   Scenario: FLUSSO_OLD_CP_23 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_23 (part 2)
      Given the FLUSSO_OLD_CP_23 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_23 (part 3)
      Given the FLUSSO_OLD_CP_23 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      And outcome with KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: FLUSSO_OLD_CP_23 (part 4)
      Given the FLUSSO_OLD_CP_23 (part 3) scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      And codiceContestoPagamento with $ccp in nodoAttivaRPT
      And aim:CodIUV with $iuv in nodoAttivaRPT
      And causaleVersamento with prova/RFDB/018431538193400/TXT/causale $iuv in paaAttivaRPT
      And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response


   # FLUSSO_OLD_CP_27
   Scenario: FLUSSO_OLD_CP_27 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_27 (part 2)
      Given the FLUSSO_OLD_CP_27 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_27 (part 3)
      Given the FLUSSO_OLD_CP_27 (part 2) scenario executed successfully
      And the pspNotifyPayment timeout scenario executed successfully
      And delay with 8000 in pspNotifyPayment
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: FLUSSO_OLD_CP_27 (part 4)
      Given the FLUSSO_OLD_CP_27 (part 3) scenario executed successfully
      When PM sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of avanzamentoPagamento response is 200
      # And check esito is ACK_UNKNOWN of avanzamentoPagamento response
      And check esito is PARKED of avanzamentoPagamento response


   # FLUSSO_OLD_CP_28
   Scenario: FLUSSO_OLD_CP_28 (part 1)
      Given the nodoVerificaRPT scenario executed successfully
      And the nodoAttivaRPT scenario executed successfully
      When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoAttivaRPT response

   Scenario: FLUSSO_OLD_CP_28 (part 2)
      Given the FLUSSO_OLD_CP_28 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_OLD_CP_28 (part 3)
      Given the FLUSSO_OLD_CP_28 (part 2) scenario executed successfully
      And the closePayment KO scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      And job paInviaRt triggered after 0 seconds
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And verify the HTTP status code of paInviaRt response is 200
      And wait 5 seconds for expiration
      # POSITION & PAYMENT STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT
      And verify 0 record for the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
      # PM_SESSION_DATA
      And verify 0 record for the table PM_SESSION_DATA retrived by the query pm_session_old_ccp on db nodo_online under macro AppIO
      # POSITION_ACTIVATE
      And verify 0 record for the table POSITION_ACTIVATE retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_SERVICE
      And verify 0 record for the table POSITION_SERVICE retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_PAYMENT_PLAN
      And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query payment_status_old on db nodo_online under macro AppIO
      # POSITION_TRANSFER
      And verify 0 record for the table POSITION_TRANSFER retrived by the query payment_status_old on db nodo_online under macro AppIO
      # RPT
      And verify 1 record for the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #canale_AGID_02# of the record at column CANALE of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value #broker_AGID# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value PO of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      # RPT STATUS
      And verify 6 record for the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
      And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
   @test
   Scenario: FLUSSO_OLD_CP_28 (part 4)
      Given the FLUSSO_OLD_CP_28 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      And outcome with KO in sendPaymentOutcome
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcome response
      And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response