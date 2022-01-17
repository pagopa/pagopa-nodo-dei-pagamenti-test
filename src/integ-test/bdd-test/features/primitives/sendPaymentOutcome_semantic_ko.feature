Feature:  semantic checks for sendPaymentOutcomeReq

  Background:
    Given systems up    
    And initial XML sendPaymentOutcome soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:sendPaymentOutcomeReq>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_01</idChannel>
                 <password>pwdpwdpwd</password>
                 <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
                 <outcome>OK</outcome>
                 <!--Optional:-->
                 <details>
                    <paymentMethod>creditCard</paymentMethod>
                    <!--Optional:-->
                    <paymentChannel>app</paymentChannel>
                    <fee>2.00</fee>
                    <!--Optional:-->
                    <payer>
                       <uniqueIdentifier>
                          <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                          <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
                       </uniqueIdentifier>
                       <fullName>name</fullName>
                       <!--Optional:-->
                       <streetName>street</streetName>
                       <!--Optional:-->
                       <civicNumber>civic</civicNumber>
                       <!--Optional:-->
                       <postalCode>postal</postalCode>
                       <!--Optional:-->
                       <city>city</city>
                       <!--Optional:-->
                       <stateProvinceRegion>state</stateProvinceRegion>
                       <!--Optional:-->
                       <country>IT</country>
                       <!--Optional:-->
                       <e-mail>prova@test.it</e-mail>
                    </payer>
                    <applicationDate>2021-12-12</applicationDate>
                    <transferDate>2021-12-11</transferDate>
                 </details>
              </nod:sendPaymentOutcomeReq>
           </soapenv:Body>
        </soapenv:Envelope>
      """
	And EC new version

  # idPSP value check: idPSP not in db [SEM_SPO_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_SCONOSCIUTO

  # idPSP value check: idPSP with field ENABLED = N [SEM_SPO_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_DISABILITATO

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_SPO_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_SPO_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO

  # idChannel value check: idChannel not in db [SEM_SPO_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_SCONOSCIUTO

  # idChannel value check: idChannel with field ENABLED = N [SEM_SPO_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_DISABILITATO
 
    # password value check: wrong password for an idChannel [SEM_SPO_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given password with password in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTENTICAZIONE    
    
    # paymentToken value check: token+idPsp not present in POSITION_ACTIVATE table of nodo-dei-pagamenti db [SEM_SPO_09]
   Scenario: Check PPT_TOKEN_SCONOSCIUTO error on non-existent couple token+idPsp
    Given idPsp with 70000000001 in sendPaymentOutcomeReq 
    And paymentToken 111111111111111 in sendPaymentOutcomeReq 
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_TOKEN_SCONOSCIUTO
    
    # paymentToken value check: token+idPsp not present in POSITION_ACTIVATE table of nodo-dei-pagamenti db [SEM_SPO_10]
   Scenario: Check PPT_TOKEN_SCONOSCIUTO error on non-existent couple token+idPsp
    Given idPsp with 70000000001 in sendPaymentOutcomeReq 
    And paymentToken 5ac599c3d8e148dca128a58e748323c9 in sendPaymentOutcomeReq #token present in POSITION_ACTIVATE table but associated to another idPsp
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_TOKEN_SCONOSCIUTO  
 
    # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_SPO_11]
   Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 91000000001 in sendPaymentOutcomeReq
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Configurazione intermediario-canale non corretta 
    