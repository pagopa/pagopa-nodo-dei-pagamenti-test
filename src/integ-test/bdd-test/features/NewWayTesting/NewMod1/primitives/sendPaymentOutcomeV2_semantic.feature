Feature:  semantic checks for sendPaymentOutcomeV2 968

    Background:
        Given systems up
        And initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>12345678901234567890123456789012</paymentToken>
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
    @ALL @PRIMITIVE
    # idPSP value check: idPSP not in db [SEM_SPO_01]
    Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
        Given idPSP with 1230984759 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PSP_SCONOSCIUTO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # idPSP value check: idPSP with field ENABLED = N [SEM_SPO_02]
    Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
        Given idPSP with NOT_ENABLED in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PSP_DISABILITATO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # idBrokerPSP value check: idBrokerPSP not present in db [SEM_SPO_03]
    Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
        Given idBrokerPSP with 1230984759 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_SPO_04]
    Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
        Given idBrokerPSP with INT_NOT_ENABLED in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # idChannel value check: idChannel not in db [SEM_SPO_05]
    Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
        Given idChannel with 1230984759 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_CANALE_SCONOSCIUTO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # idChannel value check: idChannel with field ENABLED = N [SEM_SPO_06]
    Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
        Given idChannel with CANALE_NOT_ENABLED in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_CANALE_DISABILITATO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # password value check: wrong password for an idChannel [SEM_SPO_08]
    Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
        Given password with password in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTENTICAZIONE of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # SEM_SPO_09
    Scenario: SEM_SPO_09
        Given paymentToken with 111111111111112 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # paymentToken value check: token+idPsp not present in POSITION_ACTIVATE table of nodo-dei-pagamenti db [SEM_SPO_10]
    Scenario: Check PPT_TOKEN_SCONOSCIUTO error on non-existent couple token+idPsp
        Given paymentToken with 7ff1180be4814c4d909f123a943eeb27 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
    @ALL @PRIMITIVE
    # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_SPO_11]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
        Given idBrokerPSP with 91000000001 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
        And check description is Configurazione intermediario-canale non corretta of sendPaymentOutcomeV2 response