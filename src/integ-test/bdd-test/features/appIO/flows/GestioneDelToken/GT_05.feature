Feature: GT_05 58

    Background:
        Given systems up
        And EC new version

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given nodo-dei-pagamenti has config parameter useIdempotency set to true
        And initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:verifyPaymentNoticeReq>
                        <idPSP>#psp_AGID#</idPSP>
                        <idBrokerPSP>#broker_AGID#</idBrokerPSP>
                        <idChannel>#canale_AGID#</idChannel>
                        <password>pwdpwdpwd</password>
                        <qrCode>
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                    </nod:verifyPaymentNoticeReq>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

    Scenario: Execute activateIOPayment (Phase 2)
        Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
        And initial XML activateIOPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:activateIOPaymentReq>
                        <idPSP>$verifyPaymentNotice.idPSP</idPSP>
                        <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
                        <idChannel>$verifyPaymentNotice.idChannel</idChannel>
                        <password>$verifyPaymentNotice.password</password>
                        <!--Optional:-->
                        <qrCode>
                            <fiscalCode>#creditor_institution_code#</fiscalCode>
                            <noticeNumber>#notice_number#</noticeNumber>
                        </qrCode>
                        <!--Optional:-->
                        <expirationTime>12345</expirationTime>
                        <amount>10.00</amount>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And check token_valid_to is equal to token_valid_from plus default_durata_token_IO

    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
 @runnable   
    Scenario: Execute nodoInoltroEsitoCarta (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <pfn:pspNotifyPaymentRes>
                    <outcome>KO</outcome>
                    <!--Optional:-->
                    <fault>
                        <faultCode>CANALE_SEMANTICA</faultCode>
                        <faultString>Errore semantico dal psp</faultString>
                        <id>1</id>
                        <!--Optional:-->
                        <description>Errore dal psp</description>
                    </fault>
                </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
        """
        {
            "idPagamento": "$activateIOPaymentResponse.paymentToken",
            "RRN": 18865881,
            "identificativoPsp": "#psp#",
            "tipoVersamento": "CP",
            "identificativoIntermediario": "#psp#",
            "identificativoCanale": "#canale#",
            "importoTotalePagato": 10,
            "timestampOperazione": "2021-07-09T17:06:03.100+01:00",
            "codiceAutorizzativo": "resOK",
            "esitoTransazioneCarta": "00"
        }
        """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is KO of inoltroEsito/carta response
        And check errorCode is RIFPSP of inoltroEsito/carta response
@runnable
    Scenario: Execute nodoNotificaAnnullamento (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest GET notificaAnnullamento?idPagamento=$activateIOPaymentResponse.paymentToken&motivoAnnullamento=SESSCA to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200
        And checks the value nodoNotificaAnnullamento of the record at column UPDATED_BY of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And restore initial configurations