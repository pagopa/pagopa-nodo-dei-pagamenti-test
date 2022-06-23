Feature: Change payment manager amex registred
    Scenario: Check that modify payment manager is not available with amex for a registred user
        Given Payment generated with mock
        When Browse the payment response url
        And Login as registered user
        And Select add Payment method

        Then sleep 1000 s