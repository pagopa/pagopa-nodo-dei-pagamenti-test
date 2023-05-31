Feature: idempotency tests for activatePaymentNoticeV2Request

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2
        Given initial XML activatePaymentNoticeV2
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
            <expirationTime>60000</expirationTime>
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

    Scenario: activatePaymentNoticeV2 without expirationTime
        Given initial XML activatePaymentNoticeV2
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

    Scenario: paGetPayment error response
        Given initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
    @test
    # [IDMP_APNV2_11.1]
    Scenario: IDMP_APNV2_11.1
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 40
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    @test
    # [IDMP_APNV2_11.2]
    Scenario: IDMP_APNV2_11.2
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test
    # [IDMP_APNV2_11.3]
    Scenario: IDMP_APNV2_11.3
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 30
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    @test
    # [IDMP_APNV2_11.4]
    Scenario: IDMP_APNV2_11.4
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
        And the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test
    # [IDMP_APNV2_11.5]
    Scenario: IDMP_APNV2_11.5
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 2
        And the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 240000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    @test
    # [IDMP_APNV2_11.6]
    Scenario: IDMP_APNV2_11.6
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 2
        And the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 120000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    @test
    # [IDMP_APNV2_12]
    Scenario: IDMP_APNV2_12
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And idPSP with Empty in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNoticeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test
    # [IDMP_APNV2_13]
    Scenario: IDMP_APNV2_13
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And idPSP with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PSP_SCONOSCIUTO of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value 1230984759 of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test
    # [IDMP_APNV2_14]
    Scenario: IDMP_APNV2_14
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And the paGetPayment error response scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_15]
    Scenario: IDMP_APNV2_15 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @test
    Scenario: IDMP_APNV2_15 (part 2)
        Given the IDMP_APNV2_15 (part 1) scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_15.1]
    Scenario: IDMP_APNV2_15.1 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And idPSP with Empty in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNoticeV2 response
    @test
    Scenario: IDMP_APNV2_15.1 (part 2)
        Given the IDMP_APNV2_15.1 (part 1) scenario executed successfully
        And idPSP with 60000000001 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_15.2]
    Scenario: IDMP_APNV2_15.2 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And password with pwdpwdpwf in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNoticeV2 response
    @test
    Scenario: IDMP_APNV2_15.2 (part 2)
        Given the IDMP_APNV2_15.2 (part 1) scenario executed successfully
        And password with pwdpwdpwd in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_16.1]
    Scenario: IDMP_APNV2_16.1 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_key_psp on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test
    Scenario: IDMP_APNV2_16.1 (part 2)
        Given the IDMP_APNV2_16.1 (part 1) scenario executed successfully
        And idPSP with 40000000001 in activatePaymentNoticeV2
        And idBrokerPSP with 40000000001 in activatePaymentNoticeV2
        And idChannel with 40000000001_01 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_key_psp on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_16.2]
    Scenario: IDMP_APNV2_16.2 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test
    Scenario: IDMP_APNV2_16.2 (part 2)
        Given the IDMP_APNV2_16.2 (part 1) scenario executed successfully
        And fiscalCode with 44444444444 in activatePaymentNoticeV2
        And fiscalCodePA with 44444444444 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_16.3]
    Scenario: IDMP_APNV2_16.3 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    @test
    Scenario: IDMP_APNV2_16.3 (part 2)
        Given the IDMP_APNV2_16.3 (part 1) scenario executed successfully
        And random iuv in context
        And noticeNumber with 302$iuv in activatePaymentNoticeV2
        And creditorReferenceId with 02$iuv in paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_16.4]
    Scenario: IDMP_APNV2_16.4 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
        And saving paGetPayment request in paGetPaymentRequest
    @test
    Scenario: IDMP_APNV2_16.4 (part 2)
        Given the IDMP_APNV2_16.4 (part 1) scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 6000 in activatePaymentNoticeV2
        And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
        And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
        And creditorReferenceId with $paGetPaymentRequest.creditorReferenceId in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_16.5]
    Scenario: IDMP_APNV2_16.5 (part 1)
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @test
    Scenario: IDMP_APNV2_16.5 (part 2)
        Given the IDMP_APNV2_16.5 (part 1) scenario executed successfully
        And amount with 8.00 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_17]
    Scenario: IDMP_APNV2_17 (part 1)
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
        And the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And wait 70 seconds for expiration
    @test
    Scenario: IDMP_APNV2_17 (part 2)
        Given the IDMP_APNV2_17 (part 1) scenario executed successfully
        And fiscalCode with 44444444444 in activatePaymentNoticeV2
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNoticeV2
        And fiscalCodePA with 44444444444 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1
        And checks the value 44444444444 of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10

    # [IDMP_APNV2_18]
    Scenario: IDMP_APNV2_18 (part 1)
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And wait 62 seconds for expiration
    @test
    Scenario: IDMP_APNV2_18 (part 2)
        Given the IDMP_APNV2_18 (part 1) scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10

    # [IDMP_APNV2_19]
    Scenario: IDMP_APNV2_19 (part 1)
        Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
        And the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 6000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And wait 6.5 seconds for expiration
    @test
    Scenario: IDMP_APNV2_19 (part 2)
        Given the IDMP_APNV2_19 (part 1) scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_timestamp_desc on db nodo_online under macro NewMod1
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_20]
    Scenario: IDMP_APNV2_20 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 6000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    @test  
    Scenario: IDMP_APNV2_20 (part 2)
        Given the IDMP_APNV2_20 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 7 seconds
        And job idempotencyCacheClean triggered after 10 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And verify the HTTP status code of idempotencyCacheClean response is 200
        And wait 10 seconds for expiration
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

    # [IDMP_APNV2_22]
    Scenario: IDMP_APNV2_22 (part 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to false
        And the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @test
    Scenario: IDMP_APNV2_22 (part 2)
        Given the IDMP_APNV2_22 (part 1) scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter useIdempotency set to true
    @test
    # [IDMP_APNV2_26]
    Scenario: IDMP_APNV2_26
        Given the activatePaymentNoticeV2 without expirationTime scenario executed successfully
        And idempotencyKey with None in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_token on db nodo_online under macro NewMod1