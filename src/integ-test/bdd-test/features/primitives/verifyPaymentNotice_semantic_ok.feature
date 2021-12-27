Feature: semantic checks for verifyPaymentReq

  Background:
    Given systems up
    And initial XML for verifyPaymentNotice
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

  Scenario: Check valid URL in WSDL namespace
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  # denylist value check: combination fiscalCode-idChannel-idPSP identifies a record in NODO4_CFG.DENYLIST table of nodo-dei-pagamenti database [SEM_VPNR_16]
  Scenario: Check outcome OK if combination psp-channel-pa in denylist
    Given fiscalCode with 77777777777 in verifyPaymentNotice
    And idBrokerPSP with 70000000002 in verifyPaymentNotice
    And idChannel with 70000000002_01 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
