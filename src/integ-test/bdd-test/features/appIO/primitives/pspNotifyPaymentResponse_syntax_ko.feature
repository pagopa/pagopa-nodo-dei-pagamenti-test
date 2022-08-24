Feature: Syntax checks for pspNotifyPaymentResponse - KO

  Background:
    Given systems up
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp_AGID#</idPSP>
      <idBrokerPSP>#broker_AGID#</idBrokerPSP>
      <idChannel>#canale_AGID#</idChannel>
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

  Scenario: Execute activateIOPaymentReq request
    When IO sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200


  # nodoInoltraEsitoPagamentoCarte phase
  Scenario Outline: Execute nodoInoltraEsitoPagamentoCarte request
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    And initial XML pspNotifyPayment
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
      </psp:pspNotifyPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And <elem> with <value> in pspNotifyPayment
    And if outcome is KO set fault to None in pspNotifyPayment
    And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
    When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
      """
      {
        "RRN": 10026669,
        "tipoVersamento": "CP",
        "idPagamento": "$activateIOPaymentResponse.paymentToken",
        "identificativoIntermediario": "#psp#",
        "identificativoPsp": "#psp#",
        "identificativoCanale": "#canale#",
        "importoTotalePagato": 10,
        "timestampOperazione": "2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo": "resOK",
        "esitoTransazioneCarta": "00"
      }
      """
    #       And identificativoCanale with SERVIZIO_NMP
    Then verify the HTTP status code of inoltroEsito/carta response is 408
    Examples:
      | elem                    | value        | soapUI test |
      | soapenv:Body            | Empty        | T_05        |
      | soapenv:Body            | None         | T_06        |
      | soapenv:Body            | RemoveParent | T_07        |
      | psp:pspNotifyPaymentRes | RemoveParent | T_08        |
      | psp:pspNotifyPaymentRes | Empty        | T_09        |
      | outcome                 | None         | T_10        |
      | outcome                 | Empty        | T_11        |
      | outcome                 | PP           | T_12        |
      | outcome                 | KO           | T_13        |
