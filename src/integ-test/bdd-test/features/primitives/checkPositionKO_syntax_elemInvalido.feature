Feature: syntax checks for checkPosition outcome KO - <elem> invalido
 
 Background:     Given systems up
    And initial json checkPosition
    """
       {"idPSP": "AGID_01",
        "idBrokerPSP": "97735020584",
        "idChannel": "97735020584_02",
        "password": "${passwordAgiD}",
        "positionslist": [
                {
                    "fiscalCode": "#creditor_institution_code#", 
                    "noticeNumber": "#notice_number#"
                }
            ]
        }   
    """
       
      
      
# element value check
Scenario Outline: Check syntax error on invalid body element value
    Given <elem> with <value> in checkPosition request
    When PM sends checkPosition to nodo-dei-pagamenti
    Then check "esito" is KO of checkPosition response
    And check "descrizione" is "<elem> invalido" of checkPosition response
    And check errorCode is 400
    
Examples:       
      | elem                           | value                                 | soapUI test |
      | idPsp                          | None                                  | SIN_CPO_01  |
      | idPsp                          | Empty                                 | SIN_CPO_02  |
      | idPsp                          | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPO_03  |
      | idBrokerPSP                    | None                                  | SIN_CPO_04  |
      | idBrokerPSP                    | Empty                                 | SIN_CPO_05  |
      | idBrokerPSP                    | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPO_06  |
      | idChannel                      | None                                  | SIN_CPO_07  |
      | idChannel                      | Empty                                 | SIN_CPO_08  |
      | idChannel                      | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPO_09  |
      | password                       | None                                  | SIN_CPO_10  |
      | password                       | Empty                                 | SIN_CPO_11  |
      | password                       | 87cacaf                               | SIN_CPO_12  |
      | password                       | 87cacaf799cadf9v                      | SIN_CPO_13  |
      | positionslist                  | None                                  | SIN_CPO_14  |
      | fiscalCode                     | None                                  | SIN_CPO_16  | 
      | fiscalCode                     | Empty                                 | SIN_CPO_17  |
      | fiscalCode                     | 1234567890                            | SIN_CPO_18  |
      | fiscalCode                     | 123456789012                          | SIN_CPO_19  |
      | fiscalCode                     | 1234567tg89                           | SIN_CPO_20  |
      | fiscalCode                     | 1234$£87909                           | SIN_CPO_20  |
      | noticeNumber                   | None                                  | SIN_CPO_21  |
      | noticeNumber                   | Empty                                 | SIN_CPO_22  |
      | noticeNumber                   | 12345678901234567                     | SIN_CPO_23  |
      | noticeNumber                   | 1234567890123456789                   | SIN_CPO_24  |
      | noticeNumber                   | 12345678901re45678                    | SIN_CPO_25  |
      | noticeNumber                   | 123456789012$£5678                    | SIN_CPO_25  |