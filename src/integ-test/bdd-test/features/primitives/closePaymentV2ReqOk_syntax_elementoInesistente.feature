Feature: syntax checks for closePayment-v2 outcome OK - Il 'parametro' indicato non esiste
 
 Background:     Given systems up
    And initial json closePayment-v2
    """
        {"paymentTokens": [
        "a3738f8bff1f4a32998fc197bd0a6b05"
        ],
        "outcome": "OK",
        "identificativoPsp": "70000000001",
        "tipoVersamento": "TPAY",
        "identificativoIntermediario": "70000000001",
        "identificativoCanale": "70000000001_03",
        "transactionId": "18345331",
        "totalAmount": 12.00,
        "fee": 2.00,
        "timestampOperation": "2033-04-23T18:25:43Z",
        "additionalPaymentInformations": {
              "key": "11225398"
            }
        }    
    """
       
      
      
# element value check - SIN_CP_31.1
Scenario Outline fee upper than totalAmount: Check syntax error if fee is upper than totalAmount
    Given fee = 45.00 in closePayment-v2 request
	And totalAmount = 12.00 in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check "esito" is KO of closePayment-v2 response
    And check "descrizione" is "Il Pagamento indicato non esiste" of closePayment-v2 response
    And check errorCode is 404
      
     