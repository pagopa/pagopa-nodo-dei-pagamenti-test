Feature: syntax checks for closePayment outcome OK - Nessun errore
 
 Background: Given systems up
			 End EC new version
			 
#activateIOPaymentReq phase
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
                        <fullName>IOname_090110YZJp</fullName>
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
	
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

#closePayment phase - SIN_CP_03.2
    Scenario: Execute a closePayment request having two paymentTokens 
    Given initial json closePayment request
    """
        {"paymentTokens": [
            "$activatePaymentNoticeResponse.paymentToken",
            "lvzmsca2nli1kz98q9kn0q3if73cujtg"
            ],
        "outcome": "OK",
        "identificativoPsp": "70000000001",
        "tipoVersamento": "BPAY",
        "identificativoIntermediario": "70000000001",
        "identificativoCanale": "70000000001_03",
        "pspTransactionId": "10063735",
        "totalAmount": 10.00,
        "fee": 0.00,
        "timestampOperation": "2012-04-23T18:25:43Z",
        "additionalPaymentInformations": {
              "transactionId": "16648928",
              "outcomePaymentGateway": "EFF",
              "authorizationCode": "yenhcunuy37dhu3n7fhjer783hc"
            }
        }
    """ 
      
    Given paymentTokens array with two tokens
    When PM sends closePayment request to nodo-dei-pagamenti
    Then check "esito" is OK
    
# element value check - Nessun errore
Scenario Outline: Check no error are raised
    Given <elem> with <value> in closePayment request
    When PM sends closePayment to nodo-dei-pagamenti
    Then check "esito" is OK of closePayment response
    
Examples:       
      | elem                           | value                                 | soapUI test |
      | pspTransactionId               | Empty                                 | SIN_CP_20   |
      | fee                            | 0.00                                  | SIN_CP_31.2 |
      | transactionId                  | Empty                                 | SIN_CP_38   |
      | outcomePaymentGateway          | Empty                                 | SIN_CP_41   |
      | authorizationCode              | Empty                                 | SIN_CP_44   |
      