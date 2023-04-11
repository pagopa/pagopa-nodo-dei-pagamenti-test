Feature: Semantic checks KO for nodoAttivaRPT
    Background:
        Given systems up

@runnable
    Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on identificativoIntermediarioPA not in configuration
    Given initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoAttivaRPT>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
                <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
                <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                <codiceIdRPT><aim:aim128> <aim:CCPost>#ccPoste#</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>018361937127600</aim:CodIUV></aim:aim128></codiceIdRPT>
                <datiPagamentoPSP>
                    <importoSingoloVersamento>4.00</importoSingoloVersamento>
                    <!--Optional:-->
                    <ibanAppoggio>IT96R0123459921000000012345</ibanAppoggio>
                    <!--Optional:-->
                    <bicAppoggio>CCRMAT5TXYY</bicAppoggio>
                    <!--Optional:-->
                    <soggettoVersante>
                      <pag:identificativoUnivocoVersante>
                          <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
                          <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
                      </pag:identificativoUnivocoVersante>
                      <pag:anagraficaVersante>Franco Rossi</pag:anagraficaVersante>
                      <!--Optional:-->
                      <pag:indirizzoVersante>viale Monza</pag:indirizzoVersante>
                      <!--Optional:-->
                      <pag:civicoVersante>1</pag:civicoVersante>
                      <!--Optional:-->
                      <pag:capVersante>20125</pag:capVersante>
                      <!--Optional:-->
                      <pag:localitaVersante>Milano</pag:localitaVersante>
                      <!--Optional:-->
                      <pag:provinciaVersante>MI</pag:provinciaVersante>
                      <!--Optional:-->
                      <pag:nazioneVersante>IT</pag:nazioneVersante>
                      <!--Optional:-->
                      <pag:e-mailVersante>mail@mail.it</pag:e-mailVersante>
                    </soggettoVersante>
                    <!--Optional:-->
                    <ibanAddebito>IT96R0123454321000000012346</ibanAddebito>
                    <!--Optional:-->
                    <bicAddebito>PARTIT2TRRX</bicAddebito>
                    <!--Optional:-->
                    <soggettoPagatore>
                      <pag:identificativoUnivocoPagatore>
                          <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
                          <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
                      </pag:identificativoUnivocoPagatore>
                      <pag:anagraficaPagatore>Franco Rossi</pag:anagraficaPagatore>
                      <!--Optional:-->
                      <pag:indirizzoPagatore>viale Monza</pag:indirizzoPagatore>
                      <!--Optional:-->
                      <pag:civicoPagatore>1</pag:civicoPagatore>
                      <!--Optional:-->
                      <pag:capPagatore>20125</pag:capPagatore>
                      <!--Optional:-->
                      <pag:localitaPagatore>Milano</pag:localitaPagatore>
                      <!--Optional:-->
                      <pag:provinciaPagatore>MI</pag:provinciaPagatore>
                      <!--Optional:-->
                      <pag:nazionePagatore>IT</pag:nazionePagatore>
                      <!--Optional:-->
                      <pag:e-mailPagatore>mail@mail.it</pag:e-mailPagatore>
                    </soggettoPagatore>
                </datiPagamentoPSP>
              </ws:nodoAttivaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """
    And initial XML paaAttivaRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>KO</esito>
                    <irraggiungibile/>
                    <fault>
                        <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                        <faultString>gbyiua</faultString>
                        <id>#creditor_institution_code_old#</id>
                        <description>dfstf</description>
                        <serial>1</serial>
                    </fault>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoAttivaRPT response