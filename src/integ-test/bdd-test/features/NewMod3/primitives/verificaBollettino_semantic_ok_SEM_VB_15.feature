Feature: Semantic checks for verificaBollettino - OK [SEM_VB_15]

  Background:
    Given systems up

  @runnable
  Scenario: Check ccPost associates with two PA
    Given initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:verificaBollettinoReq>
      <idPSP>#pspPoste#</idPSP>
      <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
      <idChannel>#channelPoste#</idChannel>
      <password>pwdpwdpwd</password>
      <ccPost>#ccPoste#</ccPost>
      <noticeNumber>#notice_number#</noticeNumber>
      </nod:verificaBollettinoReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And initial XML paaVerificaRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                        <importoSingoloVersamento>1.00</importoSingoloVersamento>
                        <ibanAccredito>IT45R0760103200#ccPoste#</ibanAccredito>
                        <bicAccredito>BSCTCH22</bicAccredito>
                        <enteBeneficiario>
                            <pag:identificativoUnivocoBeneficiario>
                                <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
                                <pag:codiceIdentificativoUnivoco>44444444444_05</pag:codiceIdentificativoUnivoco>
                            </pag:identificativoUnivocoBeneficiario>
                            <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
                            <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
                            <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
                            <pag:indirizzoBeneficiario>\"paaVerificaRPT\"</pag:indirizzoBeneficiario>
                            <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
                            <pag:capBeneficiario>jyr</pag:capBeneficiario>
                            <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
                            <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
                            <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
                        </enteBeneficiario>
                        <credenzialiPagatore>of8</credenzialiPagatore>
                        <causaleVersamento>prova/RFDB/019551233153100/TXT/</causaleVersamento>
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
    #And  ccPost associated with two EC  ("INSERT INTO NODO4_CFG.CODIFICHE_PA (CODICE_PA, FK_CODIFICA, FK_PA) VALUES ('#ccPoste#', 1, 6023)")
    When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response

    #Scenario: Delete on DB
    #query = "DELETE FROM CODIFICHE_PA WHERE CODICE_PA = '#ccPoste#' AND FK_CODIFICA = 1 AND FK_PA = 6023"