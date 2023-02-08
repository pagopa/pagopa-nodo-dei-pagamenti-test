Feature: PAG-2358 anomalia 2 part 2

    Background:
        Given systems up

    @bug
    Scenario: notificaAnnullamento
        When WISP sends REST GET notificaAnnullamento?idPagamento=3a7e243b-5de7-4ece-8a86-fb0e6a8fbcf9 to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200