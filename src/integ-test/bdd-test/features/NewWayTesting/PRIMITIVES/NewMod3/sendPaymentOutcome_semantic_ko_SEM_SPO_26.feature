Feature: Semantic checks for sendPaymentOutcome - KO - SEM_SPO_26 1390

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3SPOSEMKO @NM3SPOSEMKO_1
  Scenario: Semantic checks for sendPaymentOutcome - KO
    Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel | password   | paymentToken                                | outcome |
      | #psp# | #psp#       | #canale#  | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
    And fee with 2.22 in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel | password   | paymentToken                                | outcome |
      | #psp# | #psp#       | #canale#  | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
    And paymentMethod with cash in sendPaymentOutcome
    And paymentChannel with onLine in sendPaymentOutcome
    And fee with 3.00 in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And check description contains Esito discorde of sendPaymentOutcome response

