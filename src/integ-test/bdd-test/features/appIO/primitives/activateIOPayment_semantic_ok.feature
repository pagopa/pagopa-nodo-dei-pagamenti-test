Feature: Semantic checks for activateIOPaymentReq - OK

    Background:
        Given systems up
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

    Scenario Outline: Check Unknown/Disabled PSP in idempotencyKey
        Given <tag> with <tag_value> in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        Examples:
            | tag            | tag_value              | soapUI test |
            | idempotencyKey | 12345678901_1244gtg684 | SEM_AIPR_17 |
            | idempotencyKey | 80000000001_1244gtg684 | SEM_AIPR_18 |

    # [SEM_AIPR_19]
    Scenario: Execute activateIOPayment (Phase 1)
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        And save activateIOPayment response in activateIOPayment_first
        Then check outcome is OK of activateIOPayment_first response

    Scenario: Check second activateIOPayment is equal to the first
        Given the Execute activateIOPayment (Phase 1) scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then activateIOPayment_first response is equal to activateIOPayment response
