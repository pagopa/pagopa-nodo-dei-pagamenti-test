Feature: process check for activatePaymentNotice - KO 1529


  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
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

@ALL
  Scenario Outline: semantic check on paaAttivaRPTRes
    Given initial XML paaAttivaRPT
      # MODIFICARE IL TIPO DI RISPOSTA (https://pagopa.atlassian.net/wiki/spaces/PAG/pages/493617751/Analisi+paaAttivaRPT)
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
      <soapenv:Header/>
      <soapenv:Body>
      <ws:paaAttivaRPTRisposta>
      <paaAttivaRPTRisposta>
      <esito>OK</esito>
      <datiPagamentoPA>
      <importoSingoloVersamento>2.00</importoSingoloVersamento>
      <ibanAccredito>${iban}</ibanAccredito>
      <bicAccredito>BSCTCH22</bicAccredito>
      <enteBeneficiario>
      <pag:identificativoUnivocoBeneficiario>
      <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
      <pag:codiceIdentificativoUnivoco>${stz}</pag:codiceIdentificativoUnivoco>
      </pag:identificativoUnivocoBeneficiario>
      <pag:denominazioneBeneficiario>${intermPsp}</pag:denominazioneBeneficiario>
      <pag:codiceUnitOperBeneficiario>${can}</pag:codiceUnitOperBeneficiario>
      <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
      <pag:indirizzoBeneficiario>y</pag:indirizzoBeneficiario>
      <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
      <pag:capBeneficiario>gt</pag:capBeneficiario>
      <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
      <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
      <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
      </enteBeneficiario>
      <credenzialiPagatore>i</credenzialiPagatore>
      <causaleVersamento>${causale}</causaleVersamento>
      </datiPagamentoPA>
      </paaAttivaRPTRisposta>
      </ws:paaAttivaRPTRisposta>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And <elem> with <value> in paaAttivaRPT
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_IBAN_NON_CENSITO of activatePaymentNotice response
    Examples:
      | elem          | value                       | soapUI test   |
      | ibanAccredito | IT40R0000000000000000300009 | SEM_PARPTR_01 |