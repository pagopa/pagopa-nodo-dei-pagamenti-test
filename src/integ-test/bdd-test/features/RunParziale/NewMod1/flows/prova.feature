Feature: BUG-PROD MULTITOKEN

    Background:
        Given systems up

    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "302#iuv#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310#iuv1#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: first activatePaymentNoticeV2 request
        Given the checkPosition scenario executed successfully
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
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>6000</expirationTime>
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPayment request in paGetPayment_1Request

    @multiToken
    Scenario: second activatePaymentNoticeV2 request
        Given the first activatePaymentNoticeV2 request scenario executed successfully
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
            <noticeNumber>310$iuv1</noticeNumber>
            </qrCode>
            <expirationTime>6000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
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
            <creditorReferenceId>10$iuv1</creditorReferenceId>
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
            <e-mail>paGetPayment@test.it</e-mail>
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    # Scenario: third activatePaymentNoticeV2 request
    #     Given the second activatePaymentNoticeV2 request scenario executed successfully
    #     And initial XML activatePaymentNoticeV2
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    #         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <nod:activatePaymentNoticeV2Request>
    #         <idPSP>#psp#</idPSP>
    #         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
    #         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
    #         <password>#password#</password>
    #         <idempotencyKey>#idempotency_key#</idempotencyKey>
    #         <qrCode>
    #         <fiscalCode>90000000001</fiscalCode>
    #         <noticeNumber>311$iuv2</noticeNumber>
    #         </qrCode>
    #         <expirationTime>6000</expirationTime>
    #         <amount>10.00</amount>
    #         <dueDate>2021-12-31</dueDate>
    #         <paymentNote>causale</paymentNote>
    #         </nod:activatePaymentNoticeV2Request>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML paGetPayment
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
    #         <soapenv:Header />
    #         <soapenv:Body>
    #         <paf:paGetPaymentRes>
    #         <outcome>OK</outcome>
    #         <data>
    #         <creditorReferenceId>11$iuv2</creditorReferenceId>
    #         <paymentAmount>10.00</paymentAmount>
    #         <dueDate>2021-12-31</dueDate>
    #         <!--Optional:-->
    #         <retentionDate>2021-12-31T12:12:12</retentionDate>
    #         <!--Optional:-->
    #         <lastPayment>1</lastPayment>
    #         <description>description</description>
    #         <!--Optional:-->
    #         <companyName>company</companyName>
    #         <!--Optional:-->
    #         <officeName>office</officeName>
    #         <debtor>
    #         <uniqueIdentifier>
    #         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
    #         <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
    #         </uniqueIdentifier>
    #         <fullName>paGetPaymentName</fullName>
    #         <!--Optional:-->
    #         <streetName>paGetPaymentStreet</streetName>
    #         <!--Optional:-->
    #         <civicNumber>paGetPayment99</civicNumber>
    #         <!--Optional:-->
    #         <postalCode>20155</postalCode>
    #         <!--Optional:-->
    #         <city>paGetPaymentCity</city>
    #         <!--Optional:-->
    #         <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
    #         <!--Optional:-->
    #         <country>IT</country>
    #         <!--Optional:-->
    #         <e-mail>paGetPayment@test.it</e-mail>
    #         </debtor>
    #         <!--Optional:-->
    #         <transferList>
    #         <!--1 to 5 repetitions:-->
    #         <transfer>
    #         <idTransfer>1</idTransfer>
    #         <transferAmount>10.00</transferAmount>
    #         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
    #         <IBAN>IT45R0760103200000000001016</IBAN>
    #         <remittanceInformation>testPaGetPayment</remittanceInformation>
    #         <transferCategory>paGetPaymentTest</transferCategory>
    #         </transfer>
    #         </transferList>
    #         <!--Optional:-->
    #         <metadata>
    #         <!--1 to 10 repetitions:-->
    #         <mapEntry>
    #         <key>1</key>
    #         <value>22</value>
    #         </mapEntry>
    #         </metadata>
    #         </data>
    #         </paf:paGetPaymentRes>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And EC replies to nodo-dei-pagamenti with the paGetPayment
    #     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    #     Then check outcome is OK of activatePaymentNoticeV2 response
    #     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3Request
    #     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
    #     And saving paGetPayment request in paGetPayment_3Request

    # Scenario: fourth activatePaymentNoticeV2 request
    #     Given the third activatePaymentNoticeV2 request scenario executed successfully
    #     And initial XML activatePaymentNoticeV2
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    #         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <nod:activatePaymentNoticeV2Request>
    #         <idPSP>#psp#</idPSP>
    #         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
    #         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
    #         <password>#password#</password>
    #         <idempotencyKey>#idempotency_key#</idempotencyKey>
    #         <qrCode>
    #         <fiscalCode>55555555555</fiscalCode>
    #         <noticeNumber>311$iuv3</noticeNumber>
    #         </qrCode>
    #         <expirationTime>6000</expirationTime>
    #         <amount>10.00</amount>
    #         <dueDate>2021-12-31</dueDate>
    #         <paymentNote>causale</paymentNote>
    #         </nod:activatePaymentNoticeV2Request>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML paGetPayment
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
    #         <soapenv:Header />
    #         <soapenv:Body>
    #         <paf:paGetPaymentRes>
    #         <outcome>OK</outcome>
    #         <data>
    #         <creditorReferenceId>11$iuv3</creditorReferenceId>
    #         <paymentAmount>10.00</paymentAmount>
    #         <dueDate>2021-12-31</dueDate>
    #         <!--Optional:-->
    #         <retentionDate>2021-12-31T12:12:12</retentionDate>
    #         <!--Optional:-->
    #         <lastPayment>1</lastPayment>
    #         <description>description</description>
    #         <!--Optional:-->
    #         <companyName>company</companyName>
    #         <!--Optional:-->
    #         <officeName>office</officeName>
    #         <debtor>
    #         <uniqueIdentifier>
    #         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
    #         <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
    #         </uniqueIdentifier>
    #         <fullName>paGetPaymentName</fullName>
    #         <!--Optional:-->
    #         <streetName>paGetPaymentStreet</streetName>
    #         <!--Optional:-->
    #         <civicNumber>paGetPayment99</civicNumber>
    #         <!--Optional:-->
    #         <postalCode>20155</postalCode>
    #         <!--Optional:-->
    #         <city>paGetPaymentCity</city>
    #         <!--Optional:-->
    #         <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
    #         <!--Optional:-->
    #         <country>IT</country>
    #         <!--Optional:-->
    #         <e-mail>paGetPayment@test.it</e-mail>
    #         </debtor>
    #         <!--Optional:-->
    #         <transferList>
    #         <!--1 to 5 repetitions:-->
    #         <transfer>
    #         <idTransfer>1</idTransfer>
    #         <transferAmount>10.00</transferAmount>
    #         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
    #         <IBAN>IT45R0760103200000000001016</IBAN>
    #         <remittanceInformation>testPaGetPayment</remittanceInformation>
    #         <transferCategory>paGetPaymentTest</transferCategory>
    #         </transfer>
    #         </transferList>
    #         <!--Optional:-->
    #         <metadata>
    #         <!--1 to 10 repetitions:-->
    #         <mapEntry>
    #         <key>1</key>
    #         <value>22</value>
    #         </mapEntry>
    #         </metadata>
    #         </data>
    #         </paf:paGetPaymentRes>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And EC replies to nodo-dei-pagamenti with the paGetPayment
    #     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    #     Then check outcome is OK of activatePaymentNoticeV2 response
    #     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4Request
    #     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
    #     And saving paGetPayment request in paGetPayment_4Request
    
    # @multiToken
    # Scenario: fifth activatePaymentNoticeV2 request
    #     Given the fourth activatePaymentNoticeV2 request scenario executed successfully
    #     And initial XML activatePaymentNoticeV2
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    #         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <nod:activatePaymentNoticeV2Request>
    #         <idPSP>#psp#</idPSP>
    #         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
    #         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
    #         <password>#password#</password>
    #         <idempotencyKey>#idempotency_key#</idempotencyKey>
    #         <qrCode>
    #         <fiscalCode>55555666666</fiscalCode>
    #         <noticeNumber>311$iuv4</noticeNumber>
    #         </qrCode>
    #         <expirationTime>6000</expirationTime>
    #         <amount>10.00</amount>
    #         <dueDate>2021-12-31</dueDate>
    #         <paymentNote>causale</paymentNote>
    #         </nod:activatePaymentNoticeV2Request>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML paGetPayment
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
    #         <soapenv:Header />
    #         <soapenv:Body>
    #         <paf:paGetPaymentRes>
    #         <outcome>OK</outcome>
    #         <data>
    #         <creditorReferenceId>11$iuv4</creditorReferenceId>
    #         <paymentAmount>10.00</paymentAmount>
    #         <dueDate>2021-12-31</dueDate>
    #         <!--Optional:-->
    #         <retentionDate>2021-12-31T12:12:12</retentionDate>
    #         <!--Optional:-->
    #         <lastPayment>1</lastPayment>
    #         <description>description</description>
    #         <!--Optional:-->
    #         <companyName>company</companyName>
    #         <!--Optional:-->
    #         <officeName>office</officeName>
    #         <debtor>
    #         <uniqueIdentifier>
    #         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
    #         <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
    #         </uniqueIdentifier>
    #         <fullName>paGetPaymentName</fullName>
    #         <!--Optional:-->
    #         <streetName>paGetPaymentStreet</streetName>
    #         <!--Optional:-->
    #         <civicNumber>paGetPayment99</civicNumber>
    #         <!--Optional:-->
    #         <postalCode>20155</postalCode>
    #         <!--Optional:-->
    #         <city>paGetPaymentCity</city>
    #         <!--Optional:-->
    #         <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
    #         <!--Optional:-->
    #         <country>IT</country>
    #         <!--Optional:-->
    #         <e-mail>paGetPayment@test.it</e-mail>
    #         </debtor>
    #         <!--Optional:-->
    #         <transferList>
    #         <!--1 to 5 repetitions:-->
    #         <transfer>
    #         <idTransfer>1</idTransfer>
    #         <transferAmount>10.00</transferAmount>
    #         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
    #         <IBAN>IT45R0760103200000000001016</IBAN>
    #         <remittanceInformation>testPaGetPayment</remittanceInformation>
    #         <transferCategory>paGetPaymentTest</transferCategory>
    #         </transfer>
    #         </transferList>
    #         <!--Optional:-->
    #         <metadata>
    #         <!--1 to 10 repetitions:-->
    #         <mapEntry>
    #         <key>1</key>
    #         <value>22</value>
    #         </mapEntry>
    #         </metadata>
    #         </data>
    #         </paf:paGetPaymentRes>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And EC replies to nodo-dei-pagamenti with the paGetPayment
    #     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    #     Then check outcome is OK of activatePaymentNoticeV2 response
    #     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_5Request
    #     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_5
    #     And saving paGetPayment request in paGetPayment_5Request