Feature: semantic check for activatePaymentNoticeReq regarding idempotency - not useIdempotency

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
    And nodo-dei-pagamenti has config parameter useIdempotency set to false

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_19.1]
  @runnable @lazy @dependentwrite 
  Scenario: Execute again the same activatePaymentNotice request
    Given the Execute activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_20.1]
  @runnable @lazy @dependentwrite 
  Scenario Outline: Execute again activatePaymentNotice request with same idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
    And <elem> with <value> in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations
    Examples:
      | elem           | value        | soapUI test            |
      | amount         | 12.00        | amount diverso         |
      | dueDate        | 2021-10-31   | dueDate diversa        |
      | paymentNote    | altraCausale | paymentNote diverso    |
      | dueDate        | None         | dueDate assente        |
      | expirationTime | None         | expirationTime assente |
      | paymentNote    | None         | paymentNote assente    |

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_21.2]
  @runnable @dependentread @lazy @dependentwrite 
  Scenario: Execute again activatePaymentNotice request right after expirationTime has passed (before the execution of mod3Cancel poller)
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
    And the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits expirationTime of activatePaymentNotice expires
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO SEM_APNR_21.3]
  @runnable @dependentread @lazy @dependentwrite 
  Scenario: Execute again activatePaymentNotice request right after expirationTime has passed
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    And the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits expirationTime of activatePaymentNotice expires
    And expirationTime with 6000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO [SEM_APNR_22.1]
  @runnable @dependentread @lazy @dependentwrite 
  Scenario: Execute again activatePaymentNotice request right after default_idempotency_key_validity_minutes has passed
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And the Execute activatePaymentNotice request scenario executed successfully
    And wait 70 seconds for expiration
    And expirationTime with 1000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    And restore initial configurations