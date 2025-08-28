Feature: semantic checks new for activatePaymentNoticeV2Request 956

    Background:
        Given systems up

    
    Scenario: activatePaymentNoticeV2 + paGetPayment
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
            <e-mail>paGetPayment@provatest.it</e-mail>
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

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
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
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2 (metadata chiaveok)
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>chiaveok</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>chiaveok</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOKFINNULL)
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOKFINNULL</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOKFINNULL</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOKFININF)
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOKFININF</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOKFININF</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOKINIZSUP)
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOKINIZSUP</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOKINIZSUP</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2 (metadata chiaveminuscola)
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>chiaveminuscola</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>chiaveminuscola</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    Scenario: activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOK)
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
            <noticeNumber>310#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-12</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <e-mail>paGetPayment@provatest.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOK</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVEOK</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

    # SEM_APNV2_19
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_1 @company
    Scenario: semantic check 19
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response


    # SEM_APNV2_19.1
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_2 @company
    Scenario: semantic check 19.1
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        Then verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |


    # SEM_APNV2_20
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_3 @company
    Scenario: semantic check 20
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given noticeNumber with 311019801089138300 in activatePaymentNoticeV2
        And creditorReferenceId with 11019801089138300 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_4 @company
    Scenario: semantic check 20.A
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given fiscalCode with 77777777777 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response



    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_5 @company
    Scenario: semantic check 20.B
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given amount with 6.00 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_6 
    Scenario: semantic check 20.C
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given dueDate with 2021-12-16 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_7
    Scenario: semantic check 20.D
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given paymentNote with metadati in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_8
    Scenario: semantic check 20.E
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given dueDate with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_9
    Scenario: semantic check 20.F
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given expirationTime with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_10
    Scenario: semantic check 20.G
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given paymentNote with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response

    # SEM_APNV2_20.1
    Scenario: semantic check 20.1 (part 1)
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_11
    Scenario: semantic check 20.1.A
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given random iuv in context
        And noticeNumber with 302$iuv in activatePaymentNoticeV2
        And creditorReferenceId with 02$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_12
    Scenario: semantic check 20.1.B
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given fiscalCode with 77777777777 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_13
    Scenario: semantic check 20.1.C
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given amount with 6.00 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        
        
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_14
    Scenario: semantic check 20.1.D
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And dueDate with 2021-12-16 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_15
    Scenario: semantic check 20.1.E
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given paymentNote with metadati in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
     

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_16
    Scenario: semantic check 20.1.F
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given dueDate with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL



    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_17
    Scenario: semantic check 20.1.G
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given expirationTime with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And wait 1 seconds for expiration
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL


    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_18
    Scenario: semantic check 20.1.H
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given paymentNote with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        Then verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |

    # SEM_APNV2_21
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_19
    Scenario: semantic check 21
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 8 seconds for expiration
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

    # SEM_APNV2_21.1
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_20
    Scenario: semantic check 21.1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 8 seconds for expiration
        Given expirationTime with 1000 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

    # SEM_APNV2_21.2
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_21
    Scenario: semantic check 21.2
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And expirationTime with 2000 in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 4 seconds for expiration
        Given expirationTime with 6000 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        Then verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |


    # SEM_APNV2_22
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_22
    Scenario: semantic check 22
        Given update for table CONFIGURATION_KEYS with parameter config_value = '1' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                             |
            | CONFIG_KEY | default_idempotency_key_validity_minutes |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 70 seconds for expiration
        Given expirationTime with 1000 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = '10' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                             |
            | CONFIG_KEY | default_idempotency_key_validity_minutes |
        And waiting after triggered refresh job ALL

    # SEM_APNV2_22.1
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_23
    Scenario: semantic check 22.1
        Given update for table CONFIGURATION_KEYS with parameter config_value = '1' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                             |
            | CONFIG_KEY | default_idempotency_key_validity_minutes |
        And update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 70 seconds for expiration
        Given expirationTime with 1000 in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        Given update for table CONFIGURATION_KEYS with parameter config_value = '10' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                             |
            | CONFIG_KEY | default_idempotency_key_validity_minutes |
        And update for table CONFIGURATION_KEYS with parameter config_value = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        Then verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |

    # SEM_APNV2_23
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_24
    Scenario: semantic check 23
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

    # SEM_APNV2_23.1
    Scenario: semantic check 23.1 (part 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to false
        And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_NEW @NMU_ACTV2_SEM_NEW_25
    Scenario: semantic check 23.1 (part 2)
        Given update for table CONFIGURATION_KEYS with parameter config_value = 'false' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | CONFIG_KEY | useIdempotency |
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
        Given the semantic check 23.1 (part 1) scenario executed successfully
        And idempotencyKey with None in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And nodo-dei-pagamenti has config parameter useIdempotency set to true
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    @newfix
    # SEM_APNV2_26
    Scenario: semantic check 26
        Given the activatePaymentNoticeV2 + paGetPaymentV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.ID of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.fullName of the record at column FULL_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.streetName of the record at column STREET_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.city of the record at column CITY of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.country of the record at column COUNTRY of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value paGetPayment@provatest.it of the record at column EMAIL of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_SUBJECT.UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT_PLAN.ID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value None of the record at column RETENTION_DATE of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT_PLAN.INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT_PLAN.UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_TRANSFER.ID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE_SECONDARY of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.IBAN of the record at column IBAN of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.remittanceInformation of the record at column REMITTANCE_INFORMATION of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.transferCategory of the record at column TRANSFER_CATEGORY of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.idTransfer of the record at column TRANSFER_IDENTIFIER of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value Y of the record at column VALID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_TRANSFER.INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_TRANSFER.UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_STATUS_SNAPSHOT.ID of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_STATUS_SNAPSHOT.INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_STATUS_SNAPSHOT.UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
        And checks the value N of the record at column ACTIVATION_PENDING of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_service on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT.ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column POSITION_PAYMENT.AMOUNT of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT.INSERTED_TIMESTAMP of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT.UPDATED_TIMESTAMP of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT_STATUS_SNAPSHOT.ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT_STATUS_SNAPSHOT.INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column POSITION_PAYMENT_STATUS_SNAPSHOT.UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # SEM_APNV2_27
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 27 (part 1)
        Given the activatePaymentNoticeV2 + paGetPaymentV2 (metadata chiaveok) scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check metadata field not exists in activatePaymentNoticeV2 response
        And checks the value chiaveok is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
        And checks the value chiaveok is contained in the record at column POSITION_TRANSFER.METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 27 (part 2)
        Given the activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOKFINNULL) scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check key is CHIAVEOKFINNULL of activatePaymentNoticeV2 response
        And checks the value CHIAVEOKFINNULL is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
        And checks the value CHIAVEOKFINNULL is contained in the record at column POSITION_TRANSFER.METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 27 (part 3)
        Given the activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOKFININF) scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check metadata field not exists in activatePaymentNoticeV2 response
        And checks the value CHIAVEOKFININF is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
        And checks the value CHIAVEOKFININF is contained in the record at column POSITION_TRANSFER.METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 27 (part 4)
        Given the activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOKINIZSUP) scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check metadata field not exists in activatePaymentNoticeV2 response
        And checks the value CHIAVEOKINIZSUP is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
        And checks the value CHIAVEOKINIZSUP is contained in the record at column POSITION_TRANSFER.METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 27 (part 5)
        Given the activatePaymentNoticeV2 + paGetPaymentV2 (metadata chiaveminuscola) scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And check metadata field not exists in activatePaymentNoticeV2 response
        And checks the value chiaveminuscola is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
        And checks the value chiaveminuscola is contained in the record at column POSITION_TRANSFER.METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 27 (part 6)
        Given the activatePaymentNoticeV2 + paGetPaymentV2 (metadata CHIAVEOK) scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check key is CHIAVEOK of activatePaymentNoticeV2 response
        And checks the value CHIAVEOK is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
        And checks the value CHIAVEOK is contained in the record at column POSITION_TRANSFER.METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

    # SEM_APNV2_28
    @ALL @PRIMITIVE @NMU @company
    Scenario: semantic check 28
        Given the activatePaymentNoticeV2 + paGetPaymentV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 5 seconds for expiration
        And execution query activatev2_resp to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query activatev2_resp retrieve xml PAYLOAD at position 0 and save it under the key XML_DB_1
        And execution query select_activatev2 to get value on the table IDEMPOTENCY_CACHE, with the columns RESPONSE under macro NewMod1 with db name nodo_online
        And by the query select_activatev2 retrieve xml_no_decode RESPONSE at position 0 and save it under the key XML_DB_2
        And check value $XML_DB_1 is equal to value $XML_DB_2