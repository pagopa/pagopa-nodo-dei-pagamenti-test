Feature: flow checks for verificaBollettino - EC new 1339

  Background:
    Given systems up

  Scenario: execute nodoVerificaRPT request
    Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML nodoVerificaRPT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
      <soapenv:Header/>
      <soapenv:Body>
      <ws:nodoVerificaRPT>
      <identificativoPSP>POSTE3</identificativoPSP>
      <identificativoIntermediarioPSP>BANCOPOSTA</identificativoIntermediarioPSP>
      <identificativoCanale>POSTE3</identificativoCanale>
      <password>pwdpwdpwd</password>
      <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
      <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
      <codiceIdRPT>
      <aim:aim128>
      <aim:CCPost>#ccPoste#</aim:CCPost>
      <aim:AuxDigit>3</aim:AuxDigit>
      <aim:CodIUV>#cod_segr#$1iuv</aim:CodIUV>
      </aim:aim128>
      </codiceIdRPT>
      </ws:nodoVerificaRPT>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    
    When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoVerificaRPT response
    And check faultCode is PPT_MULTI_BENEFICIARIO of nodoVerificaRPT response

  # verificaBollettinoReq phase - TF_VB_04
  Scenario: Execute verificaBollettino request
    Given the execute nodoVerificaRPT request scenario executed successfully
    And initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:verificaBollettinoReq>
        <idPSP>#pspPoste#</idPSP>
        <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
        <idChannel>#channelPoste#</idChannel>
      <password>pwdpwdpwd</password>
      <ccPost>#ccPoste#</ccPost>
      <noticeNumber>$1noticeNumber</noticeNumber>
      </nod:verificaBollettinoReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    And check allCCP field exists in verificaBollettino response

  # activatePaymentNoticeReq phase - TF_VB_04
  Scenario: Execute activatePaymentNotice request
    Given the Execute verificaBollettino request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
      <noticeNumber>$1noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @runnable
  # Payment Outcome Phase outcome OK - TF_VB_04
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
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
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
