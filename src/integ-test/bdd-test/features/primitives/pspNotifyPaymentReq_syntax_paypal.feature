Feature: syntax checks for pspNotifyPaymentReq - payPal [T_01]

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
        
        
  # nodoInoltraEsitoPagamentoPaypal phase
        Scenario: Execute nodoInoltraEsitoPagamentoPaypal request
        Given nodoChiediInformazioniPagamento request successfully executed 
        And initial nodoInoltraEsitoPagamentoPaypal request
        """
        {"idTransazione": "responseOK",
        "idTransazionePsp":"#id_transazione_psp#",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "70000000001",
        "identificativoPsp": "70000000001",
        "identificativoCanale": "70000000001_03",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"}
        """
        And identificativoCanale with SERVIZIO_NMP
        When WISP sends nodoInoltraEsitoPagamentoPaypalReq to nodo-dei-pagamenti
        Then check pspNotifyPaymentReq is sent to psp
        And check pspNotifyPaymentReq contains all required fields
        """
        <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pspfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
           <soapenv:Body>
              <pspfn:pspNotifyPaymentReq>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_03</idChannel>
                 <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
                 <paymentDescription>test</paymentDescription>
                 <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                 <companyName>company</companyName>
                 <creditorReferenceId>#iuv#</creditorReferenceId>
                 <debtAmount>10.00</debtAmount>
                 <transferList>
                    <transfer>
                       <idTransfer>1</idTransfer>
                       <transferAmount>10.00</transferAmount>
                       <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                       <IBAN>IT45R0760103200000000001016</IBAN>
                       <remittanceInformation>testPaGetPayment</remittanceInformation>
                    </transfer>
                 </transferList>
                 <paypalPayment>
                    <transactionId>responseOK</transactionId>
                    <pspTransactionId>114739uafX</pspTransactionId>
                    <totalAmount>10.00</totalAmount>
                    <fee>0.00</fee>
                    <timestampOperation>2012-04-23T18:25:43</timestampOperation>
                 </paypalPayment>
              </pspfn:pspNotifyPaymentReq>
           </soapenv:Body>
        </soapenv:Envelope>               
        """
        And check nodoInoltraEsitoPagamentoPaypal response contains {"esito": "OK"}
 