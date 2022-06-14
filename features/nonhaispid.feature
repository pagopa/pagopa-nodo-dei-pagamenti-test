Feature: Non hai spid
  Scenario: Corretto funzionamento di non hai spid.
    Given Pagamento generato tramite mock
    When Navigo l'url di risposta al pagamento
    And Seleziono non hai spid
    Then controlla bottone tua mail
    #da implementare
    And controlla assenza bottone cos
    And chiudi il browser
