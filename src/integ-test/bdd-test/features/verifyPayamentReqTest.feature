Feature:  Controlli sintattici per la primitiva verifyPaymentReq


   Background:

      Given systems up 
         | name                    | url                                                    | healtcheck                          | service |
         | nodo-dei-pagamenti      | http://localhost:8081                                  | /monitor/health                     | /webservices/input |
         | mock-ec                 | http://localhost:8080/servizi/PagamentiTelematiciRPT   | /api/v1/info | |
         
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
                  <fiscalCode>77777777777</fiscalCode>
                  <noticeNumber>121094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """

   Scenario: Check valid URL in WSDL namespace

      # Given a valid WSDL

      When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti

      Then nodo-dei-pagamenti sends verifyPaymentNoticeRes with outcome OK

      # Examples:

      # | url |

      # | http://schemas.xmlsoap.org/soap/envelope/ |


   # Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace 

   #    Given a invalid <url> in wsdl 

   #    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti

   #    Then nodo-dei-pagamenti sends verifyPaymentNoticeRes with outcome KO 

   #    And faultCode PPT_SINTASSI_EXTRAXSD

   #    Examples:

   #    | url |

   #    | http://schemas.xmlsoap.org/ciao/envelope/ |
