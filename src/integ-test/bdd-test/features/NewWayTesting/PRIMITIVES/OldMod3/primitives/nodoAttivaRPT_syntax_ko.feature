Feature: Syntax checks KO for nodoAttivaRPT 1409
    Background:
        Given systems up
        And initial XML nodoAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoAttivaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
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

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given <attribute> set <value> for <elem> in nodoAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | ARPTSIN1    |
            | soapenv:Body     | xmlns:ws      | <wss:></wss>                              | ARPTSIN2    |

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given <elem> with <value> in nodoAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | elem         | value | soapUI test |
            | soapenv:Body | None  | ARPTSIN3    |
            | soapenv:Body | Empty | ARPTSIN4    |

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD on invalid body element value
        Given <elem> with <value> in nodoAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | elem                                    | value                                                                   | soapUI test |
            | ws:nodoAttivaRPT                        | None                                                                    | ARPTSIN5    |
            | identificativoPSP                       | None                                                                    | ARPTSIN6    |
            | identificativoIntermediarioPSP          | None                                                                    | ARPTSIN9    |
            | identificativoCanale                    | None                                                                    | ARPTSIN12   |
            | identificativoCanale                    | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN14   |
            | password                                | None                                                                    | ARPTSIN15   |
            | codiceContestoPagamento                 | None                                                                    | ARPTSIN19   |
            | identificativoIntermediarioPSPPagamento | None                                                                    | ARPTSIN22   |
            | identificativoIntermediarioPSPPagamento | Empty                                                                   | ARPTSIN23   |
            | identificativoIntermediarioPSPPagamento | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN24   |
            | identificativoCanalePagamento           | None                                                                    | ARPTSIN25   |
            | identificativoCanalePagamento           | Empty                                                                   | ARPTSIN26   |
            | identificativoCanalePagamento           | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN27   | 
            | codificaInfrastrutturaPSP               | None                                                                    | ARPTSIN28   |
            | codiceIdRPT                             | None                                                                    | ARPTSIN30   |
            | codiceIdRPT                             | Empty                                                                   | ARPTSIN31   |
            | datiPagamentoPSP                        | None                                                                    | ARPTSIN32   |
            | datiPagamentoPSP                        | RemoveParent                                                            | ARPTSIN33   |
            | importoSingoloVersamento                | None                                                                    | ARPTSIN34   |
            | importoSingoloVersamento                | Empty                                                                   | ARPTSIN35   |
            | importoSingoloVersamento                | 10,25                                                                   | ARPTSIN40   |
            | soggettoVersante                        | Empty                                                                   | ARPTSIN48   |
            | soggettoVersante                        | RemoveParent                                                            | ARPTSIN49   |
            | pag:identificativoUnivocoVersante       | None                                                                    | ARPTSIN50   |
            | pag:identificativoUnivocoVersante       | RemoveParent                                                            | ARPTSIN51   |
            | pag:tipoIdentificativoUnivoco           | None                                                                    | ARPTSIN52   |
            | pag:tipoIdentificativoUnivoco           | Empty                                                                   | ARPTSIN53   |
            | pag:tipoIdentificativoUnivoco           | PP                                                                      | ARPTSIN54   |
            | pag:tipoIdentificativoUnivoco           | A                                                                       | ARPTSIN55   |
            | pag:codiceIdentificativoUnivoco         | None                                                                    | ARPTSIN56   |
            | pag:anagraficaVersante                  | None                                                                    | ARPTSIN59   |
            | soggettoPagatore                        | Empty                                                                   | ARPTSIN83   |
            | soggettoPagatore                        | RemoveParent                                                            | ARPTSIN84   |
            | pag:identificativoUnivocoPagatore       | RemoveParent                                                            | ARPTSIN85   |
            | pag:tipoIdentificativoUnivoco           | None                                                                    | ARPTSIN86   |
            | pag:tipoIdentificativoUnivoco           | Empty                                                                   | ARPTSIN87   |
            | pag:tipoIdentificativoUnivoco           | FF                                                                      | ARPTSIN88   |
            | pag:tipoIdentificativoUnivoco           | H                                                                       | ARPTSIN89   |
            | pag:codiceIdentificativoUnivoco         | None                                                                    | ARPTSIN90   |
            | pag:anagraficaPagatore                  | None                                                                    | ARPTSIN93   |
            | codiceContestoPagamento                 | Empty                                                                   | ARPTSIN20   |
            | codiceContestoPagamento                 | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN21   |
            | importoSingoloVersamento                | 22                                                                      | ARPTSIN36   |
            | importoSingoloVersamento                | 1999999999.99                                                           | ARPTSIN38   |
            | importoSingoloVersamento                | 10.251                                                                  | ARPTSIN39   |
            | ibanAppoggio                            | Empty                                                                   | ARPTSIN41   |
            | ibanAppoggio                            | IT96R01234543210000000123456IT96R01                                     | ARPTSIN42   |
            | bicAppoggio                             | Empty                                                                   | ARPTSIN44   |
            | bicAppoggio                             | CCRTIT                                                                  | ARPTSIN45   |
            | bicAppoggio                             | CCRTIT2TXXXX                                                            | ARPTSIN46   |
            | bicAppoggio                             | U2CRITMM                                                                | ARPTSIN47   |
            | pag:codiceIdentificativoUnivoco         | Empty                                                                   | ARPTSIN57   |
            | pag:codiceIdentificativoUnivoco         | RSSFNC50S01L781HARSSFNC50S01L781HARSSFNC50S01L781HARSSFNC50S01L781HA    | ARPTSIN58   |
            | pag:anagraficaVersante                  | Empty                                                                   | ARPTSIN60   |
            | pag:anagraficaVersante                  | RSSFNC50S01L781HARSSFNC50S01L781HARSSFNC50S01L781HARSSFNC50S01L781HAasd | ARPTSIN61   |
            | pag:indirizzoVersante                   | Empty                                                                   | ARPTSIN62   |
            | pag:indirizzoVersante                   | RSSFNC50S01L781HARSSFNC50S01L781HARSSFNC50S01L781HARSSFNC50S01L781HAasd | ARPTSIN63   |
            | pag:civicoVersante                      | Empty                                                                   | ARPTSIN64   |
            | pag:civicoVersante                      | Sono17CaratteAlfa                                                       | ARPTSIN65   |
            | pag:capVersante                         | Empty                                                                   | ARPTSIN66   |
            | pag:capVersante                         | Sono17CaratteAlfa                                                       | ARPTSIN67   |
            | pag:localitaVersante                    | Empty                                                                   | ARPTSIN68   |
            | pag:localitaVersante                    | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN69   |
            | pag:provinciaVersante                   | Empty                                                                   | ARPTSIN70   |
            | pag:provinciaVersante                   | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN71   |
            | pag:nazioneVersante                     | Empty                                                                   | ARPTSIN72   |
            | pag:nazioneVersante                     | ITT                                                                     | ARPTSIN73   |
            | pag:e-mailVersante                      | Empty                                                                   | ARPTSIN74   |
            | pag:e-mailVersante                      | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail@mail.it  | ARPTSIN75   |
            | ibanAddebito                            | Empty                                                                   | ARPTSIN76   |
            | ibanAddebito                            | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN77   |
            | ibanAddebito                            | X596R0123454321000000012345                                             | ARPTSIN78   |
            | bicAddebito                             | Empty                                                                   | ARPTSIN79   |
            | bicAddebito                             | CCRTIT                                                                  | ARPTSIN80   |
            | bicAddebito                             | CCRTIT2TXXXX                                                            | ARPTSIN81   |
            | bicAddebito                             | U2CRITMM                                                                | ARPTSIN82 - oggi   | 
            | pag:codiceIdentificativoUnivoco         | Empty                                                                   | ARPTSIN91   |
            | pag:codiceIdentificativoUnivoco         | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN92   |
            | pag:anagraficaPagatore                  | Empty                                                                   | ARPTSIN94   |
            | pag:anagraficaPagatore                  | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345 | ARPTSIN95   |
            | pag:indirizzoPagatore                   | Empty                                                                   | ARPTSIN96   |
            | pag:indirizzoPagatore                   | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345 | ARPTSIN97   |
            | pag:civicoPagatore                      | Empty                                                                   | ARPTSIN98   |
            | pag:civicoPagatore                      | Sono17CaratteAlfa                                                       | ARPTSIN99   |
            | pag:capPagatore                         | Empty                                                                   | ARPTSIN100  |
            | pag:capPagatore                         | Sono17CaratteAlfa                                                       | ARPTSIN101  |
            | pag:localitaPagatore                    | Empty                                                                   | ARPTSIN102  |
            | pag:localitaPagatore                    | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN103  |
            | pag:provinciaPagatore                   | Empty                                                                   | ARPTSIN104  |
            | pag:provinciaPagatore                   | QuestiSono36CaratteriAlfaNumericiTT1                                    | ARPTSIN105  |
            | pag:nazionePagatore                     | Empty                                                                   | ARPTSIN106  |
            | pag:nazionePagatore                     | ITT                                                                     | ARPTSIN107  |
            | pag:e-mailPagatore                      | Empty                                                                   | ARPTSIN108  |
            | pag:e-mailPagatore                      | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail@mail.it | ARPTSIN109  |

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_XSD on invalid body element value
        Given <tag> with <value> in nodoAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoAttivaRPT response
        Examples:
        | tag                    | value                    | SoapUI Test |
        | bc:AuxDigit            | Empty                    | ARPTSIN110  |
        | bc:AuxDigit            | 8                        | ARPTSIN112  |
        | bc:CodIUV              | Empty                    | ARPTSIN113  |
        | bc:CodIUV              | Sono16CaratteAlf         | ARPTSIN114  |
        | bc:CodStazPA           | Empty                    | ARPTSIN115  |

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD on invalid body element value
        Given <tag> with <value> in nodoAttivaRPT
        When psp sends soap nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | tag               | value                                | soapUI test |
            | identificativoPSP | Empty                                | ARPTSIN7    |
            | identificativoPSP | QuestiSono36CaratteriAlfaNumericiTT1 | ARPTSIN8    |

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD on invalid body element value
        Given <tag> with <value> in nodoAttivaRPT
        When psp sends soap nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
        Examples:
            | tag                            | value                                | soapUI test |
            | identificativoIntermediarioPSP | Empty                                | ARPTSIN10   |
            | identificativoIntermediarioPSP | QuestiSono36CaratteriAlfaNumericiTT1 | ARPTSIN11   |

@runnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD on invalid body element value
        Given <tag> with <value> in nodoAttivaRPT
        When psp sends soap nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response
            Examples:
                | tag      | value            | soapUI test |
                | password | Empty            | ARPTSIN16   |
                | password | Alpha_7          | ARPTSIN17   |
                | password | Alpha_16_Num_123 | ARPTSIN18   |

@runnable
    Scenario: Check faultCode PPT_SINTASSI_EXTRAXSD on invalid body element value [ARPTSIN13]
        Given identificativoCanale with Empty in nodoAttivaRPT
        When psp sends soap nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable
    Scenario: Check faultCode PPT_AUTORIZZAZIONE error on invalid body element value [ARPTSIN29]
         Given codificaInfrastrutturaPSP with empty in nodoAttivaRPT
         When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
         Then check faultCode is PPT_CODIFICA_PSP_SCONOSCIUTA of nodoAttivaRPT response
