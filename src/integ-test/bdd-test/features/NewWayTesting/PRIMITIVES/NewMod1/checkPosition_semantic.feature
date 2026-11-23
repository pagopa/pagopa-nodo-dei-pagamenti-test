Feature: semantic checks for checkPosition outcome OK 960

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
                    }
                ]
            }
            """

    Scenario: checkPosition with 3 notice numbers
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

    Scenario: checkPosition with 3 activated notice numbers
        Given initial json checkPosition
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

    @ALL @PRIMITIVE @NMU @NMU_CHECK_POS_SEM @NMU_CHECK_POS_SEM_1
    # SEM_CPO_01
    Scenario: Code 200 OK 1
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response


    @ALL @PRIMITIVE @NMU @NMU_CHECK_POS_SEM @NMU_CHECK_POS_SEM_2
    Scenario: checkPosition with station version 1 [PG-37]
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 002#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response


    @ALL @PRIMITIVE @NMU @NMU_CHECK_POS_SEM @NMU_CHECK_POS_SEM_3
    Scenario: Wrong configuration 1
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode  | noticeNumber |
            | 12345678902 | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Wrong configuration of checkPosition response


    @ALL @PRIMITIVE @NMU @NMU_CHECK_POS_SEM @NMU_CHECK_POS_SEM_4
    # SEM_CPO_06
    Scenario: Wrong configuration 2
        Given from body with datatable vertical checkPositionBody_3element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | noticeNumber1 | 311123456789012345          |
            | noticeNumber2 | 002123456789012345          |
            | noticeNumber3 | 310123456789012345          |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Wrong configuration of checkPosition response