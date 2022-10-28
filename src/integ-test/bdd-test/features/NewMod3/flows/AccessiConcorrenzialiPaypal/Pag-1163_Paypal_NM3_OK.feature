
Feature: Checks for concorrential access of Paypal payments OK

   Background:
      Given systems up
      And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>#psp_AGID#</idPSP>
         <idBrokerPSP>#broker_AGID#</idBrokerPSP>
         <idChannel>#canale_AGID#</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>$1noticeNumber</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML activateIOPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activateIOPaymentReq>
         <fullName>name</fullName>
         <!--Optional:-->
         <streetName>street</streetName>
         <!--Optional:-->
         <civicNumber>civic</civicNumber>
         <!--Optional:-->
         <postalCode>code</postalCode>
         <!--Optional:-->
         <city>city</city>
         <!--Optional:-->
         <stateProvinceRegion>state</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>test.prova@gmail.com</e-mail>
         </payer>
         </nod:activateIOPaymentReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   Scenario: Execute activateIOPaymentReq request
      When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response

   Scenario: Execute nodoChiediInformazioniPagamento request
      Given the Execute activateIOPaymentReq request scenario executed successfully
      When EC sends rest GET /informazioniPagamento?idPagamento=$idPagamento to nodo-dei-pagamenti
      Then check importo field exists in /informazioniPagamento response
      And check ragioneSociale field exists in /informazioniPagamento response
      And check oggettoPagamento field exists in /informazioniPagamento response
      And check redirect is redirectEC of /informazioniPagamento response
      And check false field exists in /informazioniPagamento response
      And check dettagli field exists in /informazioniPagamento response
      And check iuv is $iuv of /informazioniPagamento response
      And check ccp is $ccp of /informazioniPagamento response
      And check pa field exists in /informazioniPagamento response
      And check enteBeneficiario field exists in /informazioniPagamento response
      And execution query pa_dbcheck_json to get value on the table PA, with the columns ragione_sociale under macro NewMod3 with db name nodo_cfg
      And through the query pa_dbcheck_json retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
      And check $ragione_sociale is enteBeneficiario in /informazioniPagamento response
      And check $ragione_sociale is ragioneSociale in /informazioniPagamento response


   Scenario: Node handling of nodoInoltraEsitoPagamentoPaypal and sendPaymentOutcome OK
      Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
      And initial XML sendPaymentOutcome
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>pwdpwdpwd</password>
         <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
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
         <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>SPOname</fullName>
         <!--Optional:-->
         <streetName>SPOstreet</streetName>
         <!--Optional:-->
         <civicNumber>SPOcivic</civicNumber>
         <!--Optional:-->
         <postalCode>SPOpostal</postalCode>
         <!--Optional:-->
         <city>city</city>
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
      When PSP sends rest POST /inoltroEsito/paypal to nodo-dei-pagamenti
         """
         {
            "idTransazione": "responseOKSleep",
            "idTransazionePsp": "$activateIOPayment.idempotencyKey",
            "idPagamento": "$idPagamento_1a",
            "identificativoIntermediario": "#psp#",
            "identificativoPsp": "#psp#",
            "identificativoCanale": "#canale_ATTIVATO_PRESSO_PSP#",
            "importoTotalePagato": 10,
            "timestampOperazione": "2012-04-23T18:25:43Z"
         }
         """
      And wait 4 seconds for expiration
      And psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check esito is OK in /inoltroEsito/paypal response
      And check outcome is OK in sendPaymentOutcome response

