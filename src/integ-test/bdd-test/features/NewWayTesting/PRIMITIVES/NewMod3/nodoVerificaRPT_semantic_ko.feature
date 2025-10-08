Feature: Checks for EC new and nodoVerificaRPT 1375

  Background:
    Given systems up


  @ALL @PRIMITIVE @NM3 @NM3NODRPTSEMKO @NM3NODRPTSEMKO_1
  # check PPT_MULTI_BENEFICIARIO error - PRO_VPNR_04
  Scenario: Check PPT_MULTI_BENEFICIARIO error
    Given from body with datatable vertical nodoVerificaRPT_full initial XML nodoVerificaRPT
      | identificativoPSP              | #psp#                        |
      | identificativoIntermediarioPSP | #psp#                        |
      | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
      | codiceContestoPagamento        | 120671877019565              |
      | CF                             | #creditor_institution_code#  |
    When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoVerificaRPT response
    And check faultCode is PPT_MULTI_BENEFICIARIO of nodoVerificaRPT response