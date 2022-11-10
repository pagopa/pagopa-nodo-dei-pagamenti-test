Feature: flow checks for sendPaymentResult

   Background:
      Given systems up 
      Then verify 2 record for the table RE retrived by the query select_sprV1_prova on db re under macro AppIO
      And execution query select_sprV1_prova to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_prova convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And check value $XML_RE.paymentToken is equal to value c87c2ea4cb5e43b88dbfb6b0bf7bbe2e
      And check value $XML_RE.pspTransactionId is equal to value 30304982
      And check value $XML_RE.outcome is equal to value OK
