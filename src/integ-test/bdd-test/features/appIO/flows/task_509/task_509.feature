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
        And execution query token_validity to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_FROM under macro AppIO with db name nodo_online
        And through the query token_validity retrieve param token_valid_from_activate at position 0 and save it under the key token_valid_from_activate

    @runnable  
    # [TASK_509_01]
    Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
        Given the Execute activateIOPayment (Phase 2) scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
    
    @runnable
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
    
    @runnable
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
    
    @runnable
    # [TASK_509_03]
    Scenario: Execute nodoChiediListaPSP (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends rest GET listaPSP?idPagamento=$activateIOPaymentResponse.paymentToken&percorsoPagamento=CARTE to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is 200
    
    @runnable
    # [TASK_509_04]
    Scenario: Execute nodoNotificaAnnullamento (Phase 4)
        Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
        When WISP sends REST GET notificaAnnullamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200
        And check esito is OK of notificaAnnullamento response
    
    @runnable   
    # [TASK_509_05]
    Scenario: Execute nodoChiediAvanzamentoPagamento (Phase 4)
        Given the Execute nodoInoltroEsitoCarta (Phase 3) scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200
        And check esito is OK of avanzamentoPagamento response
    
    @runnable
    # [TASK_509_06]
    Scenario: Check TOKEN_VALID_FROM (Phase 5)
        Given the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
        Then checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
        And execution query token_validity to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_FROM under macro AppIO with db name nodo_online
        And through the query token_validity retrieve param token_valid_from_inoltro at position 0 and save it under the key token_valid_from_inoltro
        And check value $token_valid_from_activate is equal to value $token_valid_from_inoltro
    
    @runnable        
    # [TASK_509_07]
    Scenario: Check TOKEN_VALID_TO + 1h (Phase 5)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        And wait 5 seconds for expiration
        And the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
        Then check token_valid_to is greater than token_valid_from plus default_durata_estensione_token_IO
        And restore initial configurations
    
    @ciao
    # [TASK_509_08]
    Scenario: Check debtor position (Phase 3)
        Given nodo-dei-pagamenti has config parameter scheduler.annullamentoRptMaiRichiesteDaPmPollerMinutesToBack set to 1
        And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
        And the Execute activateIOPayment (Phase 2) scenario executed successfully
        When job annullamentoRptMaiRichiesteDaPm triggered after 65 seconds
        And verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200 
        And wait 130 seconds for expiration
        Then checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
        # Assertion Failed: check expected element: INSERTED, obtained: ['PAYING']
        And restore initial configurations