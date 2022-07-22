Feature: Visa - XPay
    Background:
        Given payment generated with mock
        When browse the payment response url
        And enter with the mail

    Scenario Outline: XPAY with Visa cards - KO
        When select <credit_card> credit card
        And confirm payment
        And sleep 30 s
        Then check Operazione rifiutata is displayed
        And check Rivolgiti alla tua banca per avere indicazione sui motivi is displayed
        Examples:
            | credit_card       |
            | CartaVisaXPAY2    |
            | CartaVisaXPAY3    |
            | CartaVisaXPAY4    |
            | CartaVisaXPAY5    |
            | CartaVisaXPAY6    |
            | CartaVisaXPAY7    |
            | CartaVisaXPAY8    |
            | CartaVisaXPAY9    |
            | CartaVisaXPAY10   |
            | CartaVisaXPAY11   |
            | CartaVisaXPAY12   |
            | CartaVisaXPAY13   |
            | CartaVisaXPAY14   |
            | CartaInvalida     |

