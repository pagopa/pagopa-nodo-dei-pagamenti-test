Feature: process tests for annulli_02

  Background:
    Given systems up
    And initial XML nodoInviaCarrelloRPT
      """
      <xsd:complexType name="nodoInviaCarrelloRPT">
      <xsd:sequence>
      <xsd:element name="password" type="ppt:stPassword" />
      <xsd:element name="identificativoPSP" type="ppt:stText35" />
      <xsd:element name="identificativoIntermediarioPSP" type="ppt:stText35" />
      <xsd:element name="identificativoCanale" type="ppt:stText35" />
      <xsd:element name="listaRPT" type="ppt:tipoListaRPT" />
      <xsd:element name="requireLightPayment" type="ppt:stZeroUno" minOccurs="0" />
      <xsd:element name="codiceConvenzione" type="ppt:stConvenzione" minOccurs="0" />
      <xsd:element name="multiBeneficiario" type="xsd:0" minOccurs="0" />
      </xsd:sequence>
      </xsd:complexType>"
      }
      """
    And EC new version

  # Verify phase
  Scenario: Execute nodoInviaCarrelloRPT request
    When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoInviaCarrelloRPT response


  # Payment/PSP choice phase
  Scenario: Execute nodoChiediInformazioniPagamento request
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
    And initial XML nodoChiediInformazioniPagamento
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:nodoChiediInformazioniPagamenti>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
  # And db check 1 rt_activision


  Scenario: Execute nodoInviaRPT request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML nodoInviaRPT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
      <ppt:intestazionePPT>
      <identificativoIntermediarioPA>${intermediarioPA}</identificativoIntermediarioPA>
      <identificativoStazioneIntermediarioPA>${stazioneAux03}</identificativoStazioneIntermediarioPA>
      <identificativoDominio>${pa}</identificativoDominio>
      <identificativoUnivocoVersamento>${#TestCase#iuv}</identificativoUnivocoVersamento>
      <codiceContestoPagamento>${#TestCase#token}</codiceContestoPagamento>
      </ppt:intestazionePPT>
      </soapenv:Header>
      <soapenv:Body>
      <ws:nodoInviaRPT>
      <password>${password}</password>
      <identificativoPSP>${pspFittizio}</identificativoPSP>
      <identificativoIntermediarioPSP>${intermediarioPSPFittizio}</identificativoIntermediarioPSP>
      <identificativoCanale>${canaleFittizio}</identificativoCanale>
      <tipoFirma></tipoFirma>
      <rpt>${#TestCase#rptAttachment}</rpt>
      </ws:nodoInviaRPT>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    #  When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti using the token of the activate phase
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoInviaRPT response

  # Verify presence of lock Phase
  Scenario: Execute nodoNotificaAnnullamento request
    Given the nodoInviaRPT request scenario executed successfully
    And initial XML nodoNotificaAnnullamento
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>OK</outcome>
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <payer>
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
      </payer>
      <applicationDate>2021-10-01</applicationDate>
      <transferDate>2021-10-02</transferDate>
      </details>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """



  # test execution part1
  Scenario Outline: Execution test [annulli_01]
    Given the nodoInviaRPT request scenario executed successfully
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaRPT response
    #And db check
    #La tabella <nameX> è opportunamente popolata con i <record>
    Examples:
      | <nameX>                          | <record>               | test_SOAPUI |
      | STATI_RPT                        | RPT_RICEVUTA_NODO      | annulli_02  |
      | STATI_RPT                        | RPT_ACCETTATA_NODO     | annulli_02  |
      | STATI_RPT                        | RPT_PARCHEGGIATA_NODO  | annulli_02  |
      | STATI_RPT                        | RPT_ANNULLATA_WISP     | annulli_02  |
      | STATI_CARRELLO                   | CART_RICEVUTO_NODO     | annulli_02  |
      | STATI_CARRELLO                   | CART_ACCETTATO_NODO    | annulli_02  |
      | STATI_CARRELLO                   | CART_PARCHEGGIATO_NODO | annulli_02  |
      | STATI_CARRELLO                   | CART_ANNULLATO_WISP    | annulli_02  |
      | POSITION_PAYMENT_STATUS          | None                   | annulli_02  |
      | POSITION_PAYMENT_STATUS_SNAPSHOT | None                   | annulli_02  |
      | POSITION_PAYMENT_STATUS          | None                   | annulli_02  |
      | POSITION_PAYMENT_STATUS_SNAPSHOT | None                   | annulli_02  |


  # test execution part2
  Scenario Outline: Execution test [annulli_01]
    Given the nodoInviaRPT request scenario executed successfully
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaRPT response
    #And db check
    #La tabella <nameY> è opportunamente popolata con gli <status>
    Examples:
      | <nameY>                 | <status>            | test_SOAPUI |
      | STATI_RPT_SNAPSHOT      | RPT_ANNULLATA_WISP  | annulli_02  |
      | STATI_CARRELLO_SNAPSHOT | CART_ANNULLATO_WISP | annulli_02  |
