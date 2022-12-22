Feature: prova

    Background:
        Given systems up

    Scenario: prova
        When job mod3CancelV1 triggered after 0 seconds
        And job mod3CancelV2 triggered after 10 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        And verify the HTTP status code of mod3CancelV2 response is 200
        And refresh job PSP triggered after 10 seconds
        And refresh job PA triggered after 10 seconds