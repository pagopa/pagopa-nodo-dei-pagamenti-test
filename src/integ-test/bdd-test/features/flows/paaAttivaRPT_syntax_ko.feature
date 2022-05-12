Feature: check syntax KO for paaAttivaRPT

    Background:
    Given systems up
    Given initial XML activatePaymentNotice
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
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """
    Given EC old version

    Scenario Outline: 
    Given initial XML paaAttivaRPT
     # MODIFICARE IL TIPO DI RISPOSTA (https://pagopa.atlassian.net/wiki/spaces/PAG/pages/493617751/Analisi+paaAttivaRPT)
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
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """
      And <tag> with <tag_value> paaAttivaRPT
      And if outcome is KO set fault to None in paaAttivaRPT
      And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
      When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of activatePaymentNotice response
      And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
      Examples:
      |          tag                 |  tag_value                |    soapUI test       |
      | datiPagamentoPA              | None                      |   SIN_PARPTR_11      |
      | datiPagamentoPA              | RemoveParent              |   SIN_PARPTR_12      |
      | datiPagamentoPA              | Empty                     |   SIN_PARPTR_13      |
      | importoSingoloVersamento     | None                      |   SIN_PARPTR_14      |
      | importoSingoloVersamento     | Empty                     |   SIN_PARPTR_15      |
      | importoSingoloVersamento     | 105,1234                  |   SIN_PARPTR_16      |
      | importoSingoloVersamento     | 105.2                     |   SIN_PARPTR_17      |
      | importoSingoloVersamento     | 105.256                   |   SIN_PARPTR_17      |
      | importoSingoloVersamento     | 12ad45rtyu78hj56          |   SIN_PARPTR_18      |
      | ibanAccredito                | None                      |   SIN_PARPTR_19      |
      | ibanAccredito                | Empty                     |   SIN_PARPTR_20      |

      

      




