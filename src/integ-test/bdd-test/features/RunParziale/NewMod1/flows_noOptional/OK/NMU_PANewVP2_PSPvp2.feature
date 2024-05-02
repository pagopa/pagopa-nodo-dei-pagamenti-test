Feature: NM1 PA New without optional

    Background:
        Given systems up

    Scenario: checkPosition request
        Given from body checkPositionBody_paNewVP2 initial JSON checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2 request
        Given the checkPosition request scenario executed successfully
        And from body activatePaymentNoticeV2Body_paNewVP2_Ecommerce initial XML activatePaymentNoticeV2
        And from body paGetPaymentV2_tokenFromActivateV2_noOptional initial XML paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: closePaymentV2 request
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And from body closePaymentV2Body_CP_PSPvp2_noOptional initial json v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @noOptional
    Scenario: sendPaymentOutcomeV2 request
        Given the closePaymentV2 request scenario executed successfully
        And from body sendPaymentOutcomeV2Body_tokenFromActivateV2_noOptional initial XML sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        

