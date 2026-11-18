Feature: Semantic checks KO for nodoAttivaRPT 1405
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_2
    Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on identificativoIntermediarioPA not in configuration
        Given from body with datatable vertical nodoAttivaRPT_full initial XML nodoAttivaRPT
            | idIntermediarioPSPPagamento    | #psp#                        |
            | idCanalePagamento              | #canale_ATTIVATO_PRESSO_PSP# |
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | password                       | #password#                   |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
            | CCPost                         | #ccPoste#                    |
            | CodStazPA                      | 02                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 018361937127600              |
            | importoSingoloVersamento       | 4.00                         |
        And from body with datatable horizontal paaAttivaRPT_KO_irrag initial XML paaAttivaRPT
            | faultCode               | faultString | id                              | description | esito |
            | PAA_FIRMA_INDISPONIBILE | gbyiua      | #creditor_institution_code_old# | dfstf       | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoAttivaRPT response