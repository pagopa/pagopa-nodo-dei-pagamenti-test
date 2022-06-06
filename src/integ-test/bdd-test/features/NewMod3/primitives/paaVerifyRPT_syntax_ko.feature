Feature: check syntax KO for paaVerificaRPTRes

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

    Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
        Given initial XML paVerifyPaymentNotice
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
            
        And <tag> with <tag_value> in paVerifyPaymentNotice
        And if esito is KO set fault to None in paVerifyPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends soap verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of verifyPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verifyPaymentNotice response
        Examples:
            | tag                               | tag_value                                                                                                                                     | soapUI test   |
            | soapenv:Body                      | None                                                                                                                                          | SIN_PVRPTR_02 |
            | soapenv:Body                      | Empty                                                                                                                                         | SIN_PVRPTR_03 |
            | paaVerificaRPTRisposta            | None                                                                                                                                          | SIN_PVRPTR_04 |
            | paaVerificaRPTRisposta            | RemoveParent                                                                                                                                  | SIN_PVRPTR_05 |
            | paaVerificaRPTRisposta            | Empty                                                                                                                                         | SIN_PVRPTR_06 |
            | esito                             | None                                                                                                                                          | SIN_PVRPTR_07 |
            | esito                             | Empty                                                                                                                                         | SIN_PVRPTR_08 |
            | esito                             | prova                                                                                                                                         | SIN_PVRPTR_09 |
            | fault                             | None                                                                                                                                          | SIN_PVRPTR_10 |
            | datiPagamentoPA					| None 																																			| SIN_PVRPTR_11 |
			| datiPagamentoPA					| RemoveParent 																																	| SIN_PVRPTR_12 |
			| datiPagamentoPA					| Empty 																																		| SIN_PVRPTR_13 |
			| importoSingoloVersamento          | None                                                                                                                                          | SIN_PVRPTR_14 |
			| importoSingoloVersamento          | Empty                                                                                                                                         | SIN_PVRPTR_15 |
			| importoSingoloVersamento          | 105,1234                                                                                                                                      | SIN_PVRPTR_16 |
			| importoSingoloVersamento          | 105,2                                                                                                                                         | SIN_PVRPTR_17 |
			| importoSingoloVersamento          | 105,256                                                                                                                                       | SIN_PVRPTR_17 |
			| importoSingoloVersamento          | 12ad45rtyu78hj56                                                                                                                              | SIN_PVRPTR_18 |
			| ibanAccredito                     | None                                                                                                                                          | SIN_PVRPTR_19 |
			| ibanAccredito                     | Empty                                                                                                                                         | SIN_PVRPTR_20 |
            | ibanAccredito                     | llpKVR96sxH3YSZJWewdpG0L4SmAgBp3SHhP                                                                                                          | SIN_PVRPTR_21 |
            | bicAccredito                      | Empty                                                                                                                                         | SIN_PVRPTR_23 |
            | bicAccredito                      | 09rCLPr                                                                                                                                       | SIN_PVRPTR_24 |
            | bicAccredito                      | fY5u4rjEv                                                                                                                                     | SIN_PVRPTR_24 |
            | bicAccredito                      | SF4ukrEcsc2S                                                                                                                                  | SIN_PVRPTR_24 |
            | enteBeneficiario                  | RemoveParent                                                                                                                                  | SIN_PVRPTR_26 |
            | enteBeneficiario                  | Empty                                                                                                                                         | SIN_PVRPTR_27 |
            | identificativoUnivocoBeneficiario | None                                                                                                                                          | SIN_PVRPTR_28 |
            | identificativoUnivocoBeneficiario | RemoveParent                                                                                                                                  | SIN_PVRPTR_29 |
            | identificativoUnivocoBeneficiario | Empty                                                                                                                                         | SIN_PVRPTR_30 |
            | tipoIdentificativoUnivoco         | None                                                                                                                                          | SIN_PVRPTR_31 |
            | tipoIdentificativoUnivoco         | Empty                                                                                                                                         | SIN_PVRPTR_32 |
            | tipoIdentificativoUnivoco         | W                                                                                                                                             | SIN_PVRPTR_33 |
            | tipoIdentificativoUnivoco         | GG                                                                                                                                            | SIN_PVRPTR_34 |
            | codiceIdentificativoUnivoco       | None                                                                                                                                          | SIN_PVRPTR_35 |
            | codiceIdentificativoUnivoco       | Empty                                                                                                                                         | SIN_PVRPTR_36 |
            | codiceIdentificativoUnivoco       | aqs41D94P1BE9FYYU                                                                                                                             | SIN_PVRPTR_37 |
            | denominazioneBeneficiario         | None                                                                                                                                          | SIN_PVRPTR_38 |
            | denominazioneBeneficiario         | Empty                                                                                                                                         | SIN_PVRPTR_39 |
            | denominazioneBeneficiario         | n07sBU01xx8FYhQ1rLXdCi6X0hlZ9fyI4npmVn0XSNIXnqThaMVZ4iDfmrw3Jck9T7iDQgM                                                                       | SIN_PVRPTR_40 |
            | codiceUnitOperBeneficiario        | Empty                                                                                                                                         | SIN_PVRPTR_42 |
            | codiceUnitOperBeneficiario        | vN9VNPz7NqFp3XpTrGw6uqXSpFsVwHmLxSRQ                                                                                                          | SIN_PVRPTR_43 |
            | denomUnitOperBeneficiario         | Empty                                                                                                                                         | SIN_PVRPTR_45 |
            | denomUnitOperBeneficiario         | 9w5Wg9acGLtILqCa6QwiscDbjJFpTi36w475Off7NAxS31uEnWiVN0SQh12xTUKl23P9kUF                                                                       | SIN_PVRPTR_46 |
            | indirizzoBeneficiario             | Empty                                                                                                                                         | SIN_PVRPTR_48 |
            | indirizzoBeneficiario             | Gd5pcvCyr6cp4QjTtYfzUC1kJ9ahQYmT0XtHcgfWQEbtnV7U4aoFb1XgoSAhW8bkD9wndKB                                                                       | SIN_PVRPTR_49 |
            | civicoBeneficiario                | Empty                                                                                                                                         | SIN_PVRPTR_51 |
            | civicoBeneficiario                | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PVRPTR_52 |
            | capBeneficiario                   | Empty                                                                                                                                         | SIN_PVRPTR_54 |
            | capBeneficiario                   | uvWjRNIKgwlykuSYZ                                                                                                                             | SIN_PVRPTR_55 |
            | localitaBeneficiario              | Empty                                                                                                                                         | SIN_PVRPTR_57 |
            | localitaBeneficiario              | JcGmMhGsOtwaHHhylTsKjCEBLaGjNVUKEsMM                                                                                                          | SIN_PVRPTR_58 |
            | provinciaBeneficiario             | Empty                                                                                                                                         | SIN_PVRPTR_60 |
      		| provinciaBeneficiario             | abc123435e5r34hjgfb3456okd3546a2mp2k                                                                                                          | SIN_PVRPTR_61 |
			| nazioneBeneficiario               | None                                                                                                                                          | SIN_PVRPTR_62 |
			| nazioneBeneficiario               | Empty                                                                                                                                         | SIN_PVRPTR_63 |
			| nazioneBeneficiario               | 1A                                                                                                                                            | SIN_PVRPTR_64 |
            | nazioneBeneficiario               | 1                                                                                                                                             | SIN_PVRPTR_64 |
            | nazioneBeneficiario               | E                                                                                                                                             | SIN_PVRPTR_64 |
			| credenzialiPagatore               | None                                                                                                                                          | SIN_PVRPTR_65 |
			| credenzialiPagatore               | Empty                                                                                                                                         | SIN_PVRPTR_66 |
			| credenzialiPagatore               | 12AS57rjifijoi245685asdas1568wa4846                                                                                                           | SIN_PVRPTR_67 |
			| causaleVersamento                 | None                                                                                                                                          | SIN_PVRPTR_68 |
            | causaleVersamento                 | Empty                                                                                                                                         | SIN_PVRPTR_69 |
			| causaleVersamento                 | CXYFD9jxEWpaefYPBMGaWHbDBIeU01JMraSQJ7VKHnfWT75DaLXvAPEcV7TDFfThv4u56iGvFT86Ui0ma9EVs1kRk5ETNjGc281weayrfiiHauaJfSNTDxqMONb7tN3PkkgBcn1gJxr6Y | SIN_PVRPTR_70 |