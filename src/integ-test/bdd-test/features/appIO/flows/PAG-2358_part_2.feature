Feature: PAG-2358

    Background:
        Given systems up

    @bug
    Scenario: notificaAnnullamento
        When WISP sends REST GET notificaAnnullamento?idPagamento=09300f24-e18b-44dc-b111-42feaa5c29c2 to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200