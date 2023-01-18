Feature: FLUSSO_APIO_01

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
                <expirationTime>60000</expirationTime>
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
@runnable
Scenario: Check sendPaymentOutcome response after nodoInoltroEsitoCarta, and check correctness of database tables
    Given the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
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
          <idempotencyKey>$activateIOPayment.idempotencyKey</idempotencyKey>
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
    And job paSendRt triggered after 10 seconds
    And wait 6 seconds for expiration
    Then check outcome is OK of sendPaymentOutcome response
    And checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED, NOTICE_SENT, NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    #check correctness of POSITION_PAYMENT table
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $sendPaymentOutcome.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
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
    # check correctness of POSITION_SUBJECT table
    #And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro AppIO
    # TODO: check correctness of POSITION_RECEIPT table (TO COMPLETE)
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online UNDER macro AppIO
    And checks the value $sendPaymentOutcomeResponse.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.totalAmount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.paymentDescription of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value $activateIOPaymentResponse.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
    #And checks the value Cassa di Risparmio di Parma e Piacenza S.p.A. descrizione lunga of the record at column DESCRIZIONE of the table PSP retrived by the query psp on db nodo_cfg under macro AppIO 
    #check correctness of POSITION_ACTIVATE table
    And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
    #check correctness of POSITION_RECEIPT_RECIPIENT table
    And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    # extraction from POSITION_PAYMENT table
    And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns * under macro AppIO with db name nodo_online
    And through the query payment_status retrieve param pa at position 1 and save it under the key pa
    And through the query payment_status retrieve param noticeNumber at position 2 and save it under the key noticeNumber
    And through the query payment_status retrieve param creditorReferenceId at position 3 and save it under the key creditorReferenceId
    And through the query payment_status retrieve param paymentToken at position 4 and save it under the key paymentToken
    And through the query payment_status retrieve param brokerPA at position 5 and save it under the key brokerPA
    And through the query payment_status retrieve param stationPA at position 6 and save it under the key stationPA
    And through the query payment_status retrieve param insertedTimestamp at position 20 and save it under the key insertedTimestamp
    And through the query payment_status retrieve param updatedTimestamp at position 21 and save it under the key updatedTimestamp  
    # check correctness of POSITION_RECEIPT_RECIPIENT table
    And checks the value $pa of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $pa of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $brokerPA of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $stationPA of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status_1 on db nodo_online under macro AppIO
    # TODO: check correctness of POSITION_RECEIPT_RECIPIENT_STATUS table
    #check correctness of POSITION_RECEIPT_XML table
    # extraction from POSITION_RECEIPT_RECIPIENT table
    And execution query payment_status to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro AppIO with db name nodo_online
    And through the query payment_status retrieve param recipientFiscalCode at position 5 and save it under the key recipientFiscalCode
    And through the query payment_status retrieve param recipientBroker at position 6 and save it under the key recipientBroker
    And through the query payment_status retrieve param recipientStation at position 7 and save it under the key recipientStation
    # check correctness of POSITION_RECEIPT_XML table
    And checks the value $pa of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $recipientFiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $recipientBroker of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value $recipientStation of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO
    And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query payment_status_1 on db nodo_online under macro AppIO