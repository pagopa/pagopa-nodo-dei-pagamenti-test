Feature: on demand

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2
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
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>$activatePaymentNoticeV2.amount</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>#broker_AGID#</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>#canale_AGID_02#</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: closePaymentV2
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 12 seconds for expiration

    Scenario: sendPaymentOutcome
        Given initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
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
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: pspNotifyPayment timeout
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <delay>10000</delay>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: mod3CancelV1
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    #################################################################################################################################

    @bug
    Scenario: test 1
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the activatePaymentNoticeV2 scenario executed successfully
        And the pspNotifyPayment timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the mod3CancelV1 scenario executed successfully
        And the sendPaymentOutcome scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        Then check outcome is OK of sendPaymentOutcome response

    @bug
    Scenario: test 2
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the activatePaymentNoticeV2 scenario executed successfully
        And the pspNotifyPayment timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the mod3CancelV1 scenario executed successfully
        And the sendPaymentOutcome scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        Then check outcome is OK of sendPaymentOutcome response