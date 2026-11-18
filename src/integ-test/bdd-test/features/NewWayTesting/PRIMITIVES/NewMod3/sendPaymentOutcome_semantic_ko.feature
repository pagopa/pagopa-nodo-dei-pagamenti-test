Feature: Semantic checks for sendPaymentOutcome - KO 1389

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3SPOSEMKO @NM3SPOSEMKO_2
  Scenario Outline: Semantic checks for sendPaymentOutcome - KO
    Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                     | outcome |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | 12345678901234567890123456789012 | OK      |
    And <elem> with <value> in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is <faultCode> of sendPaymentOutcome response
    And check description is <description> of sendPaymentOutcome response
    Examples:
      | elem         | value              | faultCode                          | description                                          | soapUI test |
      | idPSP        | pspUnknown         | PPT_PSP_SCONOSCIUTO                | PSP sconosciuto.                                     | SEM_SPO_01  |
      | idPSP        | NOT_ENABLED        | PPT_PSP_DISABILITATO               | PSP conosciuto ma disabilitato da configurazione.    | SEM_SPO_02  |
      | idBrokerPSP  | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | Identificativo intermediario psp sconosciuto.        | SEM_SPO_03  |
      | idBrokerPSP  | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | Intermediario psp disabilitato.                      | SEM_SPO_04  |
      | idChannel    | channelUnknown     | PPT_CANALE_SCONOSCIUTO             | Canale sconosciuto.                                  | SEM_SPO_05  |
      | idChannel    | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | Canale conosciuto ma disabilitato da configurazione. | SEM_SPO_06  |
      | password     | password           | PPT_AUTENTICAZIONE                 | Password sconosciuta o errata                        | SEM_SPO_07  |
      | paymentToken | 111111111111111    | PPT_TOKEN_SCONOSCIUTO              | token unknown                                        | SEM_SPO_08  |
      | idBrokerPSP  | 91000000001        | PPT_AUTORIZZAZIONE                 | Configurazione intermediario-canale non corretta     | SEM_SPO_09  |


