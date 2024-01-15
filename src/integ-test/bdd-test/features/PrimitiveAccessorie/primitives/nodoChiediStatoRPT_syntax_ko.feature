Feature: Syntax checks for nodoChiediStatoRPT - KO

    Background:
        Given systems up

@runnable @independent
    # [CSRPTSIN1]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediStatoRPT primitive
        Given initial XML nodoChiediStatoRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header>
                    <ppt:IntestazionePPT>ciao</ppt:IntestazionePPT>
                </soapenv:Header>
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
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediStatoRPT response

@runnable @independent
    # [CSRPTSIN5]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediStatoRPT primitive
        Given initial XML nodoChiediStatoRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header />
                <soapenv:Body>
                    <ppt:nodoChiediStatoRPT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>44444444444</identificativoDominio>
                        <identificativoUnivocoVersamento>IUV-2022-06-08-15:57:10.978</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                    </ppt:nodoChiediStatoRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediStatoRPT response

@runnable @independent
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediStatoRPT primitive
        Given initial XML nodoChiediStatoRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header />
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
        And <tag> with <tag_value> in nodoChiediStatoRPT
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediStatoRPT response
        Examples:
            | tag                                   | tag_value                            | soapUI test |
            | soapenv:Body                          | Empty                                | CSRPTSIN2   |
            | soapenv:Body                          | None                                 | CSRPTSIN3   |
            | ws:nodoChiediStatoRPT                 | Empty                                | CSRPTSIN4   |
            | identificativoIntermediarioPA         | None                                 | CSRPTSIN6   |
            | identificativoIntermediarioPA         | Empty                                | CSRPTSIN7   |
            | identificativoIntermediarioPA         | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CSRPTSIN8   |
            | identificativoStazioneIntermediarioPA | None                                 | CSRPTSIN9   |
            | identificativoStazioneIntermediarioPA | Empty                                | CSRPTSIN10  |
            | identificativoStazioneIntermediarioPA | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CSRPTSIN11  |
            | password                              | None                                 | CSRPTSIN12  |
            | password                              | Empty                                | CSRPTSIN13  |
            | password                              | aaaaaaa                              | CSRPTSIN14  |
            | password                              | aaaaaaaaaaaaaaaa                     | CSRPTSIN15  |
            | identificativoDominio                 | None                                 | CSRPTSIN16  |
            | identificativoDominio                 | Empty                                | CSRPTSIN17  |
            | identificativoDominio                 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CSRPTSIN18  |
            | identificativoUnivocoVersamento       | None                                 | CSRPTSIN19  |
            | identificativoUnivocoVersamento       | Empty                                | CSRPTSIN20  |
            | identificativoUnivocoVersamento       | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CSRPTSIN21  |
            | codiceContestoPagamento               | None                                 | CSRPTSIN22  |
            | codiceContestoPagamento               | Empty                                | CSRPTSIN23  |
            | codiceContestoPagamento               | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CSRPTSIN24  |