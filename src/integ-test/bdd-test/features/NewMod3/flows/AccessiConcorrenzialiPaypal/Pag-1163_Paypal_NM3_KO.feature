Feature: Pag-1163_Paypal_NM3_KO

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given initial XML verifyPaymentNotice
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
            <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response


    Scenario: Execute activateIOPayment (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:activateIOPaymentReq>
                        <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                        <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                        <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                        <password>pwdpwdpwd</password>
                        <!--Optional:-->
                        <idempotencyKey>#idempotency_key#</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                        </qrCode>
                        <!--Optional:-->
                        <expirationTime>6000</expirationTime>
                        <amount>10.00</amount>
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
                            <fullName>Full name</fullName>
                            <!--Optional:-->
                            <streetName>Street name</streetName>
                            <!--Optional:-->
                            <civicNumber>Civic number</civicNumber>
                            <!--Optional:-->
                            <postalCode>Postal code</postalCode>
                            <!--Optional:-->
                            <city>City</city>
                            <!--Optional:-->
                            <stateProvinceRegion>State province region</stateProvinceRegion>
                            <!--Optional:-->
                            <country>IT</country>
                            <!--Optional:-->
                            <e-mail>test.prova@gmail.com</e-mail>
                        </payer>
                    </nod:activateIOPaymentReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: Execute nodoChiediInformazioniPagamento request
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When EC sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check dettagli field exists in informazioniPagamento response
        And check IUV is $iuv of informazioniPagamento response
        And check CCP is $activateIOPaymentResponse.paymentToken of informazioniPagamento response
        And check enteBeneficiario field exists in informazioniPagamento response

    @check
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
                 <idChannel>#canale#</idChannel>
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
        And initial JSON inoltroEsito/paypal
            """
            {
                "idTransazione": "responseKO",
                "idTransazionePsp": "$activateIOPayment.idempotencyKey",
                "idPagamento": "$activateIOPaymentResponse.paymentToken",
                "identificativoIntermediario": "#psp#",
                "identificativoPsp": "#psp#",
                "identificativoCanale": "#canale#",
                "importoTotalePagato": 10,
                "timestampOperazione": "2012-04-23T18:25:43Z"
            }
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
                <delay>8000</delay>
                <outcome>KO</outcome>
                <fault>
                    <faultCode>CANALE_SEMANTICA</faultCode>
                    <faultString>Errore semantico dal psp</faultString>
                    <id>1</id>
                    <description>Errore dal psp</description>
                </fault>
            </pfn:pspNotifyPaymentRes>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And saving inoltroEsito/paypalJSON request in inoltroEsito/paypal
        When calling primitive inoltroEsito/paypal_inoltroEsito/paypal POST and sendPaymentOutcome_sendPaymentOutcome POST with 4000 ms delay
        Then verify the HTTP status code of inoltroEsito/paypal response is 200
        And check esito is KO of inoltroEsito/paypal response
        And check errorCode is RIFPSP of inoltroEsito/paypal response
        And check descrizione is Risposta negativa del Canale of inoltroEsito/paypal response
        And check outcome is KO of sendPaymentOutcome response