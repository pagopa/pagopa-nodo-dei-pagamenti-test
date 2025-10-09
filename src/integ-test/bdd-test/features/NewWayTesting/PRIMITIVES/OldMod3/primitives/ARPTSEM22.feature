Feature: Semantic checks KO for nodoAttivaRPT 1404
  Background:
    Given systems up


  @ALL @PRIMITIVE @OM3 @OM3NDATRPTKO @OM3NDATRPTKO_1
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error
    Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
      | identificativoIntermediarioPSPPagamento | #psp#                        |
      | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP                       | #psp#                        |
      | identificativoIntermediarioPSP          | #psp#                        |
      | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP# |
      | password                                | #password#                   |
      | codiceContestoPagamento                 | CCD01                        |
      | codificaInfrastrutturaPSP               | QR-CODE                      |
      | CCPost                                  | 11223344551                  |
      | CodStazPA                               | 01                           |
      | AuxDigit                                | 0                            |
      | CodIUV                                  | 015701081153300              |
      | importoSingoloVersamento                | 4.00                         |
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoAttivaRPT response