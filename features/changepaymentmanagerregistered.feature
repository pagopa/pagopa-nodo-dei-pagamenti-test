Feature: Change payment manager registred
    Scenario: Check that modify payment manager is available for registred users
        Given Payment generated with mock
        When Browse the payment response url
        And Login as registered user
        And Select a card from the list
        Then check change payment manager