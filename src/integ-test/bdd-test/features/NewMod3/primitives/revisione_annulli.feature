Feature: process tests for reviione-poller annulli01_02

  Background:
    Given systems up
    And EC new version

  Scenario: Execute verifyPaymentNotice (Phase 1)
    Given initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header />
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
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  #activate phase
  Scenario: Execute activatePaymentNotice (Phase 2)
    Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
          </nod:activatePaymentNoticeReq>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  Scenario: [REV_ANN_01]
    Given the Execute activatePaymentNotice (Phase 2) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
  
  Scenario: [REV_ANN_02]
    Given the Execute activatePaymentNotice (Phase 2) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    When job mod3CancelV2 triggered after 7 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
    And checks the value CANCELLED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value CANCELLED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3

  Scenario: [REV_ANN_05] (Phase 1)
    Given the Execute activatePaymentNotice (Phase 2) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3

  Scenario: [REV_ANN_05] (Phase 2)
    Given the [REV_ANN_05] (Phase 1) scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  Scenario: [REV_ANN_05] (Phase 3)
    Given the [REV_ANN_05] (Phase 2) scenario executed successfully
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
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 5.0 seconds for expiration
    And checks the value PAYING, INSERTED, PAID, CANCELLED, NOTICE_GENERATED, NOTIFIED, NOTICE_SENT of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NOTICE_SENT of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO