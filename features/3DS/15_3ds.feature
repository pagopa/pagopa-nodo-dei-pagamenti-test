Feature: 15

    Scenario: 15
        Given db connection opened
        And payment generated with mock
        When browse the payment response url
        And Login as registered user
        And Select add Payment method
        And select 3ds credit card
        And confirm payment
        And close the page
        And sleep 10 s
        Then check resultCode in METHOD_RESPONSE_3DS2 is 25
        And close db connection