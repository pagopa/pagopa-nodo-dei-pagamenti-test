Feature: Syntax checks for sendPaymentOutcome - OK

  Background:
    Given systems up
    And EC new version
    And initial XML activatePaymentNotice
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:activatePaymentNoticeReq>
                <idPSP>#psp#</idPSP>
                <idBrokerPSP>#psp#</idBrokerPSP>
                <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
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
    And PSP sends soap activatePaymentNotice to nodo-dei-pagamenti

    @runnable
    # [SIN_SPO_00]
    Scenario: Check sendPaymentOutcome response with mandatory fields
      Given initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>#psp#</idPSP>
          <idBrokerPSP>#psp#</idBrokerPSP>
          <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
          <password>pwdpwdpwd</password>
          <idempotencyKey>#idempotency_key#</idempotencyKey>
          <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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
    And idempotencyKey with None in sendPaymentOutcome
    And paymentChannel with None in sendPaymentOutcome
    And payer with None in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @runnable
  # element value check
  Scenario Outline: Check sendPaymentOutcome response with missing optional fields
    Given initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>#psp#</idPSP>
          <idBrokerPSP>#psp#</idBrokerPSP>
          <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
          <password>pwdpwdpwd</password>
          <idempotencyKey>#idempotency_key#</idempotencyKey>
          <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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
    And <elem> with <value> in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

    Examples:
      | elem                | value           | soapUI test |
      | paymentMethod       | cash            | SIN_SPO_25  |
      | paymentMethod       | creditCard      | SIN_SPO_25  |
      | paymentMethod       | bancomat        | SIN_SPO_25  |
      | paymentMethod       | other           | SIN_SPO_25  |
      | paymentChannel      | None            | SIN_SPO_26  |
      | paymentChannel      | frontOffice     | SIN_SPO_28  |
      | paymentChannel      | atm             | SIN_SPO_28  |
      | paymentChannel      | onLine          | SIN_SPO_28  |
      | paymentChannel      | other           | SIN_SPO_28  |
      | payer               | None            | SIN_SPO_35  |
      | streetName          | None            | SIN_SPO_51  |
      | civicNumber         | None            | SIN_SPO_54  |
      | postalCode          | None            | SIN_SPO_57  |
      | city                | None            | SIN_SPO_60  |
      | stateProvinceRegion | None            | SIN_SPO_63  |
      | country             | None            | SIN_SPO_66  |
      | e-mail              | None            | SIN_SPO_70  |
      | idempotencyKey      | None            | SIN_SPO_80  |

      
