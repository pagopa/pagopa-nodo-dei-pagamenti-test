Feature: Charity Payment with card amex
    Scenario: Charity Payment on wisp with card amex as guest user.
        Given Payment generated with mock charity
        When Browse the payment response url
        And Enter with the mail
        And Select amex credit card
        #Then sleep 1000 s
        Then operation denied

