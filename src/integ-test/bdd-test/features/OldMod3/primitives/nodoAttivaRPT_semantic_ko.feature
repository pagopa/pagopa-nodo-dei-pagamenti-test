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

  # codificaInfrastrutturaPSP value check: codificaInfrastrutturaPSP not in configuration [ARPTSEM12]
  Scenario: Check PPT_CODIFICA_PSP_SCONOSCIUTA error on wrong codificaInfrastrutturaPSP
    Given codificaInfrastrutturaPSP with infrastrutturaPSP in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CODIFICA_PSP_SCONOSCIUTA of nodoAttivaRPT response


####################### 14/09/2022 #######################

  # # IUV value check: IUV dimension check  [ARPTSEM13]
  # Scenario: Check PPT_SEMANTICA error on wrong IUV dimension
  #   Given bc:AuxDigit with 0 in nodoAttivaRPT
  #   And bc:CodIUV with abeft54bd8opr321 in nodoAttivaRPT 
  #   When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
  #   Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response

  # # IUV value check: IUV dimension check  [ARPTSEM14]
  # Scenario: Check PPT_SEMANTICA error on wrong IUV dimension
  #   Given bc:AuxDigit with 2 in nodoAttivaRPT
  #   And bc:CodIUV with abeft54bd8opr32114 in nodoAttivaRPT 
  #   When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
  #   Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response


  # IUV value check: IUV dimension check 
  Scenario Outline: Check PPT_SEMANTICA error on wrong IUV dimension
    Given <elem> with <value> in nodoAttivaRPT
    And <tag> with <tag_value> in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response
    Examples:
      | elem         | value | tag        | tag_value          | SoapUI     |
      | aim:AuxDigit | 0     | aim:CodIUV | abeft54bd8opr321   | ARPTSEM13  |
      | aim:AuxDigit | 2     | aim:CodIUV | abeft54bd8opr32114 | ARPTSEM14  |
  
  # codiceIdRPT value check: segregation code check  [ARPTSEM15]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on segregation code not in configuration
    Given aim:AuxDigit with 3 in nodoAttivaRPT
    And aim:CodIUV with 00 in nodoAttivaRPT 
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoAttivaRPT response

  # importoSingoloVersamento KO value check  [ARPTSEM16]
  Scenario: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on importoSingoloVersamento not in configuration
    Given importoSingoloVersamento with 0.00 in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of nodoAttivaRPT response    

  # identificativoStazioneIntermediarioPA value check [ARPTSEM24]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on identificativoStazioneIntermediarioPA not in configuration
    Given aim:AuxDigit with 1 in nodoAttivaRPT
    And aim:CodIUV with abeft54bd8opr3210 in nodoAttivaRPT
    And identificativoStazioneIntermediarioPA with 34 in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoAttivaRPT response

  # identificativoStazioneIntermediarioPA value check: identificativoStazioneIntermediarioPA disabled [ARPTSEM25]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on identificativoStazioneIntermediarioPA disabled
    Given identificativoStazioneIntermediarioPA with NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoAttivaRPT response
  
  # identificativoDominio value check: identificativoDominio not in configuration [ARPTSEM26]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on identificativoDominio not in configuration
    Given identificativoDominio with NULL in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoAttivaRPT response
  
  # identificativoDominio value check: identificativoDominio disabled [ARPTSEM27]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on identificativoDominio disabled
    Given identificativoDominio with NOT_ENABLED in nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoAttivaRPT response
    
  # identificativoCanale value check: identificativoCanale not in configuration [ARPTSEM28]
  Scenario: Check PPT_AUTORIZZAZIONE error on identificativoCanale not in psp configuration
    Given identificativoCanale with canale3 nodoAttivaRPT
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
    Then check faultCode is PPT_AUTORIZZAZIONE of nodoAttivaRPT response
  
  Scenario Outline: Check PPT_SEMANTICA error 
    Given <elem> with <value> in nodoAttivaRPT
    And <tag> with <tag_value> in nodoAttivaRPT 
    And <tag1> with <tag_value1> in nodoAttivaRPT 
    When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_SEMANTICA of nodoAttivaRPT response
    Examples:
      | elem        | value             | tag         | tag_value   | tag1           | tag_value1             | SoapUI    |
      | bc:Gln      | 9000000000111     | bc:AuxDigit | 2           | bc:CodIUV      | 123456789012345        | ARPTSEM29 |
      | bc:Gln      | 9000000000111     | bc:AuxDigit | 0           | bc:CodStazPA   | None                   | ARPTSEM30 |
