Feature: CartaXpay7

    Scenario: CartaXpay7
        Given payment generated with mock
        When browse the payment response url
        And Login as registered user
        And Select add Payment method
        And select CartaXpay7 credit card
        And confirm payment
        Then close the page
