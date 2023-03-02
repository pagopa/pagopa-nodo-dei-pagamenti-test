Feature: flow tests for demandPaymentNotice

    Background:
        Given systems up

    Scenario: demandPaymentNotice
        Given initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00042</idSoggettoServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <paymentDescription>paymentDescription</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends soap demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response

    Scenario: verifyPaymentNotice
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paVerifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paVerifyPaymentNoticeRes>
            <outcome>OK</outcome>
            <paymentList>
            <paymentOptionDescription>
            <amount>1.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2021-12-31</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <!--Optional:-->
            <paymentDescription>/RFB/00202200000217527/5.00/TXT/</paymentDescription>
            <!--Optional:-->
            <fiscalCodePA>$verifyPaymentNotice.fiscalCode</fiscalCodePA>
            <!--Optional:-->
            <companyName>company PA</companyName>
            <!--Optional:-->
            <officeName>office PA</officeName>
            </paf:paVerifyPaymentNoticeRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: activatePaymentNotice request
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
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

    Scenario: activatePaymentNotice request with dueDate
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-04-30</dueDate>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
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

    Scenario: activatePaymentNotice request with 3 transfers
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000002</fiscalCodePA>
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

    Scenario: activatePaymentNotice request with 3 transfers (1.1)
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>15.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <paymentAmount>15.00</paymentAmount>
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
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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

    Scenario: activatePaymentNotice request with 3 transfers (1.2)
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>15.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <paymentAmount>15.00</paymentAmount>
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
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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

    Scenario: activatePaymentNotice request with 2 transfers
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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

    Scenario: sendPaymentOutcome request
        Given initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
            <outcome>OK</outcome>
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
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
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

    # F_DPNR_01

    Scenario: F_DPNR_01 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_01 (part 2)
        Given the F_DPNR_01 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT
        And checks the value $sendPaymentOutcome.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_01.1

    Scenario: F_DPNR_01.1 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_01.1 (part 2)
        Given the F_DPNR_01.1 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And paymentChannel with None in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT
        And checks the value $sendPaymentOutcome.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NA of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_02

    Scenario: F_DPNR_02 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_02 (part 2)
        Given the F_DPNR_02 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_03

    Scenario: F_DPNR_03 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_03 (part 2)
        Given the F_DPNR_03 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_04

    Scenario: F_DPNR_04 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_04 (part 2)
        Given the F_DPNR_04 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT_TRANSFER
        And verify 3 record for the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_05

    Scenario: F_DPNR_05 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_05 (part 2)
        Given the F_DPNR_05 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT_TRANSFER
        And verify 0 record for the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_06

    Scenario: F_DPNR_06 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_06 (part 2)
        Given the F_DPNR_06 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT_TRANSFER
        And verify 0 record for the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_07

    Scenario: F_DPNR_07 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_07 (part 2)
        Given the F_DPNR_07 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And execution query select_activate to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # F_DPNR_08

    Scenario: F_DPNR_08 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_08 (part 2)
        Given the F_DPNR_08 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_09

    Scenario: F_DPNR_09 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test @newfix 
    Scenario: F_DPNR_09 (part 2)
        Given the F_DPNR_09 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_10

    Scenario: F_DPNR_10 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_10 (part 2)
        Given the F_DPNR_10 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And execution query select_activate to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # F_DPNR_11

    Scenario: F_DPNR_11 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_11 (part 2)
        Given the F_DPNR_11 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_12

    Scenario: F_DPNR_12 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_12 (part 2)
        Given the F_DPNR_12 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_13

    Scenario: F_DPNR_13 (part 1)
        Given updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_13 (part 2)
        Given the F_DPNR_13 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000002 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,90000000001_01 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000002 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,90000000001_01 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And execution query recipient_pa_fiscal_code to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query recipient_pa_fiscal_code retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
        And execution query recipient_pa_fiscal_code_1 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query recipient_pa_fiscal_code_1 retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value 90000000001
        And check value $XML_DB.idBrokerPA is equal to value 90000000001
        And check value $XML_DB.idStation is equal to value 90000000001_06
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
        And execution query recipient_pa_fiscal_code_2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query recipient_pa_fiscal_code_2 retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value 90000000002
        And check value $XML_DB.idBrokerPA is equal to value 90000000001
        And check value $XML_DB.idStation is equal to value 90000000001_01
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # F_DPNR_14

    Scenario: F_DPNR_14 (part 1)
        Given updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_14 (part 2)
        Given the F_DPNR_14 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_15

    Scenario: F_DPNR_15 (part 1)
        Given updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_15 (part 2)
        Given the F_DPNR_15 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_16

    Scenario: F_DPNR_16 (part 1)
        Given updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 2 transfers scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_16 (part 2)
        Given the F_DPNR_16 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,90000000001_09 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,90000000001_09 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And execution query select_activate to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
        And execution query recipient_station_id_1 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query recipient_station_id_1 retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value 90000000001
        And check value $XML_DB.idBrokerPA is equal to value 90000000001
        And check value $XML_DB.idStation is equal to value 90000000001_06
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
        And execution query recipient_station_id_2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query recipient_station_id_2 retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value 90000000001
        And check value $XML_DB.idBrokerPA is equal to value 90000000001
        And check value $XML_DB.idStation is equal to value 90000000001_09
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # F_DPNR_17

    Scenario: F_DPNR_17 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers (1.1) scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_17 (part 2)
        Given the F_DPNR_17 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 7 seconds for expiration
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And execution query select_activate to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
        And execution query recipient_station_id_1 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query recipient_station_id_1 retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value 90000000001
        And check value $XML_DB.idBrokerPA is equal to value 90000000001
        And check value $XML_DB.idStation is equal to value 90000000001_06
        And check value $XML_DB.receiptId is equal to value $activatePaymentNoticeResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activatePaymentNotice.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activatePaymentNotice.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activatePaymentNotice.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.officeName is equal to value $paGetPayment.officeName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $paGetPayment.transferAmount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value $sendPaymentOutcome.idChannel
        And check value $XML_DB.channelDescription is equal to value $sendPaymentOutcome.paymentChannel
        And check value $XML_DB is containing value <uniqueIdentifier><entityUniqueIdentifierType>G</entityUniqueIdentifierType><entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue></uniqueIdentifier><fullName>name</fullName><streetName>street</streetName><civicNumber>civic</civicNumber><postalCode>postal</postalCode><city>city</city><stateProvinceRegion>state</stateProvinceRegion><country>IT</country>
        And check value $XML_DB.paymentMethod is equal to value $sendPaymentOutcome.paymentMethod
        And check value $XML_DB.fee is equal to value $sendPaymentOutcome.fee
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # F_DPNR_18

    Scenario: F_DPNR_18 (part 1)
        Given updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers (1.1) scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_18 (part 2)
        Given the F_DPNR_18 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,90000000001_09 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,90000000001_09 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_18.1

    Scenario: F_DPNR_18.1 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers (1.2) scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_18.1 (part 2)
        Given the F_DPNR_18.1 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 7 seconds for expiration
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_19

    Scenario: F_DPNR_19 (part 1)
        Given updates through the query update_fk_pa_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        And fiscalCodePA with 90000000001 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_19 (part 2)
        Given the F_DPNR_19 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 7 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_19.1

    Scenario: F_DPNR_19.1 (part 1)
        Given updates through the query update_obj_id_3 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_19.1 (part 2)
        Given the F_DPNR_19.1 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id_3 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_20

    Scenario: F_DPNR_20 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with 3 transfers (1.1) scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_20 (part 2)
        Given the F_DPNR_20 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken,$sendPaymentOutcome.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode,90000000001,$activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode,90000000001,90000000001 of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value #id_station#,90000000001_06,#id_station#,#id_station#,90000000001_06,90000000001_06 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_21

    Scenario: F_DPNR_21 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: F_DPNR_21 (part 2)
        Given the F_DPNR_21 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

    Scenario: F_DPNR_21 (part 3)
        Given the F_DPNR_21 (part 2) scenario executed successfully
        And random idempotencyKey having $activatePaymentNotice.idPSP as idPSP in activatePaymentNotice
        And expirationTime with 2000 in activatePaymentNotice
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_21 (part 4)
        Given the F_DPNR_21 (part 3) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_SERVICE
        And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And checks the value NotNone of the record at column POSITION_SUBJECT.ID of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.city of the record at column CITY of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value paGetPayment@test.it of the record at column EMAIL of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.INSERTED_TIMESTAMP of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.UPDATED_TIMESTAMP of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1

    # F_DPNR_22

    Scenario: F_DPNR_22 (part 1)
        Given the demandPaymentNotice scenario executed successfully
        And the activatePaymentNotice request with dueDate scenario executed successfully
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: F_DPNR_22 (part 2)
        Given the F_DPNR_22 (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends soap sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

    Scenario: F_DPNR_22 (part 3)
        Given the F_DPNR_22 (part 2) scenario executed successfully
        And random idempotencyKey having $activatePaymentNotice.idPSP as idPSP in activatePaymentNotice
        And expirationTime with 2000 in activatePaymentNotice
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @test 
    Scenario: F_DPNR_22 (part 4)
        Given the F_DPNR_22 (part 3) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_SERVICE
        And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SERVICE retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And checks the value NotNone of the record at column POSITION_SUBJECT.ID of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.entityUniqueIdentifierValue of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.city of the record at column CITY of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.country of the record at column COUNTRY of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value paGetPayment@test.it of the record at column EMAIL of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.INSERTED_TIMESTAMP of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.UPDATED_TIMESTAMP of the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SUBJECT JOIN POSITION_SERVICE ON POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_PLAN
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.amount of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_PLAN retrived by the query select_activate on db nodo_online under macro NewMod1