Feature: syntax checks for closePayment outcome OK - <elem> invalido
 
 Background:     Given systems up
    And initial json closePayment
    """
        {"paymentTokens": [
        "a3738f8bff1f4a32998fc197bd0a6b05"
        ],
        "outcome": "OK",
        "identificativoPsp": "70000000001",
        "tipoVersamento": "BPAY",
        "identificativoIntermediario": "70000000001",
        "identificativoCanale": "70000000001_03",
        "pspTransactionId": "18345331",
        "totalAmount": 12.00,
        "fee": 2.00,
        "timestampOperation": "2033-04-23T18:25:43Z",
        "additionalPaymentInformations": {
              "transactionId": "11225398",
              "outcomePaymentGateway": "EFF",
              "authorizationCode": "resOK"
            }
        }    
    """
       
      
      
# element value check
Scenario Outline: Check syntax error on invalid body element value
    Given <elem> with <value> in closePayment request
    When PM sends closePayment to nodo-dei-pagamenti
    Then check "esito" is KO of closePayment response
    And check "descrizione" is "<elem> invalido" of closePayment response
    And check errorCode is 400
    
Examples:       
      | elem                           | value                                 | soapUI test |
      | paymentTokens                  | None                                  | SIN_CP_01   |
      | paymentTokens                  | Empty                                 | SIN_CP_02   |
      | paymentTokens                  | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CP_03   |
      | paymentTokens                  | No []                                 | SIN_CP_03.1 |
      | outcome                        | None                                  | SIN_CP_04   |
      | outcome                        | Empty                                 | SIN_CP_05   |
      | outcome                        | OO                                    | SIN_CP_06   |
      | identificativoPSP              | None                                  | SIN_CP_07   |
      | identificativoPSP              | 700000000017000000000170000000001700  | SIN_CP_09   |
      | tipoVersamento                 | None                                  | SIN_CP_10   |
      | tipoVersamento                 | Empty                                 | SIN_CP_11   |
      | identificativoIntermediario    | None                                  | SIN_CP_13   |
      | identificativoIntermediario    | 700000000017000000000170000000001700  | SIN_CP_15   |
      | identificativoCanale           | None                                  | SIN_CP_16   |
      | identificativoCanale           | 70000000001_0370000000001_0370000000  | SIN_CP_18   |
      | pspTransactionId               | None                                  | SIN_CP_19   |
      | pspTransactionId               | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_21   |
      | totalAmount                    | None                                  | SIN_CP_22   |
      | totalAmount                    | 12.321                                | SIN_CP_25   |
      | totalAmount                    | 1234567890.12                         | SIN_CP_26   |
      | fee                            | None                                  | SIN_CP_27   |
      | fee                            | 12.321                                | SIN_CP_30   |
      | fee                            | 1234567890.12                         | SIN_CP_31   |
	  | timestampOperation             | None								   | SIN_CP_32   |
	  | timestampOperation			   | Empty 								   | SIN_CP_33   |
	  | timestampOperation			   | 2012-04-23							   | SIN_CP_34   |
	  | timestampOperation			   | 2012-04-23T18:25:43				   | SIN_CP_34   |
	  | timestampOperation			   | 2012-04-23T18:25    				   | SIN_CP_34   |
	  | transactionId                  | None 								   | SIN_CP_37   |
	  | transactionId                  | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_39   |
      | outcomePaymentGateway          | None 								   | SIN_CP_40   |
	  | outcomePaymentGateway          | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_42   |
	  | authorizationCode			   | None 								   | SIN_CP_43   |
	  | authorizationCode			   | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_45   | 
      
      
     