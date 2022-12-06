T217_Quadrature
   Background:
      Given systems up

   Scenario: nodoChiediElencoQuadraturePA
        Given initial XML nodoChiediElencoQuadraturePA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediElencoQuadraturePA>
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                </ws:nodoChiediElencoQuadraturePA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
       
        When EC sends SOAP nodoChiediElencoQuadraturePA to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoChiediElencoQuadraturePA response
       