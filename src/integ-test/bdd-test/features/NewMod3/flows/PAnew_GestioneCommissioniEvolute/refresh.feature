Feature: refresh

    Background:
        Given wait 0 seconds for expiration

    Scenario: refresh
        Given wait 0 seconds for expiration
        When job refreshConfiguration triggered after 0 seconds
        Then verify the HTTP status code of refreshConfiguration response is 200