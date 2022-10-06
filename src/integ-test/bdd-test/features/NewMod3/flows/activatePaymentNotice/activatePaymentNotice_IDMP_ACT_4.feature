Feature: semantic check for activatePaymentNotice regarding idempotency

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice
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
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And initial XML paaAttivaRPT
      """
      <soapenv:Envelope
      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:ws="http://ws.pagamenti.telematici.gov/"
      xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
      <soapenv:Header/>
      </soapenv:Envelope>

      """
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response

  #DB check
  Scenario: Execute activatePaymentNotice request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And check datetime plus number of date 1 of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3