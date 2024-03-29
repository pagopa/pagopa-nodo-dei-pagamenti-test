Feature: Semantic checks for paVerifyPaymentNoticeRes

   Background:
      Given systems up

   Scenario: execute verifyPaymentNotice request
      Given update through the query param_update_in of the table INTERMEDIARI_PSP the parameter FAULT_BEAN_ESTESO with Y, with where condition OBJ_ID and where value ('16646') under macro update_query on db nodo_cfg
      And refresh job ALL triggered after 10 seconds
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
      And idChannel with USE_NEW_FAULT_CODE=Y

   @runnable @dependentwrite @lazy
   Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error on fault generated by EC
      Given the execute verifyPaymentNotice request scenario executed successfully
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
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
      And check originalFaultCode is PAA_SEMANTICA of verifyPaymentNotice response
      And check originalFaultString is Errore semantico of verifyPaymentNotice response
      And update through the query param_update_in of the table INTERMEDIARI_PSP the parameter FAULT_BEAN_ESTESO with N, with where condition OBJ_ID and where value ('16646') under macro update_query on db nodo_cfg
      And refresh job ALL triggered after 10 seconds
