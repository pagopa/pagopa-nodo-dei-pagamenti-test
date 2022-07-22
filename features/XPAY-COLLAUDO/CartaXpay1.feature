Feature: CartaXpay1

    Scenario: CartaXpay1
        Given payment generated with mock
        When browse the payment response url
        And Login as registered user
        And Select add Payment method
        And select CartaXpay1 credit card
        And confirm payment
        Then close the page
