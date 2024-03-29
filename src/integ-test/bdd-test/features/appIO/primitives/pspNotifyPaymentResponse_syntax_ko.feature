Feature: Syntax checks for pspNotifyPaymentResponse - KO

    Background:
        Given systems up
        And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And initial XML paGetPayment
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <paf:paGetPaymentRes>
                    <outcome>OK</outcome>
                    <data>
                        <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
                        <paymentAmount>10.00</paymentAmount>
                        <dueDate>2021-07-31</dueDate>
                        <description>TARI 2021</description>
                        <companyName>company PA</companyName>
                        <officeName>office PA</officeName>
                        <debtor>
                            <uniqueIdentifier>
                                <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
                                <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
                            </uniqueIdentifier>
                            <fullName>John Doe</fullName>
                            <streetName>street</streetName>
                            <civicNumber>12</civicNumber>
                            <postalCode>89020</postalCode>
                            <city>city</city>
                            <stateProvinceRegion>MI</stateProvinceRegion>
                            <country>IT</country>
                            <e-mail>john.doe@test.it</e-mail>
                        </debtor>
                        <transferList>
                            <transfer>
                                <idTransfer>1</idTransfer>
                                <transferAmount>10.00</transferAmount>
                                <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                                <IBAN>IT96R0123454321000000012345</IBAN>
                                <remittanceInformation>TARI Comune EC_TE</remittanceInformation>
                                <transferCategory>0101101IM</transferCategory>
                            </transfer>
                        </transferList>
                    </data>
                </paf:paGetPaymentRes>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
                            <noticeNumber>$1noticeNumber</noticeNumber>
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
                                <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
  Scenario: Execute activateIOPaymentReq request
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  # nodoChiediInformazioniPagamento phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the Execute activateIOPaymentReq request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  @runnable @independent
  # nodoInoltraEsitoPagamentoCarte phase
  Scenario Outline: Execute nodoInoltraEsitoPagamentoCarte request
    Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
    And initial XML pspNotifyPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <pfn:pspNotifyPaymentRes>
      <outcome>OK</outcome>
      <delay>10000</delay>
      </pfn:pspNotifyPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And <elem> with <value> in pspNotifyPayment
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
        "importoTotalePagato": 10.00,
        "timestampOperazione": "2021-07-09T17:06:03.100+01:00",
        "codiceAutorizzativo": "resTim",
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
      | pfn:pspNotifyPaymentRes | RemoveParent | T_08        |
      | pfn:pspNotifyPaymentRes | Empty        | T_09        |
      | outcome                 | None         | T_10        |
      | outcome                 | Empty        | T_11        |
      | outcome                 | PP           | T_12        |
      | outcome                 | KO           | T_13        |
