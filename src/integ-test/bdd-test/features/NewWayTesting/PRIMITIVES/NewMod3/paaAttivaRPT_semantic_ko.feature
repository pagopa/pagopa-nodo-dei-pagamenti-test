Feature: process check for activatePaymentNotice - KO 1376


  Background:
    Given systems up

  @ALL @PRIMITIVE @NM3 @NM3PAARPTSEMKO @NM3PAARPTSEMKO_1
  Scenario Outline: semantic check on paaAttivaRPTRes
    # MODIFICARE IL TIPO DI RISPOSTA (https://pagopa.atlassian.net/wiki/spaces/PAG/pages/493617751/Analisi+paaAttivaRPT)
    Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
      | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
      | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 4000           |
    And from body with datatable vertical paaAttivaRPT_complete initial XML paaAttivaRPT
      | esito                       | OK           |
      | importoSingoloVersamento    | 2.00         |
      | codiceIdentificativoUnivoco | ${stz}       |
      | denominazioneBeneficiario   | ${intermPsp} |
      | codiceUnitOperBeneficiario  | ${can}       |
    And <elem> with <value> in paaAttivaRPT
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_IBAN_NON_CENSITO of activatePaymentNotice response
    Examples:
      | elem          | value                       | soapUI test   |
      | ibanAccredito | IT40R0000000000000000300009 | SEM_PARPTR_01 |