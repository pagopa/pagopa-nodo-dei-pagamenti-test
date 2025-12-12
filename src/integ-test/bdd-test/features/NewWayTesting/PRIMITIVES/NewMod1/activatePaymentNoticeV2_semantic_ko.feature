Feature: semantic checks KO for activatePaymentNoticeV2Request 955

    Background:
        Given systems up

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_1 @PG34
    # [SEM_APNV2_01]
    Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idPSP with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PSP_SCONOSCIUTO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_2 @PG34
    # [SEM_APNV2_02]
    Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idPSP with NOT_ENABLED in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PSP_DISABILITATO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_3 @PG34
    # [SEM_APNV2_03]
    Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idBrokerPSP with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_4 @PG34
    # [SEM_APNV2_04]
    Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idBrokerPSP with INT_NOT_ENABLED in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_5 @PG34
    # [SEM_APNV2_05]
    Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idChannel with 1230984759 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_CANALE_SCONOSCIUTO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_6 @PG34
    # [SEM_APNV2_06]
    Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idChannel with CANALE_NOT_ENABLED in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_CANALE_DISABILITATO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_7 @PG34
    # [SEM_APNV2_07]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idChannel with 60000000001_03 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_8 @PG34
    # [SEM_APNV2_08]
    Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And password with pippo123 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_9 @PG34
    # [SEM_APNV2_09]
    Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And fiscalCode with 12309847591 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_DOMINIO_SCONOSCIUTO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_10 @PG34
    # [SEM_APNV2_10]
    Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And fiscalCode with 11111122222 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_DOMINIO_DISABILITATO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_11 @PG34
    # [SEM_APNV2_11]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And idBrokerPSP with 50000000001 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNoticeV2 response
        And check description is Configurazione intermediario-canale non corretta of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_12 @PG34
    # [SEM_APNV2_12]
    Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And noticeNumber with <value> in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activatePaymentNoticeV2 response
        Examples:
            | value              | soapUI test         |
            | 511456789012345678 | SEM_APNV2_12 - aux5 |
            | 011456789012345678 | SEM_APNV2_12 - aux0 |
            | 300456789012345678 | SEM_APNV2_12 - aux3 |

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_13 @PG34
    # [SEM_APNV2_13]
    Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And noticeNumber with 006456789012345478 in activatePaymentNoticeV2
        And fiscalCode with 77777777777 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_14 @PG34
    # [SEM_APNV2_14]
    Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And fiscalCode with 00000000000 in activatePaymentNoticeV2
        And noticeNumber with 443456789012345678 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_15 @PG34
    # [SEM_APNV2_15]
    Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And fiscalCode with 55555555555 in activatePaymentNoticeV2
        And noticeNumber with 088456789012345678 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of activatePaymentNoticeV2 response

    @ALL @PRIMITIVE @NMU @NMU_ACTV2_SEM_KO @NMU_ACTV2_SEM_KO_16 @PG34 @after
    # [SEM_APNV2_25]
    Scenario: Check PPT_AUTORIZZAZIONE error if expirationTime > default_token_duration_validity_millis
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
        And update for table CONFIGURATION_KEYS with parameter config_value = 15000 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values            |
            | CONFIG_KEY | default_durata_token_IO |
        And update for table CONFIGURATION_KEYS with parameter config_value = 7000 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                           |
            | CONFIG_KEY | default_token_duration_validity_millis |
        And waiting after triggered refresh job ALL
        And expirationTime with 10000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNoticeV2 response