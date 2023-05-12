Feature: annullamentorptmaitichiestedapm_pa_new

   Background:
      Given systems up

   Scenario: Execute verifyPaymentNotice (Phase 1)
      Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 6000
      And nodo-dei-pagamenti has config parameter scheduler.cancelIOPaymentActorMinutesToBack set to 1
      And nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to true
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>#psp_AGID#</idPSP>
         <idBrokerPSP>#broker_AGID#</idBrokerPSP>
         <idChannel>#canale_AGID#</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>#notice_number#</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   @eventhub
   Scenario: Execute activateIOPayment (Phase 2)
      Given the Execute verifyPaymentNotice (Phase 1) scenario executed successfully
      And initial XML activateIOPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activateIOPaymentReq>
         <idPSP>$verifyPaymentNotice.idPSP</idPSP>
         <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
         <idChannel>$verifyPaymentNotice.idChannel</idChannel>
         <password>$verifyPaymentNotice.password</password>
         <!--Optional:-->
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
         </qrCode>
         <!--Optional:-->
         <expirationTime>6000</expirationTime>
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
         <fullName>name</fullName>
         <!--Optional:-->
         <streetName>street</streetName>
         <!--Optional:-->
         <civicNumber>civic</civicNumber>
         <!--Optional:-->
         <postalCode>code</postalCode>
         <!--Optional:-->
         <city>city</city>
         <!--Optional:-->
         <stateProvinceRegion>state</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>test.prova@gmail.com</e-mail>
         </payer>
         </nod:activateIOPaymentReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      And job annullamentoRptMaiRichiesteDaPm triggered after 61 seconds
      Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200
      And restore initial configurations