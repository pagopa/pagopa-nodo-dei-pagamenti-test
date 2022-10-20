Feature: Syntax checks OK for nodoChiediElencoFlussiRendicontazione

    Background:
        Given systems up
    @runnable
    Scenario Outline: Syntax checks OK for nodoChiediElencoFlussiRendicontazione
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/ciao/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ws:nodoChiediElencoFlussiRendicontazione />
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoChiediElencoFlussiRendicontazione>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And  <elem> with <value> in nodoChiediElencoFlussiRendicontazione
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediElencoFlussiRendicontazione response
        Examples:
            | elem                  | value | soapUI test |
            | identificativoDominio | None  | CEFRSIN16.1 |
            | identificativoPSP     | None  | CEFRSIN18   |