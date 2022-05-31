Feature: check syntax OK for paaVerificaRPTRes

    Background:
        Given systems up
        And EC old version
        And initial XML verifyPaymentNotice
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

    Scenario Outline: 
        Given initial XML paaVerificaRPTRes
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:paaVerificaRPTRisposta>
                        <esito>OK</esito>
                        <datiPagamentoPA>dati_pagamento_PA</datiPagamentoPA>
                        <importoSingoloVersamento>
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
                        </importoSingoloVersamento>
                    </nod:paaVerificaRPTRisposta>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in paaVerificaRPTRes
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPTRes
        When psp sends soap verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Examples:
            | tag                        | tag_value | soapUI test   |
            | codiceUnitOperBeneficiario | None      | SIN_PVRPTR_41 |
            | denomUnitOperBeneficiario  | None      | SIN_PVRPTR_44 |
            | indirizzoBeneficiario      | None      | SIN_PVRPTR_47 |
            | civicoBeneficiario         | None      | SIN_PVRPTR_50 |
            | capBeneficiario            | None      | SIN_PVRPTR_53 |
            | localitaBeneficiario       | None      | SIN_PVRPTR_56 |
            | provinciaBeneficiario      | None      | SIN_PVRPTR_59 |
