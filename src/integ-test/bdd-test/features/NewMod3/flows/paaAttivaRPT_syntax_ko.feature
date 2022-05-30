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
        Given initial XML paaAttivaRPTRisposta
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
        And <tag> with <tag_value> in paaAttivaRPTRisposta
        And if outcome is KO set fault to None in paaAttivaRPTRisposta
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPTRisposta
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
        Examples:
            | tag                               | tag_value                                                                                                                                     | soapUI test   |
            | soapenv:Body                      | None                                                                                                                                          | SIN_PARPTR_02 |
            | soapenv:Body                      | Empty                                                                                                                                         | SIN_PARPTR_03 |
            | soapenv:paaAttivaRPTRisposta      | None                                                                                                                                          | SIN_PARPTR_04 |
            | paaAttivaRPTRisposta              | RemoveParent                                                                                                                                  | SIN_PARPTR_05 |
            | paaAttivaRPTRisposta              | Empty                                                                                                                                         | SIN_PARPTR_06 |
            | esito                             | None                                                                                                                                          | SIN_PARPTR_07 |
            | esito                             | Empty                                                                                                                                         | SIN_PARPTR_08 |
            | esito                             | prova                                                                                                                                         | SIN_PARPTR_09 |
            | datiPagamentoPA                   | None                                                                                                                                          | SIN_PARPTR_11 |
            | datiPagamentoPA                   | RemoveParent                                                                                                                                  | SIN_PARPTR_12 |
            | datiPagamentoPA                   | Empty                                                                                                                                         | SIN_PARPTR_13 |
            | importoSingoloVersamento          | None                                                                                                                                          | SIN_PARPTR_14 |
            | importoSingoloVersamento          | Empty                                                                                                                                         | SIN_PARPTR_15 |
            | importoSingoloVersamento          | 105,1234                                                                                                                                      | SIN_PARPTR_16 |
            | importoSingoloVersamento          | 105.2                                                                                                                                         | SIN_PARPTR_17 |
            | importoSingoloVersamento          | 105.256                                                                                                                                       | SIN_PARPTR_17 |
            | importoSingoloVersamento          | 12ad45rtyu78hj56                                                                                                                              | SIN_PARPTR_18 |
            | ibanAccredito                     | None                                                                                                                                          | SIN_PARPTR_19 |
            | ibanAccredito                     | Empty                                                                                                                                         | SIN_PARPTR_20 |
            | ibanAccredito                     | LzMdYpAMYOmncJuwfSlsuAEykZeutSzYUMn                                                                                                           | SIN_PARPTR_21 |
            | bicAccredito                      | Empty                                                                                                                                         | SIN_PARPTR_23 |
            | bicAccredito                      | oZGFzQB                                                                                                                                       | SIN_PARPTR_24 |
            | bicAccredito                      | CmlNroXzd                                                                                                                                     | SIN_PARPTR_24 |
            | bicAccredito                      | dtBhfpmUWBRl                                                                                                                                  | SIN_PARPTR_24 |
            | enteBeneficiario                  | RemoveParent                                                                                                                                  | SIN_PARPTR_26 |
            | enteBeneficiario                  | Empty                                                                                                                                         | SIN_PARPTR_27 |
            | identificativoUnivocoBeneficiario | None                                                                                                                                          | SIN_PARPTR_28 |
            | identificativoUnivocoBeneficiario | RemoveParent                                                                                                                                  | SIN_PARPTR_29 |
            | identificativoUnivocoBeneficiario | Empty                                                                                                                                         | SIN_PARPTR_30 |
            | tipoIdentificativoUnivoco         | None                                                                                                                                          | SIN_PARPTR_31 |
            | tipoIdentificativoUnivoco         | Empty                                                                                                                                         | SIN_PARPTR_32 |
            | tipoIdentificativoUnivoco         | F                                                                                                                                             | SIN_PARPTR_33 |
            | tipoIdentificativoUnivoco         | GG                                                                                                                                            | SIN_PARPTR_34 |
            | codiceIdentificativoUnivoco       | None                                                                                                                                          | SIN_PARPTR_35 |
            | codiceIdentificativoUnivoco       | Empty                                                                                                                                         | SIN_PARPTR_36 |
            | codiceIdentificativoUnivoco       | cuOgco5MdQNeL4OwY                                                                                                                             | SIN_PARPTR_37 |
            | denominazioneBeneficiario         | None                                                                                                                                          | SIN_PARPTR_38 |
            | denominazioneBeneficiario         | Empty                                                                                                                                         | SIN_PARPTR_39 |
            | denominazioneBeneficiario         | lM0Gm66IEpiwsuLFPC0MWYX1WP2UbKF5lkLIF2N5fNrznVcf1WNnfZexSwDOWamXqrN1Ezi                                                                       | SIN_PARPTR_40 |
            | codiceUnitOperBeneficiario        | Empty                                                                                                                                         | SIN_PARPTR_42 |
            | codiceUnitOperBeneficiario        | OhCLdNnMWyuZOFxLHPJvnBQdPSRBOuUzeaPZ                                                                                                          | SIN_PARPTR_43 |
            | denomUnitOperBeneficiario         | Empty                                                                                                                                         | SIN_PARPTR_45 |
            | denomUnitOperBeneficiario         | YHBRElAVeOXtUdkTzMEbXZDQGuUxaVATbLRRrahkOhTvWDaHfrmyFuWwfuIrmAHkdxWepJf                                                                       | SIN_PARPTR_46 |
            | indirizzoBeneficiario             | Empty                                                                                                                                         | SIN_PARPTR_48 |
            | indirizzoBeneficiario             | YHBRElAVeOXtUdkTzMEbXZDQGuUxaVATbLRRrahkOhTvWDaHfrmyFuWwfuIrmAHkdxWepJf                                                                       | SIN_PARPTR_49 |
            | civicoBeneficiario                | Empty                                                                                                                                         | SIN_PARPTR_51 |
            | civicoBeneficiario                | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PARPTR_52 |
            | capBeneficiario                   | Empty                                                                                                                                         | SIN_PARPTR_54 |
            | capBeneficiario                   | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PARPTR_55 |
            | localitaBeneficiario              | Empty                                                                                                                                         | SIN_PARPTR_57 |
            | localitaBeneficiario              | JcGmMhGsOtwaHHhylTsKjCEBLaGjNVUKEsMM                                                                                                          | SIN_PARPTR_58 |
            | provinciaBeneficiario             | Empty                                                                                                                                         | SIN_PARPTR_60 |
            | provinciaBeneficiario             | 12AS57rjifijoi245685asdas1568wa4846                                                                                                           | SIN_PARPTR_61 |
            | nazioneBeneficiario               | Empty                                                                                                                                         | SIN_PARPTR_63 |
            | nazioneBeneficiario               | 1A                                                                                                                                            | SIN_PARPTR_64 |
            | nazioneBeneficiario               | 1                                                                                                                                             | SIN_PARPTR_64 |
            | nazioneBeneficiario               | E                                                                                                                                             | SIN_PARPTR_64 |
            | credenzialiPagatore               | Empty                                                                                                                                         | SIN_PARPTR_66 |
            | credenzialiPagatore               | 12AS57rjifijoi245685asdas1568wa4846                                                                                                           | SIN_PARPTR_67 |
            | causaleVersamento                 | None                                                                                                                                          | SIN_PARPTR_68 |
            | causaleVersamento                 | Empty                                                                                                                                         | SIN_PARPTR_69 |
            | causaleVersamento                 | CXYFD9jxEWpaefYPBMGaWHbDBIeU01JMraSQJ7VKHnfWT75DaLXvAPEcV7TDFfThv4u56iGvFT86Ui0ma9EVs1kRk5ETNjGc281weayrfiiHauaJfSNTDxqMONb7tN3PkkgBcn1gJxr6Y | SIN_PARPTR_70 |






