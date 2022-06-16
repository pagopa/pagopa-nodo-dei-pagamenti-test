Feature:  flow checks for demandPaymentNoticeRequest - paGetPaymentRes 3Transfers - broadcast = false - TF_DPNR_10

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
    # UPDATE PA_STAZIONE_PA s SET s.BROADCAST = 'N' WHERE s.FK_PA IN ('','')" - broadcast false for pa secondary
    
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
                 <expirationTime>60000</expirationTime>
                 <amount>10.00</amount>
              </nod:activatePaymentNoticeReq>
           </soapenv:Body>
        </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And check transferList tag contains 3 transfers of activatePaymentNotice response


    # sendPaymentOutcome Phase outcome OK
    Scenario: Execute sendPaymentOutcome request
    Given the activatePaymentNotice scenario successfully executed 
    Given initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:sendPaymentOutcomeReq>
             <idPSP>70000000001</idPSP>
             <idBrokerPSP>70000000001</idBrokerPSP>
             <idChannel>70000000001_01</idChannel>
             <password>pwdpwdpwd</password>
             <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
             <outcome>OK</outcome>
             <!--Optional:-->
             <details>
                <paymentMethod>creditCard</paymentMethod>
                <fee>2.00</fee>
                <!--Optional:-->
                <payer>
                   <uniqueIdentifier>
                      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                      <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
                   </uniqueIdentifier>
                   <fullName>name</fullName>
                   <!--Optional:-->
                   <streetName>street</streetName>
                   <!--Optional:-->
                   <civicNumber>civic</civicNumber>
                   <!--Optional:-->
                   <postalCode>postal</postalCode>
                   <!--Optional:-->
                   <city>city</city>
                   <!--Optional:-->
                   <stateProvinceRegion>state</stateProvinceRegion>
                   <!--Optional:-->
                   <country>IT</country>
                   <!--Optional:-->
                   <e-mail>prova@test.it</e-mail>
                </payer>
                <applicationDate>2021-12-12</applicationDate>
                <transferDate>2021-12-11</transferDate>
             </details>
          </nod:sendPaymentOutcomeReq>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    # And check POSITION_RECEIPT_RECIPIENT table of NODO_ONLINE contains a row for noticeId = $demandPaymentNoticeResponse.notice_number
    # And check POSITION_RECEIPT_RECIPIENT_STATUS of NODO_ONLINE contains a record in status NOTICE_GENERATED for noticeId = $demandPaymentNoticeResponse.notice_number
    # And check POSITION_RECEIPT_XML of NODO_ONLINE contains a record for noticeId = $demandPaymentNoticeResponse.notice_number having pa_fiscal_code = paIntestataria
    # And check XML_CONTENT in POSITION_RECEIPT_XML of NODO_ONLINE is properly filled