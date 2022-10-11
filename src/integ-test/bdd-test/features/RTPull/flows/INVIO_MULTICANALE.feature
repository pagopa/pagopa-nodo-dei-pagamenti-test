Feature: INVIO_MULTICANALE

    Background:
        Given systems up

    Scenario: Parallel nodoInviaRPT
        Given RPT1 generation
        And RT1 generation
        And RPT2 generation
        And RT2 generation
        And initial XML nodoInviaRPT
        And initial XML nodoInviaRPT2
        