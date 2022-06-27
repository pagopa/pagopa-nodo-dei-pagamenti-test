Feature: FLUSSO_APIO_35

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
                <idPSP>AGID_01</idPSP>
                <idBrokerPSP>97735020584</idBrokerPSP>
                <idChannel>97735020584_03</idChannel>
                <password>pwdpwdpwd</password>
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
    And initial XML paGetPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <paf:paGetPaymentRes>
                <outcome>KO</outcome>
                <fault>
                    <faultCode>PAA_SEMANTICA</faultCode>
                    <faultString>errore semantico PA</faultString>
                    <id>$activateIOPayment.fiscalCode</id>
                    <description>Errore semantico emesso dalla PA</description>
                    </fault>
            </paf:paGetPaymentRes>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response

Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
    Given the Execute activateIOPayment (Phase 2) scenario executed successfully
    And get value from PAYMENT_TOKEN column in POSITION_ACTIVATE table retrivied by the query payment_status on nodo_online db under AppIO macro
    # COME PRENDO IL PAYMENT TOKEN DAL DB PER PASSARLO POI AL SERVIZIO INFORMAZIONI PAGAMENTO?
    When WISP sends rest GET informazioniPagamento?idPagamento=%PAYMENT_TOKEN to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 404
    And check error is Il pagamento non esiste of informazioniPagamento response

Scenario: Execute nodoInoltroEsitoCarta (Phase 4) 
    Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {
        "idPagamento": "%PAYMENT_TOKEN",
        "RRN": 0,
        "identificativoPsp": "40000000001",
        "tipoVersamento": "CP",
        "identificativoIntermediario": "40000000001",
        "identificativoCanale": "40000000001_06",
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2012-04-23T18:25:43Z",
        "codiceAutorizzativo": "resOk",
        "esitoTransazioneCarta": "00"
    }
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 404
    And check error is Il Pagamento indicato non esiste of inoltroEsito/carta response

Scenario: Check sendPaymentOutcome response after nodoInoltroEsitoPaypal primitive and the correctness of column values
    Given the Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
    And initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>40000000001</idPSP>
          <idBrokerPSP>40000000001</idBrokerPSP>
          <idChannel>40000000001_03</idChannel>
          <password>pwdpwdpwd</password>
          <idempotencyKey>#idempotency_key#</idempotencyKey>
          <paymentToken>%PAYMENT_TOKEN</paymentToken>
          <outcome>KO</outcome>
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
              <fullName>SPOname_%PAYMENT_TOKEN</fullName>
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
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response