Feature:  flow checks for mod3cancelV2 - pspNotifyPaymentV2 timeout, mod3CancelV2 when tokens expired and all payments in PAYMENT_UNKNOWN [FLUSSO_NM1_M3CV2_05]

  Background:
    Given systems up 
    And EC new version

	# UPDATE NODO4_CFG.CONFIGURATION_KEYS s SET s.CONFIG_VALUE = 1000 WHERE s.CONFIG_KEY ='default_durata_estensione_token_IO'

   # CONFIG server refresh phase
    Scenario: Execute CONFIG server refresh
    When CONFIG server refresh is triggered  # https://api.dev.platform.pagopa.it/nodo-pagamenti-dev/api/v1/config/refresh/CONFIG
    Then verify the HTTP status code response is 200 
	
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
	
	
    # mod3CancelV2 phase
    Scenario: Execute mod3CancelV2 poller
    Given the Execute closePayment-v2 request scenario executed successfully
    When job mod3CancelV2 triggered after 4 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
	
    # DB CHECK
    # SELECT s.* FROM "+username+".NMU_CANCEL_UTILITY s where s.TRANSACTION_ID = '#transaction_id#';

    # NMU_CANCEL_UTILITY
    # PAYMENT_TOKENS == null
	
    # SELECT s.* FROM POSITION_PAYMENT_STATUS s WHERE s.NOTICE_ID ='#notice_number#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#' order by s.ID ASC;
    # SELECT s.* FROM POSITION_PAYMENT_STATUS_SNAPSHOT s WHERE s.NOTICE_ID ='#notice_number#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#';
    # SELECT s.* FROM POSITION_STATUS s WHERE s.NOTICE_ID ='#notice_number#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#' order by s.ID ASC;
    # SELECT s.* FROM POSITION_STATUS_SNAPSHOT s WHERE s.NOTICE_ID ='#notice_number#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#';

    # POSITION_PAYMENT_STATUS
    # status[0] == 'PAYING'
	# status[1] == 'PAYMENT_RESERVED'
	# status[2] == 'PAYMENT_SENT'
	# status[3] == 'PAYMENT_UNKNOWN'
    # status[4] == 'CANCELLED'
    # status[5] == null

    # POSITION_PAYMENT_STATUS_SNAPSHOT
    # status[0] == 'CANCELLED'
    # status[1] == null

    # POSITION_STATUS
    # status[0] == 'PAYING'
    # status[1] == 'INSERTED'
    # status[2] == null

    # POSITION_STATUS_SNAPSHOT
    # status[0] == 'INSERTED'
    # status[1] == null

    # SELECT s.* FROM POSITION_PAYMENT_STATUS s WHERE s.NOTICE_ID ='#notice_number_1#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#' order by s.ID ASC;
    # SELECT s.* FROM POSITION_PAYMENT_STATUS_SNAPSHOT s WHERE s.NOTICE_ID ='#notice_number_1#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#';
    # SELECT s.* FROM POSITION_STATUS s WHERE s.NOTICE_ID ='#notice_number_1#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#' order by s.ID ASC;
    # SELECT s.* FROM POSITION_STATUS_SNAPSHOT s WHERE s.NOTICE_ID ='#notice_number_1#' AND s.PA_FISCAL_CODE = '#creditor_institution_code#';

    # POSITION_PAYMENT_STATUS
    # status[0] == 'PAYING'
	# status[1] == 'PAYMENT_RESERVED'
	# status[2] == 'PAYMENT_SENT'
	# status[3] == 'PAYMENT_UNKNOWN'
    # status[4] == 'CANCELLED'
    # status[5] == null

    # POSITION_PAYMENT_STATUS_SNAPSHOT
    # status[0] == 'CANCELLED'
    # status[1] == null

    # POSITION_STATUS
    # status[0] == 'PAYING'
    # status[1] == 'INSERTED'
    # status[2] == null

    # POSITION_STATUS_SNAPSHOT
    # status[0] == 'INSERTED'
    # status[1] == null
	
	
	# UPDATE NODO4_CFG.CONFIGURATION_KEYS s SET s.CONFIG_VALUE = 3600000 WHERE s.CONFIG_KEY ='default_durata_estensione_token_IO'

    # CONFIG server refresh phase
    Scenario: Execute CONFIG server refresh
    When CONFIG server refresh is triggered  # https://api.dev.platform.pagopa.it/nodo-pagamenti-dev/api/v1/config/refresh/CONFIG
    Then verify the HTTP status code response is 200 