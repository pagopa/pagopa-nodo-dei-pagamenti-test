Feature:  semantic checks for sendPaymentOutcomeV2 968

    Background:
        Given systems up

    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_1
    # idPSP value check: idPSP not in db [SEM_SPO_01]
    Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idPSP with 1230984759 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PSP_SCONOSCIUTO of sendPaymentOutcomeV2 response



    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_2
    # idPSP value check: idPSP with field ENABLED = N [SEM_SPO_02]
    Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idPSP with NOT_ENABLED in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PSP_DISABILITATO of sendPaymentOutcomeV2 response



    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_3
    # idBrokerPSP value check: idBrokerPSP not present in db [SEM_SPO_03]
    Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idBrokerPSP with 1230984759 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of sendPaymentOutcomeV2 response



    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_4
    # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_SPO_04]
    Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idBrokerPSP with INT_NOT_ENABLED in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of sendPaymentOutcomeV2 response




    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_5
    # idChannel value check: idChannel not in db [SEM_SPO_05]
    Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idChannel with 1230984759 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_CANALE_SCONOSCIUTO of sendPaymentOutcomeV2 response



    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_6
    # idChannel value check: idChannel with field ENABLED = N [SEM_SPO_06]
    Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idChannel with CANALE_NOT_ENABLED in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_CANALE_DISABILITATO of sendPaymentOutcomeV2 response




    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_7
    # password value check: wrong password for an idChannel [SEM_SPO_08]
    Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And password with password in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTENTICAZIONE of sendPaymentOutcomeV2 response




    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_8
    # SEM_SPO_09
    Scenario: SEM_SPO_09
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And paymentToken with 111111111111112 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response





    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_9
    # paymentToken value check: token+idPsp not present in POSITION_ACTIVATE table of nodo-dei-pagamenti db [SEM_SPO_10]
    Scenario: Check PPT_TOKEN_SCONOSCIUTO error on non-existent couple token+idPsp
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And paymentToken with 7ff1180be4814c4d909f123a943eeb27 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response





    @ALL @PRIMITIVE @NMU @NMU_SPOV2_SEM @NMU_SPOV2_SEM_10
    # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_SPO_11]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                     | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | 12345678901234567890123456789012 | OK      |
        And idBrokerPSP with 91000000001 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
        And check description is Configurazione intermediario-canale non corretta of sendPaymentOutcomeV2 response