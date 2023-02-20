Feature: semantic check for activatePaymentNoticeReq regarding idempotency - use idempotency

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And nodo-dei-pagamenti has config parameter useIdempotency set to true
    

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_19.1]
  @ciao
  Scenario: Execute again the same activatePaymentNotice request without idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
    And idempotencyKey with None in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_ERRORE_IDEMPOTENZA [SEM_APNR_20]
  Scenario: Execute again the activatePaymentNotice request with same idempotencyKey before it expires
    Given the Execute activatePaymentNotice request scenario executed successfully
    And random noticeNumber in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response

  # Activate Phase 2 - PPT_ERRORE_IDEMPOTENZA [SEM_APNR_20]
  @ciao
  Scenario Outline: Execute again the activatePaymentNotice request with same idempotencyKey before it expires
    Given the Execute activatePaymentNotice request scenario executed successfully
    And wait 2 seconds for expiration
    And expirationTime with 60000 in activatePaymentNotice
    And <elem> with <value> in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
    And restore initial configurations
    Examples:
      | elem           | value        | soapUI test            |
      | fiscalCode     | 44444444444  | fiscalCodePA diverso   |
      | amount         | 12.00        | amount diverso         |
      | dueDate        | None         | dueDate assente        |
      | dueDate        | 2021-10-31   | dueDate diversa        |
      | paymentNote    | None         | paymentNote assente    |
      | paymentNote    | altraCausale | paymentNote diverso    |
      | expirationTime | None         | expirationTime assente |

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO SEM_APNR_21]
  @ciao
  Scenario: Execute again activatePaymentNotice request right after expirationTime has passed (before the execution of mod3Cancel poller)
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
    And the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits expirationTime of activatePaymentNotice expires
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO SEM_APNR_21.1]
  @ciao
  Scenario: Execute again activatePaymentNotice request right after expirationTime has passed
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    And the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits expirationTime of activatePaymentNotice expires
    And expirationTime with 8000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_22]
  @ciao
  Scenario: Execute again activatePaymentNotice request right after default_idempotency_key_validity_minutes has passed
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits 70 seconds for expiration
    And expirationTime with 1000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_23.1]
  @ciao
  Scenario: Execute agin activatePaymentNotice request except for missing idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
    And idempotencyKey with None in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 1 - syntax error: no value of idPSP [IDMP_ACT_15.1]
  Scenario: Execute activatePaymentNotice request with an empty idPSP
    Given idPSP with Empty in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNotice response

  # Activate Phase 2 - after a syntax error regarding no value of idPSP [IDMP_ACT_15.1]
  @ciao
  Scenario: Execute formally correct activatePaymentNotice request with same idempotencyKey before it expires
    Given the Execute activatePaymentNotice request with an empty idPSP scenario executed successfully
    And idPSP with #psp# in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 1 - semantic error: wrong password [IDMP_ACT_15.2]
  Scenario: Execute activatePaymentNotice request with wrong password
    Given password with wrongPassword in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNotice response

  # Activate Phase 2 - after a semantic error regarding wrong password [IDMP_ACT_15.2]
  @ciao
  Scenario: Execute formally correct activatePaymentNotice request with same idempotencyKey before it expires
    Given the Execute activatePaymentNotice request with wrong password scenario executed successfully
    And password with pwdpwdpwd in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - different PSP in second activate [IDMP_ACT_16.1]
  @ciao
  Scenario: Execute activatePaymentNotice request with different idPSP-idBrokerPSP-idChannel before idempotencyKey expires
    Given the Execute activatePaymentNotice request scenario executed successfully
    And idPSP with 40000000001 in activatePaymentNotice
    And idBrokerPSP with 40000000001 in activatePaymentNotice
    And idChannel with 40000000001_01 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - different position in second activate [IDMP_ACT_17]
  @ciao
  Scenario Outline: Execute activatePaymentNotice request with different fiscalCode, right after default_idempotency_key_validity_minutes has passed
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    Given the Execute activatePaymentNotice request scenario executed successfully
    And wait 70 seconds for expiration
    And fiscalCode with 44444444444 in activatePaymentNotice
    And PSP waits 1 seconds for expiration
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And restore initial configurations


  # Mod3Cancel Phase - [IDMP_ACT_20]
  Scenario: Execute mod3Cancel poller
    Given expirationTime with 2000 in activatePaymentNotice
    And the Execute activatePaymentNotice request scenario executed successfully
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200

  # Activate Phase 2 - different amount - [IDMP_ACT_20]
  @ciao
  Scenario: Execute activatePaymentNotice request with different amount
    Given the Execute mod3Cancel poller scenario executed successfully
    And amount with 8.00 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And restore initial configurations

  # IdempotencyCacheClean Phase [IDMP_ACT_23]
  Scenario: Execute idempotencyCacheClean poller
    Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
    And expirationTime with 2000 in activatePaymentNotice
    And the Execute activatePaymentNotice request scenario executed successfully
    When job idempotencyCacheClean triggered after 3 seconds
    Then verify the HTTP status code of idempotencyCacheClean response is 200

  # Activate Phase 2 - different amount [IDMP_ACT_23]
  @ciao
  Scenario: Execute activatePaymentNotice request with different amount
    Given the Execute idempotencyCacheClean poller scenario executed successfully
    And amount with 8.00 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - different amount - Not idempotency cache clean [IDMP_ACT_24]
  @ciao
  Scenario: Execute activatePaymentNotice request with different amount, after waiting 130 seconds
    Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
    And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And the Execute activatePaymentNotice request scenario executed successfully
    And amount with 8.00 in activatePaymentNotice
    And PSP waits 3 minutes for expiration
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
