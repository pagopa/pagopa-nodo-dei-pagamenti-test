# Feature: FLUSSO_APIO_24

# Background:
#  Given systems up
#  And EC new version

#  Scenario: Execute verifyPaymentNotice (Phase 1)
#     Given initial XML verifyPaymentNotice
#     """
#     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:verifyPaymentNoticeReq>
#             <idPSP>#psp_AGID#</idPSP>
#             <idBrokerPSP>#broker_AGID#</idBrokerPSP>
#             <idChannel>#canale_AGID#</idChannel>
#             <password>pwdpwdpwd</password>
#             <qrCode>
#                 <fiscalCode>#creditor_institution_code#</fiscalCode>
#                 <noticeNumber>#notice_number#</noticeNumber>
#             </qrCode>
#         </nod:verifyPaymentNoticeReq>
#         </soapenv:Body>
#     </soapenv:Envelope>
#     """
#     When AppIO sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
#     Then check outcome is OK of verifyPaymentNotice response

# Scenario: Execute activateIOPayment (Phase 2)
#     Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
#     And initial XML activateIOPayment
#     """
#     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#             <nod:activateIOPaymentReq>
#                 <idPSP>$verifyPaymentNotice.idPSP</idPSP>
#                 <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
#                 <idChannel>$verifyPaymentNotice.idChannel</idChannel>
#                 <password>$verifyPaymentNotice.password</password>
#                 <!--Optional:-->
#                 <idempotencyKey>#idempotency_key#</idempotencyKey>
#                 <qrCode>
#                     <fiscalCode>#creditor_institution_code#</fiscalCode>
#                     <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
#                 </qrCode>
#                 <!--Optional:-->
#                 <expirationTime>12345</expirationTime>
#                 <amount>10.00</amount>
#                 <!--Optional:-->
#                 <dueDate>2021-12-12</dueDate>
#                 <!--Optional:-->
#                 <paymentNote>test</paymentNote>
#                 <!--Optional:-->
#                 <payer>
#                     <uniqueIdentifier>
#                         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
#                         <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
#                     </uniqueIdentifier>
#                     <fullName>name</fullName>
#                     <!--Optional:-->
#                     <streetName>street</streetName>
#                     <!--Optional:-->
#                     <civicNumber>civic</civicNumber>
#                     <!--Optional:-->
#                     <postalCode>code</postalCode>
#                     <!--Optional:-->
#                     <city>city</city>
#                     <!--Optional:-->
#                     <stateProvinceRegion>state</stateProvinceRegion>
#                     <!--Optional:-->
#                     <country>IT</country>
#                     <!--Optional:-->
#                     <e-mail>test.prova@gmail.com</e-mail>
#                 </payer>
#             </nod:activateIOPaymentReq>
#         </soapenv:Body>
#     </soapenv:Envelope>
#     """
#     When AppIO sends SOAP activateIOPayment to nodo-dei-pagamenti
#     Then check outcome is OK of activateIOPayment response

# Scenario: Execute nodoChiediInformazioniPagamento (Phase 3)
#     Given the Execute activateIOPayment (Phase 2) scenario executed successfully
#     When WISP sends rest GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
#     Then verify the HTTP status code of informazioniPagamento response is 200

# Scenario: Execute nodoInoltroEsitoCarta (Phase 4) 
#     Given the Execute nodoChiediInformazioniPagamento (Phase 3) scenario executed successfully
#     And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
#     """
#     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:psp="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#             <psp:pspNotifyPaymentRes>
#                 <outcome>Response malformata</outcome>
#             </psp:pspNotifyPaymentRes>
#         </soapenv:Body>
#     </soapenv:Envelope>
#     """
#     When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
#     """
#     {
#         "RRN":10026669,
#         "tipoVersamento":"CP",
#         "idPagamento":"$activateIOPaymentResponse.paymentToken",
#         "identificativoIntermediario":"#psp#",
#         "identificativoPsp":"#psp#",
#         "identificativoCanale":"#canale#",
#         "importoTotalePagato":10.00,
#         "timestampOperazione":"2021-07-09T17:06:03.100+01:00",
#         "codiceAutorizzativo":"resOK",
#         "esitoTransazioneCarta":"00"
#         }
#     """
#     Then verify the HTTP status code of inoltroEsito/carta response is 408
#     And check error is Operazione in timeout of inoltroEsito/carta response

# Scenario: Check nodoChiediAvanzamentoPagamento response after nodoInoltroEsitoCarta, and check correctness of database tables
#     Given The Execute nodoInoltroEsitoCarta (Phase 4) scenario executed successfully
#     And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
#     When WISP sends rest GET avanzamentoPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
#     Then verify the HTTP status code of avanzamentoPagamento response is 200
#     And check esito is ACK_UNKNOWN of avanzamentoPagamento response
#     And checks the value PAYING, PAYMENT_SENT, PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
#     # correctness of POSITION_PAYMENT table 
#     And checks the value $activateIOPaymentResponse.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value $activateIOPaymentResponse.fiscalCodePA of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value #canale# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value $activateIOPaymentResponse.totalAmount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value CP of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO
#     And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro AppIO