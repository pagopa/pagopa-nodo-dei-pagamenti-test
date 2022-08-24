Feature: checks for pspNotifyPaymentV2

  Background:
    Given systems up
    And initial json checkPosition
      """
      {
        "positionslist": [
          {
            "fiscalCode": "#creditor_institution_code#",
            "noticeNumber": "310#iuv#"
          }
        ]
      }
      """
    When PM sends checkPosition to nodo-dei-pagamenti
    Then check outcome is OK of checkPosition response
    And check faultCode is 200 of checkPosition response

  Scenario: activatePaymentNoticeV2
    Given initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>310$iuv</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <paymentNote>metadati</paymentNote>
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: closePaymentV2
    Given initial json closePaymentV2
      """
      {
      "paymentTokens": [
      "$activatePaymentNoticeV2Response.paymentToken"
      ],
      "outcome": "OK",
      "idPSP": "70000000001",
      "paymentMethod": "TPAY",
      "idBrokerPSP": "70000000001",
      "idChannel": "70000000001_08",
      "transactionId": "#transaction_id#",
      "totalAmount": $activatePaymentNoticeV2.amount,
      "fee": 0.00,
      "timestampOperation": "2012-04-23T18:25:43Z",
      "additionalPaymentInformations": {}
      }
      """

  # T_PNPV2_01

  Scenario: T_PNPV2_01 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_01 (part 2)
    Given the T_PNPV2_01 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_ACCEPTED,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_01.1

Scenario: T_PNPV2_01.1 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 5.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_01.1 (part 2)
    Given the T_PNPV2_01.1 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 10 seconds for expiration
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_ACCEPTED,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_02

Scenario: T_PNPV2_02 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 1.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_02 (part 2)
    Given the T_PNPV2_02 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_REFUSED,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_02.1

Scenario: T_PNPV2_02.1 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 6.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_02.1 (part 2)
    Given the T_PNPV2_02.1 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 10 seconds for expiration
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_REFUSED,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_03

Scenario: T_PNPV2_03 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 2.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_03 (part 2)
    Given the T_PNPV2_03 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_03.1

Scenario: T_PNPV2_03.1 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 3.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_03.1 (part 2)
    Given the T_PNPV2_03.1 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 25 seconds for expiration
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_03.2

Scenario: T_PNPV2_03.2 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 4.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_03.2 (part 2)
    Given the T_PNPV2_03.2 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_03.3

Scenario: T_PNPV2_03.3 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 7.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_03.3 (part 2)
    Given the T_PNPV2_03.3 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And wait 10 seconds for expiration
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_UNKNOWN,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# T_PNPV2_04

Scenario: T_PNPV2_04 (part 1)
    Given the activatePaymentNoticeV2 scenario executed successfully
    And amount with 8.00 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    And check metadata contains CHIAVEOK of activatePaymentNoticeV2 response
    And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

  Scenario: T_PNPV2_04 (part 2)
    Given the T_PNPV2_04 (part 1) scenario executed successfully
    And the closePaymentV2 scenario executed successfully
    When PM sends closePaymentV2 to nodo-dei-pagamenti
    Then check outcome is OK of closePaymentV2 response
    And check faultCode is 200 of closePaymentV2 response
    And checks the value test of the record at column description of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value metadati of the record at column company_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value office of the record at column office_name of the table POSITION_SERVICE retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2Response.creditorReferenceId of the record at column creditor_reference_id of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_PAYMENT retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value 1 of the record at column transfer_identifier of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.amount of the record at column amount of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column pa_fiscal_code_secondary of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value IT45R0760103200000000001016 of the record at column iban of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value /RFB/00202200000217527/5.00/TXT/ of the record at column remittance_information of the table POSITION_TRANSFER retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,None of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_pa on db db_online under macro NewMod1
    And checks the value PAYMENT_SEND_ERROR,None of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_pa on db db_online under macro NewMod1

# da implementare in query_AutomationTest.json
# "NewMod1" : { "notice_id_pa":"SELECT columns FROM table_name WHERE NOTICE_ID ='$activatePaymentNoticeV2.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNoticeV2.fiscalCode' ORDER BY ID ASC" }