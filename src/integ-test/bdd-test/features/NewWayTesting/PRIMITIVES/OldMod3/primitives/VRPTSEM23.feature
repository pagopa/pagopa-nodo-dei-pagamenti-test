Feature: Semantic checks KO for nodoVerificaRPT 1416
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDPAVERSEMKO @OM3NDPAVERSEMKO_2
    Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station[VRPTSEM23]
        Given from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                           |
            | identificativoIntermediarioPSP | #psp#                           |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP#    |
            | codiceContestoPagamento        | 153041492411187                 |
            | codificaInfrastrutturaPSP      | QR-CODE                         |
            | password                       | pwdpwdpwd                       |
            | CF                             | #creditor_institution_code_old# |
            | CodStazPA                      | 02                              |
            | AuxDigit                       | 0                               |
            | CodIUV                         | 013601115164900                 |
        And from body with datatable vertical paaVerificaRPT_KO_irrag initial XML paaVerificaRPT
            | faultCode   | PAA_SEMANTICA                   |
            | faultString | chiamata da rifiutare           |
            | id          | #creditor_institution_code_old# |
            | esito       | KO                              |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoVerificaRPT response