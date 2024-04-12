Feature: GT_01 54

    Background:
        Given systems up
        

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to true
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
                            <noticeNumber>#notice_number#</noticeNumber>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value activateIOPayment of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
@runnable
    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And check token_valid_to is equal to token_valid_from plus default_durata_token_IO
        And restore initial configurations