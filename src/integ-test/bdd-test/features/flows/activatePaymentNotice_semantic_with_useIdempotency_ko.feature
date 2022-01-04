Feature: semantic check for activatePaymentNoticeReq regarding idempotency - not use idempotency [SEM_APNR_19.1]

  Background:
    Given systems up
	And initial XML activatePaymentNotice
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:activatePaymentNoticeReq>
             <idPSP>70000000001</idPSP>
             <idBrokerPSP>70000000001</idBrokerPSP>
             <idChannel>70000000001_01</idChannel>
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
    
  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO
  Scenario: Execute again the same activatePaymentNotice request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And idempotencyKey with None in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
	And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response

  # Activate Phase 2 - PPT_ERRORE_IDEMPOTENZA
  Scenario Outline: Execute again the activatePaymentNotice request with same idempotencyKey before it expires
    Given the current timestamp
    And the Execute activatePaymentNotice request scenario executed successfully
    And <elem> with <value> in activatePaymentNotice
    And idempotencyKey in activatePaymentNotice is not expired yet
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
    Examples:
      | elem                 | value                    | soapUI test          |
      | noticeNumber         | 311456789012345678       | noticeNumber diverso |
      | fiscalCode           | 40000000001              | fiscalCodePA diverso |
      | amount               | 12.00                    | amount diverso       |
      | dueDate              | 2021-10-31               | dueDate diversa      |
      | paymentNote          | altraCausale             | paymentNote diverso  |
      | noticeNumber         | None                     | dueDateAssente       |
      | noticeNumber         | None                     | expirationTimeAssente|
      | noticeNumber         | None                     | paymentNoteAssente   |

  # Activate Phase 2 - PPT_PAGAMENTO_IN_CORSO
  Scenario: Execute again activatePaymentNotice request right after expirationTime has passed (before the execution of mod3Cancel poller)
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 10
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
    And the Execute activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
