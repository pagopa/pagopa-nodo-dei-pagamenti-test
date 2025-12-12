Feature: Syntax checks KO for nodoPAChiediInformativaPA 273
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SINPACIPAKO @MOD1SINPACIPAKO_1
    Scenario Outline:Check KO for nodoPAChiediInformativaPA

        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
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


    @ALL @PRIMITIVE @MD1 @MD1SINPACIPAKO @MD1SINPACIPAKO_2
    Scenario Outline: Check OK for nodoPAChiediInformativaPA-[PACIPA3]
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response
        Examples:
            | tag          | tag_value | SoapUI  |
            | soapenv:Body | None      | PACIPA3 |


    @ALL @PRIMITIVE @MOD1 @MOD1SINPACIPAKO @MD1SINPACIPAKO_3
    Scenario Outline: Check OK for nodoPAChiediInformativaPA-[PACIPA5]
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response
        Examples:
            | tag                           | tag_value | SoapUI  |
            | identificativoIntermediarioPA | Empty     | PACIPA5 |


    # @runnable
    # Scenario:Check OK for nodoPAChiediInformativaPA-[PACIPA1]
    #     Given initial XML nodoPAChiediInformativaPA
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <password>pwdpwdpwd</password>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
    #     Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response


    @ALL @PRIMITIVE @MOD1 @MOD1SINPACIPAKO @MOD1SINPACIPAKO_4
    Scenario Outline: Check OK for nodoPAChiediInformativaPA-[PACIPA1]
        Given from body with datatable horizontal nodoPAChiediInformativaPA_malformed initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        And <tag1> with <tag_value1> in nodoPAChiediInformativaPA
        And <tag2> with <tag_value2> in nodoPAChiediInformativaPA
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoPAChiediInformativaPA response
        Examples:
            | tag1                  | tag_value1 | tag2                         | tag_value2   | SoapUI  |
            | identificativoDominio | None       | ws:nodoPAChiediInformativaPA | RemoveParent | PACIPA1 |


