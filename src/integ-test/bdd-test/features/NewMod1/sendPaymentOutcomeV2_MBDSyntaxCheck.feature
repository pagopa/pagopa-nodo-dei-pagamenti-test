Feature: MBD syntax checks in sendPaymentOutcomeV2

   Background:
      Given systems up

   @skip
   Scenario: sendPaymentOutcomeV2
      Given initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <paymentTokens>
         <paymentToken>12345678901234567890123456789012</paymentToken>
         </paymentTokens>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <primaryCiIncurredFee>1.00</primaryCiIncurredFee>
         <idBundle>1</idBundle>
         <idCiBundle>1.00</idCiBundle>
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
         <marcheDaBollo>
         <marcaDaBollo>
         <paymentToken>12345678901234567890123456789012</paymentToken>
         <idTransfer>1</idTransfer>
         <MBDAttachment>$bollo</MBDAttachment>
         </marcaDaBollo>
         </marcheDaBollo>
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """
   @skip
   # test 1
   Scenario: Define MBD test 1
      Given MB generation
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <IUBD>#iubd#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
         </ImprontaDocumento>
         <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
         <SignedInfo>
         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
         <Reference URI="">
         <Transforms>
         <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
         </Transforms>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
         </Reference>
         </SignedInfo>
         <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
         </Signature>
         </marcaDaBollo>
         """
   @skip
   Scenario: Check PPT_SINTASSI error on MBD PSP None - Test 1
      Given the Define MBD test 1 scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI of sendPaymentOutcomeV2 response
      And check faultString is Errore validazione marca da bollo of sendPaymentOutcomeV2 response

   @skip
   # test 2
   Scenario: Define MBD test 2
      Given MB generation
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>

         </PSP>
         <IUBD>#iubd#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
         </ImprontaDocumento>
         <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
         <SignedInfo>
         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
         <Reference URI="">
         <Transforms>
         <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
         </Transforms>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
         </Reference>
         </SignedInfo>
         <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
         </Signature>
         </marcaDaBollo>
         """
   @skip
   Scenario: Check PPT_SINTASSI error on MBD PSP Empty - Test 2
      Given the Define MBD test 2 scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI of sendPaymentOutcomeV2 response
      And check faultString is Errore validazione marca da bollo of sendPaymentOutcomeV2 response

   @skip
   # test 3
   Scenario: Define MBD test 3
      Given MB generation
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">

         <CodiceFiscale>CF60000000006</CodiceFiscale>
         <Denominazione>#psp#</Denominazione>

         <IUBD>#iubd#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
         </ImprontaDocumento>
         <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
         <SignedInfo>
         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
         <Reference URI="">
         <Transforms>
         <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
         </Transforms>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
         </Reference>
         </SignedInfo>
         <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
         </Signature>
         </marcaDaBollo>
         """
   @skip
   Scenario: Check PPT_SINTASSI error on MBD PSP no tag - Test 3
      Given the Define MBD test 3 scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI of sendPaymentOutcomeV2 response
      And check faultString is Errore validazione marca da bollo of sendPaymentOutcomeV2 response


   # test 3
   Scenario: Define MBD test 4
      Given initial xml MB
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>
         <CodiceFiscale>CF60000000006</CodiceFiscale>
         <Denominazione>#psp#</Denominazione>
         </PSP>
         <IUBD>#iubd#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
         </ImprontaDocumento>
         <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
         <SignedInfo>
         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
         <Reference URI="">
         <Transforms>
         <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
         </Transforms>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
         </Reference>
         </SignedInfo>
         <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
         </Signature>
         </marcaDaBollo>
         """

   Scenario Outline: Check PPT_SINTASSI error on MBD PSP no tag - Test 4
      Given the Define MBD test 4 scenario executed successfully
      And <elem> with <value> in MB
      And MB generation 
      """
      $MB
      """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      # And check faultCode is PPT_SINTASSI of sendPaymentOutcomeV2 response
      # And check faultString is Errore validazione marca da bollo of sendPaymentOutcomeV2 response
      Examples:
         | elem | value | soapUI test |
         | PSP  | None  | Test 1      |
         | PSP  | Empty | Test 2      |