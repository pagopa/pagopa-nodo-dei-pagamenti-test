Feature: flow tests for paSendRTV2

    Background:
        Given systems up

    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310#iuv#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2 request
        Given initial XML activatePaymentNoticeV2
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
            <noticeNumber>310$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 response
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with 3 transfers (1)
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000002</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with 3 transfers (2)
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with 3 transfers (3)
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with 3 transfers (4)
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code_secondary#</fiscalCodePA>
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
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code_secondary#</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with 2 transfers
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with 2 transfers (2)
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>#creditor_institution_code_secondary#</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with metadata CHIAVEOK
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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

    Scenario: paGetPaymentV2 response with metadata CHIAVESCONOSCIUTA
        Given initial XML paGetPaymentV2
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
            <!--Optional:-->
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
            <e-mail>paGetPayment@test.it</e-mail>
            </debtor>
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>10.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVESCONOSCIUTA</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            </transferList>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>CHIAVESCONOSCIUTA</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </data>
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: closePaymentV2
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: pspNotifyPaymentV2 timeout response
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <delay>10000</delay>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: sendPaymentOutcomeV2 request
        Given initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            </paymentTokens>
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
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paSendRTV2 timeout response
        Given initial XML paSendRTV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paSendRTV2Response>
            <delay>10000</delay>
            </paf:paSendRTV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # PSRTV2_ACTV1_03

    Scenario: PSRTV2_ACTV1_03 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And lastPayment with 0 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_03 (part 2)
        Given the PSRTV2_ACTV1_03 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 3 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_04

    Scenario: PSRTV2_ACTV1_04 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_04 (part 2)
        Given the PSRTV2_ACTV1_04 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 3 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_05

    Scenario: PSRTV2_ACTV1_05 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_05 (part 2)
        Given the PSRTV2_ACTV1_05 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 3 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_06

    Scenario: PSRTV2_ACTV1_06 (part 1)
        Given updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_06 (part 2)
        Given the PSRTV2_ACTV1_06 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 9 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_07

    Scenario: PSRTV2_ACTV1_07 (part 1)
        Given updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 2 transfers scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_07 (part 2)
        Given the PSRTV2_ACTV1_07 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 10 seconds for expiration
        And updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 9 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_08

    Scenario: PSRTV2_ACTV1_08 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (2) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_08 (part 2)
        Given the PSRTV2_ACTV1_08 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 10 seconds for expiration
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_09

    Scenario: PSRTV2_ACTV1_09 (part 1)
        Given updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (2) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_09 (part 2)
        Given the PSRTV2_ACTV1_09 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 10 seconds for expiration
        And updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 9 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_10

    Scenario: PSRTV2_ACTV1_10 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (3) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_10 (part 2)
        Given the PSRTV2_ACTV1_10 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 10 seconds for expiration
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_11

    Scenario: PSRTV2_ACTV1_11 (part 1)
        Given updates through the query update_fk_pa_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And fiscalCodePA with 90000000001 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_11 (part 2)
        Given the PSRTV2_ACTV1_11 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 13 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_12

    Scenario: PSRTV2_ACTV1_12 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_12 (part 2)
        Given the PSRTV2_ACTV1_12 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_16

    Scenario: PSRTV2_ACTV1_16 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 2000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_16 (part 2)
        Given the PSRTV2_ACTV1_16 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 10 seconds for expiration

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_17

    Scenario: PSRTV2_ACTV1_17 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 4000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_17 (part 2)
        Given the PSRTV2_ACTV1_17 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 6 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_18

    Scenario: PSRTV2_ACTV1_18 (part 1)
        Given updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 4000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_18 (part 2)
        Given the PSRTV2_ACTV1_18 (part 1) scenario executed successfully
        And updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_20

    Scenario: PSRTV2_ACTV1_20 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And lastPayment with 0 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_20 (part 2)
        Given the PSRTV2_ACTV1_20 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_20 (part 3)
        Given the PSRTV2_ACTV1_20 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_21

    Scenario: PSRTV2_ACTV1_21 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_21 (part 2)
        Given the PSRTV2_ACTV1_21 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_21 (part 3)
        Given the PSRTV2_ACTV1_21 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_22

    Scenario: PSRTV2_ACTV1_22 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_22 (part 2)
        Given the PSRTV2_ACTV1_22 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable 
    Scenario: PSRTV2_ACTV1_22 (part 3)
        Given the PSRTV2_ACTV1_22 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_23

    Scenario: PSRTV2_ACTV1_23 (part 1)
        Given updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_23 (part 2)
        Given the PSRTV2_ACTV1_23 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_23 (part 3)
        Given the PSRTV2_ACTV1_23 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200
        And updates through the query update_obj_id of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 11 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING,NOTIFIED,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_24

    Scenario: PSRTV2_ACTV1_24 (part 1)
        Given updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro NewMod1 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 2 transfers (2) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_24 (part 2)
        Given the PSRTV2_ACTV1_24 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC2 replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_24 (part 3)
        Given the PSRTV2_ACTV1_24 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC2 replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200
        And updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro NewMod1 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query recipient_station_id_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query recipient_station_id_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query recipient_station_id_3_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query recipient_station_id_3_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query recipient_station_id_4_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query recipient_station_id_4_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTICE_PENDING,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 7 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value $sendPaymentOutcomeV2.paymentToken,$sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1,1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_25

    Scenario: PSRTV2_ACTV1_25 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro NewMod1 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (4) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_25 (part 2)
        Given the PSRTV2_ACTV1_25 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC2 replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_25 (part 3)
        Given the PSRTV2_ACTV1_25 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC2 replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro NewMod1 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 7 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_26

    Scenario: PSRTV2_ACTV1_26 (part 1)
        Given updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (3) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_26 (part 2)
        Given the PSRTV2_ACTV1_26 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_26 (part 3)
        Given the PSRTV2_ACTV1_26 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200
        And updates through the query update_obj_id_2 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTIFIED,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_27

    Scenario: PSRTV2_ACTV1_27 (part 1)
        Given updates through the query update_fk_pa_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And fiscalCodePA with 90000000001 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_27 (part 2)
        Given the PSRTV2_ACTV1_27 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable 
    Scenario: PSRTV2_ACTV1_27 (part 3)
        Given the PSRTV2_ACTV1_27 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_28

    Scenario: PSRTV2_ACTV1_28 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_28 (part 2)
        Given the PSRTV2_ACTV1_28 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 5 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    Scenario: PSRTV2_ACTV1_28 (part 3)
        Given the PSRTV2_ACTV1_28 (part 2) scenario executed successfully
        And wait 12 seconds for expiration
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTICE_PENDING of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECIPIENT of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    @runnable
    Scenario: PSRTV2_ACTV1_28 (part 4)
        Given the PSRTV2_ACTV1_28 (part 3) scenario executed successfully
        When job paSendRt triggered after 5 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT,NOTICE_PENDING,NOTICE_SENT of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTICE_SENT,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 10 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_29

    Scenario: PSRTV2_ACTV1_29 (part 1)
        Given updates through the query update_fk_pa of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro Mod4 on db nodo_cfg
        And refresh job PA triggered after 10 seconds
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 2000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response with 3 transfers (1) scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: PSRTV2_ACTV1_29 (part 2)
        Given the PSRTV2_ACTV1_29 (part 1) scenario executed successfully
        And the pspNotifyPaymentV2 timeout response scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And wait 12 seconds for expiration
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

    Scenario: PSRTV2_ACTV1_29 (part 3)
        Given the PSRTV2_ACTV1_29 (part 2) scenario executed successfully
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_29 (part 4)
        Given the PSRTV2_ACTV1_29 (part 3) scenario executed successfully
        And wait 12 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        And the paSendRTV2 timeout response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        When job paSendRt triggered after 12 seconds
        Then verify the HTTP status code of paSendRt response is 200

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # PSRTV2_ACTV1_30

    Scenario: PSRTV2_ACTV1_30 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with metadata CHIAVEOK scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_30 (part 2)
        Given the PSRTV2_ACTV1_30 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # RE
        And execution query pasendrtv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query pasendrtv2_req_spov2 retrieve xml PAYLOAD at position 0 and save it under the key paSendRTV2Req
        And check value $paSendRTV2Req.key is equal to value $paGetPaymentV2.key

    # PSRTV2_ACTV1_31

    Scenario: PSRTV2_ACTV1_31 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response with metadata CHIAVESCONOSCIUTA scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
    @runnable
    Scenario: PSRTV2_ACTV1_31 (part 2)
        Given the PSRTV2_ACTV1_31 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends soap sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # RE
        And execution query pasendrtv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query pasendrtv2_req_spov2 retrieve xml PAYLOAD at position 0 and save it under the key paSendRTV2Req
        And check value $paSendRTV2Req.key is equal to value $paGetPaymentV2.key