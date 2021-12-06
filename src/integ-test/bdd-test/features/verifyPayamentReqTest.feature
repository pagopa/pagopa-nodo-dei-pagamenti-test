Feature:  syntax checks for verifyPaymentReq

  Background:
    Given systems up
      | name               | url                                                  | healthcheck      | service            |
#      | nodo-dei-pagamenti | http://localhost:8081                                | /monitor/health | /webservices/input |
#      | mock-ec            | http://localhost:8087/Pof                            | /api/v1/info    |                    |
#      | api-config         | http://localhost:8080/apiconfig/api/v1               | /info           |                    |

    And valid verifyPaymentNoticeReq soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>77777777777</fiscalCode>
                  <noticeNumber>320094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: Check valid URL in WSDL namespace
    # Given a valid WSDL
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then outcome is OK


  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
    Given <attribute> set <value> for <elem> in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then outcome is KO
    And faultCode is PPT_SINTASSI_EXTRAXSD
    Examples:
      | elem                | attribute     | value                                     |
      | soapenv:Envelope    | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ |

  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then outcome is KO
    And faultCode is PPT_SINTASSI_EXTRAXSD
    Examples:
      | elem                | value                                     |
      | idPSP               | 123456789012345678901234567890123456      |
      | idPSP               | None                                      |
      | idPSP               | Null                                      |
      | idBrokerPSP         | 123456789012345678901234567890123456      |
      | idBrokerPSP         | None                                      |
      | idBrokerPSP         | Null                                      |
      | idChannel           | 123456789012345678901234567890123456      |
      | idChannel           | None                                      |
      | idChannel           | Null                                      |
      | password            | None                                      |
      | password            | Null                                      |
      | password            | 1234567                                   |
      | password            | 123456789012345678901234567890123456      |
      | qrCode              | None                                      |
      | fiscalCode          | None                                      |
      | fiscalCode          | Null                                      |
      | fiscalCode          | 1234567890                                |
      | fiscalCode          | 123456789012                              |
      | fiscalCode          | 12345jh%lk9                               |
      | noticeNumber        | None                                      |
      | noticeNumber        | Null                                      |
      | noticeNumber        | 12345678901234567                         |
      | noticeNumber        | 1234567890123456789                       |
