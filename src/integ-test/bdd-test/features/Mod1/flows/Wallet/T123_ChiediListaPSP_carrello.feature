Feature: process tests for chiediListaPSP

    Background:
        Given systems up
<<<<<<< HEAD

=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: RPT generation
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
<<<<<<< HEAD
                <pay_i:identificativoDominio>44444444444</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>44444444444_01</pay_i:identificativoStazioneRichiedente>
=======
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
>>>>>>> origin/feature/gherkin-with-behavetag
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
                <pay_i:importoTotaleDaVersare>6.20</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>#IUV#</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                    <pay_i:importoSingoloVersamento>6.20</pay_i:importoSingoloVersamento>
                    <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
                    <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
                    <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                    <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
                    <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                    <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                    <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                    <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
<<<<<<< HEAD
=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazioneCarrelloPPT>
<<<<<<< HEAD
                    <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
=======
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
>>>>>>> origin/feature/gherkin-with-behavetag
                    <identificativoCarrello>$IUV</identificativoCarrello>
                </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaCarrelloRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>AGID_01</identificativoPSP>
                    <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                    <identificativoCanale>97735020584_02</identificativoCanale>
                    <listaRPT>
                        <elementoListaRPT>
<<<<<<< HEAD
                        <identificativoDominio>44444444444</identificativoDominio>
=======
                        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
>>>>>>> origin/feature/gherkin-with-behavetag
                        <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                        </elementoListaRPT>
                    </listaRPT>
                </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url contains acardste of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url

        # DB Check
        And execution query version to get value on the table ELENCO_SERVIZI_PSP_SYNC_STATUS, with the columns SNAPSHOT_VERSION under macro Mod1 with db name nodo_offline
        And through the query version retrieve param version at position 0 and save it under the key version

        And replace lingua content with DE content
        And replace importoTot content with 6.20 content

        And execution query getPspCarte to get value on the table ELENCO_SERVIZI_PSP, with the columns COUNT(*) under macro Mod1 with db name nodo_offline
        And through the query getPspCarte retrieve param sizeCarte at position 0 and save it under the key sizeCarte
        And execution query getPspCarte to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro Mod1 with db name nodo_offline
        And through the query getPspCarte retrieve param listaCarte at position -1 and save it under the key listaCarte

        And execution query getPspConto to get value on the table ELENCO_SERVIZI_PSP, with the columns COUNT(*) under macro Mod1 with db name nodo_offline
        And through the query getPspConto retrieve param sizeConto at position 0 and save it under the key sizeConto
        And execution query getPspConto to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro Mod1 with db name nodo_offline
        And through the query getPspConto retrieve param listaConto at position -1 and save it under the key listaConto

        And execution query getPspAltro to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro Mod1 with db name nodo_offline
        And through the query getPspAltro retrieve param listaAltro at position -1 and save it under the key listaAltro

<<<<<<< HEAD

=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: execution nodoChiediListaPSP - altro
        Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
        When WISP sends rest GET listaPSP?idPagamento=$sessionToken&percorsoPagamento=ALTRO&lingua=$lingua to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is 200
<<<<<<< HEAD

=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: execution nodoChiediListaPSP - carte
        Given the execution nodoChiediListaPSP - altro scenario executed successfully
        When WISP sends rest GET listaPSP?idPagamento=$sessionToken&percorsoPagamento=CARTE&lingua=$lingua to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is 200
        And check totalRows is $sizeCarte of listaPSP response
        And check data is $listaCarte of listaPSP response
<<<<<<< HEAD

=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: execution nodoChiediListaPSP - conto
        Given the execution nodoChiediListaPSP - carte scenario executed successfully
        When WISP sends rest GET listaPSP?idPagamento=$sessionToken&percorsoPagamento=CC&lingua=$lingua to nodo-dei-pagamenti
        Then verify the HTTP status code of listaPSP response is 200
        And check totalRows is $sizeConto of listaPSP response
        And check data is $listaConto of listaPSP response