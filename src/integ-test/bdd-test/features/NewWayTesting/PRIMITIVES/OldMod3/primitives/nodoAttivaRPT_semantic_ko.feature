Feature: Semantic checks KO for nodoAttivaRPT 1407
  Background:
    Given systems up


  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_2
  Scenario Outline: Semantic checks KO for nodoAttivaRPT
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
      | importoSingoloVersamento       | 10.00                        |
    And <elem> with <value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is <faultCode> of nodoAttivaRPT response
    Examples:
      | elem                                    | value              | faultCode                          | soapUI test |
      | identificativoPSP                       | pspUnknown         | PPT_PSP_SCONOSCIUTO                | ARPTSEM1    |
      | identificativoPSP                       | NOT_ENABLED        | PPT_PSP_DISABILITATO               | ARPTSEM2    |
      | identificativoIntermediarioPSP          | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | ARPTSEM3    |
      | identificativoIntermediarioPSP          | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | ARPTSEM4    |
      | identificativoCanale                    | channelUnknown     | PPT_CANALE_SCONOSCIUTO             | ARPTSEM5    |
      | identificativoCanale                    | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | ARPTSEM6    |
      | identificativoCanale                    | #canale#           | PPT_AUTORIZZAZIONE                 | ARPTSEM28   |
      | password                                | wrongPassword      | PPT_AUTENTICAZIONE                 | ARPTSEM7    |
      | identificativoIntermediarioPSPPagamento | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | ARPTSEM8    |
      | identificativoIntermediarioPSPPagamento | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | ARPTSEM9    |
      | identificativoCanalePagamento           | channelUnknown     | PPT_CANALE_SCONOSCIUTO             | ARPTSEM10   |
      | identificativoCanalePagamento           | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | ARPTSEM11   |
      | codificaInfrastrutturaPSP               | infrastrutturaPSP  | PPT_CODIFICA_PSP_SCONOSCIUTA       | ARPTSEM12   |
      | aim:CCPost                              | 712377777777       | PPT_DOMINIO_SCONOSCIUTO            | ARPTSEM26   |



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_3
  # IUV value check: IUV dimension check
  Scenario Outline: Check PPT_SEMANTICA error on wrong IUV dimension
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
      | importoSingoloVersamento       | 10.00                        |
    And <elem> with <value> in nodoAttivaRPT
    And <tag> with <tag_value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response
    Examples:
      | elem         | value | tag        | tag_value         | SoapUI    |
      | aim:AuxDigit | 0     | aim:CodIUV | 12312541281233210 | ARPTSEM13 |
      | aim:AuxDigit | 2     | aim:CodIUV | 123455412812332   | ARPTSEM14 |



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_4
  # codiceIdRPT value check: segregation code check
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on segregation code not in configuration or disabled
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
      | importoSingoloVersamento       | 10.00                        |
    And <elem1> with <value1> in nodoAttivaRPT
    And <elem2> with <value2> in nodoAttivaRPT
    And <elem3> with <value3> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is <faultCode> of nodoAttivaRPT response
    Examples:
      | elem1        | value1 | elem2         | value2 | elem3      | value3            | faultCode                        | SoapUI    |
      | aim:AuxDigit | 3      | aim:CodStazPA | None   | aim:CodIUV | 00017241417113000 | PPT_STAZIONE_INT_PA_SCONOSCIUTA  | ARPTSEM15 |
      | aim:AuxDigit | 3      | aim:CodStazPA | None   | aim:CodIUV | 16017241417113000 | PPT_STAZIONE_INT_PA_DISABILITATA | ARPTSEM25 |



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_5
  # importoSingoloVersamento KO value check  [ARPTSEM16]
  Scenario: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on importoSingoloVersamento not in configuration
    Given from body with datatable vertical nodoAttivaRPT_full initial XML nodoAttivaRPT
      | idIntermediarioPSPPagamento    | #psp#                        |
      | idCanalePagamento              | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP              | #psp#                        |
      | identificativoIntermediarioPSP | #psp#                        |
      | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
      | password                       | pwdpwdpwd                    |
      | codiceContestoPagamento        | #ccp#                        |
      | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
      | CCPost                         | #ccPoste#                    |
      | CodStazPA                      | #cod_segr#                   |
      | AuxDigit                       | 0                            |
      | CodIUV                         | #iuv#                        |
      | importoSingoloVersamento       | 0.00                         |
    And from body with datatable horizontal paaAttivaRPT_KO_serial initial XML paaAttivaRPT
      | faultCode               | faultString | id                          | description | serial | esito |
      | PAA_FIRMA_INDISPONIBILE | gbyiua      | #creditor_institution_code# | dfstf       | 1      | KO    |
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of nodoAttivaRPT response



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_6
  # identificativoStazioneIntermediarioPA value check [ARPTSEM24]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on identificativoStazioneIntermediarioPA not in configuration
    Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
      | identificativoIntermediarioPSPPagamento | #psp#                           |
      | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP#    |
      | identificativoPSP                       | #psp#                           |
      | identificativoIntermediarioPSP          | #psp#                           |
      | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP#    |
      | password                                | #password#                      |
      | codiceContestoPagamento                 | CCD01                           |
      | codificaInfrastrutturaPSP               | QR-CODE                         |
      | CCPost                                  | #creditor_institution_code_old# |
      | CodStazPA                               | 77                              |
      | AuxDigit                                | 0                               |
      | CodIUV                                  | 010551696163500                 |
      | importoSingoloVersamento                | 10.00                           |
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoAttivaRPT response



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_7
  # identificativoDominio value check: identificativoDominio disabled [ARPTSEM27]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on identificativoDominio disabled
    Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
      | identificativoIntermediarioPSPPagamento | #psp#                        |
      | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP                       | #psp#                        |
      | identificativoIntermediarioPSP          | #psp#                        |
      | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP# |
      | password                                | #password#                   |
      | codiceContestoPagamento                 | CCD01                        |
      | codificaInfrastrutturaPSP               | QR-CODE                      |
      | CCPost                                  | 11111122222                  |
      | CodStazPA                               | 02                           |
      | AuxDigit                                | 0                            |
      | CodIUV                                  | 011311555197400              |
      | importoSingoloVersamento                | 10.00                        |
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoAttivaRPT response



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_8
  # Check PPT_SEMANTICA error [ARPTSEM29]
  Scenario Outline: Check PPT_SEMANTICA error on wrong noticeNumber
    Given from body with datatable vertical nodoAttivaRPT_namespace_BC initial XML nodoAttivaRPT
      | identificativoIntermediarioPSPPagamento | #psp#                        |
      | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP                       | #psp#                        |
      | identificativoIntermediarioPSP          | #psp#                        |
      | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP# |
      | password                                | pwdpwdpwd                    |
      | codiceContestoPagamento                 | CCD01                        |
      | codificaInfrastrutturaPSP               | BARCODE-GS1-128              |
      | Gln                                     | 9000000000111                |
      | AuxDigit                                | 2                            |
      | CodStazPA                               | 01                           |
      | CodIUV                                  | 123456789012345              |
      | importoSingoloVersamento                | 10.00                        |
    And <elem> with <value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response
    Examples:
      | elem         | value | SoapUI Test |
      | bc:CodStazPA | None  | ARPTSEM29   |



  @ALL @PRIMITIVE @OM3 @OM3NDATRPTSEMKO @OM3NDATRPTSEMKO_9
  # Check PPT_SEMANTICA error [ARPTSEM30]
  Scenario Outline: Check PPT_SEMANTICA error on wrong noticeNumber
    Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
      | identificativoIntermediarioPSPPagamento | #psp#                        |
      | identificativoCanalePagamento           | #canale_ATTIVATO_PRESSO_PSP# |
      | identificativoPSP                       | #psp#                        |
      | identificativoIntermediarioPSP          | #psp#                        |
      | identificativoCanale                    | #canale_ATTIVATO_PRESSO_PSP# |
      | password                                | #password#                   |
      | codiceContestoPagamento                 | CCD01                        |
      | codificaInfrastrutturaPSP               | QR-CODE                      |
      | CCPost                                  | 44444444444                  |
      | CodStazPA                               | #cod_segr#                   |
      | AuxDigit                                | 0                            |
      | CodIUV                                  | 018251821137900              |
      | importoSingoloVersamento                | 10.00                        |
    And <elem> with <value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response
    Examples:
      | elem          | value | SoapUI Test |
      | qrc:CodStazPA | None  | ARPTSEM30   |