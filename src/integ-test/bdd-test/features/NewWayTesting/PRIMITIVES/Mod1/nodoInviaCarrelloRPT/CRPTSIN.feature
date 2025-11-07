Feature: process tests for nodoInviaCarrelloRPT[CRPTSIN] 327
    Background:
        Given systems up
    #     And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02

    # Scenario: RPT generation
    #     Given RPT generation
    #         """
    #         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
    #         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
    #         <pay_i:dominio>
    #         <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
    #         <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
    #         </pay_i:dominio>
    #         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
    #         <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
    #         <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
    #         <pay_i:soggettoVersante>
    #         <pay_i:identificativoUnivocoVersante>
    #         <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
    #         <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
    #         </pay_i:identificativoUnivocoVersante>
    #         <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
    #         <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
    #         <pay_i:civicoVersante>11</pay_i:civicoVersante>
    #         <pay_i:capVersante>00186</pay_i:capVersante>
    #         <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
    #         <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
    #         <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
    #         <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
    #         </pay_i:soggettoVersante>
    #         <pay_i:soggettoPagatore>
    #         <pay_i:identificativoUnivocoPagatore>
    #         <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
    #         <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
    #         </pay_i:identificativoUnivocoPagatore>
    #         <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
    #         <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
    #         <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
    #         <pay_i:capPagatore>00186</pay_i:capPagatore>
    #         <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
    #         <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
    #         <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
    #         <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
    #         </pay_i:soggettoPagatore>
    #         <pay_i:enteBeneficiario>
    #         <pay_i:identificativoUnivocoBeneficiario>
    #         <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
    #         <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
    #         </pay_i:identificativoUnivocoBeneficiario>
    #         <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
    #         <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
    #         <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
    #         <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
    #         <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
    #         <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
    #         <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
    #         <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
    #         <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
    #         </pay_i:enteBeneficiario>
    #         <pay_i:datiVersamento>
    #         <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
    #         <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
    #         <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
    #         <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
    #         <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
    #         <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
    #         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
    #         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
    #         <pay_i:datiSingoloVersamento>
    #         <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
    #         <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
    #         <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
    #         <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
    #         <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
    #         <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
    #         <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
    #         <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
    #         <pay_i:datiSpecificiRiscossione>0/abc</pay_i:datiSpecificiRiscossione>
    #         </pay_i:datiSingoloVersamento>
    #         </pay_i:datiVersamento>
    #         </pay_i:RPT>
    #         """


    # @ALL @PRIMITIVE @MOD1 @test1
    # #CRPTSINSunnyDay
    # Scenario: (phase SunnyDay) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_1
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSINSunnyDay
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    # @ALL @PRIMITIVE @MOD1 @test2
    # Scenario Outline: (phase 1) Execute nodoInviaCarrelloRPT request - CRPTSIN1
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And <attribute> set <value> for <elem> in nodoInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check faultCode is <error> of nodoInviaCarrelloRPT response
    #     Examples:
    #         | elem             | attribute     | value                                     | error                 | soapUI test |
    #         | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | PPT_SINTASSI_EXTRAXSD | CRPTSIN1    |


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_2
    Scenario Outline: process tests for nodoInviaCarrelloRPT - CRPTSIN1
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And <attribute> set <value> for <elem> in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoInviaCarrelloRPT response
        Examples:
            | elem             | attribute     | value                                     | error                 | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | PPT_SINTASSI_EXTRAXSD | CRPTSIN1    |



    # @ALL @PRIMITIVE @MOD1 @test3
    # #CRPTSIN3
    # Scenario: (phase 2) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:PPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:PPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_3
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN3
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_malformed initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    # @ALL @PRIMITIVE @MOD1 @test4
    # #CRPTSIN4
    # Scenario: (phase 3) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_4
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN3
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_2intestazioneCarrello initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response



    # @ALL @PRIMITIVE @MOD1 @test5
    # Scenario Outline: (phase 4) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         <requireLightPayment></requireLightPayment>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And <tag> with <tagvalue> in nodoInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check faultCode is <error> of nodoInviaCarrelloRPT response
    #     Examples:
    #         | tag                                   | tagvalue                             | error                 | soapUI test |
    #         | identificativoIntermediarioPA         | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN5    |
    #         | identificativoIntermediarioPA         | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN6    |
    #         | identificativoIntermediarioPA         | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN7    |
    #         | identificativoStazioneIntermediarioPA | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN8    |
    #         | identificativoStazioneIntermediarioPA | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN9    |
    #         | identificativoStazioneIntermediarioPA | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN10   |
    #         | identificativoCarrello                | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN11   |
    #         | identificativoCarrello                | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN12   |
    #         | identificativoCarrello                | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN13   |
    #         | soapenv:Body                          | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN14   |
    #         | soapenv:Body                          | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN15   |
    #         | ws:nodoInviaCarrelloRPT               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN16   |
    #         | password                              | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN17   |
    #         | password                              | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN18   |
    #         | password                              | passwor                              | PPT_SINTASSI_EXTRAXSD | CRPTSIN19   |
    #         | password                              | passworpasswordd                     | PPT_SINTASSI_EXTRAXSD | CRPTSIN20   |
    #         | identificativoPSP                     | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN21   |
    #         | identificativoPSP                     | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN22   |
    #         | identificativoPSP                     | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN23   |
    #         | identificativoIntermediarioPSP        | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN24   |
    #         | identificativoIntermediarioPSP        | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN24.1 |
    #         | identificativoIntermediarioPSP        | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN25   |
    #         | identificativoCanale                  | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN26   |
    #         | identificativoCanale                  | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN26.1 |
    #         | identificativoCanale                  | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN27   |
    #         | listaRPT                              | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN28   |
    #         | listaRPT                              | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN29   |
    #         | listaRPT                              | RemoveParent                         | PPT_SINTASSI_EXTRAXSD | CRPTSIN29.1 |
    #         | identificativoDominio                 | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN30   |
    #         | identificativoDominio                 | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN31   |
    #         | identificativoDominio                 | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN32   |
    #         | identificativoUnivocoVersamento       | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN33   |
    #         | identificativoUnivocoVersamento       | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN34   |
    #         | identificativoUnivocoVersamento       | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN35   |
    #         | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN36   |
    #         | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN37   |
    #         | codiceContestoPagamento               | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN38   |
    #         | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN41   |
    #         | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN42   |
    #         | requireLightPayment                   | 4                                    | PPT_SINTASSI_EXTRAXSD | CRPTSIN47   |


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_5
    Scenario Outline: process tests for nodoInviaCarrelloRPT
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_full initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
            | requireLightPayment                   |                                 |
        And <tag> with <tagvalue> in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoInviaCarrelloRPT response
        Examples:
            | tag                                   | tagvalue                             | error                 | soapUI test |
            | identificativoIntermediarioPA         | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN5    |
            | identificativoIntermediarioPA         | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN6    |
            | identificativoIntermediarioPA         | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN7    |
            | identificativoStazioneIntermediarioPA | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN8    |
            | identificativoStazioneIntermediarioPA | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN9    |
            | identificativoStazioneIntermediarioPA | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN10   |
            | identificativoCarrello                | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN11   |
            | identificativoCarrello                | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN12   |
            | identificativoCarrello                | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN13   |
            | soapenv:Body                          | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN14   |
            | soapenv:Body                          | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN15   |
            | ws:nodoInviaCarrelloRPT               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN16   |
            | password                              | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN17   |
            | password                              | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN18   |
            | password                              | passwor                              | PPT_SINTASSI_EXTRAXSD | CRPTSIN19   |
            | password                              | passworpasswordd                     | PPT_SINTASSI_EXTRAXSD | CRPTSIN20   |
            | identificativoPSP                     | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN21   |
            | identificativoPSP                     | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN22   |
            | identificativoPSP                     | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN23   |
            | identificativoIntermediarioPSP        | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN24   |
            | identificativoIntermediarioPSP        | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN24.1 |
            | identificativoIntermediarioPSP        | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN25   |
            | identificativoCanale                  | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN26   |
            | identificativoCanale                  | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN26.1 |
            | identificativoCanale                  | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN27   |
            | listaRPT                              | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN28   |
            | listaRPT                              | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN29   |
            | listaRPT                              | RemoveParent                         | PPT_SINTASSI_EXTRAXSD | CRPTSIN29.1 |
            | identificativoDominio                 | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN30   |
            | identificativoDominio                 | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN31   |
            | identificativoDominio                 | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN32   |
            | identificativoUnivocoVersamento       | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN33   |
            | identificativoUnivocoVersamento       | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN34   |
            | identificativoUnivocoVersamento       | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN35   |
            | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN36   |
            | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN37   |
            | codiceContestoPagamento               | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN38   |
            | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN41   |
            | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN42   |
            | requireLightPayment                   | 4                                    | PPT_SINTASSI_EXTRAXSD | CRPTSIN47   |


    # @ALL @PRIMITIVE @MOD1 @test6
    # #CRPTSIN39
    # Scenario: (phase 5) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response

    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_6
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN39
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    # @ALL @PRIMITIVE @MOD1 @test7
    # #CRPTSIN39.1
    # Scenario: (phase 5_1) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <tipoFirma></tipoFirma>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response

    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_7
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN39.1
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_tipofirma initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
            | tipoFirma                             |                                 |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response



    # @ALL @PRIMITIVE @MOD1 @test8
    # #CRPTSIN40
    # Scenario: (phase 6) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <tipoFirma>1</tipoFirma>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_8
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN40
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_tipofirma initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
            | tipoFirma                             | 1                               |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response

    #CRPTSIN43
    Scenario: (phase 7) RPT generation
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>11</pay_i:civicoVersante>
            <pay_i:capVersante>00186</pay_i:capVersante>
            <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
            <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
            <pay_i:capPagatore>00186</pay_i:capPagatore>
            <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
            <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>0/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """

    @ALL @PRIMITIVE @MOD1 @test9
    Scenario: (phase 7) Execute nodoInviaCarrelloRPT request
        Given the (phase 7) RPT generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1iuv</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_9
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN43
        Given RPT generation RPT_generation_malformed with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoInviaCarrelloRPT response


    # @ALL @PRIMITIVE @MOD1 @test10
    # #CRPTSIN44
    # Scenario: (phase 8) Execute nodoInviaCarrelloRPT request
    #     Given initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt><pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
    #         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
    #         <pay_i:dominio>
    #         <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
    #         <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
    #         </pay_i:dominio>
    #         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
    #         <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
    #         <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
    #         <pay_i:soggettoVersante>
    #         <pay_i:identificativoUnivocoVersante>
    #         <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
    #         <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
    #         </pay_i:identificativoUnivocoVersante>
    #         <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
    #         <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
    #         <pay_i:civicoVersante>11</pay_i:civicoVersante>
    #         <pay_i:capVersante>00186</pay_i:capVersante>
    #         <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
    #         <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
    #         <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
    #         <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
    #         </pay_i:soggettoVersante>
    #         <pay_i:soggettoPagatore>
    #         <pay_i:identificativoUnivocoPagatore>
    #         <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
    #         <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
    #         </pay_i:identificativoUnivocoPagatore>
    #         <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
    #         <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
    #         <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
    #         <pay_i:capPagatore>00186</pay_i:capPagatore>
    #         <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
    #         <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
    #         <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
    #         <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
    #         </pay_i:soggettoPagatore>
    #         <pay_i:enteBeneficiario>
    #         <pay_i:identificativoUnivocoBeneficiario>
    #         <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
    #         <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
    #         </pay_i:identificativoUnivocoBeneficiario>
    #         <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
    #         <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
    #         <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
    #         <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
    #         <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
    #         <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
    #         <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
    #         <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
    #         <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
    #         </pay_i:enteBeneficiario>
    #         <pay_i:datiVersamento>
    #         <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
    #         <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
    #         <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
    #         <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
    #         <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
    #         <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
    #         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
    #         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
    #         <pay_i:datiSingoloVersamento>
    #         <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
    #         <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
    #         <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
    #         <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
    #         <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
    #         <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
    #         <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
    #         <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
    #         <pay_i:datiSpecificiRiscossione>0/abc</pay_i:datiSpecificiRiscossione>
    #         </pay_i:datiSingoloVersamento>
    #         </pay_i:datiVersamento>
    #         </pay_i:RPT></rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response

    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_10
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN44
        Given RPT body generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachmentBody              |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    # @ALL @PRIMITIVE @MOD1 @test11
    # #CRPTSIN45
    # Scenario: (phase 9) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_11
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN45
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response



    # @ALL @PRIMITIVE @MOD1 @test12
    # #CRPTSIN48
    # Scenario: (phase 10) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         <requireLightPayment>00</requireLightPayment>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response



    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_12
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN48
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_full initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
            | requireLightPayment                   | 00                              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    # @ALL @PRIMITIVE @MOD1 @test13
    # #CRPTSIN49
    # Scenario: (phase 11) Execute nodoInviaCarrelloRPT request
    #     Given the RPT generation scenario executed successfully
    #     And initial XML nodoInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header>
    #         <ppt:intestazioneCarrelloPPT>
    #         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
    #         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
    #         <identificativoCarrello>$1iuv</identificativoCarrello>
    #         </ppt:intestazioneCarrelloPPT>
    #         </soapenv:Header>
    #         <soapenv:Body>
    #         <ws:nodoInviaCarrelloRPT>
    #         <password>pwdpwdpwd</password>
    #         <identificativoPSP>#psp#</identificativoPSP>
    #         <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
    #         <identificativoCanale>#canale#</identificativoCanale>
    #         <listaRPT>
    #         <!--1 or more repetitions:-->
    #         <elementoListaRPT>
    #         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
    #         <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
    #         <codiceContestoPagamento>CCD01</codiceContestoPagamento>
    #         <rpt>$rptAttachment</rpt>
    #         </elementoListaRPT>
    #         </listaRPT>
    #         </ws:nodoInviaCarrelloRPT>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And initial XML pspInviaCarrelloRPT
    #         """
    #         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #         <soapenv:Header/>
    #         <soapenv:Body>
    #         <ws:pspInviaCarrelloRPTResponse>
    #         <pspInviaCarrelloRPTResponse>
    #         <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
    #         <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
    #         <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
    #         </pspInviaCarrelloRPTResponse>
    #         </ws:pspInviaCarrelloRPTResponse>
    #         </soapenv:Body>
    #         </soapenv:Envelope>
    #         """
    #     And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    #     When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #     Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_13
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN49
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @test14
    #CRPTSIN50
    Scenario: (phase 12) Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1iuv</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <codiceConvenzione></codiceConvenzione>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response

    @ALL @PRIMITIVE @MOD1 @test15
    #CRPTSIN51
    Scenario: (phase 13) Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1iuv</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <codiceConvenzione>d5e9</codiceConvenzione>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response

    @ALL @PRIMITIVE @MOD1 @test16
    #CRPTSIN52
    Scenario: (phase 14) Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1iuv</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <codiceConvenzione>as12df57g8q45er69t74yuiop45789asw123</codiceConvenzione>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response

    @ALL @PRIMITIVE @MOD1 @test17
    #CRPTSIN46
    Scenario: (phase 15) Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1iuv</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <requireLightPayment></requireLightPayment>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response