Feature: Syntax checks for activateIOPaymentReq - KO

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

    Scenario: Execute activateIOPaymentReq request
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: check db DB_AIPR_01
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And execute the sql DB_AIPR_01_AppIO on db nodo_online under macro AppIO
        Then checks the POSITION_ACTIVATE table is properly populated according to the query DB_AIPR_01_AppIO and primitive
    
    Scenario: check db DB_AIPR_02
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And execute the sql DB_AIPR_02_AppIO on db nodo_online under macro AppIO
        Then checks the POSITION_SERVICE table is properly populated according to the query DB_AIPR_02_AppIO and primitive
    
    Scenario: check db DB_AIPR_03
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And random idempotencyKey having 70000000001 as idPSP in activateIOPayment
        And noticeNumber with $activateIOPayment.noticeNumber in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And execute the sql DB_AIPR_03_AppIO on db nodo_online under macro AppIO
        And checks the POSITION_SERVICE table is properly populated according to the query DB_AIPR_03_AppIO and primitive

    Scenario: check db DB_AIPR_04
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And execute the sql DB_AIPR_04_AppIO on db nodo_online under macro AppIO
        Then checks the POSITION_PAYMENT_PLAN table is properly populated according to the query DB_AIPR_04_AppIO and primitive

    Scenario: check db DB_AIPR_05
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And execute the sql DB_AIPR_05_AppIO on db nodo_online under macro AppIO
        Then checks the POSITION_PAYMENT_PLAN table is properly populated according to the query DB_AIPR_05_AppIO and primitive

    Scenario: check db DB_AIPR_06
        Given the Execute activateIOPaymentReq request scenario executed successfully
        And execute the sql DB_AIPR_06_AppIO on db nodo_online under macro AppIO
        Then checks the POSITION_SUBJECT table is properly populated according to the query DB_AIPR_06_AppIO and primitive