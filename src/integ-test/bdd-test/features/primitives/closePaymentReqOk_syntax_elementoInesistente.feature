Feature: syntax checks for closePayment outcome OK - Il 'parametro' indicato non esiste
 
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
       
      
      
# element value check - SIN_CP_08
Scenario Outline identificativoPsp: Check syntax error on empty body element value
    Given identificativoPsp Empty in closePayment request
    When PM sends closePayment to nodo-dei-pagamenti
    Then check "esito" is KO of closePayment response
    And check "descrizione" is "Il PSP indicato non esiste" of closePayment response
    And check errorCode is 404
    
# element value check - SIN_CP_14
Scenario Outline identificativoIntermediario: Check syntax error on empty body element value
    Given identificativoIntermediario Empty in closePayment request
    When PM sends closePayment to nodo-dei-pagamenti
    Then check "esito" is KO of closePayment response
    And check "descrizione" is "L'Intermediario indicato non esiste" of closePayment response
    And check errorCode is 404
	
# element value check - SIN_CP_17
Scenario Outline identificativoCanale: Check syntax error on empty body element value
    Given identificativoCanale Empty in closePayment request
    When PM sends closePayment to nodo-dei-pagamenti
    Then check "esito" is KO of closePayment response
    And check "descrizione" is "Il Canale indicato non esiste" of closePayment response
    And check errorCode is 404
	
# element value check - SIN_CP_31.1
Scenario Outline fee upper than totalAmount: Check syntax error if fee is upper than totalAmount
    Given fee = 45.00 in closePayment request
	And totalAmount = 12.00 in closePayment request
    When PM sends closePayment to nodo-dei-pagamenti
    Then check "esito" is KO of closePayment response
    And check "descrizione" is "Il Pagamento indicato non esiste" of closePayment response
    And check errorCode is 404
      
     