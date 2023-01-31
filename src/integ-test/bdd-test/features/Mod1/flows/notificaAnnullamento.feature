Feature: notificaAnnullamento

    Background:
        Given systems up

    @bug
    Scenario: notificaAnnullamento
        When WISP sends REST GET notificaAnnullamento?idPagamento=a57f358b-4b57-4175-8af0-20f517e93db6 to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200