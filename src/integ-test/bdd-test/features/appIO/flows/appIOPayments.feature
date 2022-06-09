Feature: Pagamenti AppIO

Background:
 Given systems up

 Scenario: Execute verifyPaymentNotice (Phase1)
    Given initial XML verifyPaymentNotice
    """"""
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

Scenario: Execute activateIOPayment (Phase 2)
    Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
    Given initial XML activateIOPayment
    """"""
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
    Given the Execute activateIOPayment (Phase 2) scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

Scenario: Execute nodoInoltraEsitoCarta (Phase 4)
    Given the Execute nodoChiediInformazioniPagamento (Phase 3)
    When WISP sends POST inoltroEsito/carta to nodo-dei-pagamenti
    """"""
    Then verify the HTTP status code of inoltroEsito/carta response is 200

Scenario:
    Given the Execute nodoInoltraEsitoCarta (Phase 4) scenario executes successfully
    And initial XML sendPaymentOutcome
    """"""
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

Scenario:

