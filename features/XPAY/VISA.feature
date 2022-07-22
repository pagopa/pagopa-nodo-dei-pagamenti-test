Feature: Visa - XPay
    Background:
        Given payment generated with mock
        When browse the payment response url
        And enter with the mail

    Scenario Outline: XPAY with Visa cards - KO
        When select <credit_card> credit card
        And confirm payment
        And sleep 40 s
        Then check Operazione rifiutata is displayed
        And check <text> is displayed
        Examples:
            | credit_card       | text                                                      |
            | CartaVisaXPAY2    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY3    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY4    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY5    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY6    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY7    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY8    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY9    | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY10   | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY11   | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY12   | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY13   | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaVisaXPAY14   | Rivolgiti alla tua banca per avere indicazione sui motivi |
            | CartaInvalida     | Controlla di aver inserito correttamente i dati carta     |

