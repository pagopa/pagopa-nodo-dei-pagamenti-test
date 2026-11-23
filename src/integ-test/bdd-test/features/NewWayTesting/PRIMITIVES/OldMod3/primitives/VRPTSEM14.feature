Feature: Semantic checks KO for nodoVerificaRPT 1415
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERSEMKO @OM3NDPAVERSEMKO_1
    Scenario: Check faultCode error PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE [VRPTSEM14]
        Given from body with datatable vertical nodoVerificaRPT_namespace_aim_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | irraggiungibile              |
            | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
            | password                       | pwdpwdpwd                    |
            | CCPost                         | #ccPoste#                    |
            | CodStazPA                      | 02                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 016101258167700              |
        And from body with datatable vertical paaVerificaRPT_KO_irrag initial XML paaVerificaRPT
            | faultCode   | PAA_SEMANTICA         |
            | faultString | chiamata da rifiutare |
            | esito       | KO                    |
        And id with #creditor_institution_code_old# in paaVerificaRPT
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoVerificaRPT response