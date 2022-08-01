Feature:  semantic checks for closePayment-v1 request - check on amount and fee [SEM_CP_12]
 
  Background:
    Given systems up 
    And EC new version
    
   # activateIOPaymentReq phase
    Scenario: Execute activateIOPayment request
    Given initial XML activateIOPayment soap-request
	
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:activateIOPaymentReq>
             <idPSP>AGID_01</idPSP>
             <idBrokerPSP>97735020584</idBrokerPSP>
             <idChannel>97735020584_03</idChannel>
             <password>pwdpwdpwd</password>
             <!--Optional:-->
             <idempotencyKey>#idempotency_key#</idempotencyKey>
             <qrCode>
                <fiscalCode>#creditor_institution_code#</fiscalCode>
                <noticeNumber>#notice_number#</noticeNumber>
             </qrCode>
             <!--Optional:-->
             <expirationTime>60000</expirationTime>
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
                <fullName>IOname_112816qhge</fullName>
                <!--Optional:-->
                <streetName>IOstreet</streetName>
                <!--Optional:-->
                <civicNumber>IOcivic</civicNumber>
                <!--Optional:-->
                <postalCode>IOcode</postalCode>
                <!--Optional:-->
                <city>IOcity</city>
                <!--Optional:-->
                <stateProvinceRegion>IOstate</stateProvinceRegion>
                <!--Optional:-->
                <country>IT</country>
                <!--Optional:-->
                <e-mail>IO.test.prova@gmail.com</e-mail>
             </payer>
          </nod:activateIOPaymentReq>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    
    
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    
    # closePayment-v1 request phase  
    Scenario: Execute a closePayment-v1 request
    Given initial json closePayment-v1
    """
        {"paymentTokens": [
        "$activateIOPaymentResponse.paymentToken"
        ],
        "outcome": "OK",
        "identificativoPsp": "70000000001",
        "tipoVersamento": "BPAY",
        "identificativoIntermediario": "70000000001",
        "identificativoCanale": "70000000001_03",
        "pspTransactionId": "18345331",
        "totalAmount": 10.00,
        "fee": 2.00,
        "timestampOperation": "2020-08-01T18:25:43Z",
        "additionalPaymentInformations": {
              "transactionId": "11225398",
              "outcomePaymentGateway": "EFF",
              "authorizationCode": "resOK"
            }
        }    
    """

    And amount minus fee is different from POSITION_ACTIVATE.AMOUNT
    When PM sends closePayment-v1 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Il Pagamento indicato non esiste'
	And check errorCode is 404
 

    