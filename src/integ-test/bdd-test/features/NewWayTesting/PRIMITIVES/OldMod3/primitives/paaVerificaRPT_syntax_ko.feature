Feature: Syntax checks KO for nodoAttivaRPT 1414
    Background:
        Given systems up
        And initial XML nodoVerificaRPT

        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale#</identificativoCanale>
                <password>pwd</password>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
                <codiceIdRPT><bc:BarCode>  <bc:Gln>#creditor_institution_code_secondary#</bc:Gln>  <!--<bc:CodStazPA>11</bc:CodStazPA>-->  <bc:AuxDigit>3</bc:AuxDigit>  <bc:CodIUV>11222222222222222</bc:CodIUV> </bc:BarCode> </codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
@runnable        
    Scenario: Execute nodoVerificaRPT [VRPTRES1]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <fault>
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <causaleVersamento>Prova</causaleVersamento>               
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES2]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <!--<fault>
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>
        -->
                    <esito>KO</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <causaleVersamento>Prova</causaleVersamento>               
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES3]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <fault>
                    <faultCode>CIAO</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>
                    <esito>KO</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <causaleVersamento>Prova</causaleVersamento>               
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES4]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <!--<fault>-->
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    <!--</fault>-->
                    <esito>KO</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <causaleVersamento>Prova</causaleVersamento>               
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES5]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <fault>
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>
                    <esito>SI</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <causaleVersamento>Prova</causaleVersamento>               
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES6]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <!--<fault>
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>-->
                    <esito>OK</esito>
                    <!--<datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <causaleVersamento>Prova</causaleVersamento>               
                    </datiPagamentoPA>-->
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES7]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <!--<fault>
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>-->
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento></importoSingoloVersamento>
                    <!--<causaleVersamento>Prova</causaleVersamento>-->
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response

@runnable
    Scenario: Execute nodoVerificaRPT [VRPTRES8]
        Given initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
                <paaVerificaRPTRisposta>
                    <!--<fault>
                    <faultCode>PAA_FIRMA_INDISPONIBILE</faultCode>
                    <faultString>Errore</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>-->
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>12</importoSingoloVersamento>
                    <!--<causaleVersamento>Prova</causaleVersamento>-->
                    </datiPagamentoPA>
                </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response