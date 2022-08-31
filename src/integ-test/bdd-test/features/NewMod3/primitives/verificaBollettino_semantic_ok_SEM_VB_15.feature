Feature: Semantic checks for verificaBollettino - OK [SEM_VB_15]

  Background:
    Given systems up
    And initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:verificaBollettinoReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
      <idChannel>#channelPoste#</idChannel>
      <password>pwdpwdpwd</password>
      <ccPost>#ccPoste#</ccPost>
      <noticeNumber>#notice_number#</noticeNumber>
      </nod:verificaBollettinoReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: Check ccPost associates with two PA
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response