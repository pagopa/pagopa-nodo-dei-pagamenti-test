Feature: retry not done for sendPaymentResult if it responds with HTTP status 200 but response outcome is KO  [T_SPR_09]

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
    "pspTransactionId": "resSPR_200KO",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult retry check
   Scenario: 4. Check retry sendPaymentResult
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    And WISP replies to nodo-dei-pagamenti with HTTP status 200 and outcome KO in sendPaymentResult
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
    And check WISP does not receive other sendPaymentResult

    

Feature: retry done for sendPaymentResult if it responds with HTTP status 400 - Bad request [T_SPR_10]

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
    "pspTransactionId": "resSPR_400",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult retry check
   Scenario: 4. Check retry sendPaymentResult
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    And WISP replies to nodo-dei-pagamenti with HTTP status 400 in sendPaymentResult
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
    And check WISP receives a number of sendPaymentResult calls on the same position equal to configuration parameter scheduler.sendPaymentResultPollerMaxRetry is reached

    
 Feature: retry done for sendPaymentResult if it responds with HTTP status 404 - Not found [T_SPR_11]

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
    "pspTransactionId": "resSPR_404",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult retry check
   Scenario: 4. Check retry sendPaymentResult
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    And WISP replies to nodo-dei-pagamenti with HTTP status 404 in sendPaymentResult
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
    And check WISP receives a number of sendPaymentResult calls on the same position equal to configuration parameter scheduler.sendPaymentResultPollerMaxRetry is reached
    

Feature: retry done for sendPaymentResult if it responds with HTTP status 408 - Timeout [T_SPR_12]

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
    "pspTransactionId": "resSPR_408",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult retry check
   Scenario: 4. Check retry sendPaymentResult
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    And WISP replies to nodo-dei-pagamenti with HTTP status 408 in sendPaymentResult
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
    And check WISP receives a number of sendPaymentResult calls on the same position equal to configuration parameter scheduler.sendPaymentResultPollerMaxRetry is reached
    

Feature: retry done for sendPaymentResult if it responds with HTTP status 422 - Unprocessable entry [T_SPR_13]

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
    "pspTransactionId": "resSPR_422",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult retry check
   Scenario: 4. Check retry sendPaymentResult
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    And WISP replies to nodo-dei-pagamenti with HTTP status 422 in sendPaymentResult
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
    And check WISP receives a number of sendPaymentResult calls on the same position equal to configuration parameter scheduler.sendPaymentResultPollerMaxRetry is reached
    
    
Feature: retry done for sendPaymentResult if it responds with HTTP status 400 - Bad request [T_SPR_10]

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
    "pspTransactionId": "resSPR_400",
    "totalAmount": 10.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
       "transactionId": "#transaction_id#",
       "outcomePaymentGateway": "EFF",
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult retry check
   Scenario: 4. Check retry sendPaymentResult
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with OK in pspNotifyPayment
    And WISP replies to nodo-dei-pagamenti with HTTP status 400 in sendPaymentResult
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
    And check sendPaymentResult retry process starts
    
   # sendPaymentResult 200 before retry ends
   Scenario: 5. Nodo receives sendPaymentResult response with HTTP status 200 before retry process ends
    Given the 4. Check retry sendPaymentResult scenario executed successfully
    And WISP replies to nodo-dei-pagamenti with HTTP status 200 in sendPaymentResult before retry process ends
    Then check sendPaymentResult retry process ends