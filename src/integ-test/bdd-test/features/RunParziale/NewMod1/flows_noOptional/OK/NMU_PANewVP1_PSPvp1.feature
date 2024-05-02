Feature: NM1 PA New without optional

    Background:
        Given systems up

    Scenario: checkPosition request
        Given from body checkPositionBody_paNewVP1 initial JSON checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2 request
        Given the checkPosition request scenario executed successfully
        And from body activatePaymentNoticeV2Body_paNewVP1_Ecommerce initial XML activatePaymentNoticeV2
        And from body paGetPayment_tokenFromActivateV2_noOptional initial XML paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: closePaymentV2 request
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And from body closePaymentV2Body_CP_PSPvp1_noOptional initial json v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @noOptional
    Scenario: sendPaymentOutcome request
        Given the closePaymentV2 request scenario executed successfully
        And from body sendPaymentOutcomeBody_tokenFromActivateV2_noOptional initial XML sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        

