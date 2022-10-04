Feature: process tests for ChiediStato_RPT_PARCHEGGIATA_NODO

    Background:

        Given systems up

    Scenario: RPT generation
        Given RPT generation
      		# RPT 
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
            <pay_i:localitaVersante>Conselve</pay_i:localitaVersante>
            <pay_i:provinciaVersante>PD</pay_i:provinciaVersante>
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
            <pay_i:localitaPagatore>Baone</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>RO</pay_i:provinciaPagatore>
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
            <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>#iuv#</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
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
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>

            """
        
        ##### nodoInviaRPT
	Scenario: Execute nodoInviaRPT
		Given the RPT generation scenario executed successfully
		And initial XML nodoInviaRPT

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazionePPT>
                    <identificativoIntermediarioPA>77777777777</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>77777777777_03</identificativoStazioneIntermediarioPA>
                    <identificativoDominio>77777777777</identificativoDominio>
                    <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>AGID_01</identificativoPSP>
                    <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                    <identificativoCanale>97735020584_02</identificativoCanale>
                    <tipoFirma></tipoFirma>
                    <rpt>$rptAttachment</rpt>
                </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
	    Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url


    
         
    
    # retrive information from the DB
    Scenario: Execute check stati rpt
        Given the Execute nodoInviaRPT scenario executed successfully
        #Then select through the query rpt_gen from the table STATI_RPT where condition_1 IUV in $iuv and where condition_2 CCP in CCD01 and where condition_3 ID_DOMINIO in $nodoInviaRPT.identificativoDominio, and check value of record is RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO, and check number of record is 3, under macro Mod1 on db nodo_online
        Then checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_pos on db nodo_online under macro Mod1
        And verify 3 record for the table STATI_RPT retrived by the query rpt_pos on db nodo_online under macro Mod1
        And checks the value $sessionToken of the record at column ID_SESSIONE of the table STATI_RPT retrived by the query rpt_pos on db nodo_online under macro Mod1
        And checks the value nodoInviaRPT of the record at column INSERTED_BY of the table STATI_RPT retrived by the query rpt_pos on db nodo_online under macro Mod1 
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_pos on db nodo_online under macro Mod1
	    
       

    Scenario: Execute nodoChiediStatoRPT
        Given the Execute check stati rpt scenario executed successfully
        And initial XML nodoChiediStatoRPT
        
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediStatoRPT>
                <identificativoIntermediarioPA>77777777777</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>77777777777_03</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>77777777777</identificativoDominio>
                <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </ws:nodoChiediStatoRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
	    Then check stato is RPT_PARCHEGGIATA_NODO of nodoChiediStatoRPT response
        Then check redirect is 1 of nodoChiediStatoRPT response

        
        ##### nodoInviaRPT Duplicato
	Scenario: Execute nodoInviaRPT Duplicato
		Given the Execute nodoChiediStatoRPT scenario executed successfully
		And initial XML nodoInviaRPT

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazionePPT>
                    <identificativoIntermediarioPA>77777777777</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>77777777777_03</identificativoStazioneIntermediarioPA>
                    <identificativoDominio>77777777777</identificativoDominio>
                    <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>AGID_01</identificativoPSP>
                    <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                    <identificativoCanale>97735020584_02</identificativoCanale>
                    <tipoFirma></tipoFirma>
                    <rpt>$rptAttachment</rpt>
                </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
	    Then check faultCode is PPT_RPT_DUPLICATA of nodoInviaRPT response

       
    Scenario: Execute nodoChiediStatoRPT Duplicato
        Given the Execute nodoInviaRPT Duplicato scenario executed successfully
        And initial XML nodoChiediStatoRPT
       """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediStatoRPT>
                <identificativoIntermediarioPA>77777777777</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>77777777777_03</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>77777777777</identificativoDominio>
                <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </ws:nodoChiediStatoRPT>
        </soapenv:Body>
        </soapenv:Envelope>
       """
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
	    Then check stato is RPT_RIFIUTATA_NODO of nodoChiediStatoRPT response
        




   