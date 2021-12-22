Feature: syntax checks for paVerifyPaymentNoticeRes - KO

  Background:
    Given systems up   
    And initial verifyPaymentNoticeReq soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>302094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

  # element value check
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given EC replies to nodo-dei-pagamenti with the following paVerifyPaymentNoticeReq
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <paf:paVerifyPaymentNoticeRes>
             <outcome>#outcome#</outcome>
             <fault>
                <faultCode>#faultCode#</faultCode>
                <faultString>#faultString#</faultString>
                <id>#id#</id>
                <description>#description#</description>
             </fault>
          </paf:paVerifyPaymentNoticeRes>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    And <elem> with <value> in paVerifyPaymentNoticeRes
    And if outcome is KO set fault to None in paVerifyPaymentNoticeRes
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE
    Examples:
      | elem                         | value                                | soapUI test  |
      | soapenv:Body                 | None                                 | SIN_PVPNR_02 |
      | soapenv:Body                 | Empty                                | SIN_PVPNR_03 |
      | paf:paVerifyPaymentNoticeRes | None                                 | SIN_PVPNR_04 |
      | paf:paVerifyPaymentNoticeRes | Empty                                | SIN_PVPNR_06 |
      | outcome                      | None                                 | SIN_PVPNR_07 |
      | outcome                      | Empty                                | SIN_PVPNR_08 |
      | outcome                      | PP                                   | SIN_PVPNR_09 |
      | outcome                      | KO                                   | SIN_PVPNR_10 |


  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given EC replies to nodo-dei-pagamenti with the following paVerifyPaymentNoticeReq
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <paf:paVerifyPaymentNoticeRes>
             <outcome>OK</outcome>
             <paymentList>
                <!--1 to 5 repetitions:-->
                <paymentOptionDescription>
                   <amount>10.00</amount>
                   <options>EQ</options>
                   <!--Optional:-->
                   <dueDate>2021-12-31</dueDate>
                   <!--Optional:-->
                   <detailDescription>test</detailDescription>
                   <!--Optional:-->
                   <allCCP>1</allCCP>
                </paymentOptionDescription>
             </paymentList>
             <!--Optional:-->
             <paymentDescription>test</paymentDescription>
             <!--Optional:-->
             <fiscalCodePA>${pa}</fiscalCodePA>
             <!--Optional:-->
             <companyName>company</companyName>
             <!--Optional:-->
             <officeName>office</officeName>
          </paf:paVerifyPaymentNoticeRes>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    And <elem> with <value> in paVerifyPaymentNoticeRes
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE
    Examples:
      | elem                      | value                 | soapUI test |
      | paymentList               | None                  | SIN_PVPNR_11|
      | paymentList               | Empty                 | SIN_PVPNR_13|
      | paymentOptionDescription  | None                  | SIN_PVPNR_14|
      | paymentOptionDescription  | Empty                 | SIN_PVPNR_15|
      | paymentOptionDescription  | Occurrences,2         | SIN_PVPNR_16|
      | amount                    | None                  | SIN_PVPNR_17|
      | amount                    | Empty                 | SIN_PVPNR_18|
      | amount                    | 11,34                 | SIN_PVPNR_19|
      | amount                    | 11.342                | SIN_PVPNR_20|
      | amount                    | 1219087657.34         | SIN_PVPNR_21|
      | options                   | None                  | SIN_PVPNR_22|
      | options                   | Empty                 | SIN_PVPNR_23|
      | options                   | KK                    | SIN_PVPNR_24|
      | dueDate                   | Empty                 | SIN_PVPNR_26|
      | dueDate                   | 12-28-2022            | SIN_PVPNR_27|
      | dueDate                   | 12-09-22              | SIN_PVPNR_27|
      | dueDate                   | 12-08-2022T12:00:678  | SIN_PVPNR_27|
      | detailDescription         | Empty                 | SIN_PVPNR_29|
      | detailDescription         | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE      | SIN_PVPNR_30|
      | allCCP                    | Empty                 | SIN_PVPNR_32|
      | allCCP                    | 3                     | SIN_PVPNR_33|
      | paymentDescription        | Empty                 | SIN_PVPNR_35|
      | paymentDescription        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE      | SIN_PVPNR_36|
      | fiscalCodePA              | Empty                 | SIN_PVPNR_38|
      | fiscalCodePA              | 123456789012          | SIN_PVPNR_39|
      | fiscalCodePA              | 12345jh%lk9           | SIN_PVPNR_40|
      | companyName               | Empty                 | SIN_PVPNR_42|
      | companyName               | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE      | SIN_PVPNR_43|
      | officeName                | Empty                 | SIN_PVPNR_45|
      | officeName                | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE      | SIN_PVPNR_46|

