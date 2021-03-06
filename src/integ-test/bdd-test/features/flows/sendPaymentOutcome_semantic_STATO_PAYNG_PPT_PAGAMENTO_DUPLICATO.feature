Feature: semantic checks for sendPaymentOutcomeReq - STATO PAYING - PPT_PAGAMENTO_DUPLICATO [SEM_SPO_13.1]

  Background:
    Given systems up 
    And EC new version    

  # activatePaymentNoticeReq phase
  Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice_1
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
          <expirationTime>6000</expirationTime>
          <amount>10.00</amount>
        </nod:activatePaymentNoticeReq>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When PSP sends SOAP activatePaymentNotice_1 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice_1 response
    
  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    Given the Execute activatePaymentNotice request scenario executed successfully
    When job mod3Cancel triggered after 7 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    
  # activatePaymentNoticeReq phase 2
  Scenario: Execute a new activatePaymentNotice request
    Given the Execute mod3Cancel poller scenario executed successfully
    And initial XML activatePaymentNotice_2
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
            <fiscalCode>$activatePaymentNotice_1.fiscalCode</fiscalCode>
            <noticeNumber>$activatePaymentNotice_1.noticeNumber</noticeNumber>
          </qrCode>
          <expirationTime>6000</expirationTime>
          <amount>10.00</amount>
        </nod:activatePaymentNoticeReq>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When PSP sends SOAP activatePaymentNotice_2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice_2 response
    
  # sendPaymentOutcomeReq phase
  Scenario: Execute a sendPaymentOutcome request
    Given the Execute a new activatePaymentNotice request scenario executed successfully
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
          <paymentToken>$activatePaymentNotice_1Response.paymentToken</paymentToken>
          <outcome>OK</outcome>
          <!--Optional:-->
          <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
              <uniqueIdentifier>
                <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
              </uniqueIdentifier>
              <fullName>name</fullName>
              <!--Optional:-->
              <streetName>street</streetName>
              <!--Optional:-->
              <civicNumber>civic</civicNumber>
              <!--Optional:-->
              <postalCode>postal</postalCode>
              <!--Optional:-->
              <city>city</city>
              <!--Optional:-->
              <stateProvinceRegion>state</stateProvinceRegion>
              <!--Optional:-->
              <country>IT</country>
              <!--Optional:-->
              <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
          </details>
        </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcome response
