Feature:  flow check for sendPaymentResult-v2 request - pagamento con appIO diverso da BPAY e PPAL, spr-v2 non inviata [T_SPR_V2_01]

   Background:
      Given systems up
      And EC new version

   # verifyPaymentNotice phase
   Scenario: Execute verifyPaymentNotice request
      Given initial xml verifyPaymentNotice

         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>AGID_01</idPSP>
         <idBrokerPSP>97735020584</idBrokerPSP>
         <idChannel>97735020584_03</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>311#iuv#</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial xml paVerifyPaymentNotice
         """"
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paVerifyPaymentNoticeRes>
         <outcome>OK</outcome>
         <paymentList>
         <paymentOptionDescription>
         <amount>1.00</amount>
         <options>EQ</options>
         <!--Optional:-->
         <dueDate>2022-09-13</dueDate>
         <!--Optional:-->
         <detailDescription>descrizione dettagliata lato PA</detailDescription>
         <!--Optional:-->
         <allCCP>false</allCCP>
         </paymentOptionDescription>
         </paymentList>
         <!--Optional:-->
         <paymentDescription>/RFB/00202200000217527/5.00/TXT/</paymentDescription>
         <!--Optional:-->
         <fiscalCodePA>$verifyPaymentNotice.fiscalCode</fiscalCodePA>
         <!--Optional:-->
         <companyName>company PA</companyName>
         <!--Optional:-->
         <officeName>office PA</officeName>
         </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   # activateIOPaymentReq phase
   Scenario: Execute activateIOPayment request
      Given the Execute verifyPaymentNotice request scenario executed successfully
      And initial xml activateIOPayment

         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activateIOPaymentReq>
         <idPSP>AGID_01</idPSP>
         <idBrokerPSP>97735020584</idBrokerPSP>
         <idChannel>97735020584_03</idChannel>
         <password>pwdpwdpwd</password>
         <!--Optional:-->
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
         </qrCode>
         <!--Optional:-->
         <expirationTime>60000</expirationTime>
         <amount>10.00</amount>
         <!--Optional:-->
         <dueDate>2021-12-12</dueDate>
         <!--Optional:-->
         <paymentNote>responseFull</paymentNote>
         <!--Optional:-->
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>IOname_#idempotency_key#</fullName>
         <!--Optional:-->
         <streetName>IOstreet</streetName>
         <!--Optional:-->
         <civicNumber>IOcivic</civicNumber>
         <!--Optional:-->
         <postalCode>IOcode</postalCode>
         <!--Optional:-->
         <city>IOcity</city>
         <!--Optional:-->
         <stateProvinceRegion>IOstate</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>IO.test.prova@gmail.com</e-mail>
         </payer>
         </nod:activateIOPaymentReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      
      And initial xml paGetPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paGetPaymentRes>
         <outcome>OK</outcome>
         <data>
         <creditorReferenceId>11$iuv</creditorReferenceId>
         <paymentAmount>10.00</paymentAmount>
         <dueDate>2021-12-30</dueDate>
         <!--Optional:-->
         <retentionDate>2021-12-30T12:12:12</retentionDate>
         <!--Optional:-->
         <lastPayment>1</lastPayment>
         <description>test</description>
         <!--Optional:-->
         <companyName>company</companyName>
         <!--Optional:-->
         <officeName>office</officeName>
         <debtor>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>paGetPaymentName</fullName>
         <!--Optional:-->
         <streetName>paGetPaymentStreet</streetName>
         <!--Optional:-->
         <civicNumber>paGetPayment99</civicNumber>
         <!--Optional:-->
         <postalCode>20155</postalCode>
         <!--Optional:-->
         <city>paGetPaymentCity</city>
         <!--Optional:-->
         <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
         <!--Optional:-->
         <country>DE</country>
         <!--Optional:-->
         <e-mail>paGetPayment@test.it</e-mail>
         </debtor>
         <!--Optional:-->
         <transferList>
         <!--1 to 5 repetitions:-->
         <transfer>
         <idTransfer>1</idTransfer>
         <transferAmount>10.00</transferAmount>
         <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
         <IBAN>IT45R0760103200000000001016</IBAN>
         <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
         <transferCategory>paGetPaymentTest</transferCategory>
         </transfer>
         </transferList>
         <!--Optional:-->
         <metadata>
         <!--1 to 10 repetitions:-->
         <mapEntry>
         <key>1</key>
         <value>22</value>
         </mapEntry>
         </metadata>
         </data>
         </paf:paGetPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """

      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When psp sends SOAP activateIOPayment to nodo-dei-pagamenti          
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse
      And checking the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query generic_select with where condition NOTICE_ID = '311$iuv' and PA_FISCAL_CODE= '#creditor_institution_code#' on db nodo_online under macro generic_queries
     
   # DB check_00
   # SELECT * FROM NODO_ONLINE.POSITION_ACTIVATE s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
   # check POSITION_ACTIVATE.PAYMENT_TOKEN == $activateIOPaymentResponse.paymentToken and
   #       POSITION_ACTIVATE.PSP_ID == $activateIOPaymentRequest.idPSP

   # nodoChiediInformazioniPagamento phase
   Scenario: Execute a nodoChiediInformazioniPagamento request
      Given the Execute activateIOPayment request scenario executed successfully
      When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200


   # closePayment-v2 phase
   Scenario: Execute a closePayment-v2 request
      Given the Execute a nodoChiediInformazioniPagamento request scenario executed successfully
      And idChannel with CANALI_NODO.VERSIONE_PRIMITIVE = 1
      And initial json closePayment-v2
         """
         {
            "paymentTokens": [
               "$activateIOPaymentNoticeResponse.paymentToken"
            ],
            "outcome": "OK",
            "idPSP": "#psp#",
            "idBrokerPSP": "60000000001",
            "idChannel": "60000000001_03",
            "paymentMethod": "TPAY",
            "transactionId": "19392562",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2033-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "key": "10793459"
            }
         }
         """

      When PM sends closePayment-v2 to nodo-dei-pagamenti
      Then check outcome is OK of closePayment-v2
      And verify the HTTP status code of closePayment-v2 response is 200
      And check no sendPaymentResult-v2 is sent

# SELECT ID FROM RE WHERE NOTICE_ID = '#notice_number#' AND TIPO_EVENTO = 'sendPaymentResult-v2';
# assert RE.ID = None;


# SELECT s.* FROM NODO_ONLINE.POSITION_PAYMENT_STATUS s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#' order by s.ID asc;
# SELECT s.* FROM NODO_ONLINE.POSITION_PAYMENT_STATUS_SNAPSHOT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
# SELECT s.* FROM NODO_ONLINE.POSITION_STATUS s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
# SELECT s.* FROM NODO_ONLINE.POSITION_STATUS_SNAPSHOT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';

#POSITION_PAYMENT_STATUS
# ID != null
# PA_FISCAL_CODE == '#creditor_institution_code#'
# NOTICE_ID == '#notice_number#'
# STATUS == 'PAYING'
# INSERTED_TIMESTAMP != null
# CREDITOR_REFERENCE_ID == #iuv#
# PAYMENT_TOKEN == #ccp#

# STATUS1 == 'PAYMENT_RESERVED'
# STATUS2 == 'PAYMENT_SENT'
# STATUS3 == 'PAYMENT_ACCEPTED'

#POSITION_PAYMENT_STATUS_SNAPSHOT
# ID != null
# PA_FISCAL_CODE == '#creditor_institution_code#'
# NOTICE_ID == '#notice_number#'
# CREDITOR_REFERENCE_ID == #iuv#
# PAYMENT_TOKEN == #ccp#
# STATUS == 'PAYMENT_ACCEPTED'
# INSERTED_TIMESTAMP != null
# UPDATED_TIMESTAMP != null
# FK_POSITION_PAYMENT == POSITION_PAYMENT.id

# ID1 == null

#POSITION_STATUS
# ID != null
# PA_FISCAL_CODE == '#creditor_institution_code#'
# NOTICE_ID == '#notice_number#'
# STATUS2 == 'PAYING'
# INSERTED_TIMESTAMP != null

# ID1 == null

#POSITION_STATUS_SNAPSHOT
# ID != null
# PA_FISCAL_CODE == '#creditor_institution_code#'
# NOTICE_ID == '#notice_number#'
# STATUS == 'PAYING'
# INSERTED_TIMESTAMP != null
# UPDATED_TIMESTAPM != null
# FK_POSITION_SERVICE == POSITION_SERVICE.id

# id1 == null
