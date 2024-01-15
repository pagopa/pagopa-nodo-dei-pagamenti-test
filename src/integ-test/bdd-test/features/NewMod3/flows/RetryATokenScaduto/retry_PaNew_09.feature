Feature: Process tests for retry a token scaduto

   Background:
      Given systems up
      And initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>pwdpwdpwd</password>
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>#notice_number#</noticeNumber>
         </qrCode>
         <expirationTime>2000</expirationTime>
         <amount>10.00</amount>
         <dueDate>2021-12-31</dueDate>
         <paymentNote>causale</paymentNote>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   #activate phase1
   Scenario: Execute activatePaymentNotice1 request
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice1
      And saving activatePaymentNotice request in activatePaymentNotice1

   #sleep phase1 + poller annulli
   Scenario: Execute sleep phase1
      Given the Execute activatePaymentNotice1 request scenario executed successfully
      When job mod3CancelV2 triggered after 3 seconds
      Then verify the HTTP status code of mod3CancelV2 response is 200

   Scenario: Execute activatePaymentNotice2 request
      Given the Execute sleep phase1 scenario executed successfully
      And initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>pwdpwdpwd</password>
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <qrCode>
         <fiscalCode>$activatePaymentNotice1.fiscalCode</fiscalCode>
         <noticeNumber>$activatePaymentNotice1.noticeNumber</noticeNumber>
         </qrCode>
         <amount>10.00</amount>
         <dueDate>2021-12-31</dueDate>
         <paymentNote>causale</paymentNote>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice2
      And saving activatePaymentNotice request in activatePaymentNotice2

   #sleep phase2
   Scenario: Execute sleep phase2
      Given the Execute activatePaymentNotice2 request scenario executed successfully
      Then wait 10 seconds for expiration

   # Payment Outcome Phase outcome OK
   Scenario: Execute sendPaymentOutcome1 request
      Given the Execute sleep phase2 scenario executed successfully
      And initial XML sendPaymentOutcome
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>pwdpwdpwd</password>
         <paymentToken>$activatePaymentNotice1Response.paymentToken</paymentToken>
         <outcome>OK</outcome>
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>John Doe</fullName>
         <streetName>street</streetName>
         <civicNumber>12</civicNumber>
         <postalCode>89020</postalCode>
         <city>city</city>
         <stateProvinceRegion>MI</stateProvinceRegion>
         <country>IT</country>
         <e-mail>john.doe@test.it</e-mail>
         </payer>
         <applicationDate>2021-10-01</applicationDate>
         <transferDate>2021-10-02</transferDate>
         </details>
         </nod:sendPaymentOutcomeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcome response
      #Test1
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcome response

   @runnable @lazy @dependentread
   # Payment Outcome Phase outcome OK
   Scenario: Execute sendPaymentOutcome2 request
      Given the Execute sendPaymentOutcome1 request scenario executed successfully
      And initial XML sendPaymentOutcome
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>pwdpwdpwd</password>
         <paymentToken>$activatePaymentNotice2Response.paymentToken</paymentToken>
         <outcome>OK</outcome>
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>John Doe</fullName>
         <streetName>street</streetName>
         <civicNumber>12</civicNumber>
         <postalCode>89020</postalCode>
         <city>city</city>
         <stateProvinceRegion>MI</stateProvinceRegion>
         <country>IT</country>
         <e-mail>john.doe@test.it</e-mail>
         </payer>
         <applicationDate>2021-10-01</applicationDate>
         <transferDate>2021-10-02</transferDate>
         </details>
         </nod:sendPaymentOutcomeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And wait 5 seconds for expiration
      #Test2
      #paymentToken1
      And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_payment_retry_05_token1 on db nodo_online under macro NewMod3
      #paymentToken2
      And checks the value PAYING,NOTICE_SENT,PAID,NOTICE_GENERATED,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_payment_retry_05_token2 on db nodo_online under macro NewMod3
      #paymentToken1
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment_retry_05_token1 on db nodo_online under macro NewMod3
      #paymentToken2
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query position_payment_retry_05_token2 on db nodo_online under macro NewMod3
      #test3
      #paymentToken1
      And checks the value PAYING,INSERTED,PAYING,INSERTED,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_retry_05_token1 on db nodo_online under macro NewMod3
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_retry_05_token1 on db nodo_online under macro NewMod3