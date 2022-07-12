Feature: 15

    Scenario: 15
        Given db connection opened
        And payment generated with mock
        When browse the payment response url
        And Login as registered user
        And select 3ds credit card
        And confirm payment
        And close browser
        Then check resultCode in METHOD_RESPONSE_3D2  is 25