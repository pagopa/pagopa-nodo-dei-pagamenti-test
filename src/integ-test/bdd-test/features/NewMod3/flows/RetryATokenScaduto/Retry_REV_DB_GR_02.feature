Feature: process tests Retry_REV_DB_GR_02

    Background:
        Given systems up

    # Verify phase
    Scenario: Execute verifyPaymentNotice request
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
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                    </nod:verifyPaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    #activate phase
    Scenario: Execute activatePaymentNotice request
        Given the Execute verifyPaymentNotice request scenario executed successfully
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
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                        <expirationTime>2000</expirationTime>
                        <amount>10.00</amount>
                        <dueDate>2021-12-31</dueDate>
                        <paymentNote>causale</paymentNote>
                    </nod:activatePaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And wait 3 seconds for expiration

    # Payment Outcome Phase outcome KO
    @runnable
    Scenario: Execute sendPaymentOutcome request
        Given the Execute activatePaymentNotice request scenario executed successfully
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
                        <outcome>KO</outcome>
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
                                    <entityUniqueIdentifierValue>#canale_ATTIVATO_PRESSO_PSP#</entityUniqueIdentifierValue>
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

        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And verify 0 record for the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3