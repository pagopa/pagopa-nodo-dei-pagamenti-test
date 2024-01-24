Feature: Semantic checks for nodoChiediStatoRPT - KO

    Background:
        Given systems up
        And initial XML nodoChiediStatoRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:nodoChiediStatoRPT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>44444444444</identificativoDominio>
                        <identificativoUnivocoVersamento>IUV-2022-06-08-15:57:10.978</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                    </ws:nodoChiediStatoRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """

@runnable
    Scenario Outline: Check semantic errors for nodoChiediStatoRPT primitive
        Given <tag> with <tag_value> in nodoChiediStatoRPT
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediStatoRPT response
        Examples:
            | tag                                   | tag_value               | error                             | soapUI test |
            | identificativoIntermediarioPA         | 12345678901             | PPT_INTERMEDIARIO_PA_SCONOSCIUTO  | CSRPTSEM1   |
            | identificativoIntermediarioPA         | INT_NOT_ENABLED         | PPT_INTERMEDIARIO_PA_DISABILITATO | CSRPTSEM2   |
            | identificativoStazioneIntermediarioPA | unknownStation          | PPT_STAZIONE_INT_PA_SCONOSCIUTA   | CSRPTSEM3   |
            | identificativoStazioneIntermediarioPA | #id_station_disabled#   | PPT_STAZIONE_INT_PA_DISABILITATA  | CSRPTSEM4   |
            | password                              | wrongPassword           | PPT_AUTENTICAZIONE                | CSRPTSEM5   |
            | identificativoDominio                 | 12345678922             | PPT_DOMINIO_SCONOSCIUTO           | CSRPTSEM6   |
            | identificativoDominio                 | NOT_ENABLED             | PPT_DOMINIO_DISABILITATO          | CSRPTSEM7   |
            | identificativoUnivocoVersamento       | wrongIUV                | PPT_RPT_SCONOSCIUTA               | CSRPTSEM8   |
            | codiceContestoPagamento               | wrongPaymentContextCode | PPT_RPT_SCONOSCIUTA               | CSRPTSEM9   |
            | identificativoIntermediarioPA         | 77777777777             | PPT_AUTORIZZAZIONE                | CSRPTSEM11  |

@runnable
    Scenario Outline: Check semantic errors for nodoChiediStatoRPT primitive
        Given identificativoUnivocoVersamento with <iuv_value_in_db> in nodoChiediStatoRPT
        And codiceContestoPagamento with <ccp_value_in_db> in nodoChiediStatoRPT
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediStatoRPT response
        Examples:
            | iuv_value_in_db         | ccp_value_in_db         | error                 | soapUI test |
            | 11000679416493210       | 59050                   | PPT_RPT_SCONOSCIUTA   | CSRPTSEM10  |