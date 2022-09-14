Feature:  flow check for sendPaymentResult-v2 request - spr-v2 408 Timeout, retry [T_SPR_V2_12]

    Background:
        Given systems up
        And EC new version

    # verifyPaymentNotice phase
    Scenario: Execute verifyPaymentNotice request
        Given initial xml verifyPaymentNotice

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>AGID_01</idPSP>
            <idBrokerPSP>97735020584</idBrokerPSP>
            <idChannel>97735020584_03</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial xml paVerifyPaymentNotice
            """"
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
            <dueDate>2022-09-13</dueDate>
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
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    # activateIOPaymentReq phase
    Scenario: Execute activateIOPayment request
        Given the Execute verifyPaymentNotice request scenario executed successfully
        And initial xml activateIOPayment

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>AGID_01</idPSP>
            <idBrokerPSP>97735020584</idBrokerPSP>
            <idChannel>97735020584_03</idChannel>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>responseFull</paymentNote>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>IOname_#idempotency_key#</fullName>
            <!--Optional:-->
            <streetName>IOstreet</streetName>
            <!--Optional:-->
            <civicNumber>IOcivic</civicNumber>
            <!--Optional:-->
            <postalCode>IOcode</postalCode>
            <!--Optional:-->
            <city>IOcity</city>
            <!--Optional:-->
            <stateProvinceRegion>IOstate</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>IO.test.prova@gmail.com</e-mail>
            </payer>
            </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And initial xml paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>11$iuv</creditorReferenceId>
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
            <country>DE</country>
            <!--Optional:-->
            <e-mail>paGetPayment@test.it</e-mail>
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
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse

    Scenario: DB check
        Given the Execute activateIOPayment request scenario executed successfully
        Then checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And checks the value $activateIOPaymentRequest.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO


    # nodoChiediInformazioniPagamento phase
    Scenario: Execute a nodoChiediInformazioniPagamento request
        Given the Execute activateIOPayment request scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200


    # closePayment-v2 phase
    Scenario: Execute a closePayment-v2 request
        Given the Execute a nodoChiediInformazioniPagamento request scenario executed successfully
        And idChannel with CANALI_NODO.VERSIONE_PRIMITIVE = 1
        And initial json closePayment-v2
            """
            {
                "paymentTokens": [
                    "$activateIOPaymentNoticeResponse.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "60000000001_03",
                "paymentMethod": "TPAY",
                "transactionId": "19392562",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "10793459"
                }
            }
            """

        When PM sends closePayment-v2 to nodo-dei-pagamenti
        Then check outcome is OK of closePayment-v2
        And verify the HTTP status code of closePayment-v2 response is 200
        And check no sendPaymentResult-v2 is sent


    # sendPaymentOutcome phase
    Scenario: Execute sendPaymentOutcome request
        Given the Execute a closePayment-v2 request scenario executed successfully
        And initial xml sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>60000000001</idBrokerPSP>
            <idChannel>#canale_IMMEDIATO_MULTIBENEFICIARIO#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$activateIOPaymentNoticeResponse.paymentToken</paymentToken>
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
            <fullName>SPOname_$activateIOPaymentNoticeResponse.paymentToken</fullName>
            <!--Optional:-->
            <streetName>SPOstreet</streetName>
            <!--Optional:-->
            <civicNumber>SPOcivic</civicNumber>
            <!--Optional:-->
            <postalCode>SPOpostal</postalCode>
            <!--Optional:-->
            <city>SPOcity</city>
            <!--Optional:-->
            <stateProvinceRegion>SPOstate</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>SPOprova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And REST POST sendPaymentResult-v2
            """
            408 Timeout
            """
        And wait 3 seconds for expiration
        When psp sends sendPaymentOutcome to nodo-dei-pagamenti
        And WISP sends REST POST sendPaymentResult-v2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

#implementare i check db e verificare che la tabella POSITION_RETRY_SENDPAYMENTRESULT sia popolata