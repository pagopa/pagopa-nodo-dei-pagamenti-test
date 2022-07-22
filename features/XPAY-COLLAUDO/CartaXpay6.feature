Feature: CartaXpay6

    Scenario: CartaXpay6
        Given payment generated with mock
        When browse the payment response url
        And Login as registered user
        And Select add Payment method
        And select CartaXpay6 credit card
        Then confirm payment
        Then close the page
