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
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial xml paaVerificaRPT
            """"
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
            <paaVerificaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>1.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaVerificaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
            <pag:capBeneficiario>jyr</pag:capBeneficiario>
            <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>of8</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/$iuv/TESTO/causale del versamento</causaleVersamento>
            </datiPagamentoPA>
            </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: activatePaymentNotice
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>002$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <importoSingoloVersamento>$activatePaymentNotice.amount</importoSingoloVersamento>
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
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @runnable
    Scenario: IDMP_SPO_11 (part 2)
        Given the IDMP_SPO_11 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_12

    Scenario: IDMP_SPO_12 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @runnable
    Scenario: IDMP_SPO_12 (part 2)
        Given the IDMP_SPO_12 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idPSP with Empty in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_13

    Scenario: IDMP_SPO_13 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @runnable
    Scenario: IDMP_SPO_13 (part 2)
        Given the IDMP_SPO_13 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And paymentToken with 798c6a817ed9482fa5659c45f4a25f286 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
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
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @runnable
    Scenario: IDMP_SPO_14 (part 2)
        Given the IDMP_SPO_14 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_15

    Scenario: IDMP_SPO_15 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_15 (part 2)
        Given the IDMP_SPO_15 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: IDMP_SPO_15 (part 3)
        Given the IDMP_SPO_15 (part 2) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_16.1

    Scenario: IDMP_SPO_16.1 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_16.1 (part 2)
        Given the IDMP_SPO_16.1 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: IDMP_SPO_16.1 (part 3)
        Given the IDMP_SPO_16.1 (part 2) scenario executed successfully
        And idPSP with 70000000001 in sendPaymentOutcomeV2
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        And idChannel with 70000000001_01 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_16.2

    Scenario: IDMP_SPO_16.2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_16.2 (part 2)
        Given the IDMP_SPO_16.2 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: IDMP_SPO_16.2 (part 3)
        Given the IDMP_SPO_16.2 (part 2) scenario executed successfully
        And paymentMethod with cash in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_16.3

    Scenario: IDMP_SPO_16.3 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_16.3 (part 2)
        Given the IDMP_SPO_16.3 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: IDMP_SPO_16.3 (part 3)
        Given the IDMP_SPO_16.3 (part 2) scenario executed successfully
        And streetName with street3 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1

    # IDMP_SPO_17

    Scenario: IDMP_SPO_17 (part 1)
        Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
        And the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_17 (part 2)
        Given the IDMP_SPO_17 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And current date plus 1 minutes generation
        And updates through the query update_validto of the table IDEMPOTENCY_CACHE the parameter VALID_TO with $date_plus_minutes under macro NewMod1 on db nodo_online
        And wait 65 seconds for expiration
    @runnable
    Scenario: IDMP_SPO_17 (part 3)
        Given the IDMP_SPO_17 (part 2) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
        And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2_timestamp_desc on db nodo_online under macro NewMod1
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
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activate on db nodo_online under macro NewMod1
    @runnable
    Scenario: IDMP_SPO_18 (part 2)
        Given the IDMP_SPO_18 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activate on db nodo_online under macro NewMod1

    # IDMP_SPO_20

    Scenario: IDMP_SPO_20 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activate on db nodo_online under macro NewMod1
    @runnable
    Scenario: IDMP_SPO_20 (part 2)
        Given the IDMP_SPO_20 (part 1) scenario executed successfully
        And nodo-dei-pagamenti has config parameter useIdempotency set to false
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And nodo-dei-pagamenti has config parameter useIdempotency set to true
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activate on db nodo_online under macro NewMod1

    # IDMP_SPO_22

    Scenario: IDMP_SPO_22 (part 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to false
        And the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_22 (part 2)
        Given the IDMP_SPO_22 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: IDMP_SPO_22 (part 3)
        Given the IDMP_SPO_22 (part 2) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_spov2 on db nodo_online under macro NewMod1
        And nodo-dei-pagamenti has config parameter useIdempotency set to true

    # IDMP_SPO_26

    Scenario: IDMP_SPO_26 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
    @runnable
    Scenario: IDMP_SPO_26 (part 2)
        Given the IDMP_SPO_26 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idempotencyKey with None in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_activate on db nodo_online under macro NewMod1

    # IDMP_SPO_27

    Scenario: IDMP_SPO_27 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: IDMP_SPO_27 (part 2)
        Given the IDMP_SPO_27 (part 1) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable
    Scenario: IDMP_SPO_27 (part 3)
        Given the IDMP_SPO_27 (part 2) scenario executed successfully
        And random idempotencyKey having $sendPaymentOutcomeV2.idPSP as idPSP in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response

    # IDMP_SPO_31

    Scenario: IDMP_SPO_31 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        And expirationTime with 2000 in activatePaymentNotice
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice_1
        And updates through the query update_activate of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
        And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online
        And wait 3 seconds for expiration

    Scenario: IDMP_SPO_31 (part 2)
        Given the IDMP_SPO_31 (part 1) scenario executed successfully
        And expirationTime with None in activatePaymentNotice
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice_2

    Scenario: IDMP_SPO_31 (part 3)
        Given the IDMP_SPO_31 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And paymentToken with $activatePaymentNotice_2Response.paymentToken in sendPaymentOutcomeV2
        And idempotencyKey with None in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @runnable @fix
    Scenario: IDMP_SPO_31 (part 4)
        Given the IDMP_SPO_31 (part 3) scenario executed successfully
        And paymentToken with $activatePaymentNotice_1Response.paymentToken in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response