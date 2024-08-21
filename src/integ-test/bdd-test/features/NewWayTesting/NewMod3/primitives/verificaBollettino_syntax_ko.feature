 Feature: Syntax checks for verificaBollettino - KO 1398
 
 Background:
    Given systems up
    And initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verificaBollettinoReq>
               <idPSP>POSTE3</idPSP>
               <idBrokerPSP>BANCOPOSTA</idBrokerPSP>
               <idChannel>POSTE3</idChannel>
               <password>pwdpwdpwd</password>
               <ccPost>777777777777</ccPost>
               <noticeNumber>#notice_number#</noticeNumber>
            </nod:verificaBollettinoReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
 @ALL @PRIMITIVE @PG34
 # attribute value check
 Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
    Given <attribute> set <value> for <elem> in verificaBollettino
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of verificaBollettino response
    Examples:
      | elem             | attribute     | value                                     | soapUI test |
      | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_VB_01   |
 
 @ALL @PRIMITIVE
 # element value check
 Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in verificaBollettino
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of verificaBollettino response
    Examples:
      | elem                       | value                                 | soapUI test |
      | soapenv:Body               | None                                  | SIN_VB_03   |
      | soapenv:Body               | Empty                                 | SIN_VB_02   |
      | nod:verificaBollettinoReq  | Empty                                 | SIN_VB_04   |
      | idPSP                      | None                                  | SIN_VB_05   |
      | idPSP                      | Empty                                 | SIN_VB_06   |
      | idPSP                      | 123456789012345678901234567890123456  | SIN_VB_07   |
      | idBrokerPSP                | None                                  | SIN_VB_08   |
      | idBrokerPSP                | Empty                                 | SIN_VB_09   |
      | idBrokerPSP                | 123456789012345678901234567890123456  | SIN_VB_10   |
      | idChannel                  | None                                  | SIN_VB_11   |
      | idChannel                  | Empty                                 | SIN_VB_12   |
      | idChannel                  | 123456789012345678901234567890123456  | SIN_VB_13   |
      | password                   | None                                  | SIN_VB_14   |
      | password                   | Empty                                 | SIN_VB_15   |
      | password                   | 1234567                               | SIN_VB_16   |
      | password                   | 123456789012345678901234567890123456  | SIN_VB_17   |
      | ccPost                     | None                                  | SIN_VB_18   |
      | ccPost                     | Empty                                 | SIN_VB_19   |
      | ccPost                     | 1234567890123                         | SIN_VB_20   |
      | ccPost                     | 12345678901                           | SIN_VB_21   |
      | ccPost                     | 77777777% ty                          | SIN_VB_22   |
      | noticeNumber               | None                                  | SIN_VB_23   |
      | noticeNumber               | Empty                                 | SIN_VB_24   |
      | noticeNumber               | 1234567890123456789                   | SIN_VB_25   |
      | noticeNumber               | 12345678901234567                     | SIN_VB_26   |
      | noticeNumber               | 12345678901234567A                    | SIN_VB_27   |
      | noticeNumber               | 12345678901234567!                    | SIN_VB_27   | 