Feature: Pagamenti con onus guest
  Scenario: Pagamento con onus guest va a buon fine
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Entro con la mail
    And Seleziono carta di credito onus
    And Confermo pagamento
    Then Il pagamento viene effettuato con successo