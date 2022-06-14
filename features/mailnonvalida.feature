Feature: mail non valida
  Scenario: errore con mail non valida.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Entro con la mail non valida
    Then check messaggio mail non valida
    And chiudi il browser