Feature: process test for appIO_paypal with station migration from V1 to V2 between nodoChiediInfoPagamento and nodoInoltraEsitoPagamentoPaypal

    Background:
        Given systems up
        And EC old version

    # nodoVerificaRPT phase
    Scenario: Execute nodoVerificaRPT request
        Given initial XML nodoVerificaRPT

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
            <codiceIdRPT><aim:aim128> <aim:CCPost>#ccPoste#</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>#iuv#</aim:CodIUV></aim:aim128></codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And initial xml paaVerificaRPT
            """"
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
            <paaVerificaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>1.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>66666666666_05</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaVerificaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
            <pag:capBeneficiario>jyr</pag:capBeneficiario>
            <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>of8</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/$iuv/TESTO/causale del versamento</causaleVersamento>
            </datiPagamentoPA>
            </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoVerificaRPT response

    # nodoAttivaRPT phase
    Scenario: Execute nodoAttivaRPT request
        Given the Execute nodoVerificaRPT request scenario executed successfully
        And initial xml nodoAttivaRPT

            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoAttivaRPT>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>$nodoVerificaRPT.codiceContestoPagamento</codiceContestoPagamento>
            <identificativoIntermediarioPSPPagamento>#broker_AGID#</identificativoIntermediarioPSPPagamento>
            <identificativoCanalePagamento>97735020584_02</identificativoCanalePagamento>
            <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
            <codiceIdRPT><aim:aim128> <aim:CCPost>#ccPoste#</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>$iuv</aim:CodIUV></aim:aim128></codiceIdRPT>
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

        And initial xml paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>66666666666_05</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>97735020584</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>97735020584_02</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response

    # nodoInviaRPT phase
    Scenario: Define RPT
        Given the Execute nodoAttivaRPT request scenario executed successfully
        And RPT generation

            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#codicePA_old#</pay_i:identificativoDominio>
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
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$nodoVerificaRPT.codiceContestoPagamento</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
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



    Scenario: Execute nodoInviaRPT
        Given the Define RPT scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#creditor_institution_code#_05</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$nodoVerificaRPT.codiceContestoPagamento</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
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


    # nodoChiediInformazioniPagamento phase
    Scenario: Execute nodoChiediInformazioniPagamento request
        Given the Execute nodoInviaRPT scenario executed successfully
        When WISP sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    #DB update
    Scenario: Execute station version update
        Given the Execute nodoChiediInformazioniPagamento request scenario executed successfully
        Then updates through the query stationUpdate of the table STAZIONI the parameter VERSIONE with 2 under macro sendPaymentResultV2 on db nodo_cfg

    #refresh pa e stazioni
    Scenario: Execute refresh pa e stazioni
        Given the Execute station version update scenario executed successfully
        Then refresh job PA triggered after 10 seconds

    # nodoInoltraEsitoPagamentoPaypal
    Scenario: Execute nodoInoltroEsitoPayPal OK
        Given the Execute refresh pa e stazioni scenario executed successfully
        When WISP sends REST POST inoltroEsito/paypal to nodo-dei-pagamenti
            """
            {
                "idTransazione": "responseOk",
                "idTransazionePsp": "153016btAE",
                "idPagamento": "$sessionToken",
                "identificativoIntermediario": "#psp#",
                "identificativoPsp": "#psp#",
                "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "importoTotalePagato": 10,
                "timestampOperazione": "2012-04-23T18:25:43Z"
            }
            """
        Then verify the HTTP status code of inoltroEsito/paypal response is 200
        And check esito is OK of inoltroEsito/paypal response


    # Payment Outcome Phase outcome OK
    Scenario: Execute sendPaymentOutcome request
        Given the Execute nodoInoltroEsitoPayPal OK scenario executed successfully
        And initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_old#</idChannel>
            <password>pwdpwdpwd</password>
            <paymentToken>$nodoVerificaRPT.codiceContestoPagamento</paymentToken>
            <outcome>OK</outcome>
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>John Doe</fullName>
            <streetName>street</streetName>
            <civicNumber>12</civicNumber>
            <postalCode>89020</postalCode>
            <city>city</city>
            <stateProvinceRegion>MI</stateProvinceRegion>
            <country>IT</country>
            <e-mail>john.doe@test.it</e-mail>
            </payer>
            <applicationDate>2021-10-01</applicationDate>
            <transferDate>2021-10-02</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

    #DB Check
    Scenario: Execute DB check
        Given the Execute sendPaymentOutcome request scenario executed successfully
        And wait 25 seconds for expiration
        #POSITION_PAYMENT_STATUS
        Then checks the value PAYING, PAYMENT_SENT, PAYMENT_ACCEPTED, PAID, NOTICE_GENERATED, NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
        #POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        #POSITION_STATUS
        And checks the value PAYING, PAID, NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status_old on db nodo_online under macro AppIO
        #POSITION_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status_old on db nodo_online under macro AppIO
        # check correctness of POSITION_PAYMENT table
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value $nodoInviaRPT.codiceContestoPagamento of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value #intermediarioPA# of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value #psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value PPAL of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value NotNone of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query payment_status_old on db nodo_online under macro AppIO
        #STATI_RPT table
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RPT_RISOLTA_OK, RT_GENERATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro AppIO
        #STATI_RPT_SNAPSHOT table
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stato on db nodo_online under macro AppIO
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query stato on db nodo_online under macro AppIO
        #RT
        Then execution query rt_1 to get value on the table RT, with the columns ID_SESSIONE,CCP,IDENT_DOMINIO,IUV,COD_ESITO,DATA_RICEVUTA,DATA_RICHIESTA,ID_RICEVUTA,ID_RICHIESTA,SOMMA_VERSAMENTI,INSERTED_TIMESTAMP,UPDATED_TIMESTAMP,CANALE,ID under macro NewMod3 with db name nodo_online
        And execution query rt_1 to get value on the table RPT, with the columns CCP,IDENT_DOMINIO,IUV,ID_MSG_RICH,CANALE under macro NewMod3 with db name nodo_online
        And execution query payment_status_old to get value on the table POSITION_PAYMENT, with the columns AMOUNT,FEE,PAYMENT_TOKEN,NOTICE_ID,PA_FISCAL_CODE,OUTCOME,CHANNEL_ID,PAYMENT_CHANNEL,PAYER_ID,PAYMENT_METHOD,ID,APPLICATION_DATE,CREDITOR_REFERENCE_ID,BROKER_PA_ID,STATION_ID under macro AppIO with db name nodo_online        
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        And with the query rt_1 check assert beetwen elem CCP in position 1 and elem CCP with position 0 of the query rt_1
        And with the query rt_1 check assert beetwen elem IDENT_DOMINIO in position 2 and elem IDENT_DOMINIO with position 1 of the query rt_1
        And with the query rt_1 check assert beetwen elem IUV in position 3 and elem IUV with position 2 of the query rt_1
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        And with the query rt_1 check assert beetwen elem ID_RICHIESTA in position 8 and elem ID_MSG_RICH with position 3 of the query rt_1
        And with the query rt_1 check assert beetwen elem SOMMA_VERSAMENTI in position 9 and elem AMOUNT with position 0 of the query payment_status
        And with the query rt_1 check assert beetwen elem CANALE in position 12 and elem CANALE with position 4 of the query rt_1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        #RT_VERSAMENTI
        And execution query rt_versamenti_old to get value on the table RT_VERSAMENTI, with the columns s.ID,s.IMPORTO_RT,s.ESITO,s.CAUSALE_VERSAMENTO,s.DATI_SPECIFICI_RISCOSSIONE,s.COMMISSIONE_APPLICATE_PSP,s.FK_RT,s.INSERTED_TIMESTAMP,s.UPDATED_TIMESTAMP under macro NewMod3 with db name nodo_online
        And execution query rpt_versamenti_old to get value on the table RPT_VERSAMENTI, with the columns s.CAUSALE_VERSAMENTO,s.DATI_SPECIFICI_RISCOSSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT retrived by the query rt_1 on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI retrived by the query rt_versamenti_old on db nodo_online under macro NewMod3
        And with the query rt_versamenti_old check assert beetwen elem IMPORTO_RT in position 1 and elem AMOUNT with position 0 of the query payment_status
        And checks the value ESEGUITO of the record at column s.ESITO of the table RT_VERSAMENTI retrived by the query rt_versamenti_old on db nodo_online under macro NewMod3
        And with the query rt_versamenti_old check assert beetwen elem CAUSALE_VERSAMENTO in position 3 and elem CAUSALE_VERSAMENTO with position 0 of the query rpt_versamenti
        And with the query rt_versamenti_old check assert beetwen elem DATI_SPECIFICI_RISCOSSIONE in position 4 and elem DATI_SPECIFICI_RISCOSSIONE with position 1 of the query rpt_versamenti
        And with the query rt_versamenti_old check assert beetwen elem COMMISSIONE_APPLICATE in position 5 and elem FEE with position 1 of the query payment_status
        And with the query rt_versamenti_old check assert beetwen elem FK_RT in position 6 and elem ID with position 13 of the query rt
        And checks the value NotNone of the record at column s.INSERTED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti_old on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column s.UPDATED_TIMESTAMP of the table RT_VERSAMENTI retrived by the query rt_versamenti_old on db nodo_online under macro NewMod3
        #POSITION_RECEIPT
        And execution query position_receipt_old to get value on the table POSITION_RECEIPT, with the columns RECEIPT_ID,s.NOTICE_ID,s.PA_FISCAL_CODE,s.CREDITOR_REFERENCE_ID,s.PAYMENT_TOKEN,s.OUTCOME,s.PAYMENT_AMOUNT,s.DESCRIPTION,s.COMPANY_NAME,s.OFFICE_NAME,s.DEBTOR_ID,s.PSP_ID,s.PSP_COMPANY_NAME,s.PSP_FISCAL_CODE,s.PSP_VAT_NUMBER,s.CHANNEL_ID,s.CHANNEL_DESCRIPTION,s.PAYER_ID,s.PAYMENT_METHOD,s.FEE,s.PAYMENT_DATE_TIME,s.APPLICATION_DATE,s.TRANSFER_DATE,s.METADATA,s.RT_ID,s.FK_POSITION_PAYMENT,s.ID under macro NewMod3 with db name nodo_online
        And execution query position_service to get value on the table POSITION_SERVICE, with the columns DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID under macro NewMod3 with db name nodo_online
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE,CODICE_FISCALE,VAT_NUMBER under macro NewMod3 with db name nodo_cfg
        And execution query position_payment_plan to get value on the table POSITION_PAYMENT_PLAN, with the columns METADATA under macro NewMod3 with db name nodo_online
        And with the query position_receipt_old check assert beetwen elem RECEIPT_ID in position 0 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem NOTICE_ID in position 1 and elem NOTICE_ID with position 3 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem PA_FISCAL_CODE in position 2 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem CREDITOR_REFERENCE_ID in position 3 and elem CREDITOR_REFERENCE_ID with position 12 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem PAYMENT_TOKEN in position 4 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem OUTCOME in position 5 and elem OUTCOME with position 5 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem AMOUNT in position 6 and elem AMOUNT with position 0 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem DESCRIPTION in position 7 and elem DESCRIPTION with position 0 of the query position_service
        And with the query position_receipt_old check assert beetwen elem COMPANY_NAME in position 8 and elem COMPANY_NAME with position 1 of the query position_service
        And with the query position_receipt_old check assert beetwen elem OFFICE_NAME in position 9 and elem OFFICE_NAME with position 2 of the query position_service
        And with the query position_receipt_old check assert beetwen elem DEBTOR_ID in position 10 and elem DEBTOR_ID with position 3 of the query position_service
        And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_receipt_old on db nodo_online under macro NewMod3
        And with the query position_receipt_old check assert beetwen elem PSP_COMPANY_NAME in position 12 and elem PSP_COMPANY_NAME with position 0 of the query psp
        And with the query position_receipt_old check assert beetwen elem PSP_FISCAL_CODE in position 13 and elem PSP_FISCAL_CODE with position 1 of the query psp
        And with the query position_receipt_old check assert beetwen elem PSP_VAT_NUMBER in position 14 and elem PSP_VAT_NUMBER with position 2 of the query psp
        And with the query position_receipt_old check assert beetwen elem CHANNEL_ID in position 15 and elem CHANNEL_ID with position 6 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem CHANNEL_DESCRIPTION in position 16 and elem PAYMENT_CHANNEL with position 7 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem PAYER_ID in position 17 and elem PAYER_ID with position 8 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem PAYMENT_METHOD in position 18 and elem PAYMENT_METHOD with position 9 of the query payment_status
        And with the query position_receipt_old check assert beetwen elem FEE in position 19 and elem FEE with position 1 of the query payment_status
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query position_receipt_old on db nodo_online under macro NewMod3
        And with the query position_receipt_old check assert beetwen elem APPLICATION_DATE in position 21 and elem APPLICATION_DATE with position 11 of the query payment_status
        And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query position_receipt_old on db nodo_online under macro NewMod3
        And with the query position_receipt_old check assert beetwen elem METADATA in position 23 and elem METADATA with position 0 of the query position_payment_plan
        And with the query position_receipt_old check assert beetwen elem RT_ID in position 24 and elem METADATA with position 13 of the query rt
        And with the query position_receipt_old check assert beetwen elem FK_POSITION_PAYMENT in position 25 and elem METADATA with position 10 of the query payment_status
        #RT_XML
        And execution query rt_xml to get value on the table RT_XML, with the columns ID,CCP,IDENT_DOMINIO,IUV,FK_RT,TIPO_FIRMA,XML_CONTENT,INSERTED_TIMESTAMP,UPDATED_TIMESTAMP,ID_SESSIONE under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And with the query rt_xml check assert beetwen elem CCP in position 1 and elem CCP with position 0 of the query rpt
        And with the query rt_xml check assert beetwen elem IDENT_DOMINIO in position 2 and elem IDENT_DOMINIO with position 1 of the query rpt
        And with the query rt_xml check assert beetwen elem iuv in position 3 and elem iuv with position 2 of the query rpt
        And with the query rt_xml check assert beetwen elem FK_RT in position 4 and elem iuv with position 13 of the query rt
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query rt_xml on db nodo_online under macro NewMod3
        And with the query rt_xml check assert beetwen elem ID_SESSIONE in position 9 and elem iuv with position 0 of the query rt
        #POSITION_RECEIPT_TRANSFER
        And execution query position_receipt_transfer to get value on the table POSITION_RECEIPT_TRANSFER, with the columns FK_POSITION_RECEIPT,s.FK_POSITION_TRANSFER under macro NewMod3 with db name nodo_online
        And execution query position_transfer to get value on the table POSITION_TRANSFER, with the columns ID under macro NewMod3 with db name nodo_online
        And with the query position_receipt_transfer check assert beetwen elem RECEIPT in position 0 and elem ID with position 26 of the query position_receipt
        And verify 1 record for the table POSITION_RECEIPT_TRANSFER retrived by the query position_receipt_transfer on db nodo_online under macro NewMod3
        And with the query position_receipt_transfer check assert beetwen elem TRANSFER in position 1 and elem ID with position 0 of the query position_transfer
        #POSITION_RECEIPT_XML
        And execution query position_receipt_xml to get value on the table POSITION_RECEIPT_XML, with the columns ID,PA_FISCAL_CODE,NOTICE_ID,CREDITOR_REFERENCE_ID,PAYMENT_TOKEN,RECIPIENT_PA_FISCAL_CODE,RECIPIENT_BROKER_PA_ID,RECIPIENT_STATION_ID,XML,INSERTED_TIMESTAMP,FK_POSITION_RECEIPT under macro NewMod3 with db name nodo_online
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And with the query position_receipt_xml check assert beetwen elem PA_FISCAL_CODE in position 1 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem NOTICE_ID in position 2 and elem NOTICE_ID with position 3 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem CREDITOR_REFERENCE_ID in position 3 and elem CREDITOR_REFERENCE_ID with position 12 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem PAYMENT_TOKEN in position 4 and elem PAYMENT_TOKEN with position 2 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_PA_FISCAL_CODE in position 5 and elem PA_FISCAL_CODE with position 4 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_BROKER_PA_ID in position 6 and elem RECIPIENT_BROKER_PA_ID with position 13 of the query payment_status
        And with the query position_receipt_xml check assert beetwen elem RECIPIENT_STATION_ID in position 7 and elem RECIPIENT_STATION_ID with position 14 of the query payment_status
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
        And with the query position_receipt_xml check assert beetwen elem FK_POSITION_RECEIPT in position 10 and elem ID with position 26 of the query position_receipt

    #DB update 2
    Scenario: Execute station version update 2
        Given the Execute DB check scenario executed successfully
        Then updates through the query stationUpdate of the table STAZIONI the parameter VERSIONE with 1 under macro sendPaymentResultV2 on db nodo_cfg


    #refresh pa e stazioni
    Scenario: Execute refresh pa e stazioni 2
        Given the Execute station version update 2 scenario executed successfully
        Then refresh job PA triggered after 10 seconds