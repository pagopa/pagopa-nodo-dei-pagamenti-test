Feature:  block checks for verifyPaymentReq - position status in NOTIFIED [Verify_blocco_09]

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>#psp#</idPSP>
               <idBrokerPSP>#psp#</idBrokerPSP>
               <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
	 And EC new version

  # Verify Phase 1
  Scenario: Execute verifyPaymentNotice request
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
    

  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:activatePaymentNoticeReq>
               <idPSP>#psp#</idPSP>
               <idBrokerPSP>#psp#</idBrokerPSP>
               <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
               <password>pwdpwdpwd</password>
               <idempotencyKey>#idempotency_key#</idempotencyKey>
               <qrCode>
                  <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
                  <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
               </qrCode>
               <amount>120.00</amount>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And paymentToken exists of activatePaymentNotice response
    And paymentToken length is less than 36 of activatePaymentNotice response

	
  # Payment Outcome Phase outcome OK
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
   #  When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti using the token of the activate phase, and with request field <outcome> = OK
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  Scenario: Execute paSendRT request
    Given the Execute sendPaymentOutcome request scenario executed successfully
    Then check EC receives paSendRT properly
  """
    $verifyPaymentNotice.noticeNumber
  """

  # Verify Phase 2
  Scenario: Execute verifyPaymentNotice request with the same request as Verify Phase 1, few seconds after the Payment Outcome Phase (e.g. 30s)
    Given the Execute paSendRT request scenario executed successfully
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of verifyPaymentNotice response
