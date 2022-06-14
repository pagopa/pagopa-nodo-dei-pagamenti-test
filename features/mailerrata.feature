Feature: mail errata
  Scenario: errore con mail errata.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Entro con la mail errata
    Then check messaggio mail errata
    And chiudi il browser



    #And Seleziono carta di credito
    #And Confermo pagamento
    #Then Il pagamento viene effettuato con successo