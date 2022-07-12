Feature: 17

    Scenario: 17
        Given payment generated with mock
        When browse the payment response url
        And login as registered user
        And select add payment method
        And select 3ds credit card
        And sleep 60 s
        And confirm payment
