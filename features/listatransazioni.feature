Feature: Lista transazioni
    Scenario: CDC Payments in Lista transazioni
         Given Payment generated with mock
        When Browse the payment response url
        And Login as registered user
        And Select transaction history
        Then Check previous transactions