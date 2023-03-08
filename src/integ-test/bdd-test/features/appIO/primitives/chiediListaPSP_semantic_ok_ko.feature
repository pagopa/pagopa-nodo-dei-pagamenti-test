Feature: Semantic checks for chiediListaPSP primitive

    Background:
        Given systems up
        And EC new version
        
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
        When AppIO sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
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
                        <expirationTime>12345</expirationTime>
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
        When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        
    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    @ciao
     # [PRO_CLPSP_14]
    Scenario: Check semantic correctness - OK [PRO_CLPSP_14]
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest GET listaPSP?percorsoPagamento=CARTE&idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is 200

    @ciao
    Scenario Outline: Check semantic correctness - KO [outline PRO_CLPSP_08-14]
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest GET <service> to nodo-dei-pagamenti
        Then check error is <value> of listaPSP response
        And verify the HTTP status code of listaPSP response is <status_code>
        Examples:
            | service                                                                              | value                            | status_code | test         |
            | listaPSP?idPagamento&percorsoPagamento=CARTE                                         | Richiesta non valida             | 400         | PRO_CLPSP_08 |
            | listaPSP?idPagamento=PAGAMENTOCHENONESISTEDENTROALDB_&percorsoPagamento=CARTE        | Il Pagamento indicato non esiste | 404         | PRO_CLPSP_09 |
            | listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken&percorsoPagamento       | Percorso di Pagamento invalido   | 422         | PRO_CLPSP_12 |
            | listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken&percorsoPagamento=PIPPO | Percorso di Pagamento invalido   | 422         | PRO_CLPSP_13 |
            | listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken&percorsoPagamento=carte | Percorso di Pagamento invalido   | 422         | PRO_CLPSP_14 |
    
    @ciao
    Scenario Outline: Check semantic correctness - KO [outline PRO_CLPSP_07/11]
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest GET <service> to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is <status_code>
        Examples:
            | service                                                                              | status_code | test         |
            | listaPSP?percorsoPagamento=CARTE                                                     | 404         | PRO_CLPSP_07 |
            | listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken                         | 404         | PRO_CLPSP_11 |