Feature: Semantic checks oon inoltroEsitoPaypal primitive for new EC

    Background:
        Given systems up
        And EC new version

################################################## PARTE 1 ########################################################################################################
    
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
    When AppIO sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
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
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
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
    When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response


Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
    Given the Execute activateIOPayment (Phase 2) scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

Scenario: Execute nodoInoltroEsitoPayPal (Phase 4) - OK
    Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is OK of inoltroEsito/paypal response
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseOK of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO 

Scenario: Execute nodoInoltroEsitoPayPal (Phase 4) - KO (RIFPSP)
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
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseKO",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is KO of inoltroEsito/paypal response
    And check errorCode is RIFPSP of inoltroEsito/paypal response
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseKO of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
   
Scenario: Execute nodoInoltroEsitoPayPal (Phase 4) - KO (CONPSP)
    Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseKO",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "irraggiungibile",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "irraggiungibile",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is KO of inoltroEsito/paypal response
    And check errorCode is CONPSP of inoltroEsito/paypal response
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value irraggiungibile of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value irraggiungibile of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseKO of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

Scenario: Execute nodoInoltroEsitoPayPal (Phase 4) - Timeout
    Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
                <outcome>Response malformata</outcome>
            </pfn:pspNotifyPaymentRes>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseMalformata",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 408
    And check error is Operazione in timeout of inoltroEsito/paypal response
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseMalformata of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

###################################################################################################################################################################################################################################

# [SEM_NIEPP_01]
Scenario: Execute sendPaymentOutcome (Phase 5) [SEM_NIEPP_01]
    Given the Execute nodoInoltroEsitoPayPal (Phase 4) - OK scenario executed successfully
    And initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>#psp#</idPSP>
          <idBrokerPSP>#psp#</idBrokerPSP>
          <idChannel>#canale#</idChannel>
          <password>pwdpwdpwd</password>
          <idempotencyKey>#idempotency_key#</idempotencyKey>
          <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
          <outcome>OK</outcome>
          <!--Optional:-->
          <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
              <uniqueIdentifier>
                <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
              </uniqueIdentifier>
              <fullName>SPOname_$activateIOPaymentResponse.paymentToken</fullName>
              <!--Optional:-->
              <streetName>street</streetName>
              <!--Optional:-->
              <civicNumber>civic</civicNumber>
              <!--Optional:-->
              <postalCode>postal</postalCode>
              <!--Optional:-->
              <city>city</city>
              <!--Optional:-->
              <stateProvinceRegion>state</stateProvinceRegion>
              <!--Optional:-->
              <country>IT</country>
              <!--Optional:-->
              <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
          </details>
        </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 5 seconds for expiration
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED, NOTICE_SENT, NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING, PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO

@runnable
Scenario: Execute nodoInoltroEsitoPaypal (Phase 6) [SEM_NIEPP_01]
    Given the Execute sendPaymentOutcome (Phase 5) scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is OK of inoltroEsito/paypal response
    And wait 5 seconds for expiration
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED, NOTICE_SENT, NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseOK of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

# [SEM_NIEPP_02]
@runnable
Scenario: Execute nodoInoltroEsitoPaypal1 (Phase 5) [SEM_NIEPP_02]
    Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 6000
    And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
    Given the Execute nodoInoltroEsitoPayPal (Phase 4) - Timeout scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
                <outcome>OK</outcome>
            </pfn:pspNotifyPaymentRes>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    When job mod3CancelV2 triggered after 7 seconds
    And wait 10 seconds for expiration
    And WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is KO of inoltroEsito/paypal response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_UNKNOWN, CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING, INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseMalformata of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And restore initial configurations

# [SEM_NIEPP_03]
@runnable
Scenario: Execute nodoInoltroEsitoPaypal1 (Phase 5) [SEM_NIEPP_03]
    Given the Execute nodoInoltroEsitoPayPal (Phase 4) - OK scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is OK of inoltroEsito/paypal response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseOK of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

# [SEM_NIEPP_04]
@runnable
Scenario: Execute nodoInoltroEsitoPaypal1 (Phase 5) [SEM_NIEPP_04]
    Given the Execute nodoInoltroEsitoPayPal (Phase 4) - Timeout scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 408
    And check error is Operazione in timeout of inoltroEsito/paypal response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseMalformata of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

# [SEM_NIEPP_05]
@runnable
Scenario: Execute nodoInoltroEsitoPayPal1 (Phase 5) [SEM_NIEPP_05]
    Given the Execute nodoInoltroEsitoPayPal (Phase 4) - KO (RIFPSP) scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is KO of inoltroEsito/paypal response
    And check errorCode is RIFPSP of inoltroEsito/paypal response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_REFUSED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYMENT_REFUSED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseKO of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

# [SEM_NIEPP_06]
Scenario: Execute nodoInoltroEsitoPayPal1 (Phase 5) [SEM_NIEPP_06]
    Given the Execute nodoInoltroEsitoPayPal (Phase 4) - KO (CONPSP) scenario executed successfully
    When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
    """
    {
        "idTransazione": "responseOK",
        "idTransazionePsp":"$activateIOPayment.idempotencyKey",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z"
    }
    """
    Then verify the HTTP status code of inoltroEsito/paypal response is 200
    And check esito is KO of inoltroEsito/paypal response
    And check errorCode is CONPSP of inoltroEsito/paypal response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_SEND_ERROR of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYMENT_SEND_ERROR of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value irraggiungibile of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value irraggiungibile of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness PM_SESSION_DATA table
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_AUTORIZZATIVO_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column ID_TRANSAZIONE_PSP_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value responseKO of the record at column ID_TRANSAZIONE_PM_PAYPAL of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO