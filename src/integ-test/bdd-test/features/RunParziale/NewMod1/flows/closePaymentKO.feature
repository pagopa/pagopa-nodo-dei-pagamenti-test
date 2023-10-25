Feature: flow with pspNptifyPaymentKO

    Background:
        Given systems up

    Scenario: checkPosition
        Given current date generation
        And from body checkPositionBody initial JSON checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2
        Given the checkPosition scenario executed successfully
        And from body activatePaymentNoticeV2Body initial XML activatePaymentNoticeV2
        And for xml replace expirationTime with 2000 in activatePaymentNoticeV2
        And from body paGetPayment_3transfersBody initial XML paGetPayment      
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response


    @closePaymentKO @NM1 @ALL
    Scenario: closePaymentV2
        Given the activatePaymentNoticeV2 scenario executed successfully
        And from body closePaymentV2_TPAY_MultibenBody initial JSON v2/closepayment
        And for json replace paymentTokens with Empty in v2/closepayment
        And for json replace idChannel with #canale_versione_primitive_2# in v2/closepayment
        And for json replace outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then check outcome is KO of v2/closepayment response
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid paymentTokens of v2/closepayment response
    
