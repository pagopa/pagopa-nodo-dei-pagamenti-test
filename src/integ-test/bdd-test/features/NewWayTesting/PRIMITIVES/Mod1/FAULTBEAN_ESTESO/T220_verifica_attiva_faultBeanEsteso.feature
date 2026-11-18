Feature: T220_verifica_attiva_faultBeanEsteso 214

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1FBENST @MOD1FBENST_1 @after
    Scenario: Execute nodoVerificaRPT with FAULT_BEAN_ESTESO = 'Y'
        Given update for table INTERMEDIARI_PSP with parameter FAULT_BEAN_ESTESO = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | OBJ_ID     | 16646        |
        And waiting after triggered refresh job ALL
        And from body with datatable vertical nodoVerificaRPT_complete initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | #ccp#                        |
            | codificaInfrastrutturaPSP      | QR-CODE                      |
            | CF                             | #creditor_institution_code#  |
            | CodStazPA                      | 02                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | #iuv#                        |
        And from body with datatable vertical paaVerificaRPT_KO_complete initial XML paaVerificaRPT
            | faultCode   | PPT_ERRORE_EMESSO_DA_PAA        |
            | faultString | Errore restituito dalla PAA     |
            | esito       | KO                              |
            | id          | #creditor_institution_code_old# |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoVerificaRPT response
        And check originalFaultCode field exists in nodoVerificaRPT response
        And replace wrongFaultCode content with PAA_SOAPACTION content
        And check value $nodoVerificaRPTResponse.originalFaultCode is not equal to value $wrongFaultCode
        Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                                    |
            | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP#             |
            | codiceContestoPagamento                 | $nodoVerificaRPT.codiceContestoPagamento |
            | identificativoPSP                       | #psp#                                    |
            | identificativoIntermediarioPSP          | #psp#                                    |
            | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP#             |
            | password                                | #password#                               |
            | CCPost                                  | #creditor_institution_code#              |
            | CodStazPA                               | 02                                       |
            | AuxDigit                                | 0                                        |
            | CodIUV                                  | #iuv#                                    |
            | importoSingoloVersamento                | 10.00                                    |
        And from body with datatable vertical paaAttivaRPT_KO initial XML paaAttivaRPT
            | esito       | KO                               |
            | faultCode   | PAA_SEMANTICA_EXTRAXSD           |
            | faultString | errore semantico PA              |
            | id          | #creditor_institution_code#      |
            | description | Errore semantico emesso dalla PA |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoAttivaRPT response
        And check originalFaultCode field exists in nodoAttivaRPT response
        And check id is #creditor_institution_code# of nodoAttivaRPT response




