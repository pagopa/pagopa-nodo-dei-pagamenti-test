Feature: CartaXpay
    
Background:
    Given payment generated with mock
    When browse the payment response url
    And enter with the mail

    Scenario: CartaXpay8
        When select CartaXpay8 credit card
        And confirm payment
        And wait until api.dev.platform.pagopa.it
        And insert OTP
        Then check Autorizzazione negata. is displayed


    Scenario Outline: xpay-collaudo - KO - Auth. denied
        When select <credit_card> credit card
        And select XPAY from psp list
        And confirm payment
        And wait until api.dev.platform.pagopa.it
        Then check Autorizazione negata. Rivolgiti alla tua banca per avere indicazione sulle motivazioni is displayed
        Examples:
            | credit_card |
            | CartaXpay9  |
            | CartaXpay10 |
            | CartaXpay11 |
            | CartaXpay12 |
            #| CartaXpay13 |



