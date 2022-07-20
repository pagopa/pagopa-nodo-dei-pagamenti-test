Feature: 18

    Scenario: 18
        Given payment generated with mock
        When browse the payment response url
        And login as registered user
        And select add payment method
        And select 3ds credit card
        And confirm payment
        And close the page
        And sleep 5 s
        Then check resultCode in METHOD_RESPONSE_3DS is 25