Feature: process checks for demandPaymentNotice - outcome KO - TF_DPNR_23

  Background:
    Given systems up
    And initial XML demandPaymentNotice soap-request 
    """    
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
                <idPSP>70000000001</idPSP>
                <idBrokerPSP>70000000001</idBrokerPSP>
                <idChannel>70000000001_01</idChannel>
                <password>pwdpwdpwd</password>
                <idSoggettoServizio>00041</idSoggettoServizio>
                <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
        </soapenv:Body>
    </soapenv:Envelope>
    """
   
    # demandPaymentNoticeRequest phase
    Scenario: Execute demandPaymentNoticeRequest
    Given initial XML demandPaymentNoticeRequest        
    When PA sends paDemandPaymentNoticeResponse with outcome KO to nodo-dei-pagamenti 
    """
    <soapenv:Envelope
        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <paf:paDemandPaymentNoticeResponse>
                <outcome>KO</outcome>
                <fault>
                    <faultCode>PAA_SEMANTICA</faultCode>
                    <faultString>chiamata da rifiutare</faultString>
                    <id>44444444444</id>
                    <description>chiamata da rifiutare</description>
                </fault>
            </paf:paDemandPaymentNoticeResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    Then check demandPaymentNoticeRes outcome is KO in demandPaymentNoticeRes
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA in demandPaymentNoticeRes