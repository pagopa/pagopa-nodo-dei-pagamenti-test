Feature: PAG-2358 anomalia 2

    Background:
        Given systems up

    @bug
    Scenario: notificaAnnullamento
        When WISP sends REST GET notificaAnnullamento?idPagamento=b01d53bb-9901-4e33-9315-6bdd48cea13c to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200