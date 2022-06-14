Feature: mail tua
  Scenario: atterraggio pagina privacy quando inserisci tua mail.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Entro con la mail tua
    Then check atterraggio pagina privacy
    And chiudi il browser