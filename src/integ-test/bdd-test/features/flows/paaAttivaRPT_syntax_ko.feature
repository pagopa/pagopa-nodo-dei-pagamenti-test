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
            | tag                               | tag_value                                                               | soapUI test   |
            | soapenv:Body                      | None                                                                    | SIN_PARPTR_02 |
            | soapenv:Body                      | Empty                                                                   | SIN_PARPTR_03 |
            | soapenv:paaAttivaRPTRisposta      | None                                                                    | SIN_PARPTR_04 |
            | paaAttivaRPTRisposta              | RemoveParent                                                            | SIN_PARPTR_05 |
            | paaAttivaRPTRisposta              | Empty                                                                   | SIN_PARPTR_06 |
            | esito                             | None                                                                    | SIN_PARPTR_07 |
            | esito                             | Empty                                                                   | SIN_PARPTR_08 |
            | esito                             | prova                                                                   | SIN_PARPTR_09 |
            | datiPagamentoPA                   | None                                                                    | SIN_PARPTR_11 |
            | datiPagamentoPA                   | RemoveParent                                                            | SIN_PARPTR_12 |
            | datiPagamentoPA                   | Empty                                                                   | SIN_PARPTR_13 |
            | importoSingoloVersamento          | None                                                                    | SIN_PARPTR_14 |
            | importoSingoloVersamento          | Empty                                                                   | SIN_PARPTR_15 |
            | importoSingoloVersamento          | 105,1234                                                                | SIN_PARPTR_16 |
            | importoSingoloVersamento          | 105.2                                                                   | SIN_PARPTR_17 |
            | importoSingoloVersamento          | 105.256                                                                 | SIN_PARPTR_17 |
            | importoSingoloVersamento          | 12ad45rtyu78hj56                                                        | SIN_PARPTR_18 |
            | ibanAccredito                     | None                                                                    | SIN_PARPTR_19 |
            | ibanAccredito                     | Empty                                                                   | SIN_PARPTR_20 |
            | ibanAccredito                     | LzMdYpAMYOmncJuwfSlsuAEykZeutSzYUMn                                     | SIN_PARPTR_21 |
            | bicAccredito                      | Empty                                                                   | SIN_PARPTR_23 |
            | bicAccredito                      | oZGFzQB                                                                 | SIN_PARPTR_24 |
            | bicAccredito                      | CmlNroXzd                                                               | SIN_PARPTR_24 |
            | bicAccredito                      | dtBhfpmUWBRl                                                            | SIN_PARPTR_24 |
            | enteBeneficiario                  | RemoveParent                                                            | SIN_PARPTR_26 |
            | enteBeneficiario                  | Empty                                                                   | SIN_PARPTR_27 |
            | identificativoUnivocoBeneficiario | None                                                                    | SIN_PARPTR_28 |
            | identificativoUnivocoBeneficiario | RemoveParent                                                            | SIN_PARPTR_29 |
            | identificativoUnivocoBeneficiario | Empty                                                                   | SIN_PARPTR_30 |
            | codiceUnitOperBeneficiario        | Empty                                                                   | SIN_PARPTR_42 |
            | codiceUnitOperBeneficiario        | OhCLdNnMWyuZOFxLHPJvnBQdPSRBOuUzeaPZ                                    | SIN_PARPTR_43 |
            | denomUnitOperBeneficiario         | Empty                                                                   | SIN_PARPTR_45 |
            | denomUnitOperBeneficiario         | YHBRElAVeOXtUdkTzMEbXZDQGuUxaVATbLRRrahkOhTvWDaHfrmyFuWwfuIrmAHkdxWepJf | SIN_PARPTR_46 |
            | indirizzoBeneficiario             | Empty                                                                   | SIN_PARPTR_48 |
            | indirizzoBeneficiario             | YHBRElAVeOXtUdkTzMEbXZDQGuUxaVATbLRRrahkOhTvWDaHfrmyFuWwfuIrmAHkdxWepJf | SIN_PARPTR_49 |
            | civicoBeneficiario                | None                                                                    | SIN_PARPTR_50 |