Feature: Payment on wisp
    Scenario: Payment on wisp goes successfuly
        Given Payment generated with mock
        When Browse the payment response url
        And Enter with the mail
        And Select onus credit card
        And Confirm payment
        Then Payment is made successfully