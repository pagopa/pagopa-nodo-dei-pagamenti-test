Feature: NM1 PA New without optional

    Background:
        Given systems up

   Scenario: Define MBD
      Given MB generation
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>
         <CodiceFiscale>#creditor_institution_code#</CodiceFiscale>
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

    Scenario: checkPosition request
        Given the Define MBD scenario executed successfully
        And from body checkPositionBody_paNewVP2 initial JSON checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2 request
        Given the checkPosition request scenario executed successfully
        And from body activatePaymentNoticeV2Body_paNewVP2_Ecommerce initial XML activatePaymentNoticeV2
        And from body paGetPaymentV2_MBD_tokenFromActivateV2_noOptional initial XML paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: closePaymentV2 request
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And from body closePaymentV2Body_CP_PSPvp2_noOptional initial json v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @noOptional
    Scenario: sendPaymentOutcomeV2 request
        Given the closePaymentV2 request scenario executed successfully
        And from body sendPaymentOutcomeV2Body_MBD_tokenFromActivateV2_noOptional initial XML sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        

