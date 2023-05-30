Feature: Syntax checks for activateIOPaymentReq - OK

    Background:
        Given systems up
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And initial XML paGetPayment
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <paf:paGetPaymentRes>
                    <outcome>OK</outcome>
                    <data>
                        <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
                        <paymentAmount>10.00</paymentAmount>
                        <dueDate>2021-07-31</dueDate>
                        <description>TARI 2021</description>
                        <companyName>company PA</companyName>
                        <officeName>office PA</officeName>
                        <debtor>
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
                        </debtor>
                        <transferList>
                            <transfer>
                                <idTransfer>1</idTransfer>
                                <transferAmount>10.00</transferAmount>
                                <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                                <IBAN>IT96R0123454321000000012345</IBAN>
                                <remittanceInformation>TARI Comune EC_TE</remittanceInformation>
                                <transferCategory>0101101IM</transferCategory>
                            </transfer>
                        </transferList>
                    </data>
                </paf:paGetPaymentRes>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:activateIOPaymentReq>
                        <idPSP>#psp_AGID#</idPSP>
                        <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                        <idChannel>#canale_AGID#</idChannel>
                        <password>pwdpwdpwd</password>
                        <!--Optional:-->
                        <idempotencyKey>#idempotency_key#</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>$1noticeNumber</noticeNumber>
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
                                <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
    @runnable @independent
    Scenario: Check OK of activateIOPayment response
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        
    @runnable @independent
    Scenario Outline: Check OK of activateIOPayment response (phase 2)
        Given <elem> with <value> in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        Examples:
            | elem                | value | soapUI test  |
            | idempotencyKey      | None  | SIN_AIOPR_18 |
            | expirationTime      | None  | SIN_AIOPR_36 |
            | dueDate             | None  | SIN_AIOPR_45 |
            | paymentNote         | None  | SIN_AIOPR_48 |
            | payer               | None  | SIN_AIOPR_51 |
            | streetName          | None  | SIN_AIOPR_67 |
            | civicNumber         | None  | SIN_AIOPR_70 |
            | postalCode          | None  | SIN_AIOPR_73 |
            | city                | None  | SIN_AIOPR_76 |
            | stateProvinceRegion | None  | SIN_AIOPR_79 |
            | country             | None  | SIN_AIOPR_82 |
            | e-mail              | None  | SIN_AIOPR_86 |

