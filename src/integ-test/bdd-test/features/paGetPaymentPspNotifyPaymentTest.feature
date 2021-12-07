Feature: verify test flow paGetPayment and pspNotifyPayment

  Background:
    Given systems up

  # Activate Phase
  Scenario: Execute activateIOPayment request
    When IO sends an activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is OK

  # Payment Phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the activate phase executed successfully
    When WISP/PM sends an informazioniPagamento to nodo-dei-pagamenti using the token of the activate phase
    Then verify the HTTP status code response is 200

  # Send payment to PSP Phase
  Scenario: Execute nodoInoltraEsitoPagamentoCarta request
    Given the payment phase executed successfully
    When WISP/PM sends an inoltroEsito/Carta to nodo-dei-pagamenti using the token and PSP/Canale data
    Then verify the HTTP status code response is 200
    And activeIOPaymentResp and pspNotifyPaymentReq are consistent
