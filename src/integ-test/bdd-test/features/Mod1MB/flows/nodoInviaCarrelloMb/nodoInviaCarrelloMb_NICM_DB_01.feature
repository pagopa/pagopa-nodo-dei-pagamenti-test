Feature: process tests for nodoInviaCarrelloMb

    Background:
        Given systems up
    Scenario: RPT generation
        Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA

        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber

        And RPT1 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>

            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>

            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:importoTotaleDaVersare>1.50</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>1.50</pay_i:importoSingoloVersamento>
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

        And RPT2 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.1</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_secondary#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_secondary#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:importoTotaleDaVersare>1.50</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>1.50</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
@runnable
    Scenario: Execute nodoInviaCarrelloRPT request
        Given the RPT generation scenario executed successfully
        And initial XML paaInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaInviaRTRisposta>
            <paaInviaRTRisposta>
            <esito>OK</esito>
            </paaInviaRTRisposta>
            </ws:paaInviaRTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaInviaRT

        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>

            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>

            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1carrello</identificativoCarrello>
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

            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <rpt>$rpt1Attachment</rpt>
            </elementoListaRPT>
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code_secondary#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <rpt>$rpt2Attachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <requireLightPayment>01</requireLightPayment>
            <multiBeneficiario>1</multiBeneficiario>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Then retrieve session token from $nodoInviaCarrelloRPTResponse.url


        And replace pa content with #creditor_institution_code# content

        And replace iuv content with $1iuv content
        And replace noticeNumber content with $1noticeNumber content
       
        #DB_CHECKS
        #POSITION_SUBJECT [NICM_DB_01]

        And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value F of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value RCCGLD09P09H501E of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value Gesualdo;Riccitelli of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value via del gesu of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value 11 of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value 00186 of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value Roma of the record at column CITY of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value RM of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value IT of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value gesualdo.riccitelli@poste.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb

        #POSITION_SERVICE [NICM_DB_04]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value Pagamento multibeneficiario of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value AZIENDA XXX of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value XXX of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And execution query by_notice_number_and_pa to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro Mod1Mb with db name nodo_online
        And through the query by_notice_number_and_pa retrieve param ID at position 0 and save it under the key DEBTOR_ID
        And checks the value $DEBTOR_ID of the record at column ID of the table POSITION_SUBJECT retrived by the query by_position_subject on db nodo_online under macro Mod1Mb

        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #POSITION_PAYMENT_PLAN [NICM_DB_06]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $1iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value 3 of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value N of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And execution query by_notice_number_and_pa to get value on the table POSITION_PAYMENT_PLAN, with the columns FK_POSITION_SERVICE under macro Mod1Mb with db name nodo_online
        And through the query by_notice_number_and_pa retrieve param ID at position 0 and save it under the key FK_POSITION_SERVICE
        And checks the value $FK_POSITION_SERVICE of the record at column ID of the table POSITION_SERVICE retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb


        #POSITION_TRANSFER [NICM_DB_10]
        And checks the value $1noticeNumber, $1noticeNumber of the record at column NOTICE_ID of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $1iuv, $1iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value #creditor_institution_code#, #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value #creditor_institution_code#, #creditor_institution_code_secondary# of the record at column PA_FISCAL_CODE_SECONDARY of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value 1.5, 1.5 of the record at column AMOUNT of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value pagamento fotocopie pratica, pagamento fotocopie pratica of the record at column REMITTANCE_INFORMATION of the table POSITION_TRANSFER retrived by the query by_position_transfer on db nodo_online under macro Mod1Mb
        And checks the value 1/abc, 1/abc of the record at column TRANSFER_CATEGORY of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value 1, 2 of the record at column TRANSFER_IDENTIFIER of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value Y, Y of the record at column VALID of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_TRANSFER retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #POSITION_PAYMENT [NICM_DB_12]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $1iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoCarrello of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value #creditor_institution_code# of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value #creditor_institution_code#_01 of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoCanale of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value 3 of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value MOD1 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #POSITION_STATUS[NICM_DB_13]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #POSITION_STATUS_SNAPSHOT [NICM_DB_14]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #POSITION_PAYMENT_STATUS [NICM_DB_16]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value $1iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoCarrello of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        #POSITION_PAYMENT_STATUS_SNAPSHOT [NICM_DB_17]

        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb

        And checks the value $1noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $1iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value $nodoInviaCarrelloRPT.identificativoCarrello of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query by_notice_number_and_pa on db nodo_online under macro Mod1Mb


