Feature: Semantic checks KO for nodoAttivaRPT
    Background:
        Given systems up
        And initial XML nodoAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoAttivaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#id_broker#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
            <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
            <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
            <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
            <codiceIdRPT><aim:aim128> <aim:CCPost>#ccPoste#</aim:CCPost> <aim:CodStazPA>#cod_segr#</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>#iuv#</aim:CodIUV></aim:aim128></codiceIdRPT>
            <datiPagamentoPSP>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <!--Optional:-->
            <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
            <!--Optional:-->
            <bicAppoggio>CCRTIT5TXXX</bicAppoggio>
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
            <bicAddebito>CCRTIT2TXXX</bicAddebito>
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

  Scenario Outline: Check faultcode error on wrong values
    Given <elem> with <value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is <faultCode> of nodoAttivaRPT response
    Examples:
    | elem                                      |  value                 | faultCode                          | SoapUI   |
    | identificativoPSP                         | pspUnknown             |PPT_PSP_SCONOSCIUTO                 | ARPTSEM1 |
    | identificativoPSP                         | NOT_ENABLED            |PPT_PSP_DISABILITATO                | ARPTSEM2 |
    | identificativoIntermediarioPSP            | brokerPspUnknown       |PPT_INTERMEDIARIO_PSP_SCONOSCIUTO   | ARPTSEM3 |
    | identificativoIntermediarioPSP            | INT_NOT_ENABLED        |PPT_INTERMEDIARIO_PSP_DISABILITATO  | ARPTSEM4 |
    | identificativoCanale                      | channelUnknown         |PPT_CANALE_SCONOSCIUTO              | ARPTSEM5 |
    | identificativoCanale                      | CANALE_NOT_ENABLED     |PPT_CANALE_DISABILITATO             | ARPTSEM6 |
    | password                                  | wrongPassword          |PPT_AUTENTICAZIONE                  | ARPTSEM7 |
    | identificativoIntermediarioPSPPagamento   | brokerPspUnknown       |PPT_INTERMEDIARIO_PSP_SCONOSCIUTO   | ARPTSEM8 |
    | identificativoIntermediarioPSPPagamento   | INT_NOT_ENABLED        |PPT_INTERMEDIARIO_PSP_DISABILITATO  | ARPTSEM9 |
    | identificativoCanalePagamento             | channelUnknown         |PPT_CANALE_SCONOSCIUTO              | ARPTSEM10|
    | identificativoCanalePagamento             | CANALE_NOT_ENABLED     |PPT_CANALE_DISABILITATO             | ARPTSEM11|
    | codificaInfrastrutturaPSP                 | infrastrutturaPSP      |PPT_CODIFICA_PSP_SCONOSCIUTA        | ARPTSEM12|

  Scenario Outline: Check faultcode error on wrong values
    Given <elem> with <value> in nodoAttivaRPT
    And <tag> with <tag_value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is <faultCode> of nodoAttivaRPT response
    Examples:
      | elem         | value | tag        | tag_value           | faultCode     | SoapUI     |
      | aim:AuxDigit | 0     | aim:CodIUV | 12312541281233210   |PPT_SEMANTICA  | ARPTSEM13  |
      | aim:AuxDigit | 2     | aim:CodIUV | 123455412812332     |PPT_SEMANTICA  | ARPTSEM14  |
  
  # codiceIdRPT value check: segregation code check  [ARPTSEM15]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on segregation code not in configuration
    Given aim:AuxDigit with 3 in nodoAttivaRPT
    And aim:CodStazPA with None in nodoAttivaRPT
    And aim:CodIUV with 00017241417113000 in nodoAttivaRPT 
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoAttivaRPT response

  # importoSingoloVersamento KO value check  [ARPTSEM16]
  Scenario: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on importoSingoloVersamento not in configuration
    Given importoSingoloVersamento with 0.00 in nodoAttivaRPT
    And initial XML paaAttivaRPT 
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>KO</esito>
                    <fault>
                      <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                      <faultString>gbyiua</faultString>
                      <id>#creditor_institution_code#</id>
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
    Then check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of nodoAttivaRPT response    

  # identificativoIntermediarioPA value check [ARPTSEM23]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on identificativoIntermediarioPA not in configuration
    Given initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoAttivaRPT>
                <identificativoPSP>40000000001</identificativoPSP>
                <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                <identificativoCanale>40000000001_01</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                <identificativoIntermediarioPSPPagamento>40000000001</identificativoIntermediarioPSPPagamento>
                <identificativoCanalePagamento>40000000001_01</identificativoCanalePagamento>
                <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                <codiceIdRPT><aim:aim128> <aim:CCPost>444444444444</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>018361937127600</aim:CodIUV></aim:aim128></codiceIdRPT>
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
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoAttivaRPT response

  # identificativoStazioneIntermediarioPA value check [ARPTSEM24]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on identificativoStazioneIntermediarioPA not in configuration
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
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT><qrc:QrCode>  <qrc:CF>#creditor_institution_code_old#</qrc:CF> <qrc:CodStazPA>98</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>010551696163500</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            <datiPagamentoPSP>
                <importoSingoloVersamento>10.00</importoSingoloVersamento>
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
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoAttivaRPT response

  # identificativoStazioneIntermediarioPA value check: identificativoStazioneIntermediarioPA disabled [ARPTSEM25]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on identificativoStazioneIntermediarioPA disabled
    Given aim:AuxDigit with 3 in nodoAttivaRPT
    And aim:CodStazPA with None in nodoAttivaRPT
    And aim:CodIUV with 14017241417113000 in nodoAttivaRPT 
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoAttivaRPT response
  
  # identificativoDominio value check: identificativoDominio not in configuration [ARPTSEM26]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on identificativoDominio not in configuration
    Given aim:CCPost with 712377777777 in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoAttivaRPT response
  
  # identificativoDominio value check: identificativoDominio disabled [ARPTSEM27]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on identificativoDominio disabled
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
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT><qrc:QrCode>  <qrc:CF>11111122222</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>011311555197400</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            <datiPagamentoPSP>
                <importoSingoloVersamento>10.00</importoSingoloVersamento>
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
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoAttivaRPT response
    
  # identificativoCanale value check: identificativoCanale not in configuration [ARPTSEM28]
  Scenario: Check PPT_AUTORIZZAZIONE error on identificativoCanale not in psp configuration
    Given identificativoCanale with #canale# in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_AUTORIZZAZIONE of nodoAttivaRPT response


  # Check PPT_SEMANTICA error [ARPTSEM29]
  Scenario: Check PPT_SEMANTICA error on wrong noticeNumber
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
            <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
            <codiceIdRPT><bc:BarCode>  <bc:Gln>9000000000111</bc:Gln>  <bc:AuxDigit>2</bc:AuxDigit>  <bc:CodIUV>123456789012345</bc:CodIUV> </bc:BarCode> </codiceIdRPT>
            <datiPagamentoPSP>
                <importoSingoloVersamento>10.00</importoSingoloVersamento>
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
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response


  # Check PPT_SEMANTICA error [ARPTSEM30]
  Scenario: Check PPT_SEMANTICA error on wrong noticeNumber
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
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT><qrc:QrCode>  <qrc:CF>44444444444</qrc:CF>  <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>018251821137900</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            <datiPagamentoPSP>
                <importoSingoloVersamento>10.00</importoSingoloVersamento>
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
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response