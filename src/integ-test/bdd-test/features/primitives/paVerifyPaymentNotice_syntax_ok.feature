Feature: syntax checks for paVerifyPaymentNoticeRes - OK

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

  Scenario Outline: Check paVerifyPaymentRes response with missing optional fields
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
    And <elem> with <value> in paVerifyPaymentNoticeRes
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK
    Examples:
      | elem               | value | soapUI test  ||
      | soapenv:Header     | None  | SIN_PVPNR_01 ||
      | dueDate            | None  | SIN_PVPNR_25 ||
      | detailDescription  | None  | SIN_PVPNR_28 ||
      | allCCP             | None  | SIN_PVPNR_31 | # it is not optionally|
      | paymentDescription | None  | SIN_PVPNR_34 | why PPT_STAZIONE_INT_PA_ERRORE_RESPONSE|
      | fiscalCodePA       | None  | SIN_PVPNR_37 | why PPT_STAZIONE_INT_PA_ERRORE_RESPONSE|
      | companyName        | None  | SIN_PVPNR_41 | why PPT_STAZIONE_INT_PA_ERRORE_RESPONSE|
      | officeName         | None  | SIN_PVPNR_44 ||
