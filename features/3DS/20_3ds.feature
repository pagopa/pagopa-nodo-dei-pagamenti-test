Feature: 20

    Scenario: 20
        Given db opened connection
        Given payment generated with mock
        When browse the payment response url
        And login as registered user
        And select add payment method
        And select 3ds credit card
        And confirm payment
        And insert OTP
        And close the page
        And sleep 10 s
        Then check resultCode in METHOD_RESPONSE_3DS is 25
        And check resultCode in CHALLENGE_RESPONSE_3DS is 26
        And close db connection