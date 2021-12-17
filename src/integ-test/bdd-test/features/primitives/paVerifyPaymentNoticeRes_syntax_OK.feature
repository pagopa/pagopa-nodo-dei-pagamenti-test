 Feature: syntax checks for paVerifyPaymentNoticeRes - OK
 
 Background: Given systems up   
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
 
 Scenario Outline2: Check paVerifyPaymentRes response with missing optional fields
    Given <elem> with <value> in paVerifyPaymentNoticeRes
    And outcome OK
    When pa sends paVerifyPaymentNoticeRes to nodo-dei-pagamenti
    Then check no error is raised
    Examples:
      | elem                      | value                 | soapUI test |
      | header                    | None                  | SIN_PVPNR_01|
      | dueDate                   | None                  | SIN_PVPNR_25|
      | detailDescription         | None                  | SIN_PVPNR_28|
      | allCCP                    | None                  | SIN_PVPNR_31|
      | paymentDescription        | None                  | SIN_PVPNR_34|
      | fiscalCodePA              | None                  | SIN_PVPNR_37|
      | companyName               | None                  | SIN_PVPNR_41|
      | officeName                | None                  | SIN_PVPNR_44|