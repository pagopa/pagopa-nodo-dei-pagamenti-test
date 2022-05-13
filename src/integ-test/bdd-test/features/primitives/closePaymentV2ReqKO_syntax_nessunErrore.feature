Feature: syntax checks for closePayment-v2 outcome KO - Nessun errore
 
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

#closePayment-v2 phase - SIN_CP_03.2
    Scenario: Execute a closePayment-v2 request having two paymentTokens 
    Given initial json closePayment-v2 request
    """
        {"paymentTokens": [
            "$activatePaymentNoticeResponse.paymentToken",
            "lvzmsca2nli1kz98q9kn0q3if73cujtg"
            ],
        "outcome": "KO",
        "identificativoPsp": "70000000001",
        "tipoVersamento": "TPAY",
        "identificativoIntermediario": "70000000001",
        "identificativoCanale": "70000000001_03",
        "transactionId": "10063735",
        "totalAmount": 10.00,
        "fee": 0.00,
        "timestampOperation": "2012-04-23T18:25:43Z",
        "additionalPaymentInformations": {
              "key": "16648928"
            }
        }
    """ 
      
    Given paymentTokens array with two tokens
    When PM sends closePayment-v2 request to nodo-dei-pagamenti
    Then check "esito" is OK
    
# element value check - Nessun errore
Scenario Outline: Check no errors are raised
    Given <elem> with <value> in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check "esito" is OK of closePayment-v2 response
    
Examples:       
      | elem                           | value                                 | soapUI test |
      | identificativoPsp              | None                                  | SIN_CP_07   |
      | identificativoPsp              | Empty                                 | SIN_CP_08   |      
      | identificativoPSP              | 700000000017000000000170000000001700  | SIN_CP_09   |      
      | tipoVersamento                 | None                                  | SIN_CP_10   |
      | tipoVersamento                 | Empty                                 | SIN_CP_11   |
      | tipoVersamento                 | BBT                                   | SIN_CP_12   | 
      | tipoVersamento                 | BP                                    | SIN_CP_12   | 
      | tipoVersamento                 | AD                                    | SIN_CP_12   | 
      | tipoVersamento                 | CP                                    | SIN_CP_12   | 
      | tipoVersamento                 | PO                                    | SIN_CP_12   | 
      | tipoVersamento                 | OBEP                                  | SIN_CP_12   | 
      | tipoVersamento                 | JIF                                   | SIN_CP_12   | 
      | tipoVersamento                 | MYBK                                  | SIN_CP_12   | 
      | tipoVersamento                 | PPAL                                  | SIN_CP_12   | 
      | tipoVersamento                 | BPAY                                  | SIN_CP_12   |       
      | identificativoIntermediario    | None                                  | SIN_CP_13   |
      | identificativoIntermediario    | Empty                                 | SIN_CP_14   |
      | identificativoIntermediario    | 700000000017000000000170000000001700  | SIN_CP_15   |      
      | identificativoCanale           | None                                  | SIN_CP_16   |
      | identificativoCanale           | Empty                                 | SIN_CP_17   |
      | identificativoCanale           | 70000000001_0370000000001_0370000000  | SIN_CP_18   |     
      | transactionId                  | None                                  | SIN_CP_19   |
      | transactionId                  | Empty                                 | SIN_CP_20   |      
      | transactionId                  | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_21   |
      | totalAmount                    | None                                  | SIN_CP_22   |      
      | totalAmount                    | 12.321                                | SIN_CP_25   |
      | totalAmount                    | 1234567890.12                         | SIN_CP_26   |      
      | fee                            | None                                  | SIN_CP_27   |
      | fee                            | 12.321                                | SIN_CP_30   |
      | fee                            | 1234567890.12                         | SIN_CP_31   |
      | fee                            | 0.00                                  | SIN_CP_31.2 |      
	  | timestampOperation             | None								   | SIN_CP_32   |
	  | timestampOperation			   | Empty 								   | SIN_CP_33   |
	  | timestampOperation			   | 2012-04-23							   | SIN_CP_34   |
	  | timestampOperation			   | 2012-04-23T18:25:43				   | SIN_CP_34   |
	  | timestampOperation			   | 2012-04-23T18:25    				   | SIN_CP_34   |
      | additionalPaymentInformations  | None                                  | SIN_CP_35   |
      | additionalPaymentInformations  | Empty                                 | SIN_CP_36   |
	  | key                            | Empty 								   | SIN_CP_37   |
      | key                            | 10 occurrences of differt 'keys'      | SIN_CP_38   |
      
      