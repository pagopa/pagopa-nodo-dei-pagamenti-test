Feature: Syntax checks for sendPaymentOutcome - OK 1393

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3SPOSNTOK @M3SPOSNTOK_1
  # [SIN_SPO_00]
  Scenario: Check sendPaymentOutcome response with mandatory fields
    Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal sendPaymentOutcomeBody_idempotency_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
    And idempotencyKey with None in sendPaymentOutcome
    And paymentChannel with None in sendPaymentOutcome
    And payer with None in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response


  @ALL @PRIMITIVE @NM3 @NM3SPOSNTOK @M3SPOSNTOK_2
  # element value check
  Scenario Outline: Check sendPaymentOutcome response with missing optional fields
    Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal sendPaymentOutcomeBody_idempotency_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
    And <elem> with <value> in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    Examples:
      | elem                | value       | soapUI test |
      | paymentMethod       | cash        | SIN_SPO_25  |
      | paymentMethod       | creditCard  | SIN_SPO_25  |
      | paymentMethod       | bancomat    | SIN_SPO_25  |
      | paymentMethod       | other       | SIN_SPO_25  |
      | paymentChannel      | None        | SIN_SPO_26  |
      | paymentChannel      | frontOffice | SIN_SPO_28  |
      | paymentChannel      | atm         | SIN_SPO_28  |
      | paymentChannel      | onLine      | SIN_SPO_28  |
      | paymentChannel      | other       | SIN_SPO_28  |
      | payer               | None        | SIN_SPO_35  |
      | streetName          | None        | SIN_SPO_51  |
      | civicNumber         | None        | SIN_SPO_54  |
      | postalCode          | None        | SIN_SPO_57  |
      | city                | None        | SIN_SPO_60  |
      | stateProvinceRegion | None        | SIN_SPO_63  |
      | country             | None        | SIN_SPO_66  |
      | e-mail              | None        | SIN_SPO_70  |
      | idempotencyKey      | None        | SIN_SPO_80  |


  @ALL @PRIMITIVE @NM3 @NM3SPOSNTOK @M3SPOSNTOK_3
  Scenario: SPO with alphanumeric idempotency key
    Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | idempotencyKey          | amount | expirationTime |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | #alpha_idempotency_key# | 10.00  | 120000         |
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal sendPaymentOutcomeBody_idempotency_full initial XML sendPaymentOutcome
      | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey                        |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | $activatePaymentNotice.idempotencyKey |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response