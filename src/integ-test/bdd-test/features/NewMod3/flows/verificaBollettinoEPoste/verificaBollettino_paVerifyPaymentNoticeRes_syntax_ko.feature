Feature: syntax checks for paVerifyPaymentNotice - KO

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
    And EC new version

  # element value check
  @runnable
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given initial XML paVerifyPaymentNotice
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <paf:paVerifyPaymentNoticeRes>
          <outcome>KO</outcome>
          <fault>
            <faultCode>PAA_SEMANTICA</faultCode>
            <faultString>chiamata da rifiutare</faultString>
            <id>#creditor_institution_code#</id>
            <description>haloo</description>
          </fault>
        </paf:paVerifyPaymentNoticeRes>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    And <elem> with <value> in paVerifyPaymentNotice
    And if outcome is KO set fault to None in paVerifyPaymentNotice
    Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verificaBollettino response
    Examples:
      | elem                         | value | soapUI test |
      | soapenv:Body                 | None  | SIN_VBR_02  |
      | soapenv:Body                 | Empty | SIN_VBR_03  |
      | paf:paVerifyPaymentNoticeRes | None  | SIN_VBR_04  |
      | paf:paVerifyPaymentNoticeRes | Empty | SIN_VBR_06  |
      | outcome                      | None  | SIN_VBR_07  |
      | outcome                      | Empty | SIN_VBR_08  |
      | outcome                      | PP    | SIN_VBR_09  |
      | outcome                      | KO    | SIN_VBR_10  |

  @runnable
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
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
                   <!--Optional:-->
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
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of verificaBollettino response
    Examples:
      | elem                     | value                                                                                                                                           | soapUI test |
      | paymentList              | None                                                                                                                                            | SIN_VBR_11  |
      | paymentList              | Empty                                                                                                                                           | SIN_VBR_13  |
      | paymentOptionDescription | None                                                                                                                                            | SIN_VBR_14  |
      | paymentOptionDescription | Empty                                                                                                                                           | SIN_VBR_15  |
      | paymentOptionDescription | Occurrences,2                                                                                                                                   | SIN_VBR_16  |
      | amount                   | None                                                                                                                                            | SIN_VBR_17  |
      | amount                   | Empty                                                                                                                                           | SIN_VBR_18  |
      | amount                   | 11,34                                                                                                                                           | SIN_VBR_19  |
      | amount                   | 11.342                                                                                                                                          | SIN_VBR_20  |
      | amount                   | 11.3                                                                                                                                            | SIN_VBR_20  |
      | amount                   | 1219087657.34                                                                                                                                   | SIN_VBR_21  |
      | options                  | None                                                                                                                                            | SIN_VBR_22  |
      | options                  | Empty                                                                                                                                           | SIN_VBR_23  |
      | options                  | KK                                                                                                                                              | SIN_VBR_24  |
      | dueDate                  | Empty                                                                                                                                           | SIN_VBR_26  |
      | dueDate                  | 12-28-2022                                                                                                                                      | SIN_VBR_27  |
      | dueDate                  | 12-09-22                                                                                                                                        | SIN_VBR_27  |
      | dueDate                  | 12-08-2022T12:00:678                                                                                                                            | SIN_VBR_27  |
      | detailDescription        | Empty                                                                                                                                           | SIN_VBR_29  |
      | detailDescription        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_30  |
      | allCCP                   | None                                                                                                                                            | SIN_VBR_31  |
      | allCCP                   | Empty                                                                                                                                           | SIN_VBR_32  |
      | allCCP                   | 3                                                                                                                                               | SIN_VBR_33  |
      | paymentDescription       | None                                                                                                                                            | SIN_VBR_34  |
      | paymentDescription       | Empty                                                                                                                                           | SIN_VBR_35  |
      | paymentDescription       | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_36  |
      | fiscalCodePA             | None                                                                                                                                            | SIN_VBR_37  |
      | fiscalCodePA             | Empty                                                                                                                                           | SIN_VBR_38  |
      | fiscalCodePA             | 123456789012                                                                                                                                    | SIN_VBR_39  |
      | fiscalCodePA             | 12345jh%lk9                                                                                                                                     | SIN_VBR_40  |
      | companyName              | None                                                                                                                                            | SIN_VBR_41  |
      | companyName              | Empty                                                                                                                                           | SIN_VBR_42  |
      | companyName              | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_43  |
      | officeName               | Empty                                                                                                                                           | SIN_VBR_45  |
      | officeName               | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | SIN_VBR_46  |
