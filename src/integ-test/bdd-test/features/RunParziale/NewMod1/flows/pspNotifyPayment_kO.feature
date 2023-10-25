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
        And from body paGetPayment_1transferBody initial XML paGetPayment  
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response


    Scenario: pspNotifyPaymentV2 KO
        Given the activatePaymentNoticeV2 scenario executed successfully
        And from body pspNotifyPaymentV2_KO initial XML pspNotifyPaymentV2
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    @pspNotifyPaymentKO @NM1 @ALL
    Scenario: closePaymentV2
        Given the pspNotifyPaymentV2 KO scenario executed successfully
        And wait 3 seconds for expiration
        And from body closePaymentV2_TPAY_MultibenBody initial JSON v2/closepayment
        And for json replace idChannel with #canale_versione_primitive_2# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then check outcome is OK of v2/closepayment response
        And verify the HTTP status code of v2/closepayment response is 200
        And wait until the update to the new state for the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
    
