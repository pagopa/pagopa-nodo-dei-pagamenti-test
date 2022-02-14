Feature: semantic checks for pspNotifyPaymentReq - CreditCard [T_02]

  Background:
    Given systems up
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                     <idPSP>70000000001</idPSP>
                     <idBrokerPSP>70000000001</idBrokerPSP>
                     <idChannel>70000000001_01</idChannel>
                     <password>pwdpwdpwd</password>
                     <!--Optional:-->
                     <idempotencyKey>#idempotency_key#</idempotencyKey>
                     <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>#notice_number#</noticeNumber>
                     </qrCode>
                     <!--Optional:-->
                     <expirationTime>6000</expirationTime>
                     <amount>10.00</amount>
                     <!--Optional:-->
                     <dueDate>2021-12-12</dueDate>
                     <!--Optional:-->
                     <paymentNote>responseFull</paymentNote>
                     <!--Optional:-->
                    <payer>
                        <uniqueIdentifier>
                           <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                           <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
                        </uniqueIdentifier>
                        <fullName>name</fullName>
                        <!--Optional:-->
                        <streetName>street</streetName>
                        <!--Optional:-->
                        <civicNumber>civic</civicNumber>
                        <!--Optional:-->
                        <postalCode>code</postalCode>
                        <!--Optional:-->
                        <city>city</city>
                        <!--Optional:-->
                        <stateProvinceRegion>state</stateProvinceRegion>
                        <!--Optional:-->
                        <country>IT</country>
                        <!--Optional:-->
                        <e-mail>test.prova@gmail.com</e-mail>
                     </payer>
                </nod:activateIOPaymentReq>
            </soapenv:Body>
        </soapenv:Envelope>
      """
    And EC new version

  Scenario: Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200
        
        
  # nodoInoltraEsitoPagamentoCarte phase
  Scenario: Execute nodoInoltraEsitoPagamentoCarte request
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
        """
        {
        "RRN":10026669,
        "tipoVersamento":"CP",
        "idPagamento":"$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario":"40000000001",
        "identificativoPsp":"40000000001",
        "identificativoCanale":"40000000001_06",
        "importoTotalePagato":10.00,
        "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo":"resOK",
        "esitoTransazioneCarta":"00"}
        """
 #       And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of inoltroEsito/carta response is 200
    And check esito is OK of inoltroEsito/carta response
    Then activateIOPayment response and pspNotifyPayment request are consistent
    And check that pspNotifyPaymentReq <element> is correctly filled with <value>

      | element               | value                                                                                               |
      | idPSP                 | $nodoInoltraEsitoPagamentoCarteRequest.identificativoPsp                                            |
      | idBrokerPSP           | $nodoInoltraEsitoPagamentoCarteRequest.identificativoIntermediario                                  |
      | idChannel             | $nodoInoltraEsitoPagamentoCarteRequest.identificativoCanale                                         |
      | paymentToken          | $activateIOPaymentResponse.paymentToken                                                             |
      | paymentDescription    | $paGetPaymentResponse.data.description                                                              |
      | fiscalCodePA          | $activateIOPaymentRequest.qrCode.fiscalCode                                                         |
      | companyName           | $paGetPaymentResponse.data.companyName                                                              |
        | creditorReferenceId       | $paGetPaymentResponse.data.creditorReferenceId                                                         |
        | debtAmount                | $paGetPaymentResponse.data.paymentAmount                                                               |
        | idTransfer                | $paGetPaymentResponse.data.transferList.transfer{n}.idTransfer                                         |
        | transferAmount            | $paGetPaymentResponse.data.transferList.transfer{n}.transferAmount                                     |
        | fiscalCodePA              | $paGetPaymentResponse.data.transferList.transfer{n}.fiscalCodePA                                       |
        | IBAN                      | $paGetPaymentResponse.data.transferList.transfer{n}.IBAN                                               |
        | remittanceInformation     | $paGetPaymentResponse.data.transferList.transfer{n}.remittanceInformation                              |
        | rrn                       | $nodoInoltraEsitoPagamentoCarteRequest.RRN                                                             |
        | outcomePaymentGateway     | $nodoInoltraEsitoPagamentoCarteRequest.esitoTransazioneCarta                                           |
        | totalAmount               | $nodoInoltraEsitoPagamentoCarteRequest.importoTotalePagato                                             |
        | fee                       | $nodoInoltraEsitoPagamentoCarteRequest.importoTotalePagato-$paGetPaymentResponse.data.paymentAmount    |
        | timestampOperation        | $nodoInoltraEsitoPagamentoCarteRequest.timestampOperazione                                             |
        | authorizationCode         | $nodoInoltraEsitoPagamentoCarteRequest.codiceAutorizzativo                                             |
        
        And check nodoInoltraEsitoPagamentoCarte response contains {"esito": "OK"}
 