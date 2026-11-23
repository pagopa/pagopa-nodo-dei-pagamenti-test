Feature: response tests for paDemandPaymentNotice 930

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM4 @NM4PADPNOK @NM4PADPNOK_1
    Scenario Outline: Check paDemandPaymentNotice response with missing optional fields
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_full initial XML paDemandPaymentNotice
            | outcome            | OK                          |
            | fiscalCode         | #creditor_institution_code# |
            | noticeNumber       | 302#iuv#                    |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | paymentDescription          |
            | fiscalCodPA        | #creditor_institution_code# |
            | companyName        | companyName                 |
            | officeName         | officeName                  |
        And <elem> with <value> in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
        Examples:
            | elem              | value | soapUI test  |
            | soapenv:Header    | None  | TRES_PDPN_01 |
            | dueDate           | None  | TRES_PDPN_39 |
            | detailDescription | None  | TRES_PDPN_42 |
            | officeName        | None  | TRES_PDPN_58 |


    @ALL @PRIMITIVE @NM4 @NM4PADPNOK @NM4PADPNOK_2
    # TRES_PDPN_02
    Scenario: TRES_PDPN_02
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_full initial XML paDemandPaymentNotice
            | outcome            | OK                          |
            | fiscalCode         | #creditor_institution_code# |
            | noticeNumber       | 302#iuv#                    |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | paymentDescription          |
            | fiscalCodPA        | #creditor_institution_code# |
            | companyName        | companyName                 |
            | officeName         | officeName                  |
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4PADPNKO @NM4PADPNKO_1
    Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_full initial XML paDemandPaymentNotice
            | outcome            | OK                          |
            | fiscalCode         | #creditor_institution_code# |
            | noticeNumber       | 302#iuv#                    |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | paymentDescription          |
            | fiscalCodPA        | #creditor_institution_code# |
            | companyName        | companyName                 |
            | officeName         | officeName                  |
        And <elem> with <value> in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response
        Examples:
            | elem                              | value                                                                                                                                           | soapUI test  |
            | soapenv:Body                      | None                                                                                                                                            | TRES_PDPN_03 |
            | soapenv:Body                      | Empty                                                                                                                                           | TRES_PDPN_04 |
            | paf:paDemandPaymentNoticeResponse | None                                                                                                                                            | TRES_PDPN_05 |
            | paf:paDemandPaymentNoticeResponse | RemoveParent                                                                                                                                    | TRES_PDPN_06 |
            | paf:paDemandPaymentNoticeResponse | Empty                                                                                                                                           | TRES_PDPN_07 |
            | outcome                           | None                                                                                                                                            | TRES_PDPN_08 |
            | outcome                           | Empty                                                                                                                                           | TRES_PDPN_09 |
            | outcome                           | PP                                                                                                                                              | TRES_PDPN_10 |
            | qrCode                            | None                                                                                                                                            | TRES_PDPN_12 |
            | qrCode                            | RemoveParent                                                                                                                                    | TRES_PDPN_13 |
            | qrCode                            | Empty                                                                                                                                           | TRES_PDPN_14 |
            | fiscalCode                        | None                                                                                                                                            | TRES_PDPN_15 |
            | fiscalCode                        | 1234567890                                                                                                                                      | TRES_PDPN_16 |
            | fiscalCode                        | 123456789012                                                                                                                                    | TRES_PDPN_17 |
            | fiscalCode                        | 1234567890a                                                                                                                                     | TRES_PDPN_18 |
            | noticeNumber                      | None                                                                                                                                            | TRES_PDPN_19 |
            | noticeNumber                      | 12345678901234567                                                                                                                               | TRES_PDPN_20 |
            | noticeNumber                      | 1234567890123456789                                                                                                                             | TRES_PDPN_21 |
            | noticeNumber                      | 12345678901234567a                                                                                                                              | TRES_PDPN_22 |
            | paymentList                       | None                                                                                                                                            | TRES_PDPN_23 |
            | paymentList                       | RemoveParent                                                                                                                                    | TRES_PDPN_24 |
            | paymentList                       | Empty                                                                                                                                           | TRES_PDPN_25 |
            | paymentOptionDescription          | None                                                                                                                                            | TRES_PDPN_27 |
            | paymentOptionDescription          | Empty                                                                                                                                           | TRES_PDPN_28 |
            | amount                            | None                                                                                                                                            | TRES_PDPN_30 |
            | amount                            | Empty                                                                                                                                           | TRES_PDPN_31 |
            | amount                            | 11,34                                                                                                                                           | TRES_PDPN_32 |
            | amount                            | 11.342                                                                                                                                          | TRES_PDPN_33 |
            | amount                            | 1219087657.34                                                                                                                                   | TRES_PDPN_34 |
            | amount                            | ciao                                                                                                                                            | TRES_PDPN_35 |
            | options                           | None                                                                                                                                            | TRES_PDPN_36 |
            | options                           | Empty                                                                                                                                           | TRES_PDPN_37 |
            | options                           | KK                                                                                                                                              | TRES_PDPN_38 |
            | dueDate                           | Empty                                                                                                                                           | TRES_PDPN_40 |
            | dueDate                           | 20220613                                                                                                                                        | TRES_PDPN_41 |
            | dueDate                           | 12-09-22                                                                                                                                        | TRES_PDPN_41 |
            | dueDate                           | 12-08-2022T12:00:678                                                                                                                            | TRES_PDPN_41 |
            | detailDescription                 | Empty                                                                                                                                           | TRES_PDPN_43 |
            | detailDescription                 | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_44 |
            | allCCP                            | None                                                                                                                                            | TRES_PDPN_45 |
            | allCCP                            | Empty                                                                                                                                           | TRES_PDPN_46 |
            | allCCP                            | 3                                                                                                                                               | TRES_PDPN_47 |
            | paymentDescription                | None                                                                                                                                            | TRES_PDPN_48 |
            | paymentDescription                | Empty                                                                                                                                           | TRES_PDPN_49 |
            | paymentDescription                | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_50 |
            | fiscalCodePA                      | None                                                                                                                                            | TRES_PDPN_51 |
            | fiscalCodePA                      | Empty                                                                                                                                           | TRES_PDPN_52 |
            | fiscalCodePA                      | 123456789012                                                                                                                                    | TRES_PDPN_53 |
            | fiscalCodePA                      | 12345jh%lk9                                                                                                                                     | TRES_PDPN_54 |
            | companyName                       | None                                                                                                                                            | TRES_PDPN_55 |
            | companyName                       | Empty                                                                                                                                           | TRES_PDPN_56 |
            | companyName                       | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_57 |
            | officeName                        | Empty                                                                                                                                           | TRES_PDPN_59 |
            | officeName                        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | TRES_PDPN_60 |


    @ALL @PRIMITIVE @NM4 @NM4PADPNKO @NM4PADPNKO_2
    # TRES_PDPN_11
    Scenario: TRES_PDPN_11
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_full initial XML paDemandPaymentNotice
            | outcome            | OK                          |
            | fiscalCode         | #creditor_institution_code# |
            | noticeNumber       | 302#iuv#                    |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | paymentDescription          |
            | fiscalCodPA        | #creditor_institution_code# |
            | companyName        | companyName                 |
            | officeName         | officeName                  |
        And outcome with KO in paDemandPaymentNotice
        And qrCode with None in paDemandPaymentNotice
        And paymentList with None in paDemandPaymentNotice
        And officeName with None in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4PADPNKO @NM4PADPNKO_3
    # TRES_PDPN_26
    Scenario: TRES_PDPN_11
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_2payments initial XML paDemandPaymentNotice
            | outcome      | OK                          |
            | fiscalCodePA | #creditor_institution_code# |
            | fiscalCode   | #creditor_institution_code# |
            | noticeNumber | 302#iuv#                    |
            | amount       | 10.00                       |
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4PADPNKO @NM4PADPNKO_4
    # TTRES_PDPN_29
    Scenario: TRES_PDPN_29
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_2paymentDesc initial XML paDemandPaymentNotice
            | outcome      | OK                          |
            | fiscalCodePA | #creditor_institution_code# |
            | fiscalCode   | #creditor_institution_code# |
            | noticeNumber | 302#iuv#                    |
            | amount       | 10.00                       |
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4PADPNKO @NM4PADPNKO_5 @after
    # TRES_PDPN_61
    Scenario: TRES_PDPN_61
        Given update for table INTERMEDIARI_PSP with parameter FAULT_BEAN_ESTESO = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys           | where_values |
            | ID_INTERMEDIARIO_PSP | #psp#        |
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_KO initial XML paDemandPaymentNotice
            | outcome     | KO                          |
            | faultCode   | PAA_SEMANTICA               |
            | faultString | chiamata da rifiutare       |
            | id          | #creditor_institution_code# |
            | description | chiamata da rifiutare       |
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of demandPaymentNotice response
        And check originalFaultCode field exists in demandPaymentNotice response
        And check originalFaultString field exists in demandPaymentNotice response
        And check originalDescription field exists in demandPaymentNotice response
        Given update for table INTERMEDIARI_PSP with parameter FAULT_BEAN_ESTESO = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys           | where_values |
            | ID_INTERMEDIARIO_PSP | #psp#        |
        And waiting after triggered refresh job ALL
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of demandPaymentNotice response
        And check originalFaultCode field not exists in demandPaymentNotice response
        And check originalFaultString field not exists in demandPaymentNotice response
        And check originalDescription field not exists in demandPaymentNotice response