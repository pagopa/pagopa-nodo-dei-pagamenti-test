Feature: CartaXpay3

    Scenario: CartaXpay3
        Given payment generated with mock
        When browse the payment response url
        And Login as registered user
        And Select add Payment method
        And select CartaXpay3 credit card
        And confirm payment
        Then close the page
