Feature: CartaXpay4

    Scenario: CartaXpay4
        Given payment generated with mock
        When browse the payment response url
        And Login as registered user
        And Select add Payment method
        And select CartaXpay4 credit card
        And confirm payment
        Then close the page
