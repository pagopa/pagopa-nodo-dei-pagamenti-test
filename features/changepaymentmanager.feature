Feature: Change payment manager
    Scenario: Check that modify payment manager is available
        Given Payment generated with mock
        When Browse the payment response url
        And Enter with the mail
        And Select credit card
        Then check change payment manager