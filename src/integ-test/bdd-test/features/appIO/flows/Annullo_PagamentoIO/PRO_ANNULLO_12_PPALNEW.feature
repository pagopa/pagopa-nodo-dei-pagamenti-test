Feature: PRO_ANNULLO_12_PPALNEW

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given nodo-dei-pagamenti has config parameter scheduler.cancelIOPaymentActorMinutesToBack set to 1
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
                    <noticeNumber>#notice_number#</noticeNumber>
                </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
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
                <password>$verifyPaymentNotice.password</password>
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
                <paymentNote>responseFull</paymentNote>
                <!--Optional:-->
                <payer>
                    <uniqueIdentifier>
                    <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                    <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
    
    Scenario: Execute nodoInoltroEsitoPaypal (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
        """
        {
            "idTransazione": "responseOK",
            "idTransazionePsp":"153016btAE",
            "idPagamento": "$sessionToken",
            "identificativoIntermediario": "#psp#",
            "identificativoPsp": "#psp#",
            "identificativoCanale": "#canale#",
            "importoTotalePagato": 10.00,
            "timestampOperazione": "2012-04-23T18:25:43Z"
        }
        """
        Then verify the HTTP status code of inoltroEsito/paypal response is 200
        And check esito is OK of inoltroEsito/paypal response
        
        
    Scenario: Execute sendPaymentOutcome (Phase 5)
        Given the Execute nodoInoltroEsitoPaypal (Phase 4) scenario executed successfully
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
                        <e-mail>prova@test.it</e-mail>
                        </payer>
                        <applicationDate>2021-12-12</applicationDate>
                        <transferDate>2021-12-11</transferDate>
                    </details>
                </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
        </soapenv:Envelope>     
        """
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job annullamentoRptMaiRichiesteDaPm triggered after 65 seconds
        And wait 15 seconds for expiration
        Then check outcome is OK of sendPaymentOutcome response
        And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value PAYING, PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And restore initial configurations