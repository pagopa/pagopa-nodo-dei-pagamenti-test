Feature:  syntax checks KO for activatePaymentNoticeReq

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
          <soapenv:Header/>
          <soapenv:Body>
              <nod:activatePaymentNoticeReq>
                  <idPSP>70000000001</idPSP>
                  <idBrokerPSP>70000000001</idBrokerPSP>
                  <idChannel>70000000001_01</idChannel>
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

  # attribute value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
    Given <attribute> set <value> for <elem> in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNotice response
    Examples:
      | elem             | attribute     | value                                     | soapUI test |
      | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_APNR_01 |

	  
  # element value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNotice response
    Examples:
      | elem                         | value                                                                                                                                                                                                               | soapUI test   |
      | idPSP                        | 123456789012345678901234567890123456                                                                                                                                                                                | SIN_APNR_07   |
      | idPSP                        | None                                                                                                                                                                                                                | SIN_APNR_05   |
      | idPSP                        | Empty                                                                                                                                                                                                               | SIN_APNR_06   |
      | idBrokerPSP                  | 123456789012345678901234567890123456                                                                                                                                                                                | SIN_APNR_10   |
      | idBrokerPSP                  | None                                                                                                                                                                                                                | SIN_APNR_08   |
      | idBrokerPSP                  | Empty                                                                                                                                                                                                               | SIN_APNR_09   |
      | idChannel                    | 123456789012345678901234567890123456                                                                                                                                                                                | SIN_APNR_13   |
      | idChannel                    | None                                                                                                                                                                                                                | SIN_APNR_11   |
      | idChannel                    | Empty                                                                                                                                                                                                               | SIN_APNR_12   |
      | password                     | None                                                                                                                                                                                                                | SIN_APNR_14   |
      | password                     | Empty                                                                                                                                                                                                               | SIN_APNR_15   |
      | password                     | 1234567                                                                                                                                                                                                             | SIN_APNR_16   |
      | password                     | 1234567890123456                                                                                                                                                                                                    | SIN_APNR_17   |
      | qrCode                       | None                                                                                                                                                                                                                | SIN_APNR_23   |
      | qrCode                       | Empty                                                                                                                                                                                                               | SIN_APNR_25   |
      | fiscalCode                   | None                                                                                                                                                                                                                | SIN_APNR_26   |
      | fiscalCode                   | Empty                                                                                                                                                                                                               | SIN_APNR_27   |
      | fiscalCode                   | 1234567890                                                                                                                                                                                                          | SIN_APNR_28   |
      | fiscalCode                   | 123456789012                                                                                                                                                                                                        | SIN_APNR_29   |
      | fiscalCode                   | 12345jh%lk9                                                                                                                                                                                                         | SIN_APNR_30   |
      | noticeNumber                 | None                                                                                                                                                                                                                | SIN_APNR_31   |
      | noticeNumber                 | Empty                                                                                                                                                                                                               | SIN_APNR_32   |
      | noticeNumber                 | 12345678901234567                                                                                                                                                                                                   | SIN_APNR_33   |
      | noticeNumber                 | 1234567890123456789                                                                                                                                                                                                 | SIN_APNR_33   |
      | noticeNumber                 | 12345678901234567A                                                                                                                                                                                                  | SIN_APNR_34   |
      | noticeNumber                 | 12345678901234567!                                                                                                                                                                                                  | SIN_APNR_34   |
      | soapenv:Body                 | None                                                                                                                                                                                                                | SIN_APNR_02   |
      | soapenv:Body                 | Empty                                                                                                                                                                                                               | SIN_APNR_03   |
      | nod:activatePaymentNoticeReq | Empty                                                                                                                                                                                                               | SIN_APNR_04   |
      | idempotencyKey               | 70000000001.1244565744                                                                                                                                                                                              | SIN_APNR_20   |
      | idempotencyKey               | 70000000001_%244565744                                                                                                                                                                                              | SIN_APNR_20   |
      | idempotencyKey               | 70000000001-1244565744                                                                                                                                                                                              | SIN_APNR_20   |
      | idempotencyKey               | 1244565768_70000000001                                                                                                                                                                                              | SIN_APNR_20   |
      | idempotencyKey               | 1244565744                                                                                                                                                                                                          | SIN_APNR_20   |
      | idempotencyKey               | 700000000011244565744                                                                                                                                                                                               | SIN_APNR_20   |
      | idempotencyKey               | 70000000001_12445657684                                                                                                                                                                                             | SIN_APNR_21   |
      | idempotencyKey               | 70000000001_124456576                                                                                                                                                                                               | SIN_APNR_22   |
      | idempotencyKey               | 700000hj123_1244565767                                                                                                                                                                                              | SIN_APNR_22.1 |
      | expirationTime               | 2021-12-12T12:12:12                                                                                                                                                                                                 | SIN_APNR_37   |
      | expirationTime               | 48:12:12                                                                                                                                                                                                            | SIN_APNR_37   |
      | expirationTime               | 12:12                                                                                                                                                                                                               | SIN_APNR_37   |
      | expirationTime               | 1800001                                                                                                                                                                                                             | SIN_APNR_38   |
      | amount                       | 10,00                                                                                                                                                                                                               | SIN_APNR_41   |
      | amount                       | 10.1                                                                                                                                                                                                                | SIN_APNR_42   |
      | amount                       | 10.123                                                                                                                                                                                                              | SIN_APNR_42   |
      | amount                       | 10.120                                                                                                                                                                                                              | SIN_APNR_42   |
      | amount                       | 8881234567.00                                                                                                                                                                                                       | SIN_APNR_43   |
      | dueDate                      | 12-28-2021                                                                                                                                                                                                          | SIN_APNR_46   |
      | dueDate                      | 12-12-21                                                                                                                                                                                                            | SIN_APNR_46   |
      | dueDate                      | 2021-03-06T15:25:32                                                                                                                                                                                                 | SIN_APNR_46   |
      | paymentNote                  | test di prova sulla lunghezza superiore a 140 caratteri per il parametro della primitiva activatePaymentNoticeReq paymentNote prova prova pro activatePaymentNoticeReq paymentNote prova prova pro activatePaymentN | SIN_APNR_49   |

