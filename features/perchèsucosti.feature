Feature: perche su costi
  Scenario: perche su costi massimi.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Entro con la mail
    And Seleziono carta di credito
    #And click su perche costi
    Then check pop up costi
    Then chiudi il browser