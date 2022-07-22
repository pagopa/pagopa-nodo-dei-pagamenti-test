Feature: XPAY - MC

    Background:
        Given payment generated with mock
        When browse the payment response url
        And enter with the mail
    
    @prova
    Scenario: XPAY with MC cards - OK
        When select CartaMCXPAY1 credit card
        And select XPAY from psp list
        And confirm payment
        And sleep 40 s 
        Then Payment is made successfully
        And close the page

    Scenario Outline: XPAY with MC cards - KO
        When select <credit_card> credit card
        And select XPAY from psp list
        And confirm payment
        And sleep 30 s
        Then check Operazione rifiutata is displayed
        And check Rivolgiti alla tua banca per avere indicazione sui motivi is displayed
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
