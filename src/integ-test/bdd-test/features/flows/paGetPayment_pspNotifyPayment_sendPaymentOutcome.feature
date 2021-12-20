Feature: verify test flow paGetPayment, pspNotifyPayment and sendPaymentOutcome

  Background:
    Given systems up
    Given initial activateIOPaymentReq soap-request
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:activateIOPaymentReq>
               <idPSP>AGID_01</idPSP>
               <idBrokerPSP>97735020584</idBrokerPSP>
               <idChannel>97735020584_03</idChannel>
               <password>pwdpwdpwd</password>
               <idempotencyKey>#idempotency_key#</idempotencyKey>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
               <amount>120.00</amount>
            </nod:activateIOPaymentReq>
         </soapenv:Body>
      </soapenv:Envelope>
    """

  # Activate Phase
  Scenario: Execute activateIOPayment request
    When IO sends an activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is OK
    And token exists and check

  # Payment Phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the activate phase executed successfully
    When WISP/PM sends an informazioniPagamento to nodo-dei-pagamenti using the token of the activate phase
    Then verify the HTTP status code response is 200

  # Send payment to PSP Phase
  Scenario: Execute nodoInoltraEsitoPagamentoCarta request
    Given the payment phase executed successfully
    When WISP/PM sends an inoltroEsito/Carta to nodo-dei-pagamenti using the token and PSP/Canale data
    Then verify esito is OK

  # Verify PA response is coherent with PSP Request
  Scenario: Verify consistency between activateIOPaymentRes and pspNotifyPaymentReq
    Given the payment notify phase executed successfully
    Then activateIOPaymentResp and pspNotifyPaymentReq are consistent

  # Send receipt phase
  Scenario: Execute sendPaymentOutcome request
    Given the payment notify phase executed successfully
    When PSP sends sendPaymentOutcomeReq to nodo-dei-pagamenti using the token
    Then check outcome is OK

  Scenario: Execute paSentRT request
    Given the sendPaymentOutcomeReq executed successfully
    Then EC receives paSendRT request by nodo-dei-pagamenti

