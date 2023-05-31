Feature: Syntax checks for nodoChiediCopiaRT - KO

    Background:
        Given systems up

@runnable @independent
    # [CCRTSIN1]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediCopiaRT primitive
        Given initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header>
                    <ppt:nodoChiediCopiaRT>ciao</ppt:nodoChiediCopiaRT>
                </soapenv:Header>
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
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCopiaRT response

@runnable @independent
    # [CCRTSIN5]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediCopiaRT primitive
        Given initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead">
                <soapenv:Header />
                <soapenv:Body>
                    <ppt:nodoChiediCopiaRT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>44444444444</identificativoDominio>
                        <identificativoUnivocoVersamento>IUV846</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>codiceContestoPagamento</codiceContestoPagamento>
                    </ppt:nodoChiediCopiaRT>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCopiaRT response

@runnable @independent
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediCopiaRT primitive
        Given initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header />
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
        And <tag> with <tag_value> in nodoChiediCopiaRT
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCopiaRT response
        Examples:
            | tag                                   | tag_value                            | soapUI test |
            | soapenv:Body                          | Empty                                | CCRTSIN2    |
            | soapenv:Body                          | None                                 | CCRTSIN3    |
            | ws:nodoChiediCopiaRT                  | Empty                                | CCRTSIN4    |
            | identificativoIntermediarioPA         | None                                 | CCRTSIN6    |
            | identificativoIntermediarioPA         | Empty                                | CCRTSIN7    |
            | identificativoIntermediarioPA         | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN8    |
            | identificativoStazioneIntermediarioPA | None                                 | CCRTSIN9    |
            | identificativoStazioneIntermediarioPA | Empty                                | CCRTSIN10   |
            | identificativoStazioneIntermediarioPA | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN11   |
            | password                              | None                                 | CCRTSIN12   |
            | password                              | Empty                                | CCRTSIN13   |
            | password                              | aaaaaaa                              | CCRTSIN14   |
            | password                              | aaaaaaaaaaaaaaaa                     | CCRTSIN15   |
            | identificativoDominio                 | None                                 | CCRTSIN16   |
            | identificativoDominio                 | Empty                                | CCRTSIN17   |
            | identificativoDominio                 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN18   |
            | identificativoUnivocoVersamento       | None                                 | CCRTSIN19   |
            | identificativoUnivocoVersamento       | Empty                                | CCRTSIN20   |
            | identificativoUnivocoVersamento       | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN21   |
            | codiceContestoPagamento               | None                                 | CCRTSIN22   |
            | codiceContestoPagamento               | Empty                                | CCRTSIN23   |
            | codiceContestoPagamento               | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CCRTSIN24   |
