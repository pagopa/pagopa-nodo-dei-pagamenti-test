Feature: SEM_AIPR_21

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

    Scenario: Execute activateIOPayment request
        Given idempotencyKey with 70000000001_1328570293 in activateIOPayment
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario Outline: Execute second activateIOPayment request
        #Given the Execute activateIOPayment request scenario executed successfully
        Given idempotencyKey with 70000000001_1328570293 in activateIOPayment
        And <tag> with <tag_value> in activateIOPayment
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activateIOPayment response
        Examples:
            | tag                         | tag_value             | soapUI test |
            | fiscalCode                  | 12345678901           | SEM_AIPR_21 |
            | amount                      | 12.00                 | SEM_AIPR_21 |
            | dueDate                     | 2021-12-31            | SEM_AIPR_21 |
            | dueDate                     | Empty                 | SEM_AIPR_21 |
            | dueDate                     | None                  | SEM_AIPR_21 |
            | paymentNote                 | test_1                | SEM_AIPR_21 |
            | paymentNote                 | Empty                 | SEM_AIPR_21 |
            | paymentNote                 | None                  | SEM_AIPR_21 |
            | expirationTime              | 123456                | SEM_AIPR_21 |
            | expirationTime              | Empty                 | SEM_AIPR_21 |
            | expirationTime              | None                  | SEM_AIPR_21 |
            | payer                       | None                  | SEM_AIPR_21 |
            | entityUniqueIdentifierType  | F                     | SEM_AIPR_21 |
            | entityUniqueIdentifierValue | 55555555555           | SEM_AIPR_21 |
            | fullName                    | name_1                | SEM_AIPR_21 |
            | streetName                  | streetName            | SEM_AIPR_21 |
            | streetName                  | Empty                 | SEM_AIPR_21 |
            | streetName                  | None                  | SEM_AIPR_21 |
            | civicNumber                 | civicNumber           | SEM_AIPR_21 |
            | civicNumber                 | Empty                 | SEM_AIPR_21 |
            | civicNumber                 | None                  | SEM_AIPR_21 |
            | postalCode                  | postalCode            | SEM_AIPR_21 |
            | postalCode                  | Empty                 | SEM_AIPR_21 |
            | postalCode                  | None                  | SEM_AIPR_21 |
            | city                        | new_city              | SEM_AIPR_21 |
            | city                        | Empty                 | SEM_AIPR_21 |
            | city                        | None                  | SEM_AIPR_21 |
            | stateProvinceRegion         | stateProvinceRegion   | SEM_AIPR_21 |
            | stateProvinceRegion         | Empty                 | SEM_AIPR_21 |
            | stateProvinceRegion         | None                  | SEM_AIPR_21 |
            | country                     | FR                    | SEM_AIPR_21 |
            | country                     | Empty                 | SEM_AIPR_21 |
            | country                     | None                  | SEM_AIPR_21 |
            | e-mail                      | test1@prova.gmail.com | SEM_AIPR_21 |
            | e-mail                      | Empty                 | SEM_AIPR_21 |
            | e-mail                      | None                  | SEM_AIPR_21 |