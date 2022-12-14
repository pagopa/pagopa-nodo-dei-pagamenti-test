Feature: T105_ChiediListaPendentiRPT_soloObbligatori
   Background:
        Given systems up

@midRunnable        
    Scenario: Execute nodoChiediListaPendentiRPT request
        Given initial XML nodoChiediListaPendentiRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediListaPendentiRPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <!--identificativoDominio>#creditor_institution_code#</identificativoDominio-->
                <rangeDa>#yesterday_date#</rangeDa>
                <rangeA>#timedate#</rangeA>
                <dimensioneLista>5</dimensioneLista>
            </ws:nodoChiediListaPendentiRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediListaPendentiRPT response
        And check listaRPTPendenti field exists in nodoChiediListaPendentiRPT response
        And check identificativoUnivocoVersamento field exists in nodoChiediListaPendentiRPT response
        #And checks identificativoDominio contains #creditor_institution_code# of nodoChiediListaPendentiRPT response
        #And checks identificativoUnivocoVersamento contains $iuv of nodoChiediListaPendentiRPT response