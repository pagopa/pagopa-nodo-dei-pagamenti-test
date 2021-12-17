Feature:  syntax checks for paVerifyPaymentNoticeRes - KO

  Background:
    Given systems up   
    And PA new version
    And valid verifyPaymentNoticeReq soap-request    
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

   # element value check
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given <elem> with <value> in paVerifyPaymentNoticeRes
    And <elem1> with <value1> in paVerifyPaymentNoticeRes
    When pa sends paVerifyPaymentNoticeRes to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE
    Examples:
      | elem                    | value                                | elem1                     |  value1        | soapUI test|
      | body                    | None                                 |                           |                | SIN_PVPNR_02|
      | body                    | Empty                                |                           |                | SIN_PVPNR_03|
      | paverifyPaymentNoticeRes| None                                 |                           |                | SIN_PVPNR_04|
      | paverifyPaymentNoticeRes| Empty                                |                           |                | SIN_PVPNR_06|
      | outcome                 | None                                 |                           |                | SIN_PVPNR_07|
      | outcome                 | Empty                                |                           |                | SIN_PVPNR_08|
      | outcome                 | PP                                   |                           |                | SIN_PVPNR_09|
      | outcome                 | KO                                   | fault                     | None           | SIN_PVPNR_10|
   

  Scenario Outline1: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given <elem> with <value> in paVerifyPaymentNoticeRes
    And outcome OK
    When pa sends paVerifyPaymentNoticeRes to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE  
    Examples:
      | elem                      | value                 | soapUI test |
      | paymentList               | None                  | SIN_PVPNR_11|
      | paymentList               | Empty                 | SIN_PVPNR_13|
      | paymentOptionDescription  | None                  | SIN_PVPNR_14|
      | paymentOptionDescription  | Empty                 | SIN_PVPNR_15|
      | paymentOptionDescription  | two occurrences       | SIN_PVPNR_16|
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

