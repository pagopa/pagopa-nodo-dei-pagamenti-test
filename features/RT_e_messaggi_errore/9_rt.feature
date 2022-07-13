Feature: 9_rt

    Scenario: 9
        Given payment generated with mock
        When browse the payment response url
        And login as registered user
        And select testCart20 credit card
        And confirm payment
        Then 