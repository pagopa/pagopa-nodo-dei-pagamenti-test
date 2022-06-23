Feature: Change payment manager amex
    Scenario: Check that modify payment manager is not available with amex
        Given Payment generated with mock
        When Browse the payment response url
        And Enter with the mail
        And Select credit card amex
        Then check not change payment manager