Feature: syntax checks for nodoChiediNumeroAvviso - KO 928

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM4 @NM4SINODCAKO @NM4SINODCAKO_1
    # attribute value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code# |
        And <attribute> set <value> for <elem> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediNumeroAvviso response
        Examples:
            | elem             | attribute     | value                                     |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ |


    @ALL @PRIMITIVE @NM4 @NM4SINODCAKO @NM4SINODCAKO_2
    # element value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code# |
        And <elem> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediNumeroAvviso response
        Examples:
            | elem                           | value                                |
            | soapenv:Body                   | None                                 |
            | soapenv:Body                   | Empty                                |
            | ws:nodoChiediNumeroAvviso      | Empty                                |
            | identificativoPSP              | None                                 |
            | identificativoPSP              | Empty                                |
            | identificativoPSP              | 123456789012345678901234567890123456 |
            | identificativoIntermediarioPSP | None                                 |
            | identificativoIntermediarioPSP | Empty                                |
            | identificativoIntermediarioPSP | 123456789012345678901234567890123456 |
            | identificativoCanale           | None                                 |
            | identificativoCanale           | Empty                                |
            | identificativoCanale           | 123456789012345678901234567890123456 |
            | password                       | None                                 |
            | password                       | Empty                                |
            | password                       | 1234567                              |
            | password                       | 123456789012345678901234567890123456 |
            | idDominioErogatoreServizio     | None                                 |
            | idDominioErogatoreServizio     | Empty                                |
            | idDominioErogatoreServizio     | 123456789012345678901234567890123456 |
            | idServizio                     | None                                 |
            | idServizio                     | Empty                                |
            | idServizio                     | 123456                               |
            | idServizio                     | 1234                                 |
            | datiSpecificiServizio          | None                                 |
            | datiSpecificiServizio          | Empty                                |
            | datiSpecificiServizio          | cia                                  |
            | datiSpecificiServizio          | cia$                                 |


    @ALL @PRIMITIVE @NM4 @NM4SINODCAKO @NM4SINODCAKO_3
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid nodoChiediNumeroAvviso
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code# |
        And <elem> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediNumeroAvviso response
        Examples:
            | elem                  | value         |
            | idServizio            | Occurrences,2 |
            | datiSpecificiServizio | Occurrences,2 |


    @ALL @PRIMITIVE @NM4 @NM4SINODCAKO @NM4SINODCAKO_4
    Scenario Outline: nodoChiediNumeroAvviso wrong XSD in base64
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio      |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code_old# |
        And <elem> with <value> in nodoChiediNumeroAvviso
        When PSP sends soap nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_XSD of nodoChiediNumeroAvviso response
        Examples:
            | elem                  | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
            | datiSpecificiServizio | PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgogIDx0YTp2ZWljb2xvQ29uVGFyZ2E+CiAgICA8dGE6Y2lhbz4xPC90YTpjaWFvPgogICAgPHRhOnZlaWNvbG9UYXJnYT5LTzEyM1BBPC90YTp2ZWljb2xvVGFyZ2E+CiAgPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg== |


    @ALL @PRIMITIVE @NM4 @NM4SINODCAKO @NM4SINODCAKO_5
    Scenario Outline: nodoChiediNumeroAvviso wrong XSD in base64
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio      |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00001      | #creditor_institution_code_old# |
        And <elem> with <value> in nodoChiediNumeroAvviso
        When PSP sends soap nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_XSD of nodoChiediNumeroAvviso response
        Examples:
            | elem                  | value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
            | datiSpecificiServizio | PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgogIDx0YTp2ZWljb2xvQ29uVGFyZ2E+CiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnbz4xPC90YTp0aXBvVmVpY29sb1RhcmdvPgogIDwvdGE6dmVpY29sb0NvblRhcmdhPgo8L3RhOnRhc3NhQXV0bz4= |
