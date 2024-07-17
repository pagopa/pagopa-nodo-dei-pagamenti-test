Feature: syntax checks for pspNotifyPaymentReq - payPal [T_01] 126

  Background:
    Given systems up
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activateIOPaymentReq>
                     <idPSP>#psp_AGID#</idPSP>
                     <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                     <idChannel>#canale_AGID#</idChannel>
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
    
  
  Scenario: 1. Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: 2. Execute nodoChiediInformazioniPagamento request
    Given the 1. Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200
        
  @PM     
  # nodoInoltraEsitoPagamentoPaypal phase
  Scenario: 3. Execute nodoInoltraEsitoPagamentoPaypal request
    Given the 2. Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP sends rest POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {"idTransazione": "responseOK",
    "idTransazionePsp":"$activateIOPayment.idempotencyKey",
    "idPagamento": "$activateIOPaymentResponse.paymentToken",
    "identificativoIntermediario": "#psp#",
    "identificativoPsp": "#psp#",
    "identificativoCanale": "#canale#",
    "importoTotalePagato": 10.00,
    "timestampOperazione": "2012-04-23T18:25:43Z"}
    """
#    And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is OK of inoltroEsito/paypal response
