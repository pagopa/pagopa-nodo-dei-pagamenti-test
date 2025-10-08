Feature: Semantic checks for sendPaymentOutcomeReq - OK [SEM_SPO_07] 1391

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3SPOSEMOK @NM3SPOSEMOK_1
  Scenario: Semantic checks for sendPaymentOutcomeReq - OK
    Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 6000           |
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel | password   | paymentToken                                | outcome |
      | #psp# | #psp#       | #canale#  | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
