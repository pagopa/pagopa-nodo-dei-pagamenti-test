Feature: semantic check for sendPaymentOutcomeReq regarding idempotency - use idempotency and cache clean

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice1 request
    Given initial XML activatePaymentNotice
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
                  <noticeNumber>#notice_number#</noticeNumber>
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
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And saving activatePaymentNotice request in activatePaymentNotice1

  # Activate Phase 2
  Scenario: Execute activatePaymentNotice2 request on different position with different idempotencyKey
    Given the Execute activatePaymentNotice1 request scenario executed successfully
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
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And call the paymentToken of activatePaymentNotice response as paymentTokenPhase2
    And saving activatePaymentNotice request in activatePaymentNotice2
    And save activatePaymentNotice response in activatePaymentNotice2

  # Send payment outcome Phase - outcome OK [IDMP_SPO_18]
  Scenario: Execute sendPaymentOutcome request with outcome OK on token of Activate Phase 2
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
    
  # First activate check [IDMP_SPO_18]
  Scenario: Execute again activatePaymentNotice1 request of Activate Phase 1
    Given the Execute sendPaymentOutcome request with outcome OK on token of Activate Phase 2 scenario executed successfully
    And saving activatePaymentNotice1 request in activatePaymentNotice 
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

@runnable @dependentread @dependentwrite
  # Second activate check [IDMP_SPO_18]
  Scenario: Execute again activatePaymentNotice2 request of Activate Phase 2
    Given the Execute again activatePaymentNotice1 request of Activate Phase 1 scenario executed successfully
    And saving activatePaymentNotice2 request in activatePaymentNotice 
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
    And restore initial configurations

  # Send payment outcome Phase - Semantic error [IDMP_SPO_20.1]
  Scenario: Semantic error for sendPaymentOutcome response executed on token of Activate Phase 1
    Given the Execute activatePaymentNotice1 request scenario executed successfully
    And initial XML sendPaymentOutcome
    """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
                <idPSP>70000000003</idPSP>
                <idBrokerPSP>#psp#</idBrokerPSP>
                <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                <password>pwdpwdpwd</password>
                <idempotencyKey>#idempotency_key#</idempotencyKey>
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
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PSP_SCONOSCIUTO of sendPaymentOutcome response
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    

@runnable @dependentread @dependentwrite    
  # First activate check [IDMP_SPO_20.1]
  Scenario: Execute again activatePaymentNotice3 request
    Given the Semantic error for sendPaymentOutcome response executed on token of Activate Phase 1 scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And restore initial configurations