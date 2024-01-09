Feature: semantic check for sendPaymentOutcomeReq regarding idempotency - use idempotency and cache clean 1276

  Background:
    Given systems up

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice1 request
    Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
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
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>$1noticeNumber</noticeNumber>
               </qrCode>
               <amount>10.00</amount>
               <dueDate>2021-12-31</dueDate>
               <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And call the paymentToken of activatePaymentNotice response as paymentTokenPhase1
    And saving activatePaymentNotice request in activatePaymentNotice1
    And save activatePaymentNotice response in activatePaymentNotice1

  # Activate Phase 2
  Scenario: Execute activatePaymentNotice2 request on different position with different idempotencyKey
    Given the Execute activatePaymentNotice1 request scenario executed successfully
    And generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
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
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>$2noticeNumber</noticeNumber>
               </qrCode>
               <amount>10.00</amount>
               <dueDate>2021-12-31</dueDate>
               <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And call the paymentToken of activatePaymentNotice response as paymentTokenPhase2
    And saving activatePaymentNotice request in activatePaymentNotice2
    And save activatePaymentNotice response in activatePaymentNotice2
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_1 on db nodo_online under macro NewMod3
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_2 on db nodo_online under macro NewMod3

 # Send payment outcome Phase - outcome KO [IDMP_SPO_19]
  Scenario: Execute sendPaymentOutcome request with outcome KO on token of Activate Phase 2
    Given the Execute activatePaymentNotice2 request on different position with different idempotencyKey scenario executed successfully
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
                <idempotencyKey>#idempotency_key#</idempotencyKey>
                <paymentToken>$activatePaymentNotice2Response.paymentToken</paymentToken>
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
    Then check outcome is OK of sendPaymentOutcome response
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_1 on db nodo_online under macro NewMod3
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_2 on db nodo_online under macro NewMod3
    
  # First activate check [IDMP_SPO_19]
  Scenario: Execute again activatePaymentNotice request of Activate Phase 1
    Given the Execute sendPaymentOutcome request with outcome KO on token of Activate Phase 2 scenario executed successfully
    And saving activatePaymentNotice1 request in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is equals to paymentTokenPhase1

  @runnable
  # Second activate check [IDMP_SPO_19]
  Scenario: Execute again activatePaymentNotice request of Activate Phase 2
    Given the Execute again activatePaymentNotice request of Activate Phase 1 scenario executed successfully
    And saving activatePaymentNotice2 request in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is not equals to paymentTokenPhase1
    And restore initial configurations