Feature:  semantic checks for closePayment-v2 request

  Background:
    Given systems up 
    And EC new version
    And initial json closePayment-v2
    """
        {"paymentTokens": [
            "yxofodw4sday59z2s0s6j13fi0bgvhqf"
            ],
            "outcome": "OK",
            "identificativoPsp": "70000000001",
            "tipoVersamento": "TPAY",
            "identificativoIntermediario": "70000000001",
            "identificativoCanale": "70000000001_03",
            "transactionId": "13789546",
            "totalAmount": 10.00,
            "fee": 2.00,
            "timestampOperation": "2012-04-23T18:25:43Z",
            "additionalPaymentInformations": {
                  "key": "17782342"
                }
            }
    """
  
  # paymentToken value check: paymentToken not in db [SEM_CP_01]
  Scenario: Check "esito":"KO" on unknown paymentToken
    Given paymentToken with random string, not present in DB, in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Il Pagamento indicato non esiste'
    And check errorCode is 404
 
  # identificativoPsp value check: identificativoPsp not in db [SEM_CP_03]
  Scenario: Check "esito":"KO" on unknown identificativoPsp
    Given identificativoPsp with pspUnknown in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Il PSP indicato non esiste'
    And check errorCode is 404

  # identificativoPsp value check: identificativoPsp with field ENABLED = N [SEM_CP_04]
  Scenario: Check "esito":"KO" on disabled identificativoPsp
    Given identificativoPsp with NOT_ENABLED in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Il PSP indicato non esiste'
    And check errorCode is 404   

  # identificativoIntermediario value check: identificativoIntermediario not present in db [SEM_CP_05]
  Scenario: Check "esito":"KO" on unknown identificativoIntermediario
    Given identificativoIntermediario with brokerPspUnknown in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'L'intermediario indicato non esiste'
    And check errorCode is 404       
    
  # identificativoIntermediario value check: identificativoIntermediario with field ENABLED = N [SEM_SPO_06]
  Scenario: Check "esito":"KO" on disabled identificativoIntermediario
    Given identificativoIntermediario with INT_NOT_ENABLED in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'L'intermediario indicato non esiste'
    And check errorCode is 404    

  # identificativoCanale value check: identificativoCanale not in db [SEM_SPO_07]
  Scenario: Check "esito":"KO" on unknown identificativoCanale
    Given identificativoCanale with channelUnknown in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Il Canale indicato non esiste'
    And check errorCode is 404     
    
  # identificativoCanale value check: identificativoCanale with field ENABLED = N [SEM_SPO_08]
  Scenario: Check "esito":"KO" on disabled identificativoCanale
    Given identificativoCanale with CANALE_NOT_ENABLED in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Il Canale indicato non esiste'
    And check errorCode is 404  
    
  # identificativoCanale value check: identificativoCanale not enableb to BPAY [SEM_SPO_09]
  Scenario: Check "esito":"KO" on identificativoCanale not enableb to TPAY
    Given identificativoCanale with 70000000001_06 in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Configurazione psp-canale-tipoVersamento non corretta'
    And check errorCode is 404  
    
  # identificativoCanale value check: identificativoCanale with Modello di pagamento = ATTIVATO PRESSO PSP [SEM_SPO_10]
  Scenario: Check "esito":"KO" on identificativoCanale with Modello di pagamento = ATTIVATO_PRESSO_PSP
    Given identificativoCanale with 70000000001_01 in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Modello pagamento non valido'
    And check errorCode is 400  
  
  # identificativoIntermediario-identificativoCanale-identificativoPsp value check: not associated [SEM_SPO_11]
   Scenario: Check "esito":"KO" on identificativoPsp not associated to identificativoIntermediario and identificativoCanale
    Given identificativoPsp with IDPSPFNZ in closePayment-v2 request
    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check esito is KO 
    And check descrizione is 'Configurazione psp-canale non corretta'
    And check errorCode is 404
 

    