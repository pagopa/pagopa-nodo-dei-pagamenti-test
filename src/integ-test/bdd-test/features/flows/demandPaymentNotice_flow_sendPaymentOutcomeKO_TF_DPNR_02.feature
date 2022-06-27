Feature:  flow checks for demandPaymentNoticeRequest - SPO KO - TF_DPNR_02

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
    When PSP sends demandPaymentNoticeRequest to nodo-dei-pagamenti
    Then check demandPaymentNoticeRes outcome is OK
    And check qrCode field is present
    
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


    # sendPaymentOutcome Phase outcome KO
    Scenario: Execute sendPaymentOutcome request
    Given the activatePaymentNotice scenario executed successfully
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
             <outcome>KO</outcome>
             <!--Optional:-->
             <details>
                <paymentMethod>creditCard</paymentMethod>
                <!--Optional:-->
                <paymentChannel>app</paymentChannel>
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
    And check POSITION_RECEIPT table of NODO_ONLINE doesn't contain a row for noticeId = $demandPaymentNoticeResponse.notice_number