Feature:  block check for activatePaymentNoticeReq - position status in PAID [Activate_blocco_02] 1024

   Background:
      Given systems up
      

   Scenario: Execute activatePaymentNotice request
      Given initial XML activatePaymentNotice
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
         <expirationTime>120000</expirationTime>
         <amount>10.00</amount>
         <dueDate>2021-12-31</dueDate>
         <paymentNote>causale</paymentNote>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response

   # Payment Outcome Phase
   Scenario: Execute sendPaymentOutcome request
      Given the Execute activatePaymentNotice request scenario executed successfully
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
         <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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
      #  When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti using the token of the activate phase, and with request field <outcome> = OK
      When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response

   @runnable
   Scenario: Execute activatePaymentNotice request with same request as Activate Phase 1 except for idempotencyKey, immediately after the Payment Outcome Phase
      Given EC replies to nodo-dei-pagamenti with the paSendRT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
         xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header />
         <soapenv:Body>
         <paf:paSendRTRes>
         <outcome>KO</outcome>
         <fault>
         <faultCode>PAA_ERRORE_MOCK</faultCode>
         <faultString>Errore semantico</faultString>
         <id>1</id>
         </fault>
         </paf:paSendRTRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And the Execute sendPaymentOutcome request scenario executed successfully
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of activatePaymentNotice response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
