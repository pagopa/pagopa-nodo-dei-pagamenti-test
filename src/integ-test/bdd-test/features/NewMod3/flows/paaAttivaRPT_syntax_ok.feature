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
                <nod:paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamento>
                        <importoSingoloVersamento>importo_singolo_versamento</importoSingoloVersamento>
                        <ibanAccredito>iban_accredito</ibanAccredito>
                        <bicAccredito>bic_accredito</bicAccredito>
                        <enteBeneficiario>ente_beneficiario</enteBeneficiario>
                        <credenzialiPagatore>credenziali_pagatore</credenzialiPagatore>
                        <causaleVersamento>causale_versamento</causaleVersamento>
                        <spezzoniCausaleVersamento>
                            <spezzoneCausaleVersamento>spezzone_causale_versamento</spezzoneCausaleVersamento>
                            <spezzoneStrutturaCausaleVersamento>
                                <causaleSpezzone>causale_spezzone</causaleSpezzone>
                                <importoSpezzone>importo_spezzone</importoSpezzone>
                            </spezzoneStrutturaCausaleVersamento>
                        </spezzoniCausaleVersamento>
                    </datiPagamento>
                </nod:paaAttivaRPTRisposta>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And <tag> with <tag_value> paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Examples:
            | tag                        | tag_value | soapUI test   |
            | soapenv:Header             | None      | SIN_PARPTR_01 |
            | bicAccredito               | None      | SIN_PARPTR_22 |
            | enteBeneficiario           | None      | SIN_PARPTR_25 |
            | codiceUnitOperBeneficiario | None      | SIN_PARPTR_41 |
            | denomUnitOperBeneficiario  | None      | SIN_PARPTR_44 |
            | indirizzoBeneficiario      | None      | SIN_PARPTR_47 |
            | civicoBeneficiario         | None      | SIN_PARPTR_50 |
            | capBeneficiario            | None      | SIN_PARPTR_53 |
            | localitaBeneficiario       | None      | SIN_PARPTR_56 |
            | provinciaBeneficiario      | None      | SIN_PARPTR_59 |
            | nazioneBeneficiario        | None      | SIN_PARPTR_62 |
            | credenzialiPagatore        | None      | SIN_PARPTR_65 |
