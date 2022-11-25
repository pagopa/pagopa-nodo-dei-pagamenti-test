Feature: verify test flow paGetPayment, pspNotifyPayment and sendPaymentOutcome

  Background:
    Given systems up

  # Activate Phase
  Scenario: Execute activateIOPayment request
    Given initial XML activateIOPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:activateIOPaymentReq>
               <idPSP>#psp_AGID#</idPSP>
               <idBrokerPSP>#broker_AGID#</idBrokerPSP>
               <idChannel>#canale_AGID#</idChannel>
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
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And paymentToken exists of activateIOPayment response
    And paymentToken length is less than 36 of activateIOPayment response

  # Payment Phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the Execute activateIOPayment scenario executed successfully
    When WISP/PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  # Send payment to PSP Phase
  Scenario: Execute nodoInoltraEsitoPagamentoCarta request
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP/PM sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {
         "idPagamento": "$activateIOPaymentResponse.paymentToken",
         "RRN": 0,
         "identificativoPsp": "#psp#",
         "tipoVersamento": "CP",
         "identificativoIntermediario": "#psp#",
         "identificativoCanale": "#canale#",
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
    Given the Execute nodoInoltraEsitoPagamentoCarta request scenario executed successfully
    Then activateIOPayment response and pspNotifyPayment request are consistent

  # Send receipt phase
  Scenario: Execute sendPaymentOutcome request
    Given the Verify consistency between activateIOPaymentRes and pspNotifyPaymentReq scenario executed successfully
    And initial XML sendPaymentOutcome
    """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
                <idPSP>#psp#</idPSP>
                <idBrokerPSP>#psp#</idBrokerPSP>
                <idChannel>#canale#</idChannel>
                <password>pwdpwdpwd</password>
                <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
                <outcome>OK</outcome>
                <details>
                    <paymentMethod>creditCard</paymentMethod>
                    <paymentChannel>app</paymentChannel>
                    <fee>2.00</fee>
                    <payer>
                    <uniqueIdentifier>
                        <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
                    </uniqueIdentifier>
                    <fullName>John Doe</fullName>
                    <streetName>street</streetName>
                    <civicNumber>12</civicNumber>
                    <postalCode>89020</postalCode>
                    <city>city</city>
                    <stateProvinceRegion>MI</stateProvinceRegion>
                    <country>IT</country>
                    <e-mail>john.doe@test.it</e-mail>
                    </payer>
                    <applicationDate>2021-10-01</applicationDate>
                    <transferDate>2021-10-02</transferDate>
              </details>
            </nod:sendPaymentOutcomeReq>
        </soapenv:Body>
      </soapenv:Envelope>
    """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @runable
  Scenario: Execute paSendRT request
    Given the Execute sendPaymentOutcome request scenario executed successfully
    Then check EC receives paSendRT properly
    """
    $activateIOPayment.noticeNumber
    """

