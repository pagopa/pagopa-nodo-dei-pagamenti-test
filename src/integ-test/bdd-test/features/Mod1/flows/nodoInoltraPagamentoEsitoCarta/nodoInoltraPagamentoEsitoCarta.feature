Feature: process tests for nodoInoltraPagamentoEsitoCarta

    Background:
        Given systems up

    Scenario: RPT generation
        Given RPT generation
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

    Scenario: Execute nodoInviaRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
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
        And retrieve session token from $nodoInviaRPTResponse.url

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC1
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "stCase#idPagamentoGr}",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il Pagamento indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC2
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC3
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il Pagamento indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC4
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": "",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is RRN invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC5
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is RRN invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC6
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "sconosciuto",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il PSP indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC7
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "NOT_ENABLED",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il PSP indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC8
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC9
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il PSP indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC10
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC11
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "PO",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is Tipo Versamento invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC12
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "PIPPO",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC13
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC14
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC15
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is L'Intermediario indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC16
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "sconosciuto",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is L'Intermediario indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC17
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "INT_NOT_ENABLED",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is L'Intermediario indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC18
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "sconosciuto",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il Canale indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC19
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il Canale indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC20
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 400
        And check error is Richiesta non valida of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC21
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "NOT_ENABLED",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 11.12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Il Canale indicato non esiste of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC22
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is Importo Totale Pagato invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC23
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": "",
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is Importo Totale Pagato invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC24
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 500

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC25
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": "10ab",
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is Importo Totale Pagato invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC26
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp_AGID#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 404
        And check error is Configurazione psp-canale non corretta of inoltroEsito/carta response

    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC27 -Phase 1
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 200

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC27 -Phase 2
        Given the execution nodoInoltraPagamentoEsitoCarta - PM_IEPC27 -Phase 1 scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 200

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC28
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43.000Z",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 200

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC29
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43.000+01:00",
                "codiceAutorizzativo": "123456"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 200

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC30
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": ""
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is Codice autorizzativo invalido of inoltroEsito/carta response

    @midRunnable
    Scenario: execution nodoInoltraPagamentoEsitoCarta - PM_IEPC31
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest POST inoltroEsito/carta to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "RRN": 10724520,
                "identificativoPsp": "#psp#",
                "tipoVersamento": "CP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "esitoTransazioneCarta": "123456",
                "importoTotalePagato": 12.34,
                "timestampOperazione": "2012-04-23T18:25:43Z",
                "codiceAutorizzativo": "123212123"
            }
            """
        Then verify the HTTP status code of inoltroEsito/carta response is 422
        And check error is Codice autorizzativo invalido of inoltroEsito/carta response

