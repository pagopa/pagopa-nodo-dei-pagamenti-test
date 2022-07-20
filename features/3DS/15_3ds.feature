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
        And sleep 5 s
<<<<<<< HEAD
        Then check resultCode in METHOD_RESPONSE_3D2 is 25
=======
        Then check resultCode in METHOD_RESPONSE_3DS2 is 25
>>>>>>> 8ee2f17f311ae37aeb22018780269416b5006c2d
