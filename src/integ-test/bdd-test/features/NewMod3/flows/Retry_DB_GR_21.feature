Feature: process tests for Retry_DB_GR_21

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
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

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
          <soapenv:Header/>
          <soapenv:Body>
              <nod:activatePaymentNoticeReq>
                  <idPSP>70000000001</idPSP>
                  <idBrokerPSP>70000000001</idBrokerPSP>
                  <idChannel>70000000001_01</idChannel>
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

  # Activate phase
  Scenario: Execute activatePaymentNotice request
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


   # Payment Outcome Phase outcome OK
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
               <outcome>KO</outcome>
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

      # test execution
   Scenario: Execution test
    Given the Execute sendPaymentOutcome request scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPayment
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    And EC replies to nodo-dei-pagamenti with the paGetPaymentRes
    And job mod3CancelV2 triggered after 3 seconds
    And verify the HTTP status code of mod3CancelV2 response is 200
   Then checks the value None of the record pa1 of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record noticeID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record creditorReferenceId of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record token of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record recipientPA of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record recipientPA of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record recipientBroker of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record recipientStation of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record status of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
   Then checks the value None of the record fkPositionReceipt of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query position_receipt_recipient_status on db nodo_online under macro NewMod3
