Feature: 16

    Scenario: 16
        Given payment generated with mock
        When browse the payment response url
        And login as registered user
        And select add payment method
        And select 3ds_wrong_cc credit card
        Then check card number is incorrect
        And close the page