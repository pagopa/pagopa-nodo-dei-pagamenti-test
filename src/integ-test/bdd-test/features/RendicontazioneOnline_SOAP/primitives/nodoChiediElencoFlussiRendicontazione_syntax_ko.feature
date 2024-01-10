Feature: Syntax checks for nodoChiediElencoFlussiRendicontazione - KO 1439

    Background:
        Given systems up

    @flusso
    #[CEFRSIN0]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
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
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check faultString is Errore di sintassi extra XSD. of nodoChiediElencoFlussiRendicontazione response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediElencoFlussiRendicontazione response
        And check description is Errore validazione XML [Envelope] - cvc-elt.1.a: impossibile trovare la dichiarazione dell'elemento "soapenv:Envelope". of nodoChiediElencoFlussiRendicontazione response

    @flusso
    #[CEFRSIN1]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediElencoFlussiRendicontazione primitive
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:nodoChiediElencoFlussiRendicontazione />
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
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check faultString is Errore di sintassi extra XSD. of nodoChiediElencoFlussiRendicontazione response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediElencoFlussiRendicontazione response

    @flusso
    #[CEFRSIN3]
    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediElencoFlussiRendicontazione primitive
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
            <soapenv:Header />
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check faultString is Errore di sintassi extra XSD. of nodoChiediElencoFlussiRendicontazione response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediElencoFlussiRendicontazione response

    
    @flusso
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediElencoFlussiRendicontazione primitive
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediElencoFlussiRendicontazione>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <elem> with <value> in nodoChiediElencoFlussiRendicontazione
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check faultString is Errore di sintassi extra XSD. of nodoChiediElencoFlussiRendicontazione response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediElencoFlussiRendicontazione response
        Examples:
            | elem                                     | value                                | soapUI test |
            | soapenv:Body                             | Empty                                | CEFRSIN2    |
            | ws:nodoChiediElencoFlussiRendicontazione | Empty                                | CEFRSIN4    |
            | identificativoIntermediarioPA            | None                                 | CEFRSIN6    |
            | identificativoIntermediarioPA            | Empty                                | CEFRSIN7    |
            | identificativoIntermediarioPA            | dbcFkSRY15k6mEaIVGoki0OcZKyVboNtjndJ | CEFRSIN8    |
            | identificativoStazioneIntermediarioPA    | None                                 | CEFRSIN9    |
            | identificativoStazioneIntermediarioPA    | Empty                                | CEFRSIN10   |
            | identificativoStazioneIntermediarioPA    | k91JETYVnE7grIIKbzWE6Di7XKM3ymJeawhf | CEFRSIN11   |
            | password                                 | None                                 | CEFRSIN12   |
            | password                                 | Empty                                | CEFRSIN13   |
            | password                                 | Xlve3Jc                              | CEFRSIN14   |
            | password                                 | xxkV8x4phzRKyiuE                     | CEFRSIN15   |

    @flusso
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediElencoFlussiRendicontazione primitive
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediElencoFlussiRendicontazione>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoPSP>#psp#</identificativoPSP>
            </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <elem> with <value> in nodoChiediElencoFlussiRendicontazione
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check faultString is Errore di sintassi extra XSD. of nodoChiediElencoFlussiRendicontazione response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediElencoFlussiRendicontazione response
        Examples:
            | elem                  | value                                | soapUI test |
            | identificativoDominio | Empty                                | CEFRSIN16   |
            | identificativoDominio | pRJRvRYYpkxm6thxNaE8hxKtry5wULdLAq8X | CEFRSIN17   |
            | identificativoPSP     | Empty                                | CEFRSIN19   |
            | identificativoPSP     | qHtFhwjP3lTEs5SmYehnnK5aEZaAD1vqQukR | CEFRSIN20   |
