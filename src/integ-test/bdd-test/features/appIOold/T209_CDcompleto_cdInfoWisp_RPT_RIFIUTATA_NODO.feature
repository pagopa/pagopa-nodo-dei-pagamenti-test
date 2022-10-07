Feature: process tests for T209_CDcompleto_cdInfoWisp_RPT_RIFIUTATA_NODO

Background:
    Given systems up
    And EC old version
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
    And RPT1 generation
        """
        <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
        <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
        <pay_i:dominio>
        <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
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
        <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
        <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
        <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
        <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>#ccp1#</pay_i:codiceContestoPagamento>
        <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
        <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
        <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
        <pay_i:datiSingoloVersamento>
        <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
        <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
        <pay_i:ibanAccredito>IT96R0123000321000000000045</pay_i:ibanAccredito>
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

    And initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>#psp_AGID#</identificativoPSP>
                <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale_AGID#</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                <codiceIdRPT><qrc:QrCode>  <qrc:CF>#creditor_institution_code#</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>$1iuv</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """

    And initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoAttivaRPT>
                <identificativoPSP>#psp_AGID#</identificativoPSP>
                <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale_AGID#</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
                <identificativoIntermediarioPSPPagamento>#broker_AGID#</identificativoIntermediarioPSPPagamento>
                <identificativoCanalePagamento>#canale_AGID#</identificativoCanalePagamento>
                <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                <codiceIdRPT><qrc:QrCode>  <qrc:CF>#creditor_institution_code#</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>$1iuv</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
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
    And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header>
            <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
            </ppt:intestazionePPT>
        </soapenv:Header>
        <soapenv:Body>
            <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp_AGID#</identificativoPSP>
                <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rpt1Attachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
Scenario: verifyRPT phase
    When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoVerificaRPT response

Scenario: attivaRPT phase
    Given the verifyRPT phase scenario executed successfully
    When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoAttivaRPT response

Scenario: check nodoInviaRPT response
    Given the attivaRPT phase scenario executed successfully
    When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response 
    And checks the value None of the record at column ID_SESSIONE of the table CD_INFO_PAGAMENTO retrived by the query cd_info_pagamento on db nodo_online under macro AppIOold

