Feature: Semantic checks for nodoChiediElencoFlussiRendicontazione - KO

    Background:
        Given systems up

    Scenario Outline: Check semantic errors for nodoChiediElencoFlussiRendicontazione primitive
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header />
            <soapenv:Body>
                <ws:nodoChiediElencoFlussiRendicontazione>
                    <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#codicePA#</identificativoDominio>
                    <identificativoPSP>#psp#</identificativoPSP>
                </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
            
        And <elem> with <value> in nodoChiediElencoFlussiRendicontazione
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediElencoFlussiRendicontazione response
        Examples:
        | elem                                  | value                                                                     | error                               | soapUI test |
        | identificativoIntermediarioPA         | AkCoPcvzPHtx2JrK9DfUCZ4dqOC6R6wOG0EnMbBv8QNKzIVNkDuSASuFZlLbSH4ZcxXg35K   | PPT_INTERMEDIARIO_PA_SCONOSCIUTO    | CEFRSEM1    |
        | identificativoIntermediarioPA         | ID intermediario non abilitato                                            | PPT_INTERMEDIARIO_PA_DISABILITATO   | CEFRSEM2    |
        | identificativoStazioneIntermediarioPA | 92cvYLDIFx6581qfKvQTYrNpohOTwIakaeUvlQk188JbgXWEo0H2pirqynwvBo4qLplrwNj   | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | CEFRSEM3    |
        | identificativoStazioneIntermediarioPA | ID Stazione intermediario PA non abilitato                                | PPT_STAZIONE_INT_PA_DISABILITATA    | CEFRSEM4    |
        | password       ?                      | OORT3m3LtJVFlWTiFGciwDJkpiG2FjA6MLB4I9nVE3fZ1Sc4xV52Vt5jry1ASkpCnblprP7   | PPT_AUTENTICAZIONE                  | CEFRSEM5    | 
        | identificativoDominio                 | wPOR2CRbjdwhZ5IvWYXW6C12dKYSY6wRVS6rbZh4m6RZaeRIhTGpm62s6hG7v2UzrOT29DK   | PPT_DOMINIO_SCONOSCIUTO             | CEFRSEM6    | 
        | identificativoDominio                 | ID dominio non abilitato                                                  | PPT_DOMINIO_DISABILITATO            | CEFRSEM7    | 
        | identificativoPSP                     | swglUOCPZyrYI7JWo04rPONEgcf0arr1YPZ4tSzFkVpymetVrQ503D5PsnqaAQP12Sr8j4a   | PPT_PSP_SCONOSCIUTO                 | CEFRSEM8    | 
        | identificativoPSP                     | ID PSP non abilitato                                                      | PPT_PSP_DISABILITATO                | CEFRSEM9    | 
        | identificativoIntermediarioPA         | ID intermediario PA non autorizzato                                       | PPT_AUTORIZZAZIONE                  | CEFRSEM10   | 
