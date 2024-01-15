Feature: Syntax checks KO for nodoPAChiediInformativaPA
    Background:
        Given systems up

    @runnable @independent
    Scenario Outline:Check KO for nodoPAChiediInformativaPA
        Given initial XML nodoPAChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
            <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response
        Examples:
            | tag                                   | tag_value                            | SoapUI   |
            | soapenv:Body                          | Empty                                | PACIPA2  |
            | ws:nodoPAChiediInformativaPA          | Empty                                | PACIPA4  |
            | identificativoIntermediarioPA         | None                                 | PACIPA6  |
            | identificativoIntermediarioPA         | Empty                                | PACIPA7  |
            | identificativoIntermediarioPA         | qertyuop234dcvgtresd567yhbvfrteesd56 | PACIPA8  |
            | identificativoStazioneIntermediarioPA | None                                 | PACIPA9  |
            | identificativoStazioneIntermediarioPA | Empty                                | PACIPA10 |
            | identificativoStazioneIntermediarioPA | qertyuop234dcvgtresd567yhbvfrteesd56 | PACIPA11 |
            | password                              | None                                 | PACIPA12 |
            | password                              | Empty                                | PACIPA13 |
            | password                              | g6f5d4s                              | PACIPA14 |
            | password                              | g6f5d4s6nd34tjs5                     | PACIPA15 |
            | identificativoDominio                 | None                                 | PACIPA16 |
            | identificativoDominio                 | Empty                                | PACIPA17 |
            | identificativoDominio                 | qertyuop234dcvgtresd567yhbvfrteesd56 | PACIPA18 |

    @runnable @independent
    Scenario: Check OK for nodoPAChiediInformativaPA-[PACIPA3]
        Given initial XML nodoPAChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"> <!-- xmlns:ws="http://ws.pagamenti.telematici.gov/"-->
            <soapenv:Header/>
            <!--soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
            <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
            </soapenv:Body-->
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response

    @runnable @independent
    Scenario: Check OK for nodoPAChiediInformativaPA-[PACIPA5]
        Given initial XML nodoPAChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
            <identificativoIntermediarioPA></identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response

    @runnable @independent
    Scenario:Check OK for nodoPAChiediInformativaPA-[PACIPA1]
        Given initial XML nodoPAChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response
