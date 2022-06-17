Feature: Process for activatePaymentNoticeReq

  Background:
    Given systems up
    And initial XML nodoAttivaRPT
      """
      sostituire questi parametri per creare req di nodoAttivaRPT
      identificativoIntermediarioPSP
      identificativoCanale
      password
      codiceContestoPagamento
      identificativoIntermediarioPSPPagamento
      identificativoCanalePagamento
      codificaInfrastrutturaPSP
      codiceIdRPT
      qrc:QrCode
      bc:BarCode
      aim:aim128
      datiPagamentoPSP
      importoSingoloVersamento
      ibanAppoggio
      bicAppoggio
      soggettoVersante
      ibanAddebito
      bicAddebito
      soggettoVersante






      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>40000000001</idPSP>
      <idBrokerPSP>40000000001</idBrokerPSP>
      <idChannel>40000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  #pa old
  Scenario: PRO_APNR_03
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  #pa new
  Scenario: PRO_APNR_04
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoAttivaRPT response
    And check esito contains PPT_MULTI_BENEFICIARIO of nodoAttivaRPT response







