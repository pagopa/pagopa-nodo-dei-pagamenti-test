Feature: response tests for paDemandPaymentNotice

    Background:
        Given systems up

    @skip
    Scenario: demandPaymentNotice
        Given initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00041</idSoggettoServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    @skip
    Scenario: paDemandPaymentNotice
        Given initial XML paDemandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <paymentList>
            <paymentOptionDescription>
            <amount>10.00</amount>
            <options>EQ</options>
            <!--Optional:-->
            <dueDate>2022-06-25</dueDate>
            <!--Optional:-->
            <detailDescription>descrizione dettagliata lato PA</detailDescription>
            <!--Optional:-->
            <allCCP>false</allCCP>
            </paymentOptionDescription>
            </paymentList>
            <officeName>officeName</officeName>
            </paf:paDemandPaymentNoticeResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario Outline: Check paDemandPaymentNotice response with missing optional fields
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And <elem> with <value> in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
        Examples:
            | elem              | value | soapUI test  |
            | soapenv:Header    | None  | TRES_PDPN_01 |
            | dueDate           | None  | TRES_PDPN_39 |
            | detailDescription | None  | TRES_PDPN_42 |
            | officeName        | None  | TRES_PDPN_58 |

    # TRES_PDPN_02

    Scenario: TRES_PDPN_02
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
    @wip
    Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And idSoggettoServizio with 00103 in demandPaymentNotice
        And <elem> with <value> in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response
        Examples:
            | elem                              | value        | soapUI test  |
            | soapenv:Body                      | None         | TRES_PDPN_03 |
            | soapenv:Body                      | Empty        | TRES_PDPN_04 |
            | paf:paDemandPaymentNoticeResponse | None         | TRES_PDPN_05 |
            | paf:paDemandPaymentNoticeResponse | RemoveParent | TRES_PDPN_06 |
            | paf:paDemandPaymentNoticeResponse | Empty        | TRES_PDPN_07 |
            | outcome                           | None         | TRES_PDPN_08 |
            | outcome                           | Empty        | TRES_PDPN_09 |
            | outcome                           | PP           | TRES_PDPN_10 |

    # TRES_PDPN_11
    @wip
    Scenario: TRES_PDPN_11
        Given the demandPaymentNotice scenario executed successfully
        And the paDemandPaymentNotice scenario executed successfully
        And idSoggettoServizio with 00103 in demandPaymentNotice
        And outcome with KO in paDemandPaymentNotice
        And qrCode with None in paDemandPaymentNotice
        And paymentList with None in paDemandPaymentNotice
        And officeName with None in paDemandPaymentNotice
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response