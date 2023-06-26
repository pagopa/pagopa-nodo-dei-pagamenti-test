Feature: syntax checks for paVerifyPaymentNoticeRes - OK

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>#psp#</idPSP>
               <idBrokerPSP>#psp#</idBrokerPSP>
               <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

  @runnable @independent
  Scenario Outline: Check paVerifyPaymentRes response with missing optional fields
    Given initial XML paVerifyPaymentNotice
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
                     <allCCP>1</allCCP>
                  </paymentOptionDescription>
               </paymentList>
               <!--Optional:-->
               <paymentDescription>test</paymentDescription>
               <!--Optional:-->
               <fiscalCodePA>#fiscalCodePA#</fiscalCodePA>
               <!--Optional:-->
               <companyName>company</companyName>
               <!--Optional:-->
               <officeName>office</officeName>
            </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
      </soapenv:Envelope>
    """
    And <elem> with <value> in paVerifyPaymentNotice
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
    Examples:
      | elem               | value | soapUI test  |
      | soapenv:Header     | None  | SIN_PVPNR_01 |
      | dueDate            | None  | SIN_PVPNR_25 |
      | detailDescription  | None  | SIN_PVPNR_28 |
      | officeName         | None  | SIN_PVPNR_44 |
