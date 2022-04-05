Feature: sendPaymentResult sent to WISP with outcome KO when pspNotifyPayment KO [T_SPR_04]

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
       "authorizationCode": "resKO"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

   # sendPaymentResult check - outcome KO
   Scenario: 4. Check sendPaymentResult request
    Given the 3. Execute closePayment request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with KO in pspNotifyPayment
    Then check WISP receives sendPaymentResult with request   
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "KO"
    }
    """


Feature: sendPaymentResult sent to WISP with outcome KO when pspNotifyPayment in timeout and token has expired [T_SPR_05]

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
    And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000 

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

  # Mod3Cancel Phase
  Scenario: 4. Execute mod3Cancel poller
    Given the 3. Execute closePayment request scenario executed successfully
    When job mod3Cancel triggered after 2 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    
   # sendPaymentResult check - outcome KO
   Scenario: 5. Check sendPaymentResult request
    Given the 4. Execute mod3Cancel poller scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with Timeout in pspNotifyPayment
    Then check WISP receives sendPaymentResult with request   
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "KO"
    }
    """    
    
    
 Feature: sendPaymentResult sent to WISP with outcome KO when pspNotifyPayment with malformed response and token has expired [T_SPR_06]

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
    And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000 

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

  # Mod3Cancel Phase
  Scenario: 4. Execute mod3Cancel poller
    Given the 3. Execute closePayment request scenario executed successfully
    When job mod3Cancel triggered after 2 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    
   # sendPaymentResult check - outcome KO
   Scenario: 5. Check sendPaymentResult request
    Given the 4. Execute mod3Cancel poller scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with Malformed in pspNotifyPayment
    Then check WISP receives sendPaymentResult with request   
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "KO"
    }
    """    


 Feature: sendPaymentResult sent to WISP with outcome KO when psp is not reacheable and token has expired [T_SPR_07]

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
    And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000 

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
       "authorizationCode": "resIrr"
       }
    }
    """
#  And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

  # Mod3Cancel Phase
  Scenario: 4. Execute mod3Cancel poller
    Given the 3. Execute closePayment request scenario executed successfully
    When job mod3Cancel triggered after 2 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    
   # sendPaymentResult check - outcome KO
   Scenario: 5. Check sendPaymentResult request
    Given the 4. Execute mod3Cancel poller scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with Unreacheble in pspNotifyPayment
    Then check WISP receives sendPaymentResult with request   
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "KO"
    }
    """


Feature: sendPaymentResult sent to WISP with outcome KO when closePayment arrives after token has expired [T_SPR_08]

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
    And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000

  # activateIOPayment phase
  Scenario: 1. Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: 2. Execute nodoChiediInformazioniPagamento request
    Given the 1. Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  # Mod3Cancel Phase
  Scenario: 3. Execute mod3Cancel poller
    Given the 2. Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When job mod3Cancel triggered after 2 seconds
    Then verify the HTTP status code of mod3Cancel response is 200

  # closePayment phase
  Scenario: 4. Execute closePayment request
    Given the 3. Execute mod3Cancel poller scenario executed successfully
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
    
   # sendPaymentResult check - outcome KO
   Scenario: 5. Check sendPaymentResult request
    Given the 4. Execute closePayment request scenario executed successfully
    Then check WISP receives sendPaymentResult with request   
    """
    {
    "paymentTokens": [
      "$activateIOPaymentResponse.paymentToken"
    ],
    "pspTransactionId": "$closePaymentRequest.pspTransactionId",
    "outcome": "KO"
    }
    """    
    
