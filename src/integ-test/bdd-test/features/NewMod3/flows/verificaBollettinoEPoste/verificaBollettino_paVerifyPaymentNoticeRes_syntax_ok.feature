Feature: syntax checks for paVerifyPaymentNoticeRes - OK 1346

  Background:
    Given systems up
    And initial XML verificaBollettino
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:verificaBollettinoReq>
          <idPSP>#pspPoste#</idPSP>
          <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
          <idChannel>#channelPoste#</idChannel>
          <password>pwdpwdpwd</password>
          <ccPost>#ccPoste#</ccPost>
          <noticeNumber>#notice_number#</noticeNumber>
        </nod:verificaBollettinoReq>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    

  @runnable
  Scenario Outline: Check paVerifyPayment response with missing optional fields
    Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
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
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    Examples:
      | elem              | value | soapUI test |
      | soapenv:Header    | None  | SIN_VBR_01  |
      | dueDate           | None  | SIN_VBR_25  |
      | detailDescription | None  | SIN_VBR_28  |
      | officeName        | None  | SIN_VBR_44  |
