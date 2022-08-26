Feature: Semantic checks for verificaBollettino - OK

  Background:
    Given systems up
    And initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
          <nod:verificaBollettinoReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <ccPost>666666666666</ccPost>
            <noticeNumber>#notice_number#</noticeNumber>
          </nod:verificaBollettinoReq>
        </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: Check valid URL in WSDL namespace
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response

  # TODO implement with api-config
  #  # ccPost associato a due PA - [SEM_VB_15]
  #  Scenario: Check outcome OK if ccPost is associated with two EC
  #    Given ccPost associated with two EC  #"INSERT INTO NODO4_CFG.CODIFICHE_PA (CODICE_PA, FK_CODIFICA, FK_PA) VALUES ('${codicePA}', 1, 6023)"
  #    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
  #    Then check outcome is OK




  #[SEM_VB_13] pt.1
  Scenario Outline: Execute verificaBollettino request
    #Given saving verificaBollettino request in verificaBollettinoTmp
    Given <elem> with <value> in verificaBollettino
    When psp sends soap verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of verificaBollettino response
    Examples:
      | elem  | value                                 | soapUI test |
      | idPSP | 123456789012345678901234567890123456  | SEM_VB_13   |

  #[SEM_VB_13] pt.2
  Scenario: Last call verificaBollettino
    Given the Execute verificaBollettino request scenario executed successfully
    #And saving verificaBollettinoTmp request in verificaBollettino
    When psp sends soap verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
