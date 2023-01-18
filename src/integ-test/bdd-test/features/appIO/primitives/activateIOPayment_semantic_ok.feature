Feature: Semantic checks for activateIOPaymentReq - OK

    Background:
        Given systems up
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

    @runnable
    Scenario Outline: Check Unknown/Disabled PSP in idempotencyKey
        Given <tag> with <tag_value> in activateIOPayment
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        Examples:
            | tag            | tag_value              | soapUI test |
            | idempotencyKey | 12345678901_1244gtg684 | SEM_AIPR_17 |
            | idempotencyKey | 80000000001_1244gtg684 | SEM_AIPR_18 |
    
    @runnable
    # [SEM_AIPR_19]
    Scenario: Execute activateIOPayment (Phase 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to true
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        And save activateIOPayment response in activateIOPayment_first
        Then check outcome is OK of activateIOPayment_first response
    
    @runnable
    Scenario: Check second activateIOPayment is equal to the first
        Given the Execute activateIOPayment (Phase 1) scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then activateIOPayment_first response is equal to activateIOPayment response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
        And restore initial configurations

    # [SEM_AIPR_31]
    @runnable
    Scenario: Check activateIOPayment response with parameters in deny list
        Given generate 1 notice number and iuv with aux digit 3, segregation code 11 and application code NA
        And noticeNumber with $1noticeNumber in activateIOPayment
        And idPSP with 40000000001 in activateIOPayment
        And idBrokerPSP with 40000000002 in activateIOPayment
        And idChannel with 40000000002_01 in activateIOPayment
        And fiscalCode with 44444444444 in activateIOPayment
        And verify 1 record for the table DENYLIST retrived by the query deny_list on db nodo_cfg under macro AppIO
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response