Feature: bug rpt carattere speciale

    Background:
        Given systems up

    @test @independent
    Scenario: nodoInviaRPT
        Given RPT generation
            """
            <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
            <pay_j:RPT xmlns:pay_j="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ http://www.digitpa.gov.it/schemas/2011/Pagamenti/PagInf_RPT_RT_6_2_0.xsd">
            <pay_j:versioneOggetto>6.2.0</pay_j:versioneOggetto>
            <pay_j:dominio>
            <pay_j:identificativoDominio>80184430587</pay_j:identificativoDominio>
            <pay_j:identificativoStazioneRichiedente>80184430587_01</pay_j:identificativoStazioneRichiedente>
            </pay_j:dominio>
            <pay_j:identificativoMessaggioRichiesta>0190ba29e78b4e199a167221360dc4d7</pay_j:identificativoMessaggioRichiesta>
            <pay_j:dataOraMessaggioRichiesta>2023-01-02T08:51:42</pay_j:dataOraMessaggioRichiesta>
            <pay_j:autenticazioneSoggetto>CNS</pay_j:autenticazioneSoggetto>
            <pay_j:soggettoPagatore>
            <pay_j:identificativoUnivocoPagatore>
            <pay_j:tipoIdentificativoUnivoco>F</pay_j:tipoIdentificativoUnivoco>
            <pay_j:codiceIdentificativoUnivoco>BNVMSM85A19I441X</pay_j:codiceIdentificativoUnivoco>
            </pay_j:identificativoUnivocoPagatore>
            <pay_j:anagraficaPagatore>Massimo BenvegnÃ¹</pay_j:anagraficaPagatore>
            </pay_j:soggettoPagatore>
            <pay_j:enteBeneficiario>
            <pay_j:identificativoUnivocoBeneficiario>
            <pay_j:tipoIdentificativoUnivoco>G</pay_j:tipoIdentificativoUnivoco>
            <pay_j:codiceIdentificativoUnivoco>80184430587</pay_j:codiceIdentificativoUnivoco>
            </pay_j:identificativoUnivocoBeneficiario>
            <pay_j:denominazioneBeneficiario>Ministero della Giustizia</pay_j:denominazioneBeneficiario>
            <pay_j:codiceUnitOperBeneficiario>0120260097</pay_j:codiceUnitOperBeneficiario>
            <pay_j:denomUnitOperBeneficiario>Tribunale Ordinario - Busto Arsizio</pay_j:denomUnitOperBeneficiario>
            </pay_j:enteBeneficiario>
            <pay_j:datiVersamento>
            <pay_j:dataEsecuzionePagamento>2023-01-02</pay_j:dataEsecuzionePagamento>
            <pay_j:importoTotaleDaVersare>43.00</pay_j:importoTotaleDaVersare>
            <pay_j:tipoVersamento>BBT</pay_j:tipoVersamento>
            <pay_j:identificativoUnivocoVersamento>#iuv#</pay_j:identificativoUnivocoVersamento>
            <pay_j:codiceContestoPagamento>n/a</pay_j:codiceContestoPagamento>
            <pay_j:firmaRicevuta>0</pay_j:firmaRicevuta>
            <pay_j:datiSingoloVersamento>
            <pay_j:importoSingoloVersamento>43.00</pay_j:importoSingoloVersamento>
            <pay_j:ibanAccredito>IT04O0100003245350008332100</pay_j:ibanAccredito>
            <pay_j:ibanAppoggio>IT94Z0760103200000057152043</pay_j:ibanAppoggio>
            <pay_j:causaleVersamento>/RFB/$iuv/43.00/TXT/Ricorso divorzio congiunto Confortino Elena (CNFLNE84C71I441S) / Raco Giorgio (RCAGRG82H0</pay_j:causaleVersamento>
            <pay_j:datiSpecificiRiscossione>9/0702100TS/CONTRIB</pay_j:datiSpecificiRiscossione>
            </pay_j:datiSingoloVersamento>
            </pay_j:datiVersamento>
            </pay_j:RPT>
            """
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>80184430587</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>n/a</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_02#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @test @independent
    Scenario: nodoInviaCarrelloRPT
        Given RPT generation
            """
            <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
            <pay_j:RPT xmlns:pay_j="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ http://www.digitpa.gov.it/schemas/2011/Pagamenti/PagInf_RPT_RT_6_2_0.xsd">
            <pay_j:versioneOggetto>6.2.0</pay_j:versioneOggetto>
            <pay_j:dominio>
            <pay_j:identificativoDominio>80184430587</pay_j:identificativoDominio>
            <pay_j:identificativoStazioneRichiedente>80184430587_01</pay_j:identificativoStazioneRichiedente>
            </pay_j:dominio>
            <pay_j:identificativoMessaggioRichiesta>0190ba29e78b4e199a167221360dc4d7</pay_j:identificativoMessaggioRichiesta>
            <pay_j:dataOraMessaggioRichiesta>2023-01-02T08:51:42</pay_j:dataOraMessaggioRichiesta>
            <pay_j:autenticazioneSoggetto>CNS</pay_j:autenticazioneSoggetto>
            <pay_j:soggettoPagatore>
            <pay_j:identificativoUnivocoPagatore>
            <pay_j:tipoIdentificativoUnivoco>F</pay_j:tipoIdentificativoUnivoco>
            <pay_j:codiceIdentificativoUnivoco>BNVMSM85A19I441X</pay_j:codiceIdentificativoUnivoco>
            </pay_j:identificativoUnivocoPagatore>
            <pay_j:anagraficaPagatore>Massimo BenvegnÃ¹</pay_j:anagraficaPagatore>
            </pay_j:soggettoPagatore>
            <pay_j:enteBeneficiario>
            <pay_j:identificativoUnivocoBeneficiario>
            <pay_j:tipoIdentificativoUnivoco>G</pay_j:tipoIdentificativoUnivoco>
            <pay_j:codiceIdentificativoUnivoco>80184430587</pay_j:codiceIdentificativoUnivoco>
            </pay_j:identificativoUnivocoBeneficiario>
            <pay_j:denominazioneBeneficiario>Ministero della Giustizia</pay_j:denominazioneBeneficiario>
            <pay_j:codiceUnitOperBeneficiario>0120260097</pay_j:codiceUnitOperBeneficiario>
            <pay_j:denomUnitOperBeneficiario>Tribunale Ordinario - Busto Arsizio</pay_j:denomUnitOperBeneficiario>
            </pay_j:enteBeneficiario>
            <pay_j:datiVersamento>
            <pay_j:dataEsecuzionePagamento>2023-01-02</pay_j:dataEsecuzionePagamento>
            <pay_j:importoTotaleDaVersare>43.00</pay_j:importoTotaleDaVersare>
            <pay_j:tipoVersamento>BBT</pay_j:tipoVersamento>
            <pay_j:identificativoUnivocoVersamento>#iuv#</pay_j:identificativoUnivocoVersamento>
            <pay_j:codiceContestoPagamento>n/a</pay_j:codiceContestoPagamento>
            <pay_j:firmaRicevuta>0</pay_j:firmaRicevuta>
            <pay_j:datiSingoloVersamento>
            <pay_j:importoSingoloVersamento>43.00</pay_j:importoSingoloVersamento>
            <pay_j:ibanAccredito>IT04O0100003245350008332100</pay_j:ibanAccredito>
            <pay_j:ibanAppoggio>IT94Z0760103200000057152043</pay_j:ibanAppoggio>
            <pay_j:causaleVersamento>/RFB/$iuv/43.00/TXT/Ricorso divorzio congiunto Confortino Elena (CNFLNE84C71I441S) / Raco Giorgio (RCAGRG82H0</pay_j:causaleVersamento>
            <pay_j:datiSpecificiRiscossione>9/0702100TS/CONTRIB</pay_j:datiSpecificiRiscossione>
            </pay_j:datiSingoloVersamento>
            </pay_j:datiVersamento>
            </pay_j:RPT>
            """
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>#ccp#</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_02#</identificativoCanale>
            <listaRPT>
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>80184430587</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>n/a</codiceContestoPagamento>
            <rpt>$rptAttachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response