Feature: process check for activatePaymentNotice - KO

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>4000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC old version

  Scenario Outline: semantic check on paaAttivaRPTRes
    Given initial XML paaAttivaRPT
      # MODIFICARE IL TIPO DI RISPOSTA (https://pagopa.atlassian.net/wiki/spaces/PAG/pages/493617751/Analisi+paaAttivaRPT)
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:paaAttivaRPTRisposta>
      <esito>OK</esito>
      <datiPagamento>
      <importoSingoloVersamento>importo_singolo_versamento</importoSingoloVersamento>
      <ibanAccredito>iban_accredito</ibanAccredito>
      <bicAccredito>bic_accredito</bicAccredito>
      <enteBeneficiario>ente_beneficiario</enteBeneficiario>
      <credenzialiPagatore>credenziali_pagatore</credenzialiPagatore>
      <causaleVersamento>causale_versamento</causaleVersamento>
      <spezzoniCausaleVersamento>
      <spezzoneCausaleVersamento>spezzone_causale_versamento</spezzoneCausaleVersamento>
      <spezzoneStrutturaCausaleVersamento>
      <causaleSpezzone>causale_spezzone</causaleSpezzone>
      <importoSpezzone>importo_spezzone</importoSpezzone>
      </spezzoneStrutturaCausaleVersamento>
      </spezzoniCausaleVersamento>
      </datiPagamento>
      </nod:paaAttivaRPTRisposta>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And <elem> with <value> in paaAttivaRPT
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_IBAN_NON_CENSITO of activatePaymentNotice response
    Examples:
      | elem          | value   | soapUI test   |
      | ibanAccredito | Unknown | SEM_PARPTR_01 |