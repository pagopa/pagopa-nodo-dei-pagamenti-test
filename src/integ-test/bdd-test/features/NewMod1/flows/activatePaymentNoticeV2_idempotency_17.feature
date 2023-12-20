    Feature: idempotency tests for activatePaymentNoticeV2Request

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2 without expirationTime
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>02$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-31</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-31T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>description</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>paGetPaymentName</fullName>
            <!--Optional:-->
            <streetName>paGetPaymentStreet</streetName>
            <!--Optional:-->
            <civicNumber>paGetPayment99</civicNumber>
            <!--Optional:-->
            <postalCode>20155</postalCode>
            <!--Optional:-->
            <city>paGetPaymentCity</city>
            <!--Optional:-->
            <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And wait 70 seconds for expiration

    @test 
    Scenario: second activateV2 with another PA
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>44444444444</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header />
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>11$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-31</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-31T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>description</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>paGetPaymentName</fullName>
            <!--Optional:-->
            <streetName>paGetPaymentStreet</streetName>
            <!--Optional:-->
            <civicNumber>paGetPayment99</civicNumber>
            <!--Optional:-->
            <postalCode>20155</postalCode>
            <!--Optional:-->
            <city>paGetPaymentCity</city>
            <!--Optional:-->
            <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1
        And checks the value 44444444444 of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10