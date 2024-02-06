Feature: happy flow multitoken test for NM1

    Background:
        Given systems up

    Scenario: checkPosition
        Given from body checkPositionBody_2element initial JSON checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: first activatePaymentNoticeV2 request
        Given the checkPosition scenario executed successfully
        And from body activatePaymentNoticeV2Body initial XML activatePaymentNoticeV2
        And from body paGetPayment_2transfersBody initial XML paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPayment request in paGetPayment_1Request


    Scenario: second activatePaymentNoticeV2 request
        Given the first activatePaymentNoticeV2 request scenario executed successfully
        And from body activatePaymentNoticeV2Body initial XML activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And from body paGetPaymentV2_2transfersBody initial XML paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request


    Scenario: closePaymentV2 with 2 paymentToken
        Given the second activatePaymentNoticeV2 request scenario executed successfully
        And from body closePaymentV2_2paymentTokens initial JSON v2/closepayment
        And for json replace idChannel with #canale_versione_primitive_2# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    @multiToken @NM1 @ALL
    Scenario: sendPaymentOutcomeV2 with 2 paymentToken
        Given the closePaymentV2 with 2 paymentToken scenario executed successfully
        And from body sendPaymentOutcomeV2Body_2payToken initial XML sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response