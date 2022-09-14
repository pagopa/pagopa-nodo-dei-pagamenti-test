Feature: semantic checks new for activatePaymentNoticeV2Request

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2 + paGetPayment
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
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
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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

    # SEM_APNV2_19
    Scenario: semantic check 19 (part 1)
        Given the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
        And saving paGetPayment request in paGetPaymentResponse

    Scenario: semantic check 19 (part 2)
        Given the semantic check 19 (part 1) scenario executed successfully
        And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
        And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
        And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
        And creditorReferenceId with $paGetPaymentResponse.creditorReferenceId in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response












# inizio test momentaneamente commentati
















# # SEM_APNV2_19.1
# Scenario: semantic check 19.1 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter useIdempotency set to false
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 1 seconds for expiration

# Scenario: semantic check 19.1 (part 2)
#     Given the semantic check 19.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to true
#     And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

# # SEM_APNV2_20
# Scenario: semantic check 20 (part 1)
#     Given the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 1 seconds for expiration

# Scenario: semantic check 20 (part 2)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20 (part 3)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And fiscalCode with 77777777777 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20 (part 4)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And amount with 6.00 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20 (part 5)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And dueDate with 2021-12-16 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 2 seconds for expiration

# Scenario: semantic check 20 (part 6)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And paymentNote with medatati in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 2 seconds for expiration

# Scenario: semantic check 20 (part 7)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And dueDate with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20 (part 8)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20 (part 9)
#     Given the semantic check 20 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And paymentNote with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response

# # SEM_APNV2_20.1
# Scenario: semantic check 20.1 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter useIdempotency set to false
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 2)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 3)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And fiscalCode with 77777777777 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 4)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And amount with 6.00 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 5)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And dueDate with 2021-12-16 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 6)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And paymentNote with medatati in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 7)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And dueDate with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 8)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration

# Scenario: semantic check 20.1 (part 9)
#     Given the semantic check 20.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And paymentNote with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And wait 1 seconds for expiration
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to true
#     And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

# # SEM_APNV2_21
# Scenario: semantic check 21 (part 1)
#     Given the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And expirationTime with 6000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 8 seconds for expiration

# Scenario: semantic check 21 (part 2)
#     Given the semantic check 21 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with 6000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

# # SEM_APNV2_21.1
# Scenario: semantic check 21.1 (part 1)
#     Given the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And expirationTime with 6000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 8 seconds for expiration

# Scenario: semantic check 21.1 (part 2)
#     Given the semantic check 21.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with 1000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

# # SEM_APNV2_21.2
# Scenario: semantic check 21.2 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter useIdempotency set to false
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And expirationTime with 2000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 4 seconds for expiration

# Scenario: semantic check 21.2 (part 2)
#     Given the semantic check 21.2 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with 6000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to true
#     And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

# # SEM_APNV2_21.3
# Scenario: semantic check 21.3 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter useIdempotency set to false
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And expirationTime with 2000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 4 seconds for expiration

# Scenario: semantic check 21.3 (part 2)
#     Given the semantic check 21.3 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with 9000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to true
#     And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

# # SEM_APNV2_22
# Scenario: semantic check 22 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter default_idempotency_key_validity_minutes set to 1
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And expirationTime with 120000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 70 seconds for expiration

# Scenario: semantic check 22 (part 2)
#     Given the semantic check 22 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with 1000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And nodo-dei-pagamenti DEV has config parameter default_idempotency_key_validity_minutes set to 10

# # SEM_APNV2_22.1
# Scenario: semantic check 22.1 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter default_idempotency_key_validity_minutes set to 1
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to false
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And expirationTime with 120000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2Request
#     And wait 70 seconds for expiration

# Scenario: semantic check 22.1 (part 2)
#     Given the semantic check 22.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with $activatePaymentNoticeV2Request.idempotencyKey in activatePaymentNoticeV2
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     And expirationTime with 1000 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And nodo-dei-pagamenti DEV has config parameter default_idempotency_key_validity_minutes set to 10
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to true
#     And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1

# # SEM_APNV2_23
# Scenario: semantic check 23 (part 1)
#     Given the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response

# Scenario: semantic check 23 (part 2)
#     Given the semantic check 23 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And noticeNumber with $activatePaymentNoticeV2Request.noticeNumber in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response

# # SEM_APNV2_23.1
# Scenario: semantic check 23.1 (part 1)
#     Given nodo-dei-pagamenti DEV has config parameter useIdempotency set to false
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response

# Scenario: semantic check 23.1 (part 2)
#     Given the semantic check 23.1 (part 1) scenario executed successfully
#     And the activatePaymentNoticeV2 + paGetPayment scenario executed successfully
#     And idempotencyKey with None in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is KO of activatePaymentNoticeV2 response
#     And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
#     And nodo-dei-pagamenti DEV has config parameter useIdempotency set to true
#     And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod1











# fine test momentaneamente commentati













# per questo test è necessaria la paGetPaymentV2, attualmente non disponibile sul mock pa
# SEM_APNV2_26
# Scenario: semantic check 26
#     Given initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value test of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value metadati of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value office of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value paGetPaymentName of the record at column FULL_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value paGetPaymentStreet of the record at column STREET_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value paGetPayment99 of the record at column CIVIC_NUMBER of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value 20155 of the record at column STREET_NAME of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value paGetPaymentCity of the record at column CITY of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value paGetPaymentState of the record at column STATE_PROVINCE_REGION of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value DE of the record at column COUNTRY of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value paGetPaymentV2@test.it of the record at column EMAIL of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_SUBJECT ON (POSITION_SERVICE.DEBTOR_ID = POSITION_SUBJECT.ID) retrived by the query position_service on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RETENTION_DATE of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE_SECONDARY of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value IT45R0760103200000000001016 of the record at column IBAN of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column REMITTANCE_INFORMATION of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value paGetPaymentTest of the record at column TRANSFER_CATEGORY of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value 1 of the record at column TRANSFER_IDENTIFIER of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value Y of the record at column VALID of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment_plan on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value N of the record at column ACTIVATION_PENDING of the table POSITION_STATUS_SNAPSHOT JOIN POSITION_SERVICE ON (POSITION_STATUS_SNAPSHOT.FK_POSITION_SERVICE = POSITION_SERVICE.ID) retrived by the query position_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value 77777777777 of the record at column BROKER_PA_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value 77777777777_08 of the record at column STATION of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FEE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT.FK_PAYMENT_PLAN = POSITION_PAYMENT_PLAN.ID) retrived by the query position_payment on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT JOIN POSITION_PAYMENT ON (POSITION_PAYMENT_STATUS_SNAPSHOT.FK_POSITION_PAYMENT = POSITION_PAYMENT.ID) retrived by the query position_payment_status_snapshot on db nodo_online under macro NewMod1
#     And checks the value NotNone,None of the record at column UPDATED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.dueDate of the record at column TO_CHAR(DUE_DATE, 'yyyy-mm-dd') of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query select_activatev2 on db nodo_online under macro NewMod1

# per questo test è necessaria la paGetPaymentV2, attualmente non disponibile sul mock pa
# SEM_APNV2_27
# Scenario: semantic check 27 (part 1)
#     Given initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati10</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And check metadata is Empty of activatePaymentNoticeV2 response
#     And controls the value chiaveok is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
#     And controls the value chiaveok is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

# Scenario: semantic check 27 (part 2)
#     Given the semantic check 27 (part 1) executed successfully
#     And initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati11</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And check key is CHIAVEOKFINNULL of activatePaymentNoticeV2 response
#     And controls the value CHIAVEOKFINNULL is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
#     And controls the value CHIAVEOKFINNULL is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

# Scenario: semantic check 27 (part 3)
#     Given the semantic check 27 (part 2) executed successfully
#     And initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati12</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And check metadata is Empty of activatePaymentNoticeV2 response
#     And controls the value CHIAVEOKFININF is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
#     And controls the value CHIAVEOKFININF is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

# Scenario: semantic check 27 (part 4)
#     Given the semantic check 27 (part 3) executed successfully
#     And initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati13</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And check metadata is Empty of activatePaymentNoticeV2 response
#     And controls the value CHIAVEOKINIZSUP is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
#     And controls the value CHIAVEOKINIZSUP is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

# Scenario: semantic check 27 (part 5)
#     Given the semantic check 27 (part 4) executed successfully
#     And initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati14</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And check metadata is Empty of activatePaymentNoticeV2 response
#     And controls the value chiaveminuscola is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
#     And controls the value chiaveminuscola is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

# Scenario: semantic check 27 (part 6)
#     Given the semantic check 27 (part 5) executed successfully
#     And initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>metadati</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And check key is CHIAVEOK of activatePaymentNoticeV2 response
#     And controls the value CHIAVEOK is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) retrived by the query metadata on db nodo_online under macro NewMod1
#     And controls the value CHIAVEOK is contained in the record at column METADATA of the table POSITION_SERVICE JOIN POSITION_PAYMENT_PLAN ON (POSITION_PAYMENT_PLAN.FK_POSITION_SERVICE=POSITION_SERVICE.ID) JOIN POSITION_TRANSFER ON (POSITION_TRANSFER.FK_PAYMENT_PLAN=POSITION_PAYMENT_PLAN.ID) retrived by the query metadata on db nodo_online under macro NewMod1

# per questo test è necessaria la paGetPaymentV2, attualmente non disponibile sul mock pa
# SEM_APNV2_28
# Scenario: semantic check 28
#     Given initial xml activatePaymentNoticeV2
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
#         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
#         <soapenv:Header/>
#         <soapenv:Body>
#         <nod:activatePaymentNoticeV2Request>
#         <idPSP>70000000001</idPSP>
#         <idBrokerPSP>70000000001</idBrokerPSP>
#         <idChannel>70000000001_01</idChannel>
#         <password>pwdpwdpwd</password>
#         <idempotencyKey>#idempotency_key#</idempotencyKey>
#         <qrCode>
#         <fiscalCode>#creditor_institution_code#</fiscalCode>
#         <noticeNumber>310$iuv</noticeNumber>
#         </qrCode>
#         <amount>10.00</amount>
#         <dueDate>2021-12-31</dueDate>
#         <paymentNote>causale</paymentNote>
#         </nod:activatePaymentNoticeV2Request>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response
#     And trim blank spaces of activatePaymentNoticeV2Response
#     And controls activatePaymentNoticeV2Response is contained in the record at column REGEXP_REPLACE(TO_CHAR(RESPONSE), '\s+', '') of the table IDEMPOTENCY_CACHE retrived by the query select_activatev2 on db nodo_online under macro NewMod1