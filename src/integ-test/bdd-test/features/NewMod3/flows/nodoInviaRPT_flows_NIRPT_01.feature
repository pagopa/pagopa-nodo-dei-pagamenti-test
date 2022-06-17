Feature: process tests for nodoInviaRPT [REV_NIRPT_01]

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
    And EC old version

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
   #  When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti check field <outcome> = OK
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  # test execution
  Scenario: Execution test REV_NIRPT_01
    Given the Execute sendPaymentOutcome request scenario executed successfully
    When EC replies to nodo-dei-pagamenti with the nodoInviaRPT
    #------primo blocco di test------
    Then api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS status == PAYING
    And api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS status == PAYING
    And api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS status == PAID
    And api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS status == PAID_NORPT
    And api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS status == NOTICE_GENERATED
    And api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS status == NOTICE_STORED
    And api-config executes the sql {sql_code} and check {status} # check in POSITION_PAYMENT_STATUS_SNAPSHOT status == NOTICE_STORED
    #------secondo blocco di test------
    And api-config executes the sql {sql_code} and check {status} # check in STATI_RPT status == RPT_RICEVUTA_NODO
    And api-config executes the sql {sql_code} and check {status} # check in STATI_RPT status == RPT_ACCETTATA_NODO
    And api-config executes the sql {sql_code} and check {status} # check in STATI_RPT status == RPT_PARCHEGGIATA_NODO_MOD3
    And api-config executes the sql {sql_code} and check {status} # check in STATI_RPT status == RPT_RISOLTA_OK
    And api-config executes the sql {sql_code} and check {status} # check in STATI_RPT status == RT_GENERATA_NODO
    And api-config executes the sql {sql_code} and check {status} # check in STATI_RPT_SNAPSHOT status ==  RT_GENERATA_NODO
   #------terzo blocco di test------
    #To Do implementare tutti gli altri test in funzione delle decisioni di pagopa



