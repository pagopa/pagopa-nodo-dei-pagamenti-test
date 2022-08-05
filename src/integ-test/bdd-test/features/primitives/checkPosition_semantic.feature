Feature: semantic checks for checkPosition outcome OK

    Background: Given systems up

    # SEM_CPO_01
    Scenario: Code 200 OK 1
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is OK of checkPosition response
        And check errorCode is 200
        And check description is not contained in checkPosition response

    # SEM_CPO_02
    Scenario: Code 200 OK 2 (part 1)
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And update through the query notice_number of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online

    Scenario: Code 200 OK 2 (part 2)
        Given the Code 200 OK 2 (part 1) executed succesfully
        And initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is OK of checkPosition response
        And check errorCode is 200
        And check description is not contained in checkPosition response

    # SEM_CPO_03
    Scenario: Code 200 KO (part 1)
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: Code 200 KO (part 2)
        Given the Code 200 KO (part 1) executed succesfully
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number_1#</noticeNumber>
            </qrCode>
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And update through the query notice_number of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online

    Scenario: Code 200 KO (part 3)
        Given the Code 200 KO (part 2) executed succesfully
        And initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>#notice_number_2#</noticeNumber>
            </qrCode>
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And update through the query notice_number of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online

    Scenario: Code 200 KO (part 4)
        Given the Code 200 KO (part 3) executed succesfully
        And initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "#notice_number#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "#notice_number_1#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "#notice_number_2#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check errorCode is 200
        And check PAID is contained in checkPosition response
        And check NOTIFIED is contained in checkPosition response
        And check PAYING is contained in checkPosition response

    # SEM_CPO_04
    Scenario: Wrong configuration 1
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "12345678902",
                        "noticeNumber": "#notice_number#"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check errorCode is 400
        And check description is Wrong configuration of checkPosition response

    # SEM_CPO_05
    Scenario: Wrong configuration 2
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "002$iuv"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check errorCode is 400
        And check description is Wrong configuration of checkPosition response

    # SEM_CPO_06
    Scenario: Wrong configuration 3
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "#311$iuv#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "311$iuv1"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "000$iuv2"
                    }
                ]
            }
            """
        When PM sends checkPosition to nodo-dei-pagamenti
        Then check outcome is KO of checkPosition response
        And check errorCode is 400
        And check description is Wrong configuration of checkPosition response

# da implementare in step.py:
# @given('initial json {primitive}')
#   ...
# @step("update through the query {query_name} of the table {table_name} the parameter {param} with {value} under macro {macro} on db {db_name}")
#   ...
# @then('check {value} is contained in {primitive} response')
#   ...
# @then('check {value} is not contained in {primitive} response')
#   ...

# da implementare in query_AutomationTest.json:
# "NewMod1" : {"notice_number": "SELECT columns FROM table_name WHERE NOTICE_ID = '$activatePaymentNoticeV2Request.noticeNumber'",