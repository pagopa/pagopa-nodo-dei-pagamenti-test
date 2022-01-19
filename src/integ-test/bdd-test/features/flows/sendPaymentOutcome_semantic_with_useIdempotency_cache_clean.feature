Feature: semantic check for sendPaymentOutcomeReq regarding idempotency - use idempotency and cache clean

  Background:
    Given systems up
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
             <expirationTime>120000</expirationTime>
             <amount>10.00</amount>
             <dueDate>2021-12-31</dueDate>
             <paymentNote>causale</paymentNote>
          </nod:activatePaymentNoticeReq>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    And call the noticeNumber of activatePaymentNotice request as noticeNumberPhase1
    And call the idempotencyKey of activatePaymentNotice request as idempotencyKeyPhase1
    Then check outcome is OK of activatePaymentNotice response
    And call the paymentToken of activatePaymentNotice response as paymentTokenPhase1

  # Activate Phase 2
  Scenario: Execute activatePaymentNotice request on different position with different idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
    And random noticeNumber in activatePaymentNotice
    And random idempotencyKey having 70000000001 as idPSP in activatePaymentNotice
    And call the noticeNumber of activatePaymentNotice request as noticeNumberPhase2
    And call the idempotencyKey of activatePaymentNotice request as idempotencyKeyPhase2
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And call the paymentToken of activatePaymentNotice response as paymentTokenPhase2

  # Send payment outcome Phase - outcome OK [IDMP_SPO_18]
  Scenario: Execute sendPaymentOutcome request with outcome OK on token of Activate Phase 2
    Given the Execute activatePaymentNotice request on different position with different idempotencyKey scenario executed successfully
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
                <idempotencyKey>#idempotency_key_2#</idempotencyKey>
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
    Then check outcome is OK of sendPaymentOutcome response
    
  # First activate check [IDMP_SPO_18]
  Scenario: Execute again activatePaymentNotice request of Activate Phase 1
    Given the Execute sendPaymentOutcome request with outcome OK on token of Activate Phase 2 scenario executed successfully
    And noticeNumber with noticeNumberPhase1 in activatePaymentNotice
    And idempotencyKey with idempotencyKeyPhase1 in activatePaymentNotice    
    And call the paymentTokenPhase1
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is equals to paymentTokenPhase1

  # Second activate check [IDMP_SPO_18]
  Scenario: Execute again activatePaymentNotice request of Activate Phase 2
    Given the Execute again activatePaymentNotice request of Activate Phase 1 scenario executed successfully
    And noticeNumber with noticeNumberPhase2 in activatePaymentNotice
    And idempotencyKey with idempotencyKeyPhase2 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
 
  # Send payment outcome Phase - outcome KO [IDMP_SPO_19]
  Scenario: Execute sendPaymentOutcome request with outcome KO on token of Activate Phase 2
    Given the Execute activatePaymentNotice request on different position with different idempotencyKey scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    
  # First activate check [IDMP_SPO_19]
  Scenario: Execute again activatePaymentNotice request of Activate Phase 1
    Given the Execute sendPaymentOutcome request with outcome KO on token of Activate Phase 2 scenario executed successfully
    And noticeNumber with noticeNumberPhase1 in activatePaymentNotice
    And idempotencyKey with idempotencyKeyPhase1 in activatePaymentNotice    
    And call the paymentTokenPhase1
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is equals to paymentTokenPhase1
  
  # Second activate check [IDMP_SPO_19]
  Scenario: Execute again activatePaymentNotice request of Activate Phase 2
    Given the Execute again activatePaymentNotice request of Activate Phase 1 scenario executed successfully
    And noticeNumber with noticeNumberPhase2 in activatePaymentNotice
    And idempotencyKey with idempotencyKeyPhase2 in activatePaymentNotice    
    And call the paymentTokenPhase2
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is not equal to paymentTokenPhase2

  # Send payment outcome Phase - Semantic error [IDMP_SPO_20.1]
  Scenario: Semantic error for sendPaymentOutcome response executed on token of Activate Phase 1
    Given the Execute activatePaymentNotice request scenario executed successfully
    And idPSP with 70000000003 in sendPaymentOutcome
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PSP_SCONOSCIUTO of sendPaymentOutcome response
    
  # First activate check [IDMP_SPO_20.1]
  Scenario: Execute again activatePaymentNotice request
    Given the Semantic error for sendPaymentOutcome response executed on token of Activate Phase 1 scenario executed successfully
    And call the paymentToken of activatePaymentNotice response as target
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is equals to target