Feature: semantic checks for pspNotifyPaymentReq - CreditCard [T_02]

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
        And paGetPaymentResponse
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <paf:paGetPaymentRes>
                 <outcome>OK</outcome>
                 <data>
                    <creditorReferenceId>#iuv#</creditorReferenceId>
                    <paymentAmount>10.00</paymentAmount>
                    <dueDate>2021-05-30</dueDate>
                    <!--Optional:-->
                    <retentionDate>2021-12-30T12:12:12</retentionDate>
                    <!--Optional:-->
                    <lastPayment>1</lastPayment>
                    <description>test</description>
                    <!--Optional:-->
                    <companyName>company</companyName>
                    <!--Optional:-->
                    <officeName>office</officeName>
                    <debtor>
                       <uniqueIdentifier>
                          <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                          <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
                       </uniqueIdentifier>
                       <fullName>paGetPaymentName</fullName>
                       <!--Optional:-->
                       <streetName>paGetPaymentStreet</streetName>
                       <!--Optional:-->
                       <civicNumber>paGetPayment99</civicNumber>
                       <!--Optional:-->
                       <postalCode>20155</postalCode>
                       <!--Optional:-->
                       <city>paGetPaymentCity</city>
                       <!--Optional:-->
                       <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
                       <!--Optional:-->
                       <country>DE</country>
                       <!--Optional:-->
                       <e-mail>paGetPayment@test.it</e-mail>
                    </debtor>
                    <!--Optional:-->
                    <transferList>
                       <!--1 to 5 repetitions:-->
                       <transfer>
                          <idTransfer>1</idTransfer>
                          <transferAmount>10.00</transferAmount>
                          <fiscalCodePA>77777777777</fiscalCodePA>
                          <IBAN>IT45R0760103200000000001016</IBAN>
                          <remittanceInformation>testPaGetPayment</remittanceInformation>
                          <transferCategory>paGetPaymentTest</transferCategory>
                       </transfer>
                    </transferList>
                    <!--Optional:-->
                    <metadata>
                       <!--1 to 10 repetitions:-->
                       <mapEntry>
                          <key>1</key>
                          <value>22</value>
                       </mapEntry>
                    </metadata>
                 </data>
              </paf:paGetPaymentRes>
           </soapenv:Body>
        </soapenv:Envelope>
        """
        
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
        And check that pspNotifyPaymentReq <element> is correctly filled with <value>
        
        | element                   | value                                                                                                  |
        | idPSP                     | $nodoInoltraEsitoPagamentoPaypalRequest.identificativoPsp                                              |
        | idBrokerPSP               | $nodoInoltraEsitoPagamentoPaypalRequest.identificativoIntermediario                                    |
        | idChannel                 | $nodoInoltraEsitoPagamentoPaypalRequest.identificativoCanale                                           |
        | paymentToken              | $activateIOPaymentResponse.paymentToken                                                                |
        | paymentDescription        | $paGetPaymentResponse.data.description                                                                 |
        | fiscalCodePA              | $activateIOPaymentRequest.qrCode.fiscalCode                                                            |
        | companyName               | $paGetPaymentResponse.data.companyName                                                                 |
        | creditorReferenceId       | $paGetPaymentResponse.data.creditorReferenceId                                                         |
        | debtAmount                | $paGetPaymentResponse.data.paymentAmount                                                               |
        | idTransfer                | $paGetPaymentResponse.data.transferList.transfer{n}.idTransfer                                         |
        | transferAmount            | $paGetPaymentResponse.data.transferList.transfer{n}.transferAmount                                     |
        | fiscalCodePA              | $paGetPaymentResponse.data.transferList.transfer{n}.fiscalCodePA                                       |
        | IBAN                      | $paGetPaymentResponse.data.transferList.transfer{n}.IBAN                                               |
        | remittanceInformation     | $paGetPaymentResponse.data.transferList.transfer{n}.remittanceInformation                              |
        | transactionId             | $nodoInoltraEsitoPagamentoPaypalRequest.idTransazione                                                  |
        | pspTransactionId          | $nodoInoltraEsitoPagamentoPaypalRequest.idTransazionePsp                                               |
        | totalAmount               | $nodoInoltraEsitoPagamentoPaypalRequest.importoTotalePagato                                            |
        | fee                       | $nodoInoltraEsitoPagamentoPaypalRequest.importoTotalePagato-$paGetPaymentResponse.data.paymentAmount   |
        | timestampOperation        | $nodoInoltraEsitoPagamentoPaypalRequest.timestampOperazione                                            |
        
        
        And check nodoInoltraEsitoPagamentoPaypal response contains {"esito": "OK"}
 