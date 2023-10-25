Feature: verification of the record present in RECEVUTA_PM in the POSITION_PAYMENT table after an activatePaymentNoticeV2

    Background:
        Given systems up


    Scenario: checkPosition for eCommerce
        Given from body checkPositionBody_2element initial JSON checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

        # Il test è necessario per la verifica del corretto funzionamento dell'activatePaymentNoticeV2 e dell'inserimento del value Y, dopo esser stata chiamata,
        # sulla tabella POSITION_PAYMENT nella colonna RICEVUTA_PM

    @checkRicevutaPM @NM1 @ALL @bugFix
    Scenario: activatePaymentNoticeV2 eCommerce with iuv
        Given the checkPosition for eCommerce scenario executed successfully
        And from body activatePaymentNoticeV2Body initial XML activatePaymentNoticeV2
        And for xml replace idPSP with #pspEcommerce# in activatePaymentNoticeV2
        And for xml replace idBrokerPSP with #brokerEcommerce# in activatePaymentNoticeV2
        And for xml replace idChannel with #canaleEcommerce# in activatePaymentNoticeV2
        And from body paGetPayment_1transferBody initial XML paGetPayment 
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And idempotencyKey with None in activatePaymentNoticeV2
        And expirationTime with None in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPayment request in paGetPayment_1Request
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        
        # And execution query notice_id_first_activatev2 to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod1 with db name nodo_online
        # And through the query notice_id_first_activatev2 retrieve param obj_id at position 0 and save it under the key obj_id
        # And update through the query param_update_in of the table POSITION_PAYMENT the parameter RICEVUTA_PM with Y, with where condition ID and where value $obj_id under macro update_query on db nodo_online
        # And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        