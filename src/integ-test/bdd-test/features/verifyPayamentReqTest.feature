#@config-ec
Feature:  syntax checks for verifyPaymentReq

  Background:
    Given systems up
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
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>302094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: Check valid URL in WSDL namespace
    # Given a valid WSDL
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK


  # attribute value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
    Given <attribute> set <value> for <elem> in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_SINTASSI_EXTRAXSD
    Examples:
      | elem                | attribute     | value                                     |
      | soapenv:Envelope    | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ |

  # element value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_SINTASSI_EXTRAXSD
    Examples:
      | elem         | value                                |
      | idPSP        | 123456789012345678901234567890123456 |
      | idPSP        | None                                 |
      | idPSP        | Empty                                |
      | idBrokerPSP  | 123456789012345678901234567890123456 |
      | idBrokerPSP  | None                                 |
      | idBrokerPSP  | Empty                                |
      | idChannel    | 123456789012345678901234567890123456 |
      | idChannel    | None                                 |
      | idChannel    | Empty                                |
      | password     | None                                 |
      | password     | Empty                                |
      | password     | 1234567                              |
      | password     | 123456789012345678901234567890123456 |
      | qrCode       | None                                 |
      | fiscalCode   | None                                 |
      | fiscalCode   | Empty                                |
      | fiscalCode   | 1234567890                           |
      | fiscalCode   | 123456789012                         |
      | fiscalCode   | 12345jh%lk9                          |
      | noticeNumber | None                                 |
      | noticeNumber | Empty                                |
      | noticeNumber | 12345678901234567                    |
      | noticeNumber | 1234567890123456789                  |
      | noticeNumber | 12345678901234567A                   |
      | noticeNumber | 12345678901234567!                   |
