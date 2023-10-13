Feature: syntax checks for closePaymentV2 outcome OK

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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>66666666666</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>66666666666</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>66666666666</fiscalCodePA>
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

    Scenario: check activatePaymentNoticeV2 OK
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21

    Scenario: closePaymentV2 PAG-2555
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
    @test @pippo
    Scenario: update DB
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds

    @test
    Scenario Outline: check closePaymentV2 PAG-2555 KO outline
        Given the closePaymentV2 PAG-2555 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response
        Examples:
            | elem                  | value                                |
            | outcomePaymentGateway | None                                 |
            | outcomePaymentGateway | Empty                                |
            | authorizationCode     | None                                 |
            | authorizationCode     | Empty                                |
            | authorizationCode     | aaaaaaa                              |
            | paymentGateway        | Empty                                |
            | paymentGateway        | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |



    @test @pippo
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount None
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "fee": "2",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @test
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount oversize
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "999999999.99",
                    "fee": "2",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @test
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount Empty
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": null,
                    "fee": "2",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @test 
    Scenario: check closePaymentV2 PAG-2555 KO fee None
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @test 
    Scenario: check closePaymentV2 PAG-2555 KO fee oversize
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "9999999999.99",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @test
    Scenario: check closePaymentV2 PAG-2555 KO fee Empty
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": null,
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @test 
    Scenario: check closePaymentV2 PAG-2555 KO timestampOperation None
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @test
    Scenario: check closePaymentV2 PAG-2555 KO timestampOperation Empty
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "timestampOperation": "null",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @test
    Scenario: check closePaymentV2 PAG-2555 OK
        Given the check activatePaymentNoticeV2 OK scenario executed successfully
        And the closePaymentV2 PAG-2555 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV21Response.paymentToken in v2/closepayment
        And paymentGateway with None in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @test @pippo
    Scenario: update DB
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'N', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds