Feature: syntax checks for pspNotifyPaymentResponse - KO

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
        Scenario: Execute nodoInoltraEsitoPagamentoCarte request
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
        When WISP sends nodoInoltraEsitoPagamentoCarteReq to nodo-dei-pagamenti
            And psp responds to nodo-dei-pagamenti at pspNotifyPaymentReq with:
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <psp:pspNotifyPaymentRes>
                        <outcome>#outcome#</outcome>
                         <fault>
                            <faultCode>#faultCode#</faultCode>
                            <faultString>#faultString#</faultString>
                            <id>#id#</id>
                            <description>#description#</description>
                         </fault>
                </soapenv:Body>
            </soapenv:Envelope>
            """
            And <elem> with <value> in pspNotifyPaymentResponse
            And if outcome is KO set fault to None
        Then check nodoInoltraEsitoPagamentoCarte response contains {"error": "Operazione in timeout"}
		
            | element		   			   | value								| soapUI test |
            | soapenv:Body                 | None                               | T_06        |
            | soapenv:Body                 | Empty                              | T_05        |
            | psp:pspNotifyPaymentRes      | Empty                              | T_09        |
            | outcome                      | None                               | T_10        |
            | outcome                      | Empty                              | T_11        |
            | outcome                      | PP                                 | T_12        |
            | outcome                      | KO                                 | T_13        |
 