Feature: FLUSSO_APIO_10.1

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
                <noticeNumber>302094719472095710</noticeNumber>
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
    When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
    Given the Execute activateIOPayment (Phase 2) scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

Scenario: Execute nodoInoltroEsitoCarta (Phase 4) 
    Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {
        "RRN":10026669,
        "tipoVersamento":"CP",
        "idPagamento":"$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario":"40000000001",
        "identificativoPsp":"40000000001",
        "identificativoCanale":"40000000001_06",
        "importoTotalePagato":10.00,
        "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo":"resOK",
        "esitoTransazioneCarta":"00"
        }
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 200
    And check esito is OK of inoltroEsito/carta response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    # check correctness POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 40000000001 of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 40000000001 of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 40000000001_06 of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value CP of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
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
    # check correctness PM_SESSION_DATA
    And checks the value PAYMENT_IO of the record at column TIPO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOBILE_TOKEN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10026669 of the record at column RRN of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 10 of the record at column IMPORTO_TOTALE_PAGATO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value 00 of the record at column ESITO_TRANSAZIONE_CARTA of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value resOK of the record at column CODICE_AUTORIZZATIVO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column TIMESTAMP_OPERAZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO
    And checks the value None of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query pm_session on db nodo_online under macro AppIO

Scenario: (Phase 5)
    Given the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
    #And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>40000000001</idPSP>
          <idBrokerPSP>40000000001</idBrokerPSP>
          <idChannel>40000000001_06</idChannel>
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
              <fullName>name</fullName>
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

Scenario: Check sendPaymentOutcome1 response after sendPaymentOutcome with sendPaymentOutcome1 OK, and check correctness of database tables
    Given the (Phase 5) scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    And random idempotencyKey having $sendPaymentOutcome.idPSP as idPSP in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And wait 5 seconds for expiration
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING, PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    #check correctness of POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 40000000001 of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 40000000001 of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 40000000001_06 of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value CP of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
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