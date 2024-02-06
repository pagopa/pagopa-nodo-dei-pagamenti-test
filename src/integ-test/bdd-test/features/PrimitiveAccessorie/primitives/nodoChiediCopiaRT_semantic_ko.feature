Feature: Semantic checks for nodoChiediCopiaRT - KO 1425

    Background:
        Given systems up
        And initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:nodoChiediCopiaRT>
                        <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                        <identificativoUnivocoVersamento>IUV846</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>codiceContestoPagamento</codiceContestoPagamento>
                    </ws:nodoChiediCopiaRT>
                </soapenv:Body>
            </soapenv:Envelope>
            """

@runnable
    Scenario Outline: Check semantic errors for nodoChiediCopiaRT primitive
        Given <tag> with <tag_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediCopiaRT response
        Examples:
            | tag                                   | tag_value               | error                             | soapUI test |
            | identificativoIntermediarioPA         | 12345678901             | PPT_INTERMEDIARIO_PA_SCONOSCIUTO  | CCRTSEM1    |
            | identificativoIntermediarioPA         | INT_NOT_ENABLED         | PPT_INTERMEDIARIO_PA_DISABILITATO | CCRTSEM2    |
            | identificativoStazioneIntermediarioPA | unknownStation          | PPT_STAZIONE_INT_PA_SCONOSCIUTA   | CCRTSEM3    |
            | identificativoStazioneIntermediarioPA | #id_station_disabled#   | PPT_STAZIONE_INT_PA_DISABILITATA  | CCRTSEM4    |
            | password                              | wrongPassword           | PPT_AUTENTICAZIONE                | CCRTSEM5    |
            | identificativoDominio                 | 12345678922             | PPT_DOMINIO_SCONOSCIUTO           | CCRTSEM6    |
            | identificativoDominio                 | NOT_ENABLED             | PPT_DOMINIO_DISABILITATO          | CCRTSEM7    |
            | identificativoUnivocoVersamento       | wrongIUV                | PPT_RT_SCONOSCIUTA                | CCRTSEM8    |
            | codiceContestoPagamento               | wrongPaymentContextCode | PPT_RT_SCONOSCIUTA                | CCRTSEM9    |
            | identificativoIntermediarioPA         | 77777777777             | PPT_AUTORIZZAZIONE                | CCRTSEM12   |

@runnable
Scenario Outline: Check semantic errors for nodoChiediCopiaRT primitive
        Given replace status content with RPT_ACCETTATA_PSP content
        And replace pa content with #creditor_institution_code_old# content
        And execution query stati_rpt_snapshot to get value on the table STATI_RPT_SNAPSHOT, with the columns IUV, CCP under macro Primitive_accessorie with db name nodo_online
        And through the query stati_rpt_snapshot retrieve param iuv at position 0 in the row 0 and save it under the key iuv
        And through the query stati_rpt_snapshot retrieve param ccp at position 1 in the row 0 and save it under the key ccp
        And identificativoUnivocoVersamento with <iuv_value> in nodoChiediCopiaRT
        And codiceContestoPagamento with <ccp_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediCopiaRT response
        #per il test CCRTSEM11 prendere i dati dal db dalla STATI_RPT_SNAPSHOT con STATO = 'RPT_ACCETTATA_PSP'
        Examples:
            | iuv_value                       | ccp_value         | error                 | soapUI test |
            | 11000679416493210               | 59050             | PPT_RT_SCONOSCIUTA    | CCRTSEM10   |
            | $iuv                            | $ccp              | PPT_RT_NONDISPONIBILE | CCRTSEM11   |