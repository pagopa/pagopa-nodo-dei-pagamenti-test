Feature: sendPaymentResult sent to WISP with outcome OK when pspNotifyPayment OK [T_SPR_01]

  Background:
    Given systems up
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                     <idPSP>70000000001</idPSP>
                     <idBrokerPSP>70000000001</idBrokerPSP>
                     <idChannel>70000000001_01</idChannel>
                     <password>pwdpwdpwd</password>
                     <!--Optional:-->
                     <idempotencyKey>#idempotency_key#</idempotencyKey>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>#notice_number#</noticeNumber>
                     </qrCode>
                     <!--Optional:-->
                     <amount>10.00</amount>
                     <!--Optional:-->
                     <dueDate>2021-12-12</dueDate>
                     <!--Optional:-->
                     <paymentNote>responseFull</paymentNote>
                     <!--Optional:-->
                    <payer>
                        <uniqueIdentifier>
                           <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                           <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
                        </uniqueIdentifier>
                        <fullName>name</fullName>
                        <!--Optional:-->
                        <streetName>street</streetName>
                        <!--Optional:-->
                        <civicNumber>civic</civicNumber>
                        <!--Optional:-->
                        <postalCode>code</postalCode>
                        <!--Optional:-->
                        <city>city</city>
                        <!--Optional:-->
                        <stateProvinceRegion>state</stateProvinceRegion>
                        <!--Optional:-->
                        <country>IT</country>
                        <!--Optional:-->
                        <e-mail>test.prova@gmail.com</e-mail>
                     </payer>
                </nod:activateIOPaymentReq>
            </soapenv:Body>
        </soapenv:Envelope>
      """
    And EC new version

  Scenario: 1. Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: 2. Execute nodoChiediInformazioniPagamento request
    Given the 1. Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  # closePayment phase
  Scenario: 3. Execute closePayment request
    Given the 2. Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP sends rest POST v1/closepayment to nodo-dei-pagamenti
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "outcome": "OK",
    "identificativoPsp": "70000000001",
    "tipoVersamento": "BPAY",
    "identificativoIntermediario": "70000000001",
    "identificativoCanale": "70000000001_03",
    "pspTransactionId": "resSPR_200OK",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resOK"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult check - outcome OK
   Scenario: 4. Check sendPaymentResult request
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    Then check WISP receives sendPaymentResult with request
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "OK"
    }
    """


Feature: sendPaymentResult sent to WISP with outcome OK when sendPaymentOutcome arrives after pspNotifyPayment in timeout but token has not expired [T_SPR_02]

  Background:
    Given systems up
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                     <idPSP>70000000001</idPSP>
                     <idBrokerPSP>70000000001</idBrokerPSP>
                     <idChannel>70000000001_01</idChannel>
                     <password>pwdpwdpwd</password>
                     <!--Optional:-->
                     <idempotencyKey>#idempotency_key#</idempotencyKey>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>#notice_number#</noticeNumber>
                     </qrCode>
                     <!--Optional:-->
                     <amount>10.00</amount>
                     <!--Optional:-->
                     <dueDate>2021-12-12</dueDate>
                     <!--Optional:-->
                     <paymentNote>responseFull</paymentNote>
                     <!--Optional:-->
                    <payer>
                        <uniqueIdentifier>
                           <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                           <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
                        </uniqueIdentifier>
                        <fullName>name</fullName>
                        <!--Optional:-->
                        <streetName>street</streetName>
                        <!--Optional:-->
                        <civicNumber>civic</civicNumber>
                        <!--Optional:-->
                        <postalCode>code</postalCode>
                        <!--Optional:-->
                        <city>city</city>
                        <!--Optional:-->
                        <stateProvinceRegion>state</stateProvinceRegion>
                        <!--Optional:-->
                        <country>IT</country>
                        <!--Optional:-->
                        <e-mail>test.prova@gmail.com</e-mail>
                     </payer>
                </nod:activateIOPaymentReq>
            </soapenv:Body>
        </soapenv:Envelope>
      """
    And EC new version

  Scenario: 1. Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: 2. Execute nodoChiediInformazioniPagamento request
    Given the 1. Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  # closePayment phase
  Scenario: 3. Execute closePayment request
    Given the 2. Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP sends rest POST v1/closepayment to nodo-dei-pagamenti
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "outcome": "OK",
    "identificativoPsp": "70000000001",
    "tipoVersamento": "BPAY",
    "identificativoIntermediario": "70000000001",
    "identificativoCanale": "70000000001_03",
    "pspTransactionId": "resSPR_200OK",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resTim"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response
    
   # sendPaymentOutcomeReq phase and sendPaymentResult check - outcome OK
   Scenario: 4. Execute a sendPaymentOutcome request and check sendPaymentResult request
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with Timeout in pspNotifyPayment    
    And initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>70000000001</idPSP>
          <idBrokerPSP>70000000001</idBrokerPSP>
          <idChannel>70000000001_03</idChannel>
          <password>pwdpwdpwd</password>
          <paymentToken>$activatePaymentNotice.paymentToken</paymentToken>
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
    Then check outcome is OK of sendPaymentOutcome response
    And check WISP receives sendPaymentResult with request  
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "OK"
    }
    """    
   

Feature: sendPaymentResult sent to WISP with outcome OK when sendPaymentOutcome arrives after pspNotifyPayment with malformed response but token has not expired [T_SPR_03]

  Background:
    Given systems up
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                     <idPSP>70000000001</idPSP>
                     <idBrokerPSP>70000000001</idBrokerPSP>
                     <idChannel>70000000001_01</idChannel>
                     <password>pwdpwdpwd</password>
                     <!--Optional:-->
                     <idempotencyKey>#idempotency_key#</idempotencyKey>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>#notice_number#</noticeNumber>
                     </qrCode>
                     <!--Optional:-->
                     <amount>10.00</amount>
                     <!--Optional:-->
                     <dueDate>2021-12-12</dueDate>
                     <!--Optional:-->
                     <paymentNote>responseFull</paymentNote>
                     <!--Optional:-->
                    <payer>
                        <uniqueIdentifier>
                           <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                           <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
                        </uniqueIdentifier>
                        <fullName>name</fullName>
                        <!--Optional:-->
                        <streetName>street</streetName>
                        <!--Optional:-->
                        <civicNumber>civic</civicNumber>
                        <!--Optional:-->
                        <postalCode>code</postalCode>
                        <!--Optional:-->
                        <city>city</city>
                        <!--Optional:-->
                        <stateProvinceRegion>state</stateProvinceRegion>
                        <!--Optional:-->
                        <country>IT</country>
                        <!--Optional:-->
                        <e-mail>test.prova@gmail.com</e-mail>
                     </payer>
                </nod:activateIOPaymentReq>
            </soapenv:Body>
        </soapenv:Envelope>
      """
    And EC new version

  Scenario: 1. Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: 2. Execute nodoChiediInformazioniPagamento request
    Given the 1. Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  # closePayment phase
  Scenario: 3. Execute closePayment request
    Given the 2. Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP sends rest POST v1/closepayment to nodo-dei-pagamenti
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "outcome": "OK",
    "identificativoPsp": "70000000001",
    "tipoVersamento": "BPAY",
    "identificativoIntermediario": "70000000001",
    "identificativoCanale": "70000000001_03",
    "pspTransactionId": "resSPR_200OK",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resMal"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response
    
   # sendPaymentOutcomeReq phase and sendPaymentResult check  - outcome OK
   Scenario: 4. Execute a sendPaymentOutcome request and check sendPaymentResult request
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with Malformed in pspNotifyPayment  
    And initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>70000000001</idPSP>
          <idBrokerPSP>70000000001</idBrokerPSP>
          <idChannel>70000000001_03</idChannel>
          <password>pwdpwdpwd</password>
          <paymentToken>$activatePaymentNotice.paymentToken</paymentToken>
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
    Then check outcome is OK of sendPaymentOutcome response
    And check WISP receives sendPaymentResult with request  
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "OK"
    }
    """       
   
    
 