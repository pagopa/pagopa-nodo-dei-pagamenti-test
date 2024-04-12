Feature: Block revision for sendPaymentOutcome - PA old 1251

    Background:
        Given systems up

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header />
                <soapenv:Body>
                    <nod:verifyPaymentNoticeReq>
                        <idPSP>#psp#</idPSP>
                        <idBrokerPSP>#psp#</idBrokerPSP>
                        <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                        <password>pwdpwdpwd</password>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                            <noticeNumber>#notice_number_old#</noticeNumber>
                        </qrCode>
                    </nod:verifyPaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activatePaymentNotice (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:activatePaymentNoticeReq>
                        <idPSP>#psp#</idPSP>
                        <idBrokerPSP>#psp#</idBrokerPSP>
                        <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                        <password>pwdpwdpwd</password>
                        <idempotencyKey>#idempotency_key#</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                        </qrCode>
                        <expirationTime>2000</expirationTime>
                        <amount>10.00</amount>
                        <dueDate>2021-12-31</dueDate>
                        <paymentNote>causale</paymentNote>
                    </nod:activatePaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: Initialize sendPaymentOutcome (Phase 3)
        Given the Execute activatePaymentNotice (Phase 2) scenario executed successfully
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
                        <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
                        <outcome>OK</outcome>
                        <details>
                            <paymentMethod>creditCard</paymentMethod>
                            <paymentChannel>app</paymentChannel>
                            <fee>2.00</fee>
                            <payer>
                                <uniqueIdentifier>
                                    <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
                                    <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
                                </uniqueIdentifier>
                                <fullName>John Doe</fullName>
                                <streetName>street</streetName>
                                <civicNumber>12</civicNumber>
                                <postalCode>89020</postalCode>
                                <city>city</city>
                                <stateProvinceRegion>MI</stateProvinceRegion>
                                <country>IT</country>
                                <e-mail>john.doe@test.it</e-mail>
                            </payer>
                            <applicationDate>2021-10-01</applicationDate>
                            <transferDate>2021-10-02</transferDate>
                        </details>
                    </nod:sendPaymentOutcomeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """

@runnable
    Scenario: [SPO_REV_01]
        Given the Initialize sendPaymentOutcome (Phase 3) scenario executed successfully
        
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 10 seconds for expiration
        And checks the value PAYING, PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING, PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3

@runnable
    Scenario: [SPO_REV_02]
        Given the Initialize sendPaymentOutcome (Phase 3) scenario executed successfully
        
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And checks the value PAYING, FAILED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value FAILED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING, INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3
        And checks the value $sendPaymentOutcome.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod3