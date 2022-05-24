Feature: Syntax checks for activateIOPaymentReq - OK

    Background:
        Given systems up
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>40000000001</idPSP>
            <idBrokerPSP>40000000001</idBrokerPSP>
            <idChannel>97735020584_03</idChannel>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <idempotencyKey>40000000001_165943nhWu</idempotencyKey>
            <qrCode>
            <fiscalCode>44444444444</fiscalCode>
            <noticeNumber>311014451435181800</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>responseFull</paymentNote>
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

    Scenario: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario Outline: Check PPT_SINTASSI_EXTRASXSD error on invalid body element value
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
            | email               | None  | SIN_AIOPR_86 |

