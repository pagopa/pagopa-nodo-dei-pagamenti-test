Feature: response tests for paDemandPaymentNotice

    Background:
        Given systems up
        And initial XML demandPaymentNotice
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

    Scenario Outline: Check paDemandPaymentNotice response with missing optional fields
        Given idSoggettoServizio with <value> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
        Examples:
            | value | soapUI test  |
            | 00101 | TRES_PDPN_01 |
            | 00102 | TRES_PDPN_02 |
            | 00139 | TRES_PDPN_39 |
            | 00142 | TRES_PDPN_42 |
            | 00158 | TRES_PDPN_58 |

    Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
        Given idSoggettoServizio with <value> in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response
        Examples:
            | value | soapUI test  |
            | 00103 | TRES_PDPN_03 |
            | 00104 | TRES_PDPN_04 |
            | 00105 | TRES_PDPN_05 |
            | 00106 | TRES_PDPN_06 |
            | 00107 | TRES_PDPN_07 |
            | 00108 | TRES_PDPN_08 |
            | 00109 | TRES_PDPN_09 |
            | 00110 | TRES_PDPN_10 |
            | 00111 | TRES_PDPN_11 |
            | 00112 | TRES_PDPN_12 |
            | 00113 | TRES_PDPN_13 |
            | 00114 | TRES_PDPN_14 |
            | 00115 | TRES_PDPN_15 |
            | 00116 | TRES_PDPN_16 |
            | 00117 | TRES_PDPN_17 |
            | 00118 | TRES_PDPN_18 |
            | 00119 | TRES_PDPN_19 |
            | 00120 | TRES_PDPN_20 |
            | 00121 | TRES_PDPN_21 |
            | 00122 | TRES_PDPN_22 |
            | 00123 | TRES_PDPN_23 |
            | 00124 | TRES_PDPN_24 |
            | 00125 | TRES_PDPN_25 |
            | 00126 | TRES_PDPN_26 |
            | 00127 | TRES_PDPN_27 |
            | 00128 | TRES_PDPN_28 |
            | 00129 | TRES_PDPN_29 |
            | 00130 | TRES_PDPN_30 |
            | 00131 | TRES_PDPN_31 |
            | 00132 | TRES_PDPN_32 |
            | 00133 | TRES_PDPN_33 |
            | 00134 | TRES_PDPN_34 |
            | 00135 | TRES_PDPN_35 |
            | 00136 | TRES_PDPN_36 |
            | 00137 | TRES_PDPN_37 |
            | 00138 | TRES_PDPN_38 |
            | 00140 | TRES_PDPN_40 |
            | 00141 | TRES_PDPN_41 |
            | 00143 | TRES_PDPN_43 |
            | 00144 | TRES_PDPN_44 |
            | 00145 | TRES_PDPN_45 |
            | 00146 | TRES_PDPN_46 |
            | 00147 | TRES_PDPN_47 |
            | 00148 | TRES_PDPN_48 |
            | 00149 | TRES_PDPN_49 |
            | 00150 | TRES_PDPN_50 |
            | 00151 | TRES_PDPN_51 |
            | 00152 | TRES_PDPN_52 |
            | 00153 | TRES_PDPN_53 |
            | 00154 | TRES_PDPN_54 |
            | 00155 | TRES_PDPN_55 |
            | 00156 | TRES_PDPN_56 |
            | 00157 | TRES_PDPN_57 |
            | 00159 | TRES_PDPN_59 |
            | 00160 | TRES_PDPN_60 |