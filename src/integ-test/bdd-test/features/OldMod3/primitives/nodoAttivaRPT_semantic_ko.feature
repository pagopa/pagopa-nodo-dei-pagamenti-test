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
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT><bc:BarCode><bc:Gln>1234567890122</bc:Gln><bc:CodStazPA>01</bc:CodStazPA><bc:AuxDigit>0</bc:AuxDigit><bc:CodIUV>112222222222222</bc:CodIUV></bc:BarCode></codiceIdRPT>
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
  # identificativoPSP value check: identificativoPSP not in configuration [ARPTSEM1]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given identificativoPSP with pspUnknown in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_PSP_SCONOSCIUTO of nodoAttivaRPT response

  # identificativoPSP value check: identificativoPSP disabled [ARPTSEM2]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled
    Given identificativoPSP with NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_PSP_DISABILITATO of nodoAttivaRPT response

  # identificativoIntermediarioPSP value check: identificativoIntermediarioPSP not in configuration [ARPTSEM3]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp
    Given identificativoIntermediarioPSP with brokerPspUnknown in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of nodoAttivaRPT response 

  # identificativoIntermediarioPSP value check: identificativoIntermediarioPSP disabled [ARPTSEM4]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given identificativoIntermediarioPSP with INT_NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of nodoAttivaRPT response

  # identificativoCanale value check: identificativoCanale not in configuration [ARPTSEM5]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given identificativoCanale with channelUnknown in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CANALE_SCONOSCIUTO of nodoAttivaRPT response

  # identificativoCanale value check: identificativoCanale disabled [ARPTSEM6]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp channel
    Given identificativoCanale with CANALE_NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CANALE_DISABILITATO of nodoAttivaRPT response

  # password value check: wrong password [ARPTSEM7]
  Scenario: Check PPT_AUTENTICAZIONE error on wrong password
    Given password with wrongPassword in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_AUTENTICAZIONE of nodoAttivaRPT response

 # identificativoIntermediarioPSPPagamento value check: identificativoIntermediarioPSPPagamento not in configuration [ARPTSEM8]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp
    Given identificativoIntermediarioPSPPagamento with brokerPspUnknown in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of nodoAttivaRPT response 

  # identificativoIntermediarioPSPPagamento value check: identificativoIntermediarioPSPPagamento disabled [ARPTSEM9]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given identificativoIntermediarioPSPPagamento with INT_NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of nodoAttivaRPT response

  # identificativoCanalePagamento value check: identificativoCanalePagamento not in configuration [ARPTSEM10]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given identificativoCanalePagamento with channelUnknown in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CANALE_SCONOSCIUTO of nodoAttivaRPT response

  # identificativoCanalePagamento value check: identificativoCanalePagamento disabled [ARPTSEM11]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp channel
    Given identificativoCanalePagamento with CANALE_NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CANALE_DISABILITATO of nodoAttivaRPT response

   # identificativoCanalePagamento value check: identificativoCanalePagamento disabled [ARPTSEM12]
  Scenario: Check PPT_CODIFICA_PSP_SCONOSCIUTA error on wrong codificaInfrastrutturaPSP
    Given codificaInfrastrutturaPSP with infrastrutturaPSP in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CODIFICA_PSP_SCONOSCIUTA of nodoAttivaRPT response
