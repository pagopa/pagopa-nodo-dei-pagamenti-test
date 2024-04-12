Feature:  block checks for verificaBollettino - position status in PAID [VerificaBollettino_blocco_02] 1343

  Background:
    Given systems up
    


   # Verify RPT Phase
   Scenario: Execute nodoVerificaRPT request
      Given initial XML nodoVerificaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
               <ws:nodoVerificaRPT>
                  <identificativoPSP>#pspPoste#</identificativoPSP>
                  <identificativoIntermediarioPSP>#brokerPspPoste#</identificativoIntermediarioPSP>
                  <identificativoCanale>#channelPoste#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
                  <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                  <codiceIdRPT>
                     <aim:aim128>
                        <aim:CCPost>#ccPoste#</aim:CCPost>
                        <aim:AuxDigit>3</aim:AuxDigit>
                        <aim:CodIUV>#cod_segr#012051482162400</aim:CodIUV>
                     </aim:aim128>
                  </codiceIdRPT>
               </ws:nodoVerificaRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
      Then check esito is KO of nodoVerificaRPT response
      And check faultString is La chiamata non è compatibile con il nuovo modello PSP. of nodoVerificaRPT response


  # Verify Phase 1
  Scenario: Execute verificaBollettino request
    Given initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:verificaBollettinoReq>
      <idPSP>#pspPoste#</idPSP>
      <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
      <idChannel>#channelPoste#</idChannel>
      <password>pwdpwdpwd</password>
      <ccPost>#ccPoste#</ccPost>
      <noticeNumber>#notice_number#</noticeNumber>
      </nod:verificaBollettinoReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response


  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verificaBollettino request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#pspPoste#</idPSP>
      <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
      <idChannel>#channelPoste#</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>$verificaBollettinoResponse.fiscalCodePA</fiscalCode>
      <noticeNumber>$verificaBollettino.noticeNumber</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And paymentToken exists of activatePaymentNotice response
    And paymentToken length is less than 36 of activatePaymentNotice response


  # Payment Outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
    Given initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#pspPoste#</idPSP>
      <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
      <idChannel>#channelPoste#</idChannel>
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
    #  When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti using the token of the activate phase, and with request field <outcome> = OK
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response


  # Verify Phase 2
  Scenario: Execute verificaBollettino request with the same request as Verify Phase 1, immediately after the Payment Outcome Phase
    Given the Execute sendPaymentOutcome request scenario executed successfully
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of verificaBollettino response


  @runnable
  Scenario: Execute verificaBollettino request with the same request as Verify Phase 1, few seconds after the Payment Outcome Phase (e.g. 30s)
    Given EC replies to nodo-dei-pagamenti with the paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <fault>
      <faultCode>PAA_ERRORE_MOCK</faultCode>
      <faultString>Errore semantico</faultString>
      <id>1</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And the Execute sendPaymentOutcome request scenario executed successfully
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of verificaBollettino response
