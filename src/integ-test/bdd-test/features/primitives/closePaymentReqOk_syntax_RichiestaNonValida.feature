Feature: syntax checks for closePayment outcome OK - Richiesta non valida
 
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
    And check "descrizione" is "Richiesta non valida" of closePayment response
    And check errorCode is 400
    
Examples:       
      | elem                           | value                                 | soapUI test |
      | totalAmount                    | Empty                                 | SIN_CP_23   |
      | totalAmount                    | 12,21                                 | SIN_CP_24   |
      | fee                            | Empty                                 | SIN_CP_28   |
      | fee                            | 12,32                                 | SIN_CP_29   |
	  | additionalPaymentInformations  | None 								   | SIN_CP_35   |
      
     