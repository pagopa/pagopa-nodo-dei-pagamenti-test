Feature: CartaXpay
    
Background:
    Given payment generated with mock
    When browse the payment response url
    And enter with the mail

    Scenario Outline: xpay-collaudo - OK
        When select <credit_card> credit card
        And confirm payment
        Then check the OK is displayed
        Examples:
            | credit_card |
            | CartaXpay1  |
            #| CartaXpay2  |
            #| CartaXpay3  |
            #| CartaXpay4  |
            #| CartaXpay5  |
            #| CartaXpay6  |
            #| CartaXpay7  |



