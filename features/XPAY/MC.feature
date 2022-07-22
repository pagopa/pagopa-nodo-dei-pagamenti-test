Feature: XPAY - MC

    Background:
        Given payment generated with mock
        When browse the payment response url
        And enter with the mail

    @prova
    Scenario: XPAY with MC cards - KO
        When select CartaMCXPAY1 credit card
        And confirm payment
        Then check the Grazie is displayed

    Scenario Outline: XPAY with MC cards - KO
        When select <credit_card> credit card
        And confirm payment
        Then check the Autorizzazione negata is displayed
        And check the Rivolgiti alla tua banca per avere indicazione sulle motivazioni is displayed
        Examples:
            | credit_card   |
            | CartaMCXPAY2  |
            | CartaMCXPAY3  |
            | CartaMCXPAY4  |
            | CartaMCXPAY5  |
            | CartaMCXPAY6  |
            | CartaMCXPAY7  |
            | CartaMCXPAY8  |
            | CartaMCXPAY9  |
            | CartaMCXPAY10 |
            | CartaMCXPAY11 |
