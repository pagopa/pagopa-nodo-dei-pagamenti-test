Feature: task_509

    Background:
        Given systems up
        And EC new version

    Scenario: Execute verifyPaymentNotice (Phase 1)
        Given initial XML verifyPaymentNotice
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
                    <idempotencyKey>#idempotency_key#</idempotencyKey>
                    <qrCode>
                        <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
                        <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
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
    
    # [TASK_509_01]
    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: Execute nodoInoltroEsitoCarta (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
        """
        {
        "idPagamento":"$activateIOPaymentResponse.paymentToken",
        "RRN":10026669,
        "tipoVersamento":"CP",
        "identificativoIntermediario":"#psp#",
        "identificativoPsp":"#psp#",
        "identificativoCanale":"#canale#",
        "importoTotalePagato":10.00,
        "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo":"resOK",
        "esitoTransazioneCarta":"00"
        }
        """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is OK of inoltroEsito/carta response

    # [TASK_509_02]
    Scenario: Execute nodoInoltroEsitoCarta (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
        """
        {
        "idPagamento":"$activateIOPaymentResponse.paymentToken",
        "RRN":10026669,
        "tipoVersamento":"CP",
        "identificativoIntermediario":"#psp#",
        "identificativoPsp":"#psp#",
        "identificativoCanale":"#canale#",
        "importoTotalePagato":10.00,
        "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo":"resOK",
        "esitoTransazioneCarta":"00"
        }
        """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is OK of inoltroEsito/carta response

    # [TASK_509_03]
    Scenario: Execute nodoChiediListaPSP (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest GET listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken&percorsoPagamento=CARTE to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is 200

    # [TASK_509_04]
    Scenario: Execute nodoNotificaAnnullamento (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends REST GET notificaAnnullamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200
        And check esito is OK of notificaAnnullamento response
    
    # [TASK_509_05]
    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 4)
        Given the Execute nodoInoltroEsitoCarta (Phase 3) scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200
        And check esito is OK of avanzamentoPagamento response

    # [TASK_509_07]
    Scenario: Check TOKEN_VALID_TO value (Phase 5)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        And wait 5 seconds for expiration
        And the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
        Then check token validity with 3600000
        And restore initial configurations

    # [TASK_509_08]
    Scenario: Check debtor position (Phase 3)
        Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
        And the Execute activateIOPayment (Phase 2) scenario executed successfully
        When job annullamentoRptMaiRichiesteDaPm triggered after 65 seconds
        And wait 10 seconds for expiration
        Then checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        And restore initial configurations