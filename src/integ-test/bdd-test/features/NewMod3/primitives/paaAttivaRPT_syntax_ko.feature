Feature: check syntax KO for paaAttivaRPT

    Background:
        Given systems up

@runnable
    Scenario Outline:
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>#notice_number_old#</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>$activatePaymentNotice.amount</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>#broker_AGID#</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>#canale_AGID_02#</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in paaAttivaRPT
        And if outcome is KO set fault to None in paaAttivaRPT
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
        Examples:
            | tag                                   | tag_value                                                                                                                                     | soapUI test   |
            | soapenv:Body                          | None                                                                                                                                          | SIN_PARPTR_02 |
            | soapenv:Body                          | Empty                                                                                                                                         | SIN_PARPTR_03 |
            | ws:paaAttivaRPTRisposta               | None                                                                                                                                          | SIN_PARPTR_04 |
            | ws:paaAttivaRPTRisposta               | RemoveParent                                                                                                                                  | SIN_PARPTR_05 |
            | ws:paaAttivaRPTRisposta               | Empty                                                                                                                                         | SIN_PARPTR_06 |
            | esito                                 | None                                                                                                                                          | SIN_PARPTR_07 |
            | esito                                 | Empty                                                                                                                                         | SIN_PARPTR_08 |
            | esito                                 | prova                                                                                                                                         | SIN_PARPTR_09 |
            | datiPagamentoPA                       | None                                                                                                                                          | SIN_PARPTR_11 |
            | datiPagamentoPA                       | RemoveParent                                                                                                                                  | SIN_PARPTR_12 |
            | datiPagamentoPA                       | Empty                                                                                                                                         | SIN_PARPTR_13 |
            | importoSingoloVersamento              | None                                                                                                                                          | SIN_PARPTR_14 |
            | importoSingoloVersamento              | Empty                                                                                                                                         | SIN_PARPTR_15 |
            | importoSingoloVersamento              | 105,1234                                                                                                                                      | SIN_PARPTR_16 |
            | importoSingoloVersamento              | 105.2                                                                                                                                         | SIN_PARPTR_17 |
            | importoSingoloVersamento              | 105.256                                                                                                                                       | SIN_PARPTR_17 |
            | importoSingoloVersamento              | 12ad45rtyu78hj56                                                                                                                              | SIN_PARPTR_18 |
            | ibanAccredito                         | None                                                                                                                                          | SIN_PARPTR_19 |
            | ibanAccredito                         | Empty                                                                                                                                         | SIN_PARPTR_20 |
            | ibanAccredito                         | LzMdYpAMYOmncJuwfSlsuAEykZeutSzYUMn                                                                                                           | SIN_PARPTR_21 |
            | bicAccredito                          | Empty                                                                                                                                         | SIN_PARPTR_23 |
            | bicAccredito                          | oZGFzQB                                                                                                                                       | SIN_PARPTR_24 |
            | bicAccredito                          | CmlNroXzd                                                                                                                                     | SIN_PARPTR_24 |
            | bicAccredito                          | dtBhfpmUWBRl                                                                                                                                  | SIN_PARPTR_24 |
            | enteBeneficiario                      | RemoveParent                                                                                                                                  | SIN_PARPTR_26 |
            | enteBeneficiario                      | Empty                                                                                                                                         | SIN_PARPTR_27 |
            | pag:identificativoUnivocoBeneficiario | None                                                                                                                                          | SIN_PARPTR_28 |
            | pag:identificativoUnivocoBeneficiario | RemoveParent                                                                                                                                  | SIN_PARPTR_29 |
            | pag:identificativoUnivocoBeneficiario | Empty                                                                                                                                         | SIN_PARPTR_30 |
            | pag:tipoIdentificativoUnivoco         | None                                                                                                                                          | SIN_PARPTR_31 |
            | pag:tipoIdentificativoUnivoco         | Empty                                                                                                                                         | SIN_PARPTR_32 |
            | pag:tipoIdentificativoUnivoco         | F                                                                                                                                             | SIN_PARPTR_33 |
            | pag:tipoIdentificativoUnivoco         | GG                                                                                                                                            | SIN_PARPTR_34 |
            | pag:codiceIdentificativoUnivoco       | None                                                                                                                                          | SIN_PARPTR_35 |
            | pag:codiceIdentificativoUnivoco       | Empty                                                                                                                                         | SIN_PARPTR_36 |
            | pag:codiceIdentificativoUnivoco       | cuOgco5MdQNeL4OwY                                                                                                                             | SIN_PARPTR_37 |
            | pag:denominazioneBeneficiario         | None                                                                                                                                          | SIN_PARPTR_38 |
            | pag:denominazioneBeneficiario         | Empty                                                                                                                                         | SIN_PARPTR_39 |
            | pag:denominazioneBeneficiario         | lM0Gm66IEpiwsuLFPC0MWYX1WP2UbKF5lkLIF2N5fNrznVcf1WNnfZexSwDOWamXqrN1Ezi                                                                       | SIN_PARPTR_40 |
            | pag:codiceUnitOperBeneficiario        | Empty                                                                                                                                         | SIN_PARPTR_42 |
            | pag:codiceUnitOperBeneficiario        | OhCLdNnMWyuZOFxLHPJvnBQdPSRBOuUzeaPZ                                                                                                          | SIN_PARPTR_43 |
            | pag:denomUnitOperBeneficiario         | Empty                                                                                                                                         | SIN_PARPTR_45 |
            | pag:denomUnitOperBeneficiario         | YHBRElAVeOXtUdkTzMEbXZDQGuUxaVATbLRRrahkOhTvWDaHfrmyFuWwfuIrmAHkdxWepJf                                                                       | SIN_PARPTR_46 |
            | pag:indirizzoBeneficiario             | Empty                                                                                                                                         | SIN_PARPTR_48 |
            | pag:indirizzoBeneficiario             | YHBRElAVeOXtUdkTzMEbXZDQGuUxaVATbLRRrahkOhTvWDaHfrmyFuWwfuIrmAHkdxWepJf                                                                       | SIN_PARPTR_49 |
            | pag:civicoBeneficiario                | Empty                                                                                                                                         | SIN_PARPTR_51 |
            | pag:civicoBeneficiario                | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PARPTR_52 |
            | pag:capBeneficiario                   | Empty                                                                                                                                         | SIN_PARPTR_54 |
            | pag:capBeneficiario                   | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PARPTR_55 |
            | pag:localitaBeneficiario              | Empty                                                                                                                                         | SIN_PARPTR_57 |
            | pag:localitaBeneficiario              | JcGmMhGsOtwaHHhylTsKjCEBLaGjNVUKEsMM                                                                                                          | SIN_PARPTR_58 |
            | pag:provinciaBeneficiario             | Empty                                                                                                                                         | SIN_PARPTR_60 |
            | pag:provinciaBeneficiario             | 12AS57rjifijoi245685asdas1568wa48461                                                                                                          | SIN_PARPTR_61 |
            | pag:nazioneBeneficiario               | Empty                                                                                                                                         | SIN_PARPTR_63 |
            | pag:nazioneBeneficiario               | 1A                                                                                                                                            | SIN_PARPTR_64 |
            | pag:nazioneBeneficiario               | 1                                                                                                                                             | SIN_PARPTR_64 |
            | pag:nazioneBeneficiario               | E                                                                                                                                             | SIN_PARPTR_64 |
            | credenzialiPagatore                   | Empty                                                                                                                                         | SIN_PARPTR_66 |
            | credenzialiPagatore                   | 12AS57rjifijoi245685asdas1568wa48461                                                                                                          | SIN_PARPTR_67 |
            | causaleVersamento                     | None                                                                                                                                          | SIN_PARPTR_68 |
            | causaleVersamento                     | CXYFD9jxEWpaefYPBMGaWHbDBIeU01JMraSQJ7VKHnfWT75DaLXvAPEcV7TDFfThv4u56iGvFT86Ui0ma9EVs1kRk5ETNjGc281weayrfiiHauaJfSNTDxqMONb7tN3PkkgBcn1gJxr6Y | SIN_PARPTR_70 |
