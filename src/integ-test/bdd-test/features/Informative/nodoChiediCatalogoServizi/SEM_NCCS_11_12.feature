Feature: Semantic checks KO for nodoChiediCatalogoServizi 225
    Background:
        Given systems up


    @runnable
    Scenario: Check SEM_NCCS_11
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediCatalogoServizi>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And checks the value NotNone of the record at column ID_SERVIZIO of the table CDS_SERVIZIO retrived by the query cds_servizio on db nodo_cfg under macro informative
    
    @runnable
    Scenario: Check SEM_NCCS_12
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediCatalogoServizi>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <identificativoDominio>#intermediarioPA#</identificativoDominio>
            </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response