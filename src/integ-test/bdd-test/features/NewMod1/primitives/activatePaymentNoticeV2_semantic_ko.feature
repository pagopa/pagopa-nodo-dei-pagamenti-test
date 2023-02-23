Feature: semantic checks KO for activatePaymentNoticeV2Request

    Background:
        Given systems up
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
    @test
    # [SEM_APNV2_01]
    Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
        Given idPSP with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PSP_SCONOSCIUTO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_02]
    Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
        Given idPSP with NOT_ENABLED in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PSP_DISABILITATO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_03]
    Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
        Given idBrokerPSP with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_04]
    Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
        Given idBrokerPSP with INT_NOT_ENABLED in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_05]
    Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
        Given idChannel with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_CANALE_SCONOSCIUTO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_06]
    Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
        Given idChannel with CANALE_NOT_ENABLED in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_CANALE_DISABILITATO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_07]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
        Given idChannel with 60000000001_03 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_08]
    Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
        Given password with pippo123 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_09]
    Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
        Given fiscalCode with 12309847591 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_DOMINIO_SCONOSCIUTO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_10]
    Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
        Given fiscalCode with 11111122222 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_DOMINIO_DISABILITATO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_11]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
        Given idBrokerPSP with 50000000001 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNoticeV2 response
        And check description is Configurazione intermediario-canale non corretta of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_12]
    Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
        Given noticeNumber with <value> in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activatePaymentNoticeV2 response
        Examples:
            | value              | soapUI test         |
            | 511456789012345678 | SEM_APNV2_12 - aux5 |
            | 011456789012345678 | SEM_APNV2_12 - aux0 |
            | 300456789012345678 | SEM_APNV2_12 - aux3 |
    @test
    # [SEM_APNV2_13]
    Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
        Given noticeNumber with 006456789012345478 in activatePaymentNoticeV2
        And fiscalCode with 77777777777 in activatePaymentNoticeV2
        # step valido in sit
        # Given noticeNumber with 316456789012345478 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_14]
    Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
        Given fiscalCode with 00000000000 in activatePaymentNoticeV2
        And noticeNumber with 443456789012345678 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_15]
    Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
        Given fiscalCode with 55555555555 in activatePaymentNoticeV2
        And noticeNumber with 088456789012345678 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of activatePaymentNoticeV2 response
    @test
    # [SEM_APNV2_25]
    Scenario: Check PPT_AUTORIZZAZIONE error if expirationTime > default_token_duration_validity_millis
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 15000
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 7000
        And expirationTime with 10000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNoticeV2 response
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000
        And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000