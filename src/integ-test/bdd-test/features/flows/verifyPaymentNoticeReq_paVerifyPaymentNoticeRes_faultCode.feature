Feature:  semantic checks for paVerifyPaymentNoticeRes faultCode

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
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
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version
    And idChannel with USE_NEW_FAULT_CODE=Y


  Scenario Outline: Check PPT_ERRORE_EMESSO_DA_PAA error on fault generated by EC
    Given initial XML paVerifyPaymentNotice
    """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <paf:paVerifyPaymentNoticeRes>
               <outcome>KO</outcome>
               <fault>
                  <faultCode>#faultCode#</faultCode>
                  <faultString>#faultString#</faultString>
                  <id>1</id>
               </fault>
            </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And faultCode with <faultCodeValue> in paVerifyPaymentNotice
    And faultString with <faultStringValue> in paVerifyPaymentNotice
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verifyPaymentNotice response
    And check originalFaultCode is <faultCodeValue> of verifyPaymentNotice response
    And check originalFaultString is <faultStringValue> of verifyPaymentNotice response
    Examples:
      | faultCodeValue              | faultStringValue                                            |
      | PAA_SINTASSI_EXTRAXSD       | Errore di sintassi extra XSD.                               |
      | PAA_ID_DOMINIO_ERRATO       | La PAA non corrisponde al Dominio indicato.                 |
      | PAA_ID_INTERMEDIARIO_ERRATO | Identificativo intermediario non corrispondente.            |
      | PAA_STAZIONE_INT_ERRATA     | Stazione intermediario non corrispondente.                  |
      | PAA_PAGAMENTO_SCONOSCIUTO   | Pagamento in_attesa risulta sconosciuto all Ente Creditore. |
      | PAA_PAGAMENTO_DUPLICATO     | Pagamento in_attesa risulta concluso all Ente Creditore.    |
      | PAA_PAGAMENTO_IN_CORSO      | Pagamento in_attesa risulta in_corso all Ente Creditore.    |
      | PAA_PAGAMENTO_SCADUTO       | Pagamento in_attesa risulta scaduto all Ente Creditore.     |
      | PAA_PAGAMENTO_ANNULLATO     | Pagamento in_attesa risulta annullato all Ente Creditore.   |
      | PAA_SYSTEM_ERROR            | Errore generico.                                            |

  # management of KO from PA - PRO_VPNR_06
  Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error when paVerifyPaymentRes contains a KO
    Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <paf:paVerifyPaymentNoticeRes>
                 <outcome>KO</outcome>
                 <fault>
                    <faultCode>PAA_SEMANTICA</faultCode>
                    <faultString>Errore semantico</faultString>
                    <id>1</id>
                 </fault>
              </paf:paVerifyPaymentNoticeRes>
           </soapenv:Body>
        </soapenv:Envelope>
    """
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verifyPaymentNotice response

  # PA in timeout - PRO_VPNR_08
  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paVerifyPaymentRes is in timeout
    Given EC wait for 30 seconds at paVerifyPaymentNoticeRes
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of verifyPaymentNotice response
