Feature: process checks for pspNotifyPayment - outcome KO [PRO_PNP_03]

  Background:
    Given systems up
    And initial XML activateIOPayment soap-request
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
    
    When IO sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    

  # nodoChiediInformazioniPagamento phase
        Scenario: Execute nodoChiediInformazioniPagamento request
        Given activateIOPayment request successfully executed 
        And initial nodoChiediInformazioniPagamento request
        """
        GET ​/informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken
        """
        When WISP sends nodoChiediInformazioniPagamentoReq to nodo-dei-pagamenti
        Then check the HTTP status code of nodoChiediInformazioniPagamento response is 200
        
        
  # nodoInoltraEsitoPagamentoCarte phase
        Scenario Outline: Check nodoInoltraEsitoPagamentoCarte response contains {"error": "Operazione in timeout"} when pspNotifyPaymentResponse is in timeout
        Given nodoChiediInformazioniPagamento request successfully executed 
        And initial nodoInoltraEsitoPagamentoCarte request
        """
        {"idPagamento":"$activateIOPaymentResponse.paymentToken",
        "RRN":10026669,
        "identificativoPsp":"70000000001",
        "tipoVersamento":"CP",
        "identificativoIntermediario":"70000000001",
        "identificativoCanale":"70000000001_03",
        "importoTotalePagato":10.00,
        "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo":"123456",
        "esitoTransazioneCarta":"00"}
        """
        And identificativoCanale with SERVIZIO_NMP
        When psp sends pspNotifyPaymentResponse with outcome KO
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <psp:pspNotifyPaymentRes>
                 <outcome>KO</outcome>
                 <!--Optional:-->
                 <fault>
                    <faultCode>CANALE_SEMANTICA</faultCode>
                    <faultString>Errore semantico dal psp</faultString>
                    <id>1</id>
                    <!--Optional:-->
                    <description>Errore dal psp</description>
                 </fault>
              </psp:pspNotifyPaymentRes>
           </soapenv:Body>
        </soapenv:Envelope>
        """
        Then check nodoInoltraEsitoPagamentoCarte response contains:
        {"esito" : "KO",
         "errorCode" :  "RIFPSP",
         “descrizione”: "Risposta negativa del Canale"}
 