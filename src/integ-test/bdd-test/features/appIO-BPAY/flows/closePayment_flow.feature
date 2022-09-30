Feature: flux / semantic checks for sendPaymentOutcomeV2

   Background:
      Given systems up

    Scenario: verifyPaymentNotice
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paVerifyPaymentNotice
            """
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
            <dueDate>2021-12-31</dueDate>
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
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

   @skip
   Scenario: activateIOPayment
      Given initial XML activateIOPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activateIOPaymentReq>
         <idPSP>#psp_AGID#</idPSP>
         <idBrokerPSP>#broker_AGID#</idBrokerPSP>
         <idChannel>#canale_AGID#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>311$iuv</noticeNumber>
         </qrCode>
         <expirationTime>60000</expirationTime>
         <amount>10.00</amount>
         <paymentNote>responseFull</paymentNote>
         </nod:activateIOPaymentReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paGetPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header />
         <soapenv:Body>
         <paf:paGetPaymentRes>
         <outcome>OK</outcome>
         <data>
         <creditorReferenceId>11$iuv</creditorReferenceId>
         <paymentAmount>10.00</paymentAmount>
         <dueDate>2021-12-31</dueDate>
         <!--Optional:-->
         <retentionDate>2021-12-31T12:12:12</retentionDate>
         <!--Optional:-->
         <lastPayment>1</lastPayment>
         <description>description</description>
         <!--Optional:-->
         <companyName>company</companyName>
         <!--Optional:-->
         <officeName>office</officeName>
         <debtor>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
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
         <country>IT</country>
         <!--Optional:-->
         <e-mail>paGetPayment@test.it</e-mail>
         </debtor>
         <!--Optional:-->
         <transferList>
         <!--1 to 5 repetitions:-->
         <transfer>
         <idTransfer>1</idTransfer>
         <transferAmount>10.00</transferAmount>
         <fiscalCodePA>$activateIOPayment.fiscalCode</fiscalCodePA>
         <IBAN>IT45R0760103200000000001016</IBAN>
         <remittanceInformation>testPaGetPayment</remittanceInformation>
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

   @skip
   Scenario: closePayment
      Given initial json v1/closepayment
         """
         {
            "paymentTokens": [
               "$activateIOPaymentResponse.paymentToken"
            ],
            "outcome": "OK",
            "identificativoPsp": "#psp#",
            "tipoVersamento": "BPAY",
            "identificativoIntermediario": "#id_broker_psp#",
            "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
            "pspTransactionId": "#psp_transaction_id#",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2012-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "transactionId": "#transaction_id#",
               "outcomePaymentGateway": "EFF",
               "authorizationCode": "resOK"
            }
         }
         """

   @skip
   Scenario: sendPaymentOutcome
      Given initial XML sendPaymentOutcome
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <!--Optional:-->
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>name</fullName>
         <!--Optional:-->
         <streetName>street</streetName>
         <!--Optional:-->
         <civicNumber>civic</civicNumber>
         <!--Optional:-->
         <postalCode>postal</postalCode>
         <!--Optional:-->
         <city>city</city>
         <!--Optional:-->
         <stateProvinceRegion>state</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>prova@test.it</e-mail>
         </payer>
         <applicationDate>2021-12-12</applicationDate>
         <transferDate>2021-12-11</transferDate>
         </details>
         </nod:sendPaymentOutcomeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: FLUSSO_CP_01 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And verify 1 record for the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: FLUSSO_CP_01 (part 2)
      Given the FLUSSO_CP_01 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: FLUSSO_CP_01 (part 3)
      Given the FLUSSO_CP_01 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration 
      And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value $activateIOPayment.noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code# of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value 10 of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value BPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table PM_SESSION_DATA retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: FLUSSO_CP_01 (part 4)
      Given the FLUSSO_CP_01 (part 3) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And wait 5 seconds for expiration
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro AppIO
      # check RECEIPT_XML content nella POSITION_RECEIPT_XML (vedi PR Flow_closePaymentV1_ok_spo_ok)


#POSITION_RECEIPT_XML
#SELECT s.* FROM NODO_ONLINE.POSITION_RECEIPT_XML s where s.NOTICE_ID = '#notice_number#' and s.PAYMENT_TOKEN= '$activateIOPaymentResponse.paymentToken';
#SELECT s.* FROM NODO_ONLINE.POSITION_PAYMENT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
#SELECT s.* FROM NODO_ONLINE.POSITION_RECEIPT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
#SELECT s.* FROM NODO_ONLINE.POSITION_RECEIPT_RECIPIENT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';

# pa1 == POSITION_PAYMENT.pa_fiscal_code
# noticeID == POSITION_PAYMENT.notice_id
# creditor == POSITION_PAYMENT.creditor_reference_id
# token == POSITION_PAYMENT.payment_token
# recipientPA == POSITION_RECEIPT_RECIPIENT.recipient_pa_fiscal_code
# recipientBroker == POSITION_RECEIPT_RECIPIENT.recipient_broker_pa_id
# recipientStation == POSITION_RECEIPT_RECIPIENT.recipient_station_id
# insertedTimestamp != null
# xml != null
# fkPositionReceipt == POSITION_RECEIPT.id
# riga2 == null

#RECEIPT_XML content
# select blob
#java.sql.Blob blob = sql.firstRow("SELECT XML as blob FROM POSITION_RECEIPT_XML WHERE PAYMENT_TOKEN ='${paymentToken}' and PA_FISCAL_CODE='${pa}' and NOTICE_ID='${noticeNumber}'").blob
#byte[] bdata = blob.getBytes(1, (int) blob.length());
#String xmlRt = new String(bdata);

#assert xmlRt.contains('<idPA>'+POSITION_PAYMENT.pa_fiscal_code)
#assert xmlRt.contains('<idBrokerPA>'+POSITION_PAYMENT.broker_pa_id)
#assert xmlRt.contains('<idStation>'+POSITION_PAYMENT.station_id)
#assert xmlRt.contains('<receiptId>'+POSITION_PAYMENT.payment_token)
#assert xmlRt.contains('<noticeNumber>'+POSITION_PAYMENT.notice_id)
#assert xmlRt.contains('<fiscalCode>'+POSITION_PAYMENT.pa_fiscal_code)
#assert xmlRt.contains('<outcome>'+POSITION_PAYMENT.outcome)
#assert xmlRt.contains('<creditorReferenceId>'+POSITION_PAYMENT.creditor_reference_id)
#assert xmlRt.contains('<paymentAmount>'+POSITION_PAYMENT.amount)
#assert xmlRt.contains('<description>'+POSITION_SERVICE.description)
#assert xmlRt.contains('<companyName>'+POSITION_SERVICE.company_name)
#assert xmlRt.contains('<debtor><uniqueIdentifier><entityUniqueIdentifierType>'+POSITION_SUBJECT.entity_unique_identifier_type)
#assert xmlRt.contains('<entityUniqueIdentifierValue>'+POSITION_SUBJECT.entity_unique_identifier_value)
#assert xmlRt.contains('<fullName>'+POSITION_SUBJECT.full_name)
#assert xmlRt.contains('<streetName>'+POSITION_SUBJECT.street_name)
#assert xmlRt.contains('<civicNumber>'+POSITION_SUBJECT.civic_number)
#assert xmlRt.contains('<postalCode>'+POSITION_SUBJECT.postal_code)
#assert xmlRt.contains('<city>'+POSITION_SUBJECT.city)
#assert xmlRt.contains('<stateProvinceRegion>'+POSITION_SUBJECT.state_province_region)
#assert xmlRt.contains('<country>'+POSITION_SUBJECT.country)
#assert xmlRt.contains('<e-mail>'+POSITION_SUBJECT.email)

#assert xmlRt.contains('<transfer><idTransfer>'+POSITION_TRANSFER.transfer_identifier)
#assert xmlRt.contains('<transferAmount>'+POSITION_TRANSFER.amount)
#assert xmlRt.contains('<fiscalCodePA>'+POSITION_TRANSFER.pa_fiscal_code_secondary)
#assert xmlRt.contains('<IBAN>'+POSITION_TRANSFER.iban)
#assert xmlRt.contains('<remittanceInformation>'+POSITION_TRANSFER.remittance_information)
#assert xmlRt.contains('<transferCategory>'+POSITION_TRANSFER.transfer_category)

#assert xmlRt.contains('<idPSP>'+PSP.id_psp)
#assert xmlRt.contains('<pspFiscalCode>'+PSP.codice_fiscale)
#assert xmlRt.contains('<PSPCompanyName>'+PSP.ragione_sociale)
#assert xmlRt.contains('<idChannel>'+POSITION_PAYMENT.channel_id)
#if(POSITION_PAYMENT.payment_channel==null){
#    assert xmlRt.contains('<channelDescription>NA')
#} else{
#    assert xmlRt.contains('<channelDescription>'+POSITION_PAYMENT.payment_channel)
#}

#if(xmlRt.contains('<officeName>')) {
#   assert xmlRt.contains('<officeName>'+POSITION_SERVICE.office_name)
#}

#if(xmlRt.contains('<payer>')) {
#  assert xmlRt.contains('<payer><uniqueIdentifier><entityUniqueIdentifierType>'+POSITION_SUBJECT.entity_unique_identifier_type)
#  assert xmlRt.contains('<entityUniqueIdentifierValue>'+POSITION_SUBJECT.entity_unique_identifier_value)
#  assert xmlRt.contains('<fullName>'+POSITION_SUBJECT.full_name)
#  assert xmlRt.contains('<streetName>'+POSITION_SUBJECT.street_name)
#  assert xmlRt.contains('<civicNumber>'+POSITION_SUBJECT.civic_number)
#  assert xmlRt.contains('<postalCode>'+POSITION_SUBJECT.postal_code)
#  assert xmlRt.contains('<city>'+POSITION_SUBJECT.city)
#  assert xmlRt.contains('<stateProvinceRegion>'+POSITION_SUBJECT.state_province_region)
#  assert xmlRt.contains('<country>'+POSITION_SUBJECT.country)
#  assert xmlRt.contains('<e-mail>'+POSITION_SUBJECT.email)
#}


#if(xmlRt.contains('<paymentMethod>')) {
#   assert xmlRt.contains('<paymentMethod>'+POSITION_PAYMENT.payment_method)
#}

#if(xmlRt.contains('<fee>')) {
#   assert xmlRt.contains('<fee>'+POSITION_PAYMENT.fee)
#}

#if(xmlRt.contains('<paymentDateTime>')) {
#   def insertedTimestamp = POSITION_PAYMENT.inserted_timestamp
#   def insTimestampString = insertedTimestamp.toString()
#   assert xmlRt.contains('<paymentDateTime>'+insTimestampString[0..9]+'T'+insTimestampString[11..18])
#}

#if(xmlRt.contains('<applicationDate>')) {
#   def applicationDate = POSITION_PAYMENT.application_date[0]
#   def appDateString = applicationDate.toString()
#   assert xmlRt.contains('<applicationDate>'+appDateString[0..9])
#}

#if(xmlRt.contains('<transferDate>')) {
#   def transferDate = POSITION_PAYMENT.transfer_date[0]
#   def traDateString = transferDate.toString()
#   assert xmlRt.contains('<transferDate>'+traDateString[0..9])
#}