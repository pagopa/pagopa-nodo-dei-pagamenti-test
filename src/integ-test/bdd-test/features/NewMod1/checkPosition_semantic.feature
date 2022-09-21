Feature: semantic checks for checkPosition outcome OK

    Background:
        Given systems up

    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "311#iuv#"
                    }
                ]
            }
            """

    Scenario: checkPosition with 3 positions
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "311123456789012345"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "002123456789012345"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310123456789012345"
                    }
                ]
            }
            """

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
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>12345</expirationTime>
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

    # SEM_CPO_01
    Scenario: Code 200 OK 1
        Given the checkPosition scenario executed successfully
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    # SEM_CPO_02
    Scenario: Code 200 OK 2 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And updates through the query select_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online

    Scenario: Code 200 OK 2 (part 2)
        Given the Code 200 OK 2 (part 1) scenario executed successfully
        And the checkPosition scenario executed successfully
        And noticeNumber with 311$iuv in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    # SEM_CPO_03
    Scenario: Code 200 KO (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request

    Scenario: Code 200 KO (part 2)
        Given the Code 200 KO (part 1) scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request1
        And updates through the query select_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online

    Scenario: Code 200 KO (part 3)
        Given the Code 200 KO (part 2) scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request2
        And updates through the query select_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online

    Scenario: Code 200 KO (part 4)
        Given the Code 200 KO (part 3) scenario executed successfully
        And initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "$activatePaymentNoticeV2Request.noticeNumber"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "$activatePaymentNoticeV2Request1.noticeNumber"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "$activatePaymentNoticeV2Request2.noticeNumber"
                    }
                ]
            }
            """

        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is KO of checkPosition response
    # And check positionslist contains PAYING of checkPosition response
    # And check positionslist contains PAID of checkPosition response
    # And check positionslist contains NOTIFIED of checkPosition response

    # SEM_CPO_04
    Scenario: Wrong configuration 1
        Given the checkPosition scenario executed successfully
        And fiscalCode with 12345678902 in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Wrong configuration of checkPosition response

    # SEM_CPO_05
    Scenario: Wrong configuration 2
        Given the checkPosition scenario executed successfully
        And noticeNumber with 002$iuv in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Wrong configuration of checkPosition response

    # SEM_CPO_06
    Scenario: Wrong configuration 3
        Given the checkPosition with 3 positions scenario executed successfully
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Wrong configuration of checkPosition response