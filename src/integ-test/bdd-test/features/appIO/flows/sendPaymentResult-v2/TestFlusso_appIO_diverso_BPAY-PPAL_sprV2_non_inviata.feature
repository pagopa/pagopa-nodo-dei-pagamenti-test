Feature:  flow check for sendPaymentResult-v2 request - pagamento con appIO diverso da BPAY e PPAL, spr-v2 non inviata [T_SPR_V2_01]
 
  Background:
    Given systems up 
    And EC new version
    
    # verifyPaymentNotice phase
    Scenario: Execute verifyPaymentNotice request
    Given initial xml verifyPaymentNotice
    
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:verifyPaymentNoticeReq>
             <idPSP>AGID_01</idPSP>
             <idBrokerPSP>97735020584</idBrokerPSP>
             <idChannel>97735020584_03</idChannel>
             <password>pwdpwdpwd</password>
             <qrCode>
                <fiscalCode>#creditor_institution_code#</fiscalCode>
                <noticeNumber>#notice_number#</noticeNumber>
             </qrCode>
          </nod:verifyPaymentNoticeReq>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
    
   # activateIOPaymentReq phase
    Scenario: Execute activateIOPayment request
    Given initial XML activateIOPayment soap-request
	
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:activateIOPaymentReq>
             <idPSP>AGID_01</idPSP>
             <idBrokerPSP>97735020584</idBrokerPSP>
             <idChannel>97735020584_03</idChannel>
             <password>pwdpwdpwd</password>
             <!--Optional:-->
             <idempotencyKey>#idempotency_key#</idempotencyKey>
             <qrCode>
                <fiscalCode>#creditor_institution_code#</fiscalCode>
                <noticeNumber>#notice_number#</noticeNumber>
             </qrCode>
             <!--Optional:-->
             <expirationTime>60000</expirationTime>
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
                <fullName>IOname_#idempotency_key#</fullName>
                <!--Optional:-->
                <streetName>IOstreet</streetName>
                <!--Optional:-->
                <civicNumber>IOcivic</civicNumber>
                <!--Optional:-->
                <postalCode>IOcode</postalCode>
                <!--Optional:-->
                <city>IOcity</city>
                <!--Optional:-->
                <stateProvinceRegion>IOstate</stateProvinceRegion>
                <!--Optional:-->
                <country>IT</country>
                <!--Optional:-->
                <e-mail>IO.test.prova@gmail.com</e-mail>
             </payer>
          </nod:activateIOPaymentReq>
       </soapenv:Body>
    </soapenv:Envelope>
    """
        
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    
    # DB check_00
    # SELECT * FROM NODO_ONLINE.POSITION_ACTIVATE s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
    # check POSITION_ACTIVATE.PAYMENT_TOKEN == $activateIOPaymentResponse.paymentToken and
    #       POSITION_ACTIVATE.PSP_ID == $activateIOPaymentRequest.idPSP
    
    # nodoChiediInformazioniPagamento phase
    Scenario: Execute a nodoChiediInformazioniPagamento request
    Given initial json nodoChiediInformazioniPagamento
    """
        {"idPagamento": "$activateIOPaymentResponse.paymentToken"}
    """
    When PM sends nodoChiediInformazioniPagamento to nodo-dei-pagamenti
    Then check errorCode is 200
    
    
    # closePayment-v2 phase  
    Scenario: Execute a closePayment-v2 request
    Given idChannel with CANALI_NODO.VERSIONE_PRIMITIVE = 1
    And initial json closePayment-v2
    """   
    {"paymentTokens": [
        "$activateIOPaymentNoticeResponse.paymentToken"
        ],
    "outcome": "OK",
    "idPSP": "#psp#",
    "idBrokerPSP": "60000000001",
    "idChannel": "60000000001_03",
    "paymentMethod": "TPAY",
    "transactionId": "19392562",
    "totalAmount": 12.00,
    "fee": 2.00,
    "timestampOperation": "2033-04-23T18:25:43Z",
    "additionalPaymentInformations": {
          "key": "10793459"
        }
    }
    """

    When PM sends closePayment-v2 to nodo-dei-pagamenti
    Then check outcome is OK of closePayment-v2
    And check errorCode is 200 of closePayment-v2
    And check no sendPaymentResult-v2 is sent
    
    # SELECT ID FROM RE WHERE NOTICE_ID = '#notice_number#' AND TIPO_EVENTO = 'sendPaymentResult-v2';
    # assert RE.ID = None;
    
    
    # SELECT s.* FROM NODO_ONLINE.POSITION_PAYMENT_STATUS s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#' order by s.ID asc;
    # SELECT s.* FROM NODO_ONLINE.POSITION_PAYMENT_STATUS_SNAPSHOT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
    # SELECT s.* FROM NODO_ONLINE.POSITION_STATUS s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
    # SELECT s.* FROM NODO_ONLINE.POSITION_STATUS_SNAPSHOT s where s.NOTICE_ID = '#notice_number#' and s.PA_FISCAL_CODE= '#creditor_institution_code#';
    
    #POSITION_PAYMENT_STATUS
    # ID != null
    # PA_FISCAL_CODE == '#creditor_institution_code#'
    # NOTICE_ID == '#notice_number#'
    # STATUS == 'PAYING'
    # INSERTED_TIMESTAMP != null
    # CREDITOR_REFERENCE_ID == #iuv#
    # PAYMENT_TOKEN == #ccp#

    # STATUS1 == 'PAYMENT_RESERVED'
    # STATUS2 == 'PAYMENT_SENT'
    # STATUS3 == 'PAYMENT_ACCEPTED'
    
    #POSITION_PAYMENT_STATUS_SNAPSHOT
    # ID != null
    # PA_FISCAL_CODE == '#creditor_institution_code#'
    # NOTICE_ID == '#notice_number#'
    # CREDITOR_REFERENCE_ID == #iuv#
    # PAYMENT_TOKEN == #ccp#
    # STATUS == 'PAYMENT_ACCEPTED'
    # INSERTED_TIMESTAMP != null
    # UPDATED_TIMESTAMP != null
    # FK_POSITION_PAYMENT == POSITION_PAYMENT.id

    # ID1 == null
    
    #POSITION_STATUS
    # ID != null
    # PA_FISCAL_CODE == '#creditor_institution_code#'
    # NOTICE_ID == '#notice_number#'
    # STATUS2 == 'PAYING'
    # INSERTED_TIMESTAMP != null

    # ID1 == null
    
    #POSITION_STATUS_SNAPSHOT
    # ID != null
    # PA_FISCAL_CODE == '#creditor_institution_code#'
    # NOTICE_ID == '#notice_number#'
    # STATUS == 'PAYING'
    # INSERTED_TIMESTAMP != null
    # UPDATED_TIMESTAPM != null
    # FK_POSITION_SERVICE == POSITION_SERVICE.id

    # id1 == null
    