Feature: T219_Carrello_Mod1_BP_parcheggio_web

    
    Background:
        Given systems up

    Scenario: Execute nodoInviaCarrelloRPT (Phase 1)
        Given RPT generation
        """
        <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.1</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
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
                <pay_i:importoTotaleDaVersare>15.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>#IUV#</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                    <pay_i:importoSingoloVersamento>15.00</pay_i:importoSingoloVersamento>
                    <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
                    <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
                    <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                    <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
                    <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                    <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                    <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
                    <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
        </pay_i:RPT>
        """

        And initial XML nodoInviaCarrelloRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazioneCarrelloPPT>
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <identificativoCarrello>#CARRELLO#</identificativoCarrello>
                </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaCarrelloRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>#psp_AGID#</identificativoPSP>
                    <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
                    <listaRPT>
                        <elementoListaRPT>
                        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                        <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                        </elementoListaRPT>
                    </listaRPT>
                </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML pspInviaCarrelloRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:pspInviaCarrelloRPTResponse>
                    <pspInviaCarrelloRPTResponse>
                        <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                        <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
                        <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
                    </pspInviaCarrelloRPTResponse>
                </ws:pspInviaCarrelloRPTResponse>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url contains acardste of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url

@midRunnable
    Scenario: Execute nodoInoltroEsitoMod1 (Phase 2)
        Given the Execute nodoInviaCarrelloRPT (Phase 1) scenario executed successfully
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canaleRtPush#",
                "tipoOperazione": "web"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200
        And check esito is OK of inoltroEsito/mod1 response
        #DB-CHECK
        And replace sessionToken content with $sessionToken content
        And checks the value #canaleRtPush# of the record at column CANALE of the table RPT retrived by the query motivo_annullamento on db nodo_online under macro Mod1
        And checks the value #psp# of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query motivo_annullamento on db nodo_online under macro Mod1
        And checks the value #psp# of the record at column PSP of the table RPT retrived by the query motivo_annullamento on db nodo_online under macro Mod1
        And checks the value web of the record at column TIPO_INTERAZIONE of the table PM_SESSION_DATA retrived by the query motivo_annullamento on db nodo_online under macro Mod1