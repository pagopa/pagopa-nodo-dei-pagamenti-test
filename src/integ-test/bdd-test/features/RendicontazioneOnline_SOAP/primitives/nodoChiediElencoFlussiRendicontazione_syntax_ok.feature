Feature: Syntax checks OK for nodoChiediElencoFlussiRendicontazione

    Background:
        Given systems up
@runnable
    Scenario Outline: Syntax checks OK for nodoChiediElencoFlussiRendicontazione
            Given initial XML nodoChiediElencoFlussiRendicontazione
                """
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:nodoChiediElencoFlussiRendicontazione>
                        <identificativocreditor_institution_code>#creditor_institution_code#</identificativocreditor_institution_code>
                        <identificativoStazionecreditor_institution_code>#id_station#</identificativoStazionecreditor_institution_code>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                        <identificativoPSP>#psp#</identificativoPSP>
                    </ws:nodoChiediElencoFlussiRendicontazione>
                </soapenv:Body>
                </soapenv:Envelope>
                """
            And  <elem> with <value> in nodoChiediElencoFlussiRendicontazione
            When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
            Then check totRestituiti field exists in nodoChiediElencoFlussiRendicontazione response
            Examples:
            | elem                                                   | value                                    | soapUI test |
            | identificativoDominio                                  | None                                     | CEFRSIN16.1 |
            | identificativoPSP                                      | None                                     | CEFRSIN18   |