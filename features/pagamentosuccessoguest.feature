Feature: Pagamenti su wisp come guest
  Scenario: Pagamento su wisp va a buon fine come guest.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Entro con la mail
    And Seleziono carta di credito
    And Confermo pagamento
    Then Il pagamento viene effettuato con successo