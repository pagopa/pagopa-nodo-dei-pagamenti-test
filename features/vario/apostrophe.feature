Feature: Holder with apostrophe
    Scenario: Verify payment successfully of guest user with card with cardHolder containing apostrophes
        Given Payment generated with mock
        When Browse the payment response url
        And Enter with the mail
        And Select credit card with apostrophe on cardHolder
        And Confirm payment
        Then Payment is made successfully