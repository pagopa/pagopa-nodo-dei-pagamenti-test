Feature: Syntax checks ok for nodoAttivaRPT 1410
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMOK @OM3NDATRPTSEMOK_1
    Scenario Outline: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on identificativoIntermediarioPA not in configuration
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
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 010231780177500              |
            | importoSingoloVersamento       | 10.00                        |
        And <elem> with <value> in nodoAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        Examples:
            | elem                     | value                       | SoapUI    |
            | importoSingoloVersamento | 0.00                        | ARPTSIN37 |
            | ibanAppoggio             | XX96R0123454321000000012345 | ARPTSIN43 |