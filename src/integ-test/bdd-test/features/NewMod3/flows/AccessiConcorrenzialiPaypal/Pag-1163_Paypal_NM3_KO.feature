Feature: Checks for concorrential access of Paypal payments KO

    Background:
        Given systems up
        And initial XML verifyPaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:verifyPaymentNoticeReq>
                 <idPSP>AGID_01</idPSP>
                 <idBrokerPSP>97735020584</idBrokerPSP>
                 <idChannel>97735020584_03</idChannel>
                 <password>pwdpwdpwd</password>
                 <qrCode>
                    <fiscalCode>77777777777</fiscalCode>
                    <noticeNumber>311$iuv</noticeNumber>
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
                        <idPSP>70000000001</idPSP>
                        <idBrokerPSP>70000000001</idBrokerPSP>
                        <idChannel>70000000001_01</idChannel>
                        <password>pwdpwdpwd</password>
                        <!--Optional:-->
                        <idempotencyKey>$idempotenza</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#fiscalCodePA#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                        <!--Optional:-->
                        <expirationTime>12345</expirationTime>
                        <amount>70.00</amount>
                        <!--Optional:-->
                        <dueDate>2021-12-12</dueDate>
                        <!--Optional:-->
                        <paymentNote>test</paymentNote>
                        <!--Optional:-->
                        <payer>
                            <uniqueIdentifier>
                                <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                                <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
                            </uniqueIdentifier>
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
        When EC sends rest GET /informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then check importo field exists in /informazioniPagamento response
        And check ragioneSociale field exists in /informazioniPagamento response
        And check oggettoPagamento field exists in /informazioniPagamento response
        And check redirect is redirectEC in /informazioniPagamento response
        And check false field exists in /informazioniPagamento response
        And check dettagli field exists in /informazioniPagamento response
        And check iuv field exists in /informazioniPagamento response
        And check ccp field exists in /informazioniPagamento response
        And check pa field exists in /informazioniPagamento response
        And check enteBeneficiario field exists in /informazioniPagamento response
        And execution query pa_dbcheck_json to get value on the table PA, with the columns ragione_sociale under macro NewMod3 with db name nodo_cfg
        And through the query pa_dbcheck_json retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
        And check $ragione_sociale is enteBeneficiario in /informazioniPagamento response
        And check $ragione_sociale is ragioneSociale in /informazioniPagamento response


    Scenario: Node handling of nodoInoltraEsitoPagamentoPaypal and sendPaymentOutcome KO
        Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
        And initial XML sendPaymentOutcome
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:sendPaymentOutcomeReq>
                 <idPSP>#psp#</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_07</idChannel>
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
                          <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
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
        {"idTransazione": "responseKOSleep",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$idPagamento_1a",
        "identificativoIntermediario": "70000000001",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "70000000001_07",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"}
        """
        And wait 5 seconds for expiration
        And psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check esito is KO in /inoltroEsito/paypal response
        And check RIFPSP is Risposta negativa del Canale in /inoltroEsito/paypal response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response