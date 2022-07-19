Feature: Charity Payment with card amex
    Scenario: Charity Payment on wisp with card amex as guest user.
        Given Payment generated with mock charity
        When Browse the payment response url
        And Enter with the mail
        And Select amex credit card
        #Then sleep 1000 s
        Then operation denied


    @prova
    Scenario: prova
        Given retrieved session token
        And onboarding credit card
        """
        {
            "data": {
                "creditCard": {
                    "expireMonth": "12",
                    "expireYear": "30",
                    "holder": "TestGuy",
                    "pan": "5255000010002856",
                    "securityCode": "123"
                },
                "type": "CREDIT_CARD"
            }
        }
        """
        And payment generated with mock
        And payment with credit card
        And open local file