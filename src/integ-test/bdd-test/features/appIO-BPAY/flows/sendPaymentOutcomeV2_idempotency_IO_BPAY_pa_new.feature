Feature: idempotency checks for sendPaymentOutcomeV2

    Background:
        Given systems up

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
            <noticeNumber>302#iuv#</noticeNumber>
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

    Scenario: activateIOPayment
        Given initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
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
            </nod:activateIOPaymentReq>
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
            <fiscalCodePA>$activateIOPayment.fiscalCode</fiscalCodePA>
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

    Scenario: closePayment
        Given initial json v1/closepayment
            """
            {
                "paymentTokens": [
                    "$activateIOPaymentResponse.paymentToken"
                ],
                "outcome": "OK",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BPAY",
                "identificativoIntermediario": "#id_broker_psp#",
                "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "pspTransactionId": "#psp_transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "EFF",
                    "authorizationCode": "resOK"
                }
            }
            """

    Scenario: sendPaymentOutcomeV2
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
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <paymentTokens>
            <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
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

    # IDMP_SPO_11

    Scenario: IDMP_SPO_11 (part 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to true
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_11 (part 2)
        Given the IDMP_SPO_11 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_11 (part 3)
        Given the IDMP_SPO_11 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
 @test @dependentread @lazy @dependentwrite 
    Scenario: IDMP_SPO_11 (part 4)
        Given the IDMP_SPO_11 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_12

    Scenario: IDMP_SPO_12 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_12 (part 2)
        Given the IDMP_SPO_12 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_12 (part 3)
        Given the IDMP_SPO_12 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
  @test @dependentread @lazy
    Scenario: IDMP_SPO_12 (part 4)
        Given the IDMP_SPO_12 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idPSP with Empty in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_13

    Scenario: IDMP_SPO_13 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_13 (part 2)
        Given the IDMP_SPO_13 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_13 (part 3)
        Given the IDMP_SPO_13 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
  @test @dependentread @lazy
    Scenario: IDMP_SPO_13 (part 4)
        Given the IDMP_SPO_13 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And paymentToken with 798c6a817ed9482fa5659c45f4a25f286 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value 798c6a817ed9482fa5659c45f4a25f286 of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_14

    Scenario: IDMP_SPO_14 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_14 (part 2)
        Given the IDMP_SPO_14 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_14 (part 3)
        Given the IDMP_SPO_14 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
  @test @dependentread @lazy
    Scenario: IDMP_SPO_14 (part 4)
        Given the IDMP_SPO_14 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_15

    Scenario: IDMP_SPO_15 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_15 (part 2)
        Given the IDMP_SPO_15 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_15 (part 3)
        Given the IDMP_SPO_15 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_15 (part 4)
        Given the IDMP_SPO_15 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
  @test @dependentread @lazy
    Scenario: IDMP_SPO_15 (part 5)
        Given the IDMP_SPO_15 (part 4) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_16.1

    Scenario: IDMP_SPO_16.1 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_16.1 (part 2)
        Given the IDMP_SPO_16.1 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_16.1 (part 3)
        Given the IDMP_SPO_16.1 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_16.1 (part 4)
        Given the IDMP_SPO_16.1 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
  @test @dependentread @lazy
    Scenario: IDMP_SPO_16.1 (part 5)
        Given the IDMP_SPO_16.1 (part 4) scenario executed successfully
        And idPSP with 70000000001 in sendPaymentOutcomeV2
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        And idChannel with 70000000001_01 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_16.2

    Scenario: IDMP_SPO_16.2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_16.2 (part 2)
        Given the IDMP_SPO_16.2 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_16.2 (part 3)
        Given the IDMP_SPO_16.2 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_16.2 (part 4)
        Given the IDMP_SPO_16.2 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
  @test @dependentread @lazy
    Scenario: IDMP_SPO_16.2 (part 5)
        Given the IDMP_SPO_16.2 (part 4) scenario executed successfully
        And paymentMethod with cash in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_16.3

    Scenario: IDMP_SPO_16.3 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_16.3 (part 2)
        Given the IDMP_SPO_16.3 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_16.3 (part 3)
        Given the IDMP_SPO_16.3 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_16.3 (part 4)
        Given the IDMP_SPO_16.3 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
  @test @dependentread @lazy
    Scenario: IDMP_SPO_16.3 (part 5)
        Given the IDMP_SPO_16.3 (part 4) scenario executed successfully
        And streetName with street3 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_17

    Scenario: IDMP_SPO_17 (part 1)
        Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_17 (part 2)
        Given the IDMP_SPO_17 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_17 (part 3)
        Given the IDMP_SPO_17 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_17 (part 4)
        Given the IDMP_SPO_17 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And current date plus 1 minutes generation
        And updates through the query update_validto of the table IDEMPOTENCY_CACHE the parameter VALID_TO with $date_plus_minutes under macro NewMod1 on db nodo_online
        And wait 65 seconds for expiration
  @test @dependentread @dependentwrite @lazy
    Scenario: IDMP_SPO_17 (part 5)
        Given the IDMP_SPO_17 (part 4) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1

    # IDMP_SPO_18

    Scenario: IDMP_SPO_18 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activateio on db nodo_online under macro NewMod1

    Scenario: IDMP_SPO_18 (part 2)
        Given the IDMP_SPO_18 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_18 (part 3)
        Given the IDMP_SPO_18 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
  @test @dependentread 
    Scenario: IDMP_SPO_18 (part 4)
        Given the IDMP_SPO_18 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activateio on db nodo_online under macro NewMod1

    # IDMP_SPO_20

    Scenario: IDMP_SPO_20 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activateio on db nodo_online under macro NewMod1

    Scenario: IDMP_SPO_20 (part 2)
        Given the IDMP_SPO_20 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_20 (part 3)
        Given the IDMP_SPO_20 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
  @test @dependentread @dependentwrite @lazy
    Scenario: IDMP_SPO_20 (part 4)
        Given the IDMP_SPO_20 (part 3) scenario executed successfully
        And nodo-dei-pagamenti has config parameter useIdempotency set to false
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And nodo-dei-pagamenti has config parameter useIdempotency set to true
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activateio on db nodo_online under macro NewMod1

    # IDMP_SPO_22

    Scenario: IDMP_SPO_22 (part 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to false
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_22 (part 2)
        Given the IDMP_SPO_22 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_22 (part 3)
        Given the IDMP_SPO_22 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_22 (part 4)
        Given the IDMP_SPO_22 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
  @test @dependentread @dependentwrite @lazy
    Scenario: IDMP_SPO_22 (part 5)
        Given the IDMP_SPO_22 (part 4) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter useIdempotency set to true

    # IDMP_SPO_26

    Scenario: IDMP_SPO_26 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_26 (part 2)
        Given the IDMP_SPO_26 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_26 (part 3)
        Given the IDMP_SPO_26 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration
  @test @dependentread
    Scenario: IDMP_SPO_26 (part 4)
        Given the IDMP_SPO_26 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idempotencyKey with None in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activateio on db nodo_online under macro NewMod1

    # IDMP_SPO_27

    Scenario: IDMP_SPO_27 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: IDMP_SPO_27 (part 2)
        Given the IDMP_SPO_27 (part 1) scenario executed successfully
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: IDMP_SPO_27 (part 3)
        Given the IDMP_SPO_27 (part 2) scenario executed successfully
        And the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response
        And wait 5 seconds for expiration

    Scenario: IDMP_SPO_27 (part 4)
        Given the IDMP_SPO_27 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
   @test @lazy 
    Scenario: IDMP_SPO_27 (part 5)
        Given the IDMP_SPO_27 (part 4) scenario executed successfully
        And random idempotencyKey having $sendPaymentOutcomeV2.idPSP as idPSP in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response