Feature: response tests for paGetPaymentV2

    Background:
        Given systems up
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
            <expirationTime>6000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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

    Scenario: paGetPaymentV2 with 6 transfers
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>1.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info2</remittanceInformation>
            <transferCategory>category2</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>2.50</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info3</remittanceInformation>
            <transferCategory>category3</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>4</idTransfer>
            <transferAmount>2.50</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info4</remittanceInformation>
            <transferCategory>category4</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>5</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info5</remittanceInformation>
            <transferCategory>category5</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>6</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info6</remittanceInformation>
            <transferCategory>category6</transferCategory>
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

    Scenario: paGetPaymentV2 with 11 mapEntry inside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>1.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <transfer>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </transfer>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info2</remittanceInformation>
            <transferCategory>category2</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>2.50</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info3</remittanceInformation>
            <transferCategory>category3</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>4</idTransfer>
            <transferAmount>2.50</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info4</remittanceInformation>
            <transferCategory>category4</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>5</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info5</remittanceInformation>
            <transferCategory>category5</transferCategory>
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

    Scenario: paGetPaymentV2 with 11 mapEntry outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>1.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <transfer>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </transfer>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info2</remittanceInformation>
            <transferCategory>category2</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>2.50</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info3</remittanceInformation>
            <transferCategory>category3</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>4</idTransfer>
            <transferAmount>2.50</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info4</remittanceInformation>
            <transferCategory>category4</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>5</idTransfer>
            <transferAmount>2.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>info5</remittanceInformation>
            <transferCategory>category5</transferCategory>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
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

    Scenario: paGetPaymentV2 with idTransfer not inside enumeration
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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

    Scenario: paGetPaymentV2 without mapEntry with subtags outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            <key>1</key>
            <value>22</value>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 with empty mapEntry outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 without metadata outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 without metadata with subtags outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 with empty metadata outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 without key outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 KO without faultBean
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>KO</outcome>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 without value outside transfer
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>10$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-30</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <!--Optional:-->
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
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
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """
    @runnable
    # KO tests
    Scenario Outline: KO tests
        Given the paGetPaymentV2 scenario executed successfully
        And <tag> with <value> in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
        Examples:
            | tag                         | value                                                                                                                                                                                                                                                             |
            | outcome                     | None                                                                                                                                                                                                                                                              |
            | outcome                     | Empty                                                                                                                                                                                                                                                             |
            | outcome                     | prova                                                                                                                                                                                                                                                             |
            | creditorReferenceId         | None                                                                                                                                                                                                                                                              |
            | creditorReferenceId         | Empty                                                                                                                                                                                                                                                             |
            | creditorReferenceId         | 123456789012345678901234567890123456                                                                                                                                                                                                                              |
            | paymentAmount               | None                                                                                                                                                                                                                                                              |
            | paymentAmount               | Empty                                                                                                                                                                                                                                                             |
            | paymentAmount               | 0.00                                                                                                                                                                                                                                                              |
            | paymentAmount               | 105,12                                                                                                                                                                                                                                                            |
            | paymentAmount               | 105.2                                                                                                                                                                                                                                                             |
            | paymentAmount               | 105.256                                                                                                                                                                                                                                                           |
            | paymentAmount               | 12ad45rtyu78hj56.44                                                                                                                                                                                                                                               |
            | paymentAmount               | 1000000000.00                                                                                                                                                                                                                                                     |
            | dueDate                     | None                                                                                                                                                                                                                                                              |
            | dueDate                     | Empty                                                                                                                                                                                                                                                             |
            | dueDate                     | 20-12-2022                                                                                                                                                                                                                                                        |
            | dueDate                     | 12-20-2022                                                                                                                                                                                                                                                        |
            | dueDate                     | 2022-12-12T12:23:000                                                                                                                                                                                                                                              |
            | retentionDate               | Empty                                                                                                                                                                                                                                                             |
            | retentionDate               | 20-12-2022                                                                                                                                                                                                                                                        |
            | retentionDate               | 2021-12-30T                                                                                                                                                                                                                                                       |
            | retentionDate               | 12-20-2022                                                                                                                                                                                                                                                        |
            | lastPayment                 | Empty                                                                                                                                                                                                                                                             |
            | lastPayment                 | 3                                                                                                                                                                                                                                                                 |
            | description                 | None                                                                                                                                                                                                                                                              |
            | description                 | Empty                                                                                                                                                                                                                                                             |
            | description                 | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                                     |
            | companyName                 | Empty                                                                                                                                                                                                                                                             |
            | companyName                 | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                                     |
            | officeName                  | Empty                                                                                                                                                                                                                                                             |
            | officeName                  | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                                     |
            | entityUniqueIdentifierType  | None                                                                                                                                                                                                                                                              |
            | entityUniqueIdentifierType  | Empty                                                                                                                                                                                                                                                             |
            | entityUniqueIdentifierType  | P                                                                                                                                                                                                                                                                 |
            | entityUniqueIdentifierValue | None                                                                                                                                                                                                                                                              |
            | entityUniqueIdentifierValue | Empty                                                                                                                                                                                                                                                             |
            | entityUniqueIdentifierValue | 12ftr4567dghfi89k                                                                                                                                                                                                                                                 |
            | fullName                    | None                                                                                                                                                                                                                                                              |
            | fullName                    | Empty                                                                                                                                                                                                                                                             |
            | fullName                    | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375                                                                                                                                                                                           |
            | streetName                  | Empty                                                                                                                                                                                                                                                             |
            | streetName                  | sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375                                                                                                                                                                                           |
            | civicNumber                 | Empty                                                                                                                                                                                                                                                             |
            | civicNumber                 | 1we345ty67ghjkl78                                                                                                                                                                                                                                                 |
            | postalCode                  | Empty                                                                                                                                                                                                                                                             |
            | postalCode                  | 12ftr4567dghfi89k                                                                                                                                                                                                                                                 |
            | city                        | Empty                                                                                                                                                                                                                                                             |
            | city                        | 123456mklo12345678901234567890123456                                                                                                                                                                                                                              |
            | stateProvinceRegion         | Empty                                                                                                                                                                                                                                                             |
            | stateProvinceRegion         | 123456mklo12345678901234567890123456                                                                                                                                                                                                                              |
            | country                     | Empty                                                                                                                                                                                                                                                             |
            | country                     | ITA                                                                                                                                                                                                                                                               |
            | country                     | de                                                                                                                                                                                                                                                                |
            | e-mail                      | Empty                                                                                                                                                                                                                                                             |
            | e-mail                      | @prova.it                                                                                                                                                                                                                                                         |
            | e-mail                      | noei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e375sanoei38932nfdiou%&ncdoaifer9eukvmptu@prova.it |
            | transferAmount              | None                                                                                                                                                                                                                                                              |
            | transferAmount              | Empty                                                                                                                                                                                                                                                             |
            | transferAmount              | 0.00                                                                                                                                                                                                                                                              |
            | transferAmount              | 10,89                                                                                                                                                                                                                                                             |
            | transferAmount              | 12.456                                                                                                                                                                                                                                                            |
            | transferAmount              | 1.1                                                                                                                                                                                                                                                               |
            | transferAmount              | 1000000000.00                                                                                                                                                                                                                                                     |
            | transferAmount              | 60.98                                                                                                                                                                                                                                                             |
            | fiscalCodePA                | None                                                                                                                                                                                                                                                              |
            | fiscalCodePA                | Empty                                                                                                                                                                                                                                                             |
            | fiscalCodePA                | 123409857635                                                                                                                                                                                                                                                      |
            | fiscalCodePA                | 123456789rf                                                                                                                                                                                                                                                       |
            | fiscalCodePA                | 152436%&789                                                                                                                                                                                                                                                       |
            | fiscalCodePA                | 17777777477                                                                                                                                                                                                                                                       |
            | fiscalCodePA                | 11111122222                                                                                                                                                                                                                                                       |
            | remittanceInformation       | None                                                                                                                                                                                                                                                              |
            | remittanceInformation       | Empty                                                                                                                                                                                                                                                             |
            | remittanceInformation       | sanoei38932nfdiou0pncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                                     |
            | transferCategory            | None                                                                                                                                                                                                                                                              |
            | transferCategory            | Empty                                                                                                                                                                                                                                                             |
            | transferCategory            | sanoei38932nfdiou0pncdoaifer9eukvmpweuw9tunfgadkvaifuewtudnvahv89u3e37572efnsfigt609w3ut0592uhngpisdugw09tutwjeodngvgeriyrw8t29762f9qef0qfurf                                                                                                                     |
            | soapenv:Body                | None                                                                                                                                                                                                                                                              |
            | soapenv:Body                | RemoveParent                                                                                                                                                                                                                                                      |
            | soapenv:Body                | Empty                                                                                                                                                                                                                                                             |
            | data                        | None                                                                                                                                                                                                                                                              |
            | data                        | Empty                                                                                                                                                                                                                                                             |
            | data                        | RemoveParent                                                                                                                                                                                                                                                      |
            | debtor                      | RemoveParent                                                                                                                                                                                                                                                      |
            | debtor                      | None                                                                                                                                                                                                                                                              |
            | debtor                      | Empty                                                                                                                                                                                                                                                             |
            | IBAN                        | IT45R0760103200000000001016908765432                                                                                                                                                                                                                              |
            | IBAN                        | None                                                                                                                                                                                                                                                              |
            | IBAN                        | Empty                                                                                                                                                                                                                                                             |
            | IBAN                        | IT45R0760103200777777777777                                                                                                                                                                                                                                       |
            | IBAN                        | IT45R0760103200004440551016                                                                                                                                                                                                                                       |
            | idTransfer                  | A                                                                                                                                                                                                                                                                 |
            | idTransfer                  | 11                                                                                                                                                                                                                                                                |
            | idTransfer                  | Empty                                                                                                                                                                                                                                                             |
            | idTransfer                  | None                                                                                                                                                                                                                                                              |
            | key                         | None                                                                                                                                                                                                                                                              |
            | mapEntry                    | RemoveParent                                                                                                                                                                                                                                                      |
            | metadata                    | RemoveParent                                                                                                                                                                                                                                                      |
            | metadata                    | Empty                                                                                                                                                                                                                                                             |
            | transferList                | Empty                                                                                                                                                                                                                                                             |
            | transferList                | None                                                                                                                                                                                                                                                              |
            | transferList                | RemoveParent                                                                                                                                                                                                                                                      |
            | uniqueIdentifier            | RemoveParent                                                                                                                                                                                                                                                      |
            | uniqueIdentifier            | None                                                                                                                                                                                                                                                              |
            | uniqueIdentifier            | Empty                                                                                                                                                                                                                                                             |
            | paf:paGetPaymentV2Response  | None                                                                                                                                                                                                                                                              |
            | paf:paGetPaymentV2Response  | RemoveParent                                                                                                                                                                                                                                                      |
            | transfer                    | None                                                                                                                                                                                                                                                              |
            | transfer                    | Empty                                                                                                                                                                                                                                                             |
            | paymentAmount               | 11.00                                                                                                                                                                                                                                                             |
            | value                       | None                                                                                                                                                                                                                                                              |
    @runnable
    # OK tests
    Scenario Outline: OK tests
        Given the paGetPaymentV2 scenario executed successfully
        And <tag> with <value> in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Examples:
            | tag                 | value                                 |
            | retentionDate       | None                                  |
            | fiscalCodePA        | #creditor_institution_code_secondary# |
            | metadata            | None                                  |
            | city                | None                                  |
            | companyName         | None                                  |
            | country             | None                                  |
            | e-mail              | None                                  |
            | lastPayment         | None                                  |
            | officeName          | None                                  |
            | postalCode          | None                                  |
            | stateProvinceRegion | None                                  |
            | streetName          | None                                  |
            | civicNumber         | None                                  |
    @runnable
    # 6 transfers
    Scenario: 6 transfers
        Given the paGetPaymentV2 with 6 transfers scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # 11 mapEntry inside trasfer
    Scenario: 11 mapEntry inside transfer
        Given the paGetPaymentV2 with 11 mapEntry inside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # 11 mapEntry outside transfer
    Scenario: 11 mapEntry outside transfer
        Given the paGetPaymentV2 with 11 mapEntry outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # different amount and paymentAmount
    Scenario: different amount and paymentAmount
        Given the paGetPaymentV2 scenario executed successfully
        And amount with 11.00 in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    # idTransfer not inside enumeration
    Scenario: idTransfer not inside enumeration
        Given the paGetPaymentV2 with idTransfer not inside enumeration scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # no mapEntry with subtags outside transfer
    Scenario: no mapEntry with subtags outside transfer
        Given the paGetPaymentV2 without mapEntry with subtags outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # empty mapEntry outside transfer
    Scenario: empty mapEntry outside transfer
        Given the paGetPaymentV2 with empty mapEntry outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # no metadata outside transfer
    Scenario: no metadata outside transfer
        Given the paGetPaymentV2 without metadata outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    # no metadata with subtags outside transfer
    Scenario: no metadata with subtags outside transfer
        Given the paGetPaymentV2 without metadata with subtags outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # empty metadata outside transfer
    Scenario: empty metadata outside transfer
        Given the paGetPaymentV2 with empty metadata outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # no key outside transfer
    Scenario: no key outside transfer
        Given the paGetPaymentV2 without key outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # response KO without faultBeam
    Scenario: response KO without faultBeam
        Given the paGetPaymentV2 KO without faultBean scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    @runnable
    # no value outside transfer
    Scenario: no value outside transfer
        Given the paGetPaymentV2 without value outside transfer scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response