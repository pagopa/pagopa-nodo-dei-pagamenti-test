Feature: Syntax checks for verifyPaymentReq - KO

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
          <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
              <fiscalCode>#creditor_institution_code#</fiscalCode>
              <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
          </nod:verifyPaymentNoticeReq>
        </soapenv:Body>
      </soapenv:Envelope>
      """

  # @runnable
  # # attribute value check
  # Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
  #   Given <attribute> set <value> for <elem> in verifyPaymentNotice
  #   When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
  #   Then check outcome is KO of verifyPaymentNotice response
  #   And check faultCode is PPT_SINTASSI_EXTRAXSD of verifyPaymentNotice response
  #   Examples:
  #     | elem             | attribute     | value                                     | soapUI test |
      #| soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_VPNR_01 |

  @runnable
  # element value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of verifyPaymentNotice response
    Examples:
      | elem                       | value                                | soapUI test |
      # | soapenv:Body               | None                                 | SIN_VPNR_02 |
      # | soapenv:Body               | Empty                                | SIN_VPNR_03 |
      # | nod:verifyPaymentNoticeReq | Empty                                | SIN_VPNR_04 |
      # | idPSP                      | None                                 | SIN_VPNR_05 |
      # | idPSP                      | Empty                                | SIN_VPNR_06 |
      # | idPSP                      | 123456789012345678901234567890123456 | SIN_VPNR_07 |
      # | idBrokerPSP                | None                                 | SIN_VPNR_08 |
      # | idBrokerPSP                | Empty                                | SIN_VPNR_09 |
      # | idBrokerPSP                | 123456789012345678901234567890123456 | SIN_VPNR_10 |
      # | idChannel                  | None                                 | SIN_VPNR_11 |
      # | idChannel                  | Empty                                | SIN_VPNR_12 |
      # | idChannel                  | 123456789012345678901234567890123456 | SIN_VPNR_13 |
      # | password                   | None                                 | SIN_VPNR_14 |
      # | password                   | Empty                                | SIN_VPNR_15 |
      # | password                   | 1234567                              | SIN_VPNR_16 |
      # | password                   | 123456789012345678901234567890123456 | SIN_VPNR_17 |
      # | qrCode                     | None                                 | SIN_VPNR_18 |
      # | qrCode                     | RemoveParent                         | SIN_APNR_19 |
      # | qrCode                     | Empty                                | SIN_VPNR_20 |
       | fiscalCode                 | None                                 | SIN_VPNR_21 |
      # | fiscalCode                 | Empty                                | SIN_VPNR_22 |
      # | fiscalCode                 | 1234567890                           | SIN_VPNR_23 |
      # | fiscalCode                 | 123456789012                         | SIN_VPNR_24 |
      # | fiscalCode                 | 12345jh%lk9                          | SIN_VPNR_25 |
      # | noticeNumber               | None                                 | SIN_VPNR_26 |
      # | noticeNumber               | Empty                                | SIN_VPNR_27 |
      # | noticeNumber               | 12345678901234567                    | SIN_VPNR_28 |
      # | noticeNumber               | 1234567890123456789                  | SIN_VPNR_28 |
      # | noticeNumber               | 12345678901234567A                   | SIN_VPNR_29 |
      # | noticeNumber               | 12345678901234567!                   | SIN_VPNR_29 |
