Feature: semantic checks for closePayment 140

    Background:
        Given systems up

    Scenario: closePayment
        Given initial JSON v1/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc1976d0a6b05"
                ],
                "outcome": "OK",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BPAY",
                "identificativoIntermediario": "#id_broker_psp#",
                "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "pspTransactionId": "#psp_transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "EFF",
                    "authorizationCode": "resOK"
                }
            }
            """
    @PM
    # paymentToken unknown [SEM_CP_01]
    Scenario: Check unknown paymentToken
        Given the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response
    @PM
    # identificativoPsp value check
    Scenario Outline: Check semantic error on identificativoPsp
        Given the closePayment scenario executed successfully
        And <elem> with <value> in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il PSP indicato non esiste of v1/closepayment response
        Examples:
            | elem              | value       | soapUI test |
            | identificativoPsp | 12345678987 | SEM_CP_03   |
            | identificativoPsp | NOT_ENABLED | SEM_CP_04   |
    @PM
    # identificativoIntermediario value check
    Scenario Outline: Check semantic error on identificativoIntermediario
        Given the closePayment scenario executed successfully
        And <elem> with <value> in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is L'Intermediario indicato non esiste of v1/closepayment response
        Examples:
            | elem                        | value           | soapUI test |
            | identificativoIntermediario | 12545678987     | SEM_CP_05   |
            | identificativoIntermediario | INT_NOT_ENABLED | SEM_CP_06   |
    @PM
    # identificativoCanale value check
    Scenario Outline: Check semantic error on identificativoCanale
        Given the closePayment scenario executed successfully
        And <elem> with <value> in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il Canale indicato non esiste of v1/closepayment response
        Examples:
            | elem                 | value              | soapUI test |
            | identificativoCanale | 12345671234_09     | SEM_CP_07   |
            | identificativoCanale | CANALE_NOT_ENABLED | SEM_CP_08   |
    @PM
    # identificativoCanale not associated to BPAY [SEM_SPO_09]
    Scenario: Check identificativoCanale not associated to BPAY
        Given the closePayment scenario executed successfully
        And identificativoCanale with 60000000001_06 in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Configurazione psp-canale-tipoVersamento non corretta of v1/closepayment response
    @PM 
    # identificativoCanale with Modello di pagamento = ATTIVATO PRESSO PSP [SEM_SPO_10]
    Scenario: Check identificativoCanale ATTIVATO_PRESSO_PSP
        Given the closePayment scenario executed successfully
        And identificativoCanale with #canale_ATTIVATO_PRESSO_PSP# in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 400
        And check esito is KO of v1/closepayment response
        And check descrizione is Modello pagamento non valido of v1/closepayment response
    @PM
    # identificativoIntermediario-identificativoCanale-identificativoPsp not associated [SEM_SPO_11]
    Scenario: Check "esito":"KO" on identificativoPsp not associated to identificativoIntermediario and identificativoCanale
        Given the closePayment scenario executed successfully
        And identificativoPsp with IDPSPFNZ in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Configurazione psp-canale non corretta of v1/closepayment response

    # other semantic checks
    Scenario: activateIOPayment
        Given initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activateIOPaymentReq>
            <idPSP>#psp_AGID#</idPSP>
            <idBrokerPSP>#broker_AGID#</idBrokerPSP>
            <idChannel>#canale_AGID#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
            <amount>12.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>test</paymentNote>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>code</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>test.prova@gmail.com</e-mail>
            </payer>
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
            <transferAmount>5.00</transferAmount>
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
            <transferAmount>2.00</transferAmount>
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

    # check on amount and fee [SEM_CP_12]
    Scenario: check activateIOPayment OK
        Given the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse
    @PM
    Scenario: check closePayment
        Given the check activateIOPayment OK scenario executed successfully
        And the closePayment scenario executed successfully
        And paymentToken with $activateIOPaymentResponse.paymentToken in v1/closepayment
        And totalAmount with 20 in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response

    # check future timestampOperation [SEM_CP_13]
    Scenario: check activateIOPayment OK 2
        Given the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse
    @PM
    Scenario: check closePayment OK 2
        Given the check activateIOPayment OK 2 scenario executed successfully
        And the closePayment scenario executed successfully
        And paymentToken with $activateIOPaymentResponse.paymentToken in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response

    # check past timestampOperation [SEM_CP_13]
    Scenario: check activateIOPayment OK 3
        Given the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse
    @PM
    Scenario: check closePayment OK 3
        Given the check activateIOPayment OK 3 scenario executed successfully
        And the closePayment scenario executed successfully
        And paymentToken with $activateIOPaymentResponse.paymentToken in v1/closepayment
        And timestampOperation with 2018-04-23T18:25:43Z in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 200
        And check esito is OK of v1/closepayment response