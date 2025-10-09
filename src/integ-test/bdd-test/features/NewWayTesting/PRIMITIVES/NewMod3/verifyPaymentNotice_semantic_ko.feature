Feature: Semantic checks for verifyPaymentReq - KO 1400

  Background:
    Given systems up

  @ALL @PRIMITIVE @NM3 @NM3VPNSEMKO @NM3VPNSEMKO_1
  Scenario Outline: Semantic checks for verifyPaymentReq - KO
    Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber       |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302094719472095710 |
    And <elem> with <value> in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is <faultCode> of verifyPaymentNotice response
    And check description is <description> of verifyPaymentNotice response
    Examples:
      | elem         | value              | faultCode                           | description                                          | soapUI test |
      | idPSP        | pspUnknown         | PPT_PSP_SCONOSCIUTO                 | PSP sconosciuto.                                     | SEM_VPNR_01 |
      | idPSP        | NOT_ENABLED        | PPT_PSP_DISABILITATO                | PSP conosciuto ma disabilitato da configurazione.    | SEM_VPNR_02 |
      | idBrokerPSP  | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO   | Identificativo intermediario psp sconosciuto.        | SEM_VPNR_03 |
      | idBrokerPSP  | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO  | Intermediario psp disabilitato.                      | SEM_VPNR_04 |
      | idBrokerPSP  | 97735020584        | PPT_AUTORIZZAZIONE                  | Configurazione intermediario-canale non corretta     | SEM_VPNR_12 |
      | idChannel    | channelUnknown     | PPT_CANALE_SCONOSCIUTO              | Canale sconosciuto.                                  | SEM_VPNR_05 |
      | idChannel    | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO             | Canale conosciuto ma disabilitato da configurazione. | SEM_VPNR_06 |
      | idChannel    | #canale#           | PPT_AUTORIZZAZIONE                  | Il canale non è di tipo 'ATTIVATO_PRESSO_PSP'        | SEM_VPNR_07 |
      | fiscalCode   | 10000000000        | PPT_DOMINIO_SCONOSCIUTO             | Identificativo Dominio sconosciuto.                  | SEM_VPNR_09 |
      | fiscalCode   | 11111122223        | PPT_DOMINIO_DISABILITATO            | Dominio disabilitato.                                | SEM_VPNR_10 |
      | noticeNumber | 316456789012345478 | PPT_STAZIONE_INT_PA_DISABILITATA    | Stazione disabilitata.                               | SEM_VPNR_13 |
      | noticeNumber | 346456789012345478 | PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE | Errore di connessione verso la Stazione.             | SEM_VPNR_14 |
      | noticeNumber | 010456789012345678 | PPT_INTERMEDIARIO_PA_DISABILITATO   | Intermediario dominio disabilitato.                  | SEM_VPNR_15 |


  @ALL @PRIMITIVE @NM3 @NM3VPNSEMKO @NM3VPNSEMKO_2
  # password value check: wrong password for an idChannel [SEM_VPNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber       |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302094719472095710 |
    And idChannel with #canale_ATTIVATO_PRESSO_PSP# in verifyPaymentNotice
    And password with wrongPassword in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_AUTENTICAZIONE of verifyPaymentNotice response


  @ALL @PRIMITIVE @NM3 @NM3VPNSEMKO @NM3VPNSEMKO_3
  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VPNR_11]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber       |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302094719472095710 |
    And fiscalCode with 77777777777 in verifyPaymentNotice
    And noticeNumber with <value> in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of verifyPaymentNotice response
    Examples:
      | value              | soapUI test                                            |
      | 511456789012345678 | SEM_VPNR_11 - auxDigit inesistente                     |
      | 011456789012345678 | SEM_VPNR_11 - auxDigit 0 - progressivo inesistente     |
      | 316456789012345678 | SEM_VPNR_11 - auxDigit 3 - segregationCode inesistente |