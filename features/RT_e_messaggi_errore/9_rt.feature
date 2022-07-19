Feature: 9_rt

    Scenario: 9
        Given payment generated with mock
        When browse the payment response url
        And login as registered user
        And select add payment method
        And select cartaTest20 credit card
        And confirm payment
        Then Operazione rifiutata is displayed