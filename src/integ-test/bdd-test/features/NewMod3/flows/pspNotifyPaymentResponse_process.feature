Feature: process checks for pspNotifyPayment

  Background:
    Given systems up

  Scenario: Execute activateIOPayment request
    Given initial XML activateIOPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:activateIOPaymentReq>
          <idPSP>#psp#</idPSP>
          <idBrokerPSP>#psp#</idBrokerPSP>
          <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
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
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the Execute activateIOPayment request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  @runnable @independent
  # nodoInoltraEsitoPagamentoCarte phase - psp Irraggiungibile [PRO_PNP_05]
  Scenario: Check nodoInoltraEsitoPagamentoCarte response contains {"esito" : "KO","errorCode" :  "CONPSP", “descrizione”: "Risposta negativa del Canale"} when psp is unreachable
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {
      "idPagamento":"$activateIOPaymentResponse.paymentToken",
      "RRN":10026669,
      "tipoVersamento":"CP",
      "identificativoIntermediario":"irraggiungibile",
      "identificativoPsp":"irraggiungibile",
      "identificativoCanale":"irraggiungibile",
      "importoTotalePagato":10.00,
      "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
      "codiceAutorizzativo":"resOK",
      "esitoTransazioneCarta":"00"
    }
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 200
    Then check esito is KO of inoltroEsito/carta response
    And check errorCode is CONPSP of inoltroEsito/carta response
    And check descrizione is Risposta negativa del Canale of inoltroEsito/carta response

  @runnable @independent
  # nodoInoltraEsitoPagamentoCarte phase - outcome KO [PRO_PNP_03]
  Scenario: Check nodoInoltraEsitoPagamentoCarte response contains { "esito": "KO", "errorCode": "RIFPSP", "descrizione": "Risposta negativa del Canale" } when pspNotifyPaymentResponse is KO
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <psp:pspNotifyPaymentRes>
          <outcome>KO</outcome>
          <!--Optional:-->
          <fault>
            <faultCode>CANALE_SEMANTICA</faultCode>
            <faultString>Errore semantico dal psp</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>Errore dal psp</description>
          </fault>
        </psp:pspNotifyPaymentRes>
      </soapenv:Body>
    </soapenv:Envelope>
    """
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
      "codiceAutorizzativo":"123456",
      "esitoTransazioneCarta":"00"
    }
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 200
    Then check esito is KO of inoltroEsito/carta response
    And check errorCode is RIFPSP of inoltroEsito/carta response
    And check descrizione is Risposta negativa del Canale of inoltroEsito/carta response

  @runnable @independent
  # nodoInoltraEsitoPagamentoCarte phase - Timeout [PRO_PNP_02]
  Scenario: Check nodoInoltraEsitoPagamentoCarte response contains {"error": "Operazione in timeout"} when pspNotifyPaymentResponse is in timeout
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <psp:pspNotifyPaymentRes>
          <outcome>OK</outcome>
          <delay>10000</delay>
        </psp:pspNotifyPaymentRes>
      </soapenv:Body>
    </soapenv:Envelope>
    """
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
      "codiceAutorizzativo":"123456",
      "esitoTransazioneCarta":"00"
    }
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 408
    And check error is Operazione in timeout of inoltroEsito/carta response
