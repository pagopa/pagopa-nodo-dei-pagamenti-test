Feature: Syntax checks KO for nodoAttivaRPT 1406
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NDATRPTSNTKO @OM3NDATRPTSNTKO_1
    Scenario: Check faultCode PPT_SINTASSI_EXTRAXSD error
        Given from body with datatable vertical nodoAttivaRPT_namespace_BC initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #psp#                        |
            | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP# |
            | identificativoPSP                       | #psp#                        |
            | identificativoIntermediarioPSP          | #psp#                        |
            | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP# |
            | password                                | #password#                   |
            | codiceContestoPagamento                 | #ccp#                        |
            | codificaInfrastrutturaPSP               | BARCODE-GS1-128              |
            | Gln                                     | #ccPoste#                    |
            | CodStazPA                               | 01                           |
            | AuxDigit                                | 3                            |
            | CodIUV                                  | 11332222222222222            |
            | importoSingoloVersamento                | 10.00                        |
        And bc:Gln with None in nodoAttivaRPT
        And bc:CodStazPA with None in nodoAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoAttivaRPT response


