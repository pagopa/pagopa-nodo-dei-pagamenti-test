Feature: semantic checks new for activatePaymentNoticeV2Request

  Background:
    Given systems up

  # SEM_APNV2_19
  Scenario: semantic check 19 (part 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>12345</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  Scenario: semantic check 19 (part 2)
    Given the semantic check 19 (part 1) executed succesfully
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>12345</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # SEM_APNV2_19.1
  Scenario: semantic check 19.1 (part 1)
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And wait 10 seconds for expiration
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>12345</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 19.1 (part 2)
    Given the semantic check 19.1 (part 1) executed succesfully
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>12345</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And restore initial configurations
    And wait 10 seconds for expiration
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

  # SEM_APNV2_20
  Scenario: semantic check 20 (part 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>100000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20 (part 2)
    Given the semantic check 20 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number_1#</noticeNumber>
      </qrCode>
      <expirationTime>100000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20 (part 3)
    Given the semantic check 20 (part 2) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_1#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20 (part 4)
    Given the semantic check 20 (part 3) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>6.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20 (part 5)
    Given the semantic check 20 (part 4) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-16</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 2 seconds for expiration

  Scenario: semantic check 20 (part 6)
    Given the semantic check 20 (part 5) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 2 seconds for expiration

  Scenario: semantic check 20 (part 7)
    Given the semantic check 20 (part 6) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20 (part 8)
    Given the semantic check 20 (part 7) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20 (part 9)
    Given the semantic check 20 (part 8) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response

  # SEM_APNV2_20.1
  Scenario: semantic check 20.1 (part 1)
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And wait 10 seconds for expiration
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>100000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 2)
    Given the semantic check 20.1 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number_1#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 3)
    Given the semantic check 20.1 (part 2) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_1#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 4)
    Given the semantic check 20.1 (part 3) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>11.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 5)
    Given the semantic check 20.1 (part 4) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-16</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 6)
    Given the semantic check 20.1 (part 5) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 7)
    Given the semantic check 20.1 (part 6) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 8)
    Given the semantic check 20.1 (part 7) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration

  Scenario: semantic check 20.1 (part 9)
    Given the semantic check 20.1 (part 8) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And wait 1 seconds for expiration
    And restore initial configurations
    And wait 10 seconds for expiration
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

  # SEM_APNV2_21
  Scenario: semantic check 21 (part 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 8 seconds for expiration

  Scenario: semantic check 21 (part 2)
    Given the semantic check 21 (part 1) executed succesfully
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

  # SEM_APNV2_21.1
  Scenario: semantic check 21.1 (part 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 10 seconds for expiration

  Scenario: semantic check 21.1 (part 2)
    Given the semantic check 21.1 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>1000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

  # SEM_APNV2_21.2
  Scenario: semantic check 21.2 (part 1)
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 4 seconds for expiration

  Scenario: semantic check 21.2 (part 2)
    Given the semantic check 21.2 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And restore initial configurations
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

  # SEM_APNV2_21.3
  Scenario: semantic check 21.3 (part 1)
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 4 seconds for expiration

  Scenario: semantic check 21.3 (part 2)
    Given the semantic check 21.3 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>9000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And restore initial configurations
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

  # SEM_APNV2_22
  Scenario: semantic check 22 (part 1)
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And wait 10 seconds for expiration
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
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
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 70 seconds for expiration

  Scenario: semantic check 22 (part 2)
    Given the semantic check 22 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>1000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And restore initial configurations
    And wait 10 seconds for expiration

  # SEM_APNV2_22.1
  Scenario: semantic check 22.1 (part 1)
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And nodo-dei-pagamenti has config parameter useIdempotency set to false
    And wait 10 seconds for expiration
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
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
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And wait 70 seconds for expiration

  Scenario: semantic check 22.1 (part 2)
    Given the semantic check 22.1 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>1000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And restore initial configurations
    And wait 10 seconds for expiration
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

  # SEM_APNV2_23
  Scenario: semantic check 23 (part 1)
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>12345</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-12</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  Scenario: semantic check 23 (part 2)
    Given the semantic check 23 (part 1) executed succesfully
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key_1#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-12</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

  # SEM_APNV2_23.1
  Scenario: semantic check 23.1 (part 1)
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  Scenario: semantic check 23.1 (part 2)
    Given the semantic check 23.1 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>12345</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
    And restore initial configurations
    And checks the value None of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1
    And checks the value None of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

  # SEM_APNV2_26
  Scenario: semantic check 26
    Given initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And checks the value NotNone,None of the record at column ID of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'test' of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'metadati' of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'office' of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'DEBTOR' of the record at column SUBJECT_TYPE of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'paGetPaymentName' of the record at column FULL_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'paGetPaymentStreet' of the record at column STREET_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'paGetPayment99' of the record at column CIVIC_NUMBER of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 20155 of the record at column STREET_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'paGetPaymentCity' of the record at column CITY of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'paGetPaymentState' of the record at column STATE_PROVINCE_REGION of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'DE' of the record at column COUNTRY of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value 'paGetPaymentV2@test.it' of the record at column EMAIL of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value None of the record at column RETENTION_DATE of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value 'Y' of the record at column FLAG_FINAL_PAYMENT of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.fiscalCode of the record at column PA_FISCAL_CODE_SECONDARY of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value 'IT45R0760103200000000001016' of the record at column IBAN of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value '/RFB/00202200000217527/5.00/TXT/' of the record at column REMITTANCE_INFORMATION of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value 'paGetPaymentTest' of the record at column TRANSFER_CATEGORY of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value '1' of the record at column TRANSFER_IDENTIFIER of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value 'Y' of the record at column VALID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'PAYING' of the record at column STATUS of the table POSITION_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
    And checks the value 'PAYING' of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
    And checks the value 'N' of the record at column ACTIVATION_PENDING of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value 77777777777 of the record at column BROKER_PA_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value 77777777777_08 of the record at column STATION of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.amount of the record at column AMOUNT of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value 'NA' of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value 'MOD3' of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value 'N' of the record at column FLAG_IO of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value 'PAYING' of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
    And checks the value 'PAYING' of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
    And checks the value NotNone,None of the record at column UPDATED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Request.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query position_activate on db nodo_online under macro NewMod1

  # SEM_APNV2_27
  Scenario: semantic check 27 (part 1)
    Given initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati10</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata is Empty of activatePaymentNoticeV2 response
    And controls the value chiaveok is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    And controls the value chiaveok is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

  Scenario: semantic check 27 (part 2)
    Given the semantic check 27 (part 1) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati11</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check key is CHIAVEOKFINNULL of activatePaymentNoticeV2 response
    And controls the value CHIAVEOKFINNULL is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    And controls the value CHIAVEOKFINNULL is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

  Scenario: semantic check 27 (part 3)
    Given the semantic check 27 (part 2) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati12</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata is Empty of activatePaymentNoticeV2 response
    And controls the value CHIAVEOKFININF is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    And controls the value CHIAVEOKFININF is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

  Scenario: semantic check 27 (part 4)
    Given the semantic check 27 (part 3) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati13</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata is Empty of activatePaymentNoticeV2 response
    And controls the value CHIAVEOKINIZSUP is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    And controls the value CHIAVEOKINIZSUP is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

  Scenario: semantic check 27 (part 5)
    Given the semantic check 27 (part 4) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati14</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata is Empty of activatePaymentNoticeV2 response
    And controls the value chiaveminuscola is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    And controls the value chiaveminuscola is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

  Scenario: semantic check 27 (part 6)
    Given the semantic check 27 (part 5) executed succesfully
    And initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>metadati</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check key is CHIAVEOK of activatePaymentNoticeV2 response
    And controls the value CHIAVEOK is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
    And controls the value CHIAVEOK is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

  # SEM_APNV2_28
  Scenario: semantic check 28
    Given initial xml activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_response
    And trim blank spaces of activatePaymentNoticeV2_response
    And controls activatePaymentNoticeV2_response is contained in the record at column REGEXP_REPLACE(TO_CHAR(RESPONSE), '\s+', '') of the table IDEMPOTENCY_CACHE retrived by the query position_activate on db nodo_online under macro NewMod1

# da implementare in query_AutomationTest.json:
# "NewMod1" : {"idempotency_cache": "SELECT columns FROM table_name WHERE IDEMPOTENCY_KEY = '$activatePaymentNoticeV2Request.idempotencyKey'",
#              "metadata": "SELECT columns FROM table_name WHERE POSITION_SERVICE.PA_FISCAL_CODE='$activatePaymentNoticeV2Request.fiscalCode' AND POSITION_SERVICE.NOTICE_ID='$activatePaymentNoticeV2Request.noticeNumber' AND POSITION_PAYMENT_PLAN.AMOUNT='$activatePaymentNoticeV2Request.amount'",
#              "position_activate" : "SELECT columns FROM table_name WHERE NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode'",
#              "position_service" = "SELECT columns FROM table_name WHERE POSITION_SERVICE.PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode' AND POSITION_SERVICE.NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber'",
#              "position_payment_plan" = "SELECT columns FROM table_name WHERE POSITION_SERVICE.PA_FISCAL_CODE='$activatePaymentNoticeV2Request.fiscalCode' AND POSITION_SERVICE.NOTICE_ID='$activatePaymentNoticeV2Request.noticeNumber' AND POSITION_PAYMENT_PLAN.AMOUNT='$activatePaymentNoticeV2Request.amount'",
#              "position_status_snapshot" = "SELECT columns FROM table_name WHERE POSITION_STATUS_SNAPSHOT.PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode' AND POSITION_STATUS_SNAPSHOT.NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber'",
#              "position_payment" = "SELECT columns FROM table_name WHERE POSITION_PAYMENT.PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode' AND POSITION_PAYMENT.NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber'",
#              "position_payment_status_snapshot" = "SELECT columns FROM table_name WHERE POSITION_PAYMENT_STATUS_SNAPSHOT.PA_FISCAL_CODE = '$activatePaymentNoticeV2Request.fiscalCode' AND POSITION_PAYMENT_STATUS_SNAPSHOT.NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber'"}

# da implementare in step.py:
# @step("controls the value {value} is contained in the record at column {column} of the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
#   ...
# @step("trim blank spaces of {primitive}")
#   ...
# @step("controls {primitive} is contained in the record at column {column} of the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
#   ...