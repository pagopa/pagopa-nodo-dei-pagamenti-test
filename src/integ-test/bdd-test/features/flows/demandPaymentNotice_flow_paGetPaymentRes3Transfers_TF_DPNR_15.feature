Feature:  flow checks for demandPaymentNoticeRequest - paGetPaymentRes 3Transfers - broadcast = true - TF_DPNR_15

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
    
    #DB update step
    # UPDATE PA_STAZIONE_PA s SET s.BROADCAST = 'Y' WHERE s.FK_PA IN ('','')" - broadcast false for pa secondary
    
    # demandPaymentNoticeRequest phase
    Scenario: Execute demandPaymentNoticeRequest
    Given initial XML demandPaymentNoticeRequest        
    When PSP sends demandPaymentNoticeRequest to nodo-dei-pagamenti
    Then check demandPaymentNoticeRes outcome is OK
    And check qrCode field is present
    
    # paGetPaymentRes setup
    Scenario: define a paGetPaymentRes on mock having 3 transfers in TransferList
    
    # activatePaymentNoticeReq phase
    Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice
      """      
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:activatePaymentNoticeReq>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_01</idChannel>
                 <password>pwdpwdpwd</password>
                 <idempotencyKey>#idempotency_key#</idempotencyKey>
                 <qrCode>
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
                    <noticeNumber>$demandPaymentNoticeResponse.notice_number</noticeNumber>
                 </qrCode>
                 <expirationTime>2000</expirationTime>
                 <amount>10.00</amount>
              </nod:activatePaymentNoticeReq>
           </soapenv:Body>
        </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And check transferList tag contains 3 transfers of activatePaymentNotice response


    # Mod3Cancel Phase
    Scenario: Execute mod3Cancel poller
    Given the Execute activatePaymentNotice request scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    # And check POSITION_RECEIPT_RECIPIENT table of NODO_ONLINE doesn't contain a record for this execution
    # And check POSITION_RECEIPT_RECIPIENT_STATUS of NODO_ONLINE doesn't contain a record for this execution
    # And check POSITION_RECEIPT_XML of NODO_ONLINE doesn't contain a record for this execution