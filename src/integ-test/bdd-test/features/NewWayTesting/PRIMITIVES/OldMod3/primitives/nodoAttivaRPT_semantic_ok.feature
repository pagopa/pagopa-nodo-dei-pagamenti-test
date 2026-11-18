Feature: Semantic checks OK for nodoAttivaRPT 1408
  Background:
    Given systems up


  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMOK @OM3NDATRPTSEMOK_1
  # identificativoStazioneIntermediarioPA value check [ARPTSEM24]
  Scenario: Check response of nodo-dei-pagamenti for value importoSingoloVersamento [ARPTSEM16]
    Given from body with datatable vertical nodoAttivaRPT_full initial XML nodoAttivaRPT
      | idIntermediarioPSPPagamento    | #psp#                        |
      | idCanalePagamento              | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP              | #psp#                        |
      | identificativoIntermediarioPSP | #psp#                        |
      | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
      | password                       | #password#                   |
      | codiceContestoPagamento        | #ccp#                        |
      | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
      | CCPost                         | #ccPoste#                    |
      | CodStazPA                      | #cod_segr#                   |
      | AuxDigit                       | 0                            |
      | CodIUV                         | #iuv#                        |
      | importoSingoloVersamento       | 0.00                         |
    And importoSingoloVersamento with 0.00 in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoAttivaRPT response



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMOK @OM3NDATRPTSEMOK_2
  Scenario Outline: Check response OK of nodo-dei-pagamenti
    Given from body with datatable vertical nodoAttivaRPT_full initial XML nodoAttivaRPT
      | idIntermediarioPSPPagamento    | #psp#                        |
      | idCanalePagamento              | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP              | #psp#                        |
      | identificativoIntermediarioPSP | #psp#                        |
      | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
      | password                       | #password#                   |
      | codiceContestoPagamento        | #ccp#                        |
      | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
      | CCPost                         | #ccPoste#                    |
      | CodStazPA                      | #cod_segr#                   |
      | AuxDigit                       | 0                            |
      | CodIUV                         | #iuv#                        |
      | importoSingoloVersamento       | 0.00                         |
    And <elem> with <value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoAttivaRPT response
    Examples:
      | elem         | value                       | SoapUI    |
      | ibanAppoggio | IT96R0123459921000000012345 | ARPTSEM17 |
      | bicAppoggio  | CCRTIT5TXXX                 | ARPTSEM18 |
      | ibanAddebito | IT96R0123454321000000012346 | ARPTSEM19 |
      | bicAddebito  | CCRTIT2TXXX                 | ARPTSEM20 |