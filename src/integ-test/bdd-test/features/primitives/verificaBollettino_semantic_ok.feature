Feature: semantic checks for verificaBollettinoReq

  Background:
    Given systems up
    And initial verificaBollettinoReq soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:verificaBollettinoReq>
                 <idPSP>POSTE3</idPSP>
                 <idBrokerPSP>BANCOPOSTA</idBrokerPSP>
                 <idChannel>POSTE3</idChannel>
                 <password>pwdpwdpwd</password>
                 <ccPost>#codicePA#</ccPost>
                 <noticeNumber>#notice_number#</noticeNumber>
              </nod:verificaBollettinoReq>
           </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: Check valid URL in WSDL namespace
    When PSP sends verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK

  # TODO with api-config
#  # ccPost associato a due PA - [SEM_VB_15]
#  Scenario: Check outcome OK if ccPost is associated with two EC
#    Given ccPost associated with two EC  #"INSERT INTO NODO4_CFG.CODIFICHE_PA (CODICE_PA, FK_CODIFICA, FK_PA) VALUES ('${codicePA}', 1, 6023)"
#    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
#    Then check outcome is OK
