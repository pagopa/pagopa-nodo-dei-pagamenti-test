Feature: check syntax OK for paaVerificaRPTRes

    Background:
        Given systems up
        Given initial XML verifyPaymentNotice
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
        Given EC old version

    Scenario Outline:
        Given initial XML paaVerificaRPTRes
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
        And <tag> with <tag_value> paaVerificaRPTRes
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPTRes
        When psp sends soap verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Examples:
            | tag                        | tag_value | soapUI test   |
            | codiceUnitOperBeneficiario     | None                                 | SIN_PVRPTR_41 |
            | denomUnitOperBeneficiario      | None                                 | SIN_PVRPTR_44 |
            | indirizzoBeneficiario          | None                                 | SIN_PVRPTR_47 |
            | civicoBeneficiario             | None                                 | SIN_PVRPTR_50 |
            | capBeneficiario                | None                                 | SIN_PVRPTR_53 |
            | localitaBeneficiario           | None                                 | SIN_PVRPTR_56 |
            | provinciaBeneficiario          | None                                 | SIN_PVRPTR_59 |
