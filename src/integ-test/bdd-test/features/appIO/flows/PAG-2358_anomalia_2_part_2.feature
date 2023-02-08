Feature: PAG-2358 anomalia 2 part 2

    Background:
        Given systems up

    @bug
    Scenario: notificaAnnullamento
        When WISP sends REST GET notificaAnnullamento?idPagamento=a1cc2bbd-4231-4a1b-803c-3aba6b2a582d to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200