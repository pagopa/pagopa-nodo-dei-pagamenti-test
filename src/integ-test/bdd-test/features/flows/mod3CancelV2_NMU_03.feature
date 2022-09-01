Feature:  flow checks for mod3cancelV2 - pspNotifyPaymentV2 timeout, SPOV2 OK [FLUSSO_NM1_M3CV2_03]

  Background:
    Given systems up 
    And EC new version

    # checkPosition phase
    Scenario: Execute checkPosition request
    Given initial json checkPosition

    """
    {"positionslist": [
    {"fiscalCode": "#creditor_institution_code#", 
    "noticeNumber": "#notice_number#"}
    ]
    }
    """

    When PM sends checkPosition to nodo-dei-pagamenti
    Then check outcome is OK of checkPosition response
    And check errorCode is 200 of checkPosition response

   # activatePaymentNoticeV2 phase
    Scenario: Execute activatePaymentNoticeV2 request
    Given stazione with STAZIONI.VERSIONE_PRIMITIVE = 2
    And initial XML activatePaymentNoticeV2 soap-request

    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
             <!--expirationTime>3000</expirationTime-->
             <amount>10.00</amount>
             <paymentNote>responseFull</paymentNote>
          </nod:activatePaymentNoticeV2Request>
       </soapenv:Body>
    </soapenv:Envelope>
    """

    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

    # activatePaymentNoticeV2 phase 1
    Scenario: Execute activatePaymentNoticeV2 request
    Given initial XML activatePaymentNoticeV2 soap-request

    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:activatePaymentNoticeV2Request>
             <idPSP>70000000001</idPSP>
             <idBrokerPSP>70000000001</idBrokerPSP>
             <idChannel>70000000001_01</idChannel>
             <password>pwdpwdpwd</password>
             <idempotencyKey>#idempotency_key_1#</idempotencyKey>
             <qrCode>
                <fiscalCode>#creditor_institution_code#</fiscalCode>
                <noticeNumber>#notice_number_1#</noticeNumber>
             </qrCode>
             <!--expirationTime>3000</expirationTime-->
             <amount>10.00</amount>
             <paymentNote>responseFull</paymentNote>
          </nod:activatePaymentNoticeV2Request>
       </soapenv:Body>
    </soapenv:Envelope>
    """

    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

    # closePayment-v2 phase  
    Scenario: Execute a closePayment-v2 request
    Given idChannel with CANALI_NODO.VERSIONE_PRIMITIVE = 2
    And initial json closePayment-v2
    """   
    {"paymentTokens": [
        "$activatePaymentNoticeV2Response.paymentToken",
        "$activatePaymentNoticeV2-1Response.paymentToken"
        ],
    "outcome": "OK",
    "idPSP": "70000000001",
    "idBrokerPSP": "70000000001",
    "idChannel": "70000000001_08",
    "paymentMethod": "TPAY",
    "transactionId": "#transaction_id#",
    "totalAmount": 22.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
          "key": "10793459"
        }
    }
    """

    When PM sends closePayment-v2 to nodo-dei-pagamenti
    And nodo-dei-pagamenti sends pspNotifyPaymentV2Response in late
    Then check esito is OK of closePayment-v2

    # DB CHECK
    # SELECT s.* FROM "+username+".NMU_CANCEL_UTILITY s where s.TRANSACTION_ID = '#transaction_id#';
    # SELECT * FROM "+username+".POSITION_ACTIVATE s where s.NOTICE_ID = '${noticeNumber}' and s.PA_FISCAL_CODE= '${pa}';

    # NMU_CANCEL_UTILITY
    # PAYMENT_TOKENS == '$activatePaymentNoticeV2Response.paymentToken' + ',' + '$activatePaymentNoticeV2-1Response.paymentToken'
    # NUM_TOKEN == 2
    # VALID_TO == POSITION_ACTIVATE.TOKEN_VALID_TO
	# INSERTED_TIMESTAMP != null
	# INSERTED_BY == 'closePayment-v2'
	
     # sendPaymentOutcomeV2Req phase
     Scenario: Execute sendPaymentOutcomeV2 request
     Given the closePayment-v2 scenario executed successfully
     Given initial XML sendPaymentOutcomeV2
     """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:sendPaymentOutcomeV2Request>
             <idPSP>70000000001</idPSP>
             <idBrokerPSP>70000000001</idBrokerPSP>
             <idChannel>70000000001_03</idChannel>
             <password>pwdpwdpwd</password>
			 <paymentTokens>
				<paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
				<paymentToken>$activatePaymentNoticeV2-1Response.paymentToken</paymentToken>
			 </paymentTokens>
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
                   <fullName>SPOname_$activateIOPaymentResponse.paymentToken</fullName>
                   <!--Optional:-->
                   <streetName>SPOstreet</streetName>
                   <!--Optional:-->
                   <civicNumber>SPOcivic</civicNumber>
                   <!--Optional:-->
                   <postalCode>SPOpostal</postalCode>
                   <!--Optional:-->
                   <city>SPOcity</city>
                   <!--Optional:-->
                   <stateProvinceRegion>SPOstate</stateProvinceRegion>
                   <!--Optional:-->
                   <country>IT</country>
                   <!--Optional:-->
                   <e-mail>SPOprova@test.it</e-mail>
                </payer>
                <applicationDate>2021-12-12</applicationDate>
                <transferDate>2021-12-11</transferDate>
             </details>
          </nod:sendPaymentOutcomeV2Request>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    When psp sends sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK

	# DB CHECK
    # SELECT s.* FROM "+username+".NMU_CANCEL_UTILITY s where s.TRANSACTION_ID = '#transaction_id#';

    # NMU_CANCEL_UTILITY
    # PAYMENT_TOKENS == null