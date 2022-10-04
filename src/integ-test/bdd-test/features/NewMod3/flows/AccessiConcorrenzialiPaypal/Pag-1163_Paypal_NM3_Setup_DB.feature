Feature: DB checks for nodoChiediEsitoPagamento  - KO

    Background:
        Given systems up
        And initial XML verifyPaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:verifyPaymentNoticeReq>
                 <idPSP>AGID_01</idPSP>
                 <idBrokerPSP>97735020584</idBrokerPSP>
                 <idChannel>97735020584_03</idChannel>
                 <password>pwdpwdpwd</password>
                 <qrCode>
                    <fiscalCode>77777777777</fiscalCode>
                    <noticeNumber>311$iuv</noticeNumber>
                 </qrCode>
              </nod:verifyPaymentNoticeReq>
           </soapenv:Body>
        </soapenv:Envelope>
        """
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
                        <idempotencyKey>$idempotenza</idempotencyKey>
                        <qrCode>
                            <fiscalCode>#fiscalCodePA#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                        <!--Optional:-->
                        <expirationTime>12345</expirationTime>
                        <amount>70.00</amount>
                        <!--Optional:-->
                        <dueDate>2021-12-12</dueDate>
                        <!--Optional:-->
                        <paymentNote>test</paymentNote>
                        <!--Optional:-->
                        <payer>
                            <uniqueIdentifier>
                                <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                                <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response


    Scenario: Execute activateIOPaymentReq request
        When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response


    Scenario: Execute nodoChiediInformazioniPagamento request
        Given the Execute activateIOPaymentReq request scenario executed successfully
        When EC sends rest GET /informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then check importo field exists in /informazioniPagamento response
        And check ragioneSociale field exists in /informazioniPagamento response
        And check oggettoPagamento field exists in /informazioniPagamento response
        And check redirect is redirectEC in /informazioniPagamento response
        And check false field exists in /informazioniPagamento response
        And check dettagli field exists in /informazioniPagamento response
        And check iuv field exists in /informazioniPagamento response
        And check ccp field exists in /informazioniPagamento response
        And check pa field exists in /informazioniPagamento response
        And check enteBeneficiario field exists in /informazioniPagamento response
        And execution query pa_dbcheck_json to get value on the table PA, with the columns ragione_sociale under macro NewMod3 with db name nodo_cfg
        And through the query pa_dbcheck_json retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
        And check $ragione_sociale is enteBeneficiario in /informazioniPagamento response
        And check $ragione_sociale is ragioneSociale in /informazioniPagamento response
