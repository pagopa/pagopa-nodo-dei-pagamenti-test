Feature: verify test flow paGetPayment, pspNotifyPayment and sendPaymentOutcome

  Background:
    Given systems up
    Given initial XML activateIOPayment
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
    When WISP/PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  # Send payment to PSP Phase
  Scenario: Execute nodoInoltraEsitoPagamentoCarta request
    Given the nodoChiediInformazioniPagamento scenario executed successfully
    When WISP/PM sends REST GET inoltroEsito/carta to nodo-dei-pagamenti
    """
    {
         "idPagamento": "$activateIOPaymentResponse.paymentToken",
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
    Then verify the HTTP status code of inoltroEsito/carta response is 200
    Then check esito is OK of inoltroEsito/carta response

  # Verify PA response is coherent with PSP Request
  Scenario: Verify consistency between activateIOPaymentRes and pspNotifyPaymentReq
    Given the nodoChiediInformazioniPagamento scenario executed successfully
    Then activateIOPaymentResp and pspNotifyPaymentReq are consistent

  # Send receipt phase
  Scenario: Execute sendPaymentOutcome request
    Given the nodoChiediInformazioniPagamento scenario executed successfully
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti using the token
    Then check outcome is OK of sendPaymentOutcome response

  Scenario: Execute paSentRT request
    Given the Execute sendPaymentOutcome request scenario executed successfully
    Then check EC receives paSendRT properly

