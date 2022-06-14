Feature: apro sito
  Scenario: apertura sito per prove.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    #And Entro con la mail
    #And Seleziono carta di credito
    #And Confermo pagamento
    #Then Il pagamento viene effettuato con successo