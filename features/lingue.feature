Feature: Non hai spid

  Background:
    Given Pagamento generato tramite mock

  Scenario Outline: Corretto funzionamento delle lingue.
    When Navigo l'url di risposta al pagamento
    And seleziono lingua <lang>
    Then controllo il testo in <lang>
        #da implementare
        #And chiudi il browser


    Examples:
    |lang|
    |en  |
    |sl  |
    |fr  |
    |de  |
