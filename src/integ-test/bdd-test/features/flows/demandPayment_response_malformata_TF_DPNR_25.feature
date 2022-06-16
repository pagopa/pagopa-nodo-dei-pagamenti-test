Feature: process checks for demandPaymentNotice - response malformata - TF_DPNR_25

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
                <idServizio>00002</idServizio>
                <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
        </soapenv:Body>
    </soapenv:Envelope>
    """
   
    # demandPaymentNoticeRequest phase
    Scenario: Execute demandPaymentNoticeRequest
    Given initial XML demandPaymentNoticeRequest        
    When PA sends a wrong paDemandPaymentNoticeResponse to nodo-dei-pagamenti 
    """
    <soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
    <soapenv:Header/>
    <soapenv:Body>
        <paf:paDemandPaymentNoticeResponse>
            <outcome>OK</outcome>
            <qrCode>
                <fiscalCode>44444444444</fiscalCode>
                <noticeNumber>311015351897120500</noticeNumber>
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
                <!--Optional:-->
                <paymentDescription>/RFB/00202200000217527/5.00/TXT/</paymentDescription>
                <!--Optional:-->
                <fiscalCodePA>44444444444</fiscalCodePA>
                <!--Optional:-->
                <companyName>company PA</companyName>
                <!--Optional:-->
                <officeName>office PA</officeName>
            </paf:paDemandPaymentNoticeResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    Then check demandPaymentNoticeRes outcome is KO in demandPaymentNoticeRes
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE in demandPaymentNoticeRes