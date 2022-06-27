Feature: Semantic checks for nodoChiediCopiaRT - KO

    Background:
        Given systems up
        And initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:nodoChiediCopiaRT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>44444444444</identificativoDominio>
                        <identificativoUnivocoVersamento>IUV846</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>codiceContestoPagamento</codiceContestoPagamento>
                    </ws:nodoChiediCopiaRT>
                </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario Outline: Check semantic errors for nodoChiediCopiaRT primitive
        Given <tag> with <tag_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediCopiaRT response
        Examples:
            | tag                                   | tag_value               | error                             | soapUI test |
            | identificativoIntermediarioPA         | 12345678901             | PPT_INTERMEDIARIO_PA_SCONOSCIUTO  | CCRTSEM1    |
            | identificativoIntermediarioPA         | INT_NOT_ENABLED         | PPT_INTERMEDIARIO_PA_DISABILITATO | CCRTSEM2    |
            | identificativoStazioneIntermediarioPA | unknownStation          | PPT_STAZIONE_INT_PA_SCONOSCIUTA   | CCRTSEM3    |
            | identificativoStazioneIntermediarioPA | STAZIONE_NOT_ENABLED    | PPT_STAZIONE_INT_PA_DISABILITATA  | CCRTSEM4    |
            | password                              | wrongPassword           | PPT_AUTENTICAZIONE                | CCRTSEM5    |
            | identificativoDominio                 | 12345678902             | PPT_DOMINIO_SCONOSCIUTO           | CCRTSEM6    |
            | identificativoDominio                 | NOT_ENABLED             | PPT_DOMINIO_DISABILITATO          | CCRTSEM7    |
            | identificativoUnivocoVersamento       | wrongIUV                | PPT_RT_SCONOSCIUTA                | CCRTSEM8    |
            | codiceContestoPagamento               | wrongPaymentContextCode | PPT_RT_SCONOSCIUTA                | CCRTSEM9    |
            | identificativoIntermediarioPA         | 77777777777             | PPT_AUTORIZZAZIONE                | CCRTSEM12   |

    Scenario Outline: Check semantic errors for nodoChiediCopiaRT primitive
        Given identificativoUnivocoVersamento with <iuv_value> in nodoChiediCopiaRT
        And codiceContestoPagamento with <ccp_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediCopiaRT response
        Examples:
            | iuv_value | ccp_value | error | soapUI test |
