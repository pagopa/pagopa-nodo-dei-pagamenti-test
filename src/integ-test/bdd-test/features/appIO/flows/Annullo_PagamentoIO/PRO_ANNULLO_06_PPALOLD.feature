Feature: PRO_ANNULLO_06_PPALOLD 25

    Background:
        Given systems up
        

    Scenario: Execute nodoVerificaRPT (Phase 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 6000
        And nodo-dei-pagamenti has config parameter scheduler.cancelIOPaymentActorMinutesToBack set to 1
        And RPT generation
        """
        <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
        <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
        <pay_i:dominio>
        <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
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
        <pay_i:identificativoUnivocoVersamento>#iuv#</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>#ccp#</pay_i:codiceContestoPagamento>
        <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
        <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
        <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
        <pay_i:datiSingoloVersamento>
        <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
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
                <codiceContestoPagamento>$ccp</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                <codiceIdRPT>
                    <qrc:QrCode>
                        <qrc:CF>#creditor_institution_code_old#</qrc:CF>
                        <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA>
                        <qrc:AuxDigit>0</qrc:AuxDigit>
                        <qrc:CodIUV>$iuv</qrc:CodIUV>
                    </qrc:QrCode>
                </codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When IO sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoVerificaRPT response

    Scenario: Execute nodoAttivaRPT (Phase 2)
        Given the Execute nodoVerificaRPT (Phase 1) scenario executed successfully
        And initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoAttivaRPT>
                    <identificativoPSP>$nodoVerificaRPT.identificativoPSP</identificativoPSP>
                    <identificativoIntermediarioPSP>$nodoVerificaRPT.identificativoIntermediarioPSP</identificativoIntermediarioPSP>
                    <identificativoCanale>$nodoVerificaRPT.identificativoCanale</identificativoCanale>
                    <password>$nodoVerificaRPT.password</password>
                    <codiceContestoPagamento>$nodoVerificaRPT.codiceContestoPagamento</codiceContestoPagamento>
                    <identificativoIntermediarioPSPPagamento>#broker_AGID#</identificativoIntermediarioPSPPagamento>
                    <identificativoCanalePagamento>#canale_AGID_BBT#</identificativoCanalePagamento>
                    <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                    <codiceIdRPT>
                        <qrc:QrCode>
                            <qrc:CF>#creditor_institution_code_old#</qrc:CF>
                            <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA>
                            <qrc:AuxDigit>0</qrc:AuxDigit>
                            <qrc:CodIUV>$iuv</qrc:CodIUV>
                        </qrc:QrCode>
                    </codiceIdRPT>
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
        When IO sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
      
        Scenario: Execute nodoInviaRPT (Phase 3)
        Given the Execute nodoAttivaRPT (Phase 2) scenario executed successfully
        And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazionePPT>
                    <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
                    <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                    <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>$nodoAttivaRPT.codiceContestoPagamento</codiceContestoPagamento>
                </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>#psp_AGID#</identificativoPSP>
                    <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
                    <tipoFirma></tipoFirma>
                    <rpt>$rptAttachment</rpt>
                </ws:nodoInviaRPT>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
   
     Scenario: update column valid_to UPDATED_TIMESTAMP
        Given the Execute nodoInviaRPT (Phase 3) scenario executed successfully
        And wait 80 seconds for expiration
        And change date Today to remove minutes 15
        Then update through the query DB_GEST_ANN_update1 with date $date under macro AppIO on db nodo_online
        And wait 10 seconds for expiration

    Scenario: Trigger annullamentoRptMaiRichiesteDaPm
      Given the update column valid_to UPDATED_TIMESTAMP scenario executed successfully
      When job annullamentoRptMaiRichiesteDaPm triggered after 0 seconds
      Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200

    @runnable
    Scenario: check DB  
      Given the Trigger annullamentoRptMaiRichiesteDaPm scenario executed successfully
        And wait 15 seconds for expiration
        #And wait until the update to the new state for the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        Then verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And verify 0 record for the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        #check correctness STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
        #check correctness STATI_RPT_SNAPSHOT table
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro AppIO
        And restore initial configurations