Feature: Change payment manager favorite
    Scenario: Check that modify payment manager is available for registered users with favorite card
        Given Payment generated with mock
        When Browse the payment response url
        And Login as registered user
        And Select favorite card from the list
        Then check change payment manager