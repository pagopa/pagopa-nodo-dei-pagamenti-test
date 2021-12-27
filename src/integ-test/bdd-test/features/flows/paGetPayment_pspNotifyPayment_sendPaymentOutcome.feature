Feature: verify test flow paGetPayment, pspNotifyPayment and sendPaymentOutcome

  Background:
    Given systems up
    Given initial XML for activateIOPayment
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
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
#    And token exists and check
    And paymentToken exists of activateIOPayment response
    And paymentToken length is less than 36 of activateIOPayment response

  # Payment Phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the activateIOPayment scenario executed successfully
    And save the paymentToken of activateIOPayment response
    And initial JSON for informazioniPagamento
    And rest-request informazioniPagamento with param idPagamento equals to $paymentToken
    When WISP/PM sends REST informazioniPagamento to nodo-dei-pagamenti
    Then verify the HTTP response status code of informazioniPagamento response is 200

  # Send payment to PSP Phase
  Scenario: Execute nodoInoltraEsitoPagamentoCarta request
    Given the nodoChiediInformazioniPagamento scenario executed successfully
    And save the paymentToken of activateIOPayment response
    Given initial JSON for inoltroEsito/carta
    """
    {
         "idPagamento": "$paymentToken",
         "RRN": 0,
         "identificativoPsp": "40000000001",
         "tipoVersamento": "CP",
         "identificativoIntermediario": "40000000001",
         "identificativoCanale": "40000000001_06",
         "importoTotalePagato": 20.1,
         "timestampOperazione": "2012-04-23T18:25:43Z",
         "codiceAutorizzativo": "666666",
         "esitoTransazioneCarta": "ok"
     }
    """
    And rest-request inoltroEsito/carta with param idPagamento equals to $paymentToken
    When WISP/PM sends REST inoltroEsito/carta to nodo-dei-pagamenti
    Then verify the HTTP response status code of inoltroEsito/carta response is 200
    Then check esito is OK of inoltroEsito/carta response

  # Verify PA response is coherent with PSP Request
  Scenario: Verify consistency between activateIOPaymentRes and pspNotifyPaymentReq
    Given the payment notify phase executed successfully
    Then activateIOPaymentResp and pspNotifyPaymentReq are consistent

  # Send receipt phase
  Scenario: Execute sendPaymentOutcome request
    Given the payment notify phase executed successfully
    When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti using the token
    Then check outcome is OK

  Scenario: Execute paSentRT request
    Given the sendPaymentOutcomeReq executed successfully
    Then EC receives paSendRT request by nodo-dei-pagamenti

