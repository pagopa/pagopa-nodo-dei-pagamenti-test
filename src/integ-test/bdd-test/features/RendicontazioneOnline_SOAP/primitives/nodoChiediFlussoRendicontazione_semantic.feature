Feature: Semantic checks for nodoChiediFlussoRendicontazione

    Background:
        Given systems up

    Scenario Outline: Check semantic errors for nodoChiediFlussoRendicontazione primitive
        Given initial XML nodoChiediFlussoRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header />
            <soapenv:Body>
            <ws:nodoChiediFlussoRendicontazione>
            <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#codicePA#</identificativoDominio>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
            </ws:nodoChiediFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """

        And <elem> with <value> in nodoChiediFlussoRendicontazione
        When EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediFlussoRendicontazione response
        Examples:
            | elem                                  | value                     | error                             | soapUI test |
            | identificativoIntermediarioPA         | ciaoIntermediarioPA       | PPT_INTERMEDIARIO_PA_SCONOSCIUTO  | CFRSEM1     |
            | identificativoIntermediarioPA         | INT_NOT_ENABLED           | PPT_INTERMEDIARIO_PA_DISABILITATO | CFRSEM2     |
            | identificativoStazioneIntermediarioPA | ciaoStazionePA            | PPT_STAZIONE_INT_PA_SCONOSCIUTA   | CFRSEM3     |
            | identificativoStazioneIntermediarioPA | 11111122222_01            | PPT_STAZIONE_INT_PA_DISABILITATA  | CFRSEM4     |
            | password                              | Password01                | PPT_AUTENTICAZIONE                | CFRSEM5     |
            | identificativoDominio                 | ciaoDominio               | PPT_DOMINIO_SCONOSCIUTO           | CFRSEM6     |
            | identificativoDominio                 | NOT_ENABLED               | PPT_DOMINIO_DISABILITATO          | CFRSEM7     |
            | identificativoPSP                     | ciaoPSP                   | PPT_PSP_SCONOSCIUTO               | CFRSEM8     |
            | identificativoPSP                     | NOT_ENABLED               | PPT_PSP_DISABILITATO              | CFRSEM9     |
            | identificativoFlusso                  | 2017-09-11idPsp1-pluto123 | PPT_ID_FLUSSO_SCONOSCIUTO         | CFRSEM10    |
            | identificativoDominio                 | 90000000001               | PPT_AUTORIZZAZIONE                | CFRSEM11    |



