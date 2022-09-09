Feature: semantic checks OK for activatePaymentNoticeV2Request

    Background:
        Given systems up
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
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
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

    Scenario: Check valid URL in WSDL namespace
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    # [SEM_APNV2_17]
    Scenario: Check outcome OK on non-existent psp in idempotencyKey
        Given idempotencyKey with 00088877799_151059xbLJ in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    # per questo test è necessaria la paGetPaymentV2, attualmente non disponibile sul mock pa
    # [SEM_APNV2_17.1]
    # Scenario: Check outcome OK on non-existent psp in idempotencyKey
    #     Given idempotencyKey with 00088877799_151059xbLJ in activatePaymentNoticeV2
    #     And noticeNumber with 310$iuv in activatePaymentNoticeV2
    #     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    #     Then check outcome is OK of activatePaymentNoticeV2 response

    # [SEM_APNV2_18]
    Scenario: Check outcome OK on disabled psp in idempotencyKey
        Given idempotencyKey with 80000000001_151101ApDu in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    # per questo test è necessaria la paGetPaymentV2, attualmente non disponibile sul mock pa
    # [SEM_APNV2_18.1]
    # Scenario: Check outcome OK on disabled psp in idempotencyKey
    #     Given idempotencyKey with 80000000001_151101ApDu in activatePaymentNoticeV2
    #     And noticeNumber with 310$iuv in activatePaymentNoticeV2
    #     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    #     Then check outcome is OK of activatePaymentNoticeV2 response

    # [SEM_APNV2_24]
    Scenario: Check outcome OK if combination psp-channel-pa in denylist
        Given idBrokerPSP with 60000000002 in activatePaymentNoticeV2
        And idChannel with 60000000002_01 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

# per questo test è necessaria la paGetPaymentV2, attualmente non disponibile sul mock pa
# [SEM_APNV2_24.1]
# Scenario: Check outcome OK if combination psp-channel-pa in denylist
#     Given idBrokerPSP with 60000000002 in activatePaymentNoticeV2
#     And idChannel with 60000000002_01 in activatePaymentNoticeV2
#     And noticeNumber with 310$iuv in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response