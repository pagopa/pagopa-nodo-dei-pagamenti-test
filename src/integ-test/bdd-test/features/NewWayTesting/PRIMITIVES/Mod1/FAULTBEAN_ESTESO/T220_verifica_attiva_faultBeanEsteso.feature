Feature: T220_verifica_attiva_faultBeanEsteso 214

    Background:
        Given systems up

    Scenario: Execute nodoVerificaRPT (Phase 1)
        Given update through the query param_update_in of the table INTERMEDIARI_PSP the parameter FAULT_BEAN_ESTESO with Y, with where condition OBJ_ID and where value ('16646') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                <codiceIdRPT>
                    <qrc:QrCode>
                        <qrc:CF>#creditor_institution_code#</qrc:CF>
                        <qrc:CodStazPA>02</qrc:CodStazPA>
                        <qrc:AuxDigit>0</qrc:AuxDigit>
                        <qrc:CodIUV>$1iuv</qrc:CodIUV>
                    </qrc:QrCode>
                </codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML paaVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:paaVerificaRPTRisposta>
                    <paaVerificaRPTRisposta>
                        <fault>
                        <faultCode>PPT_ERRORE_EMESSO_DA_PAA</faultCode>
                        <faultString>Errore restituito dalla PAA</faultString>
                        <id>#creditor_institution_code_old#</id>
                        </fault>
                        <esito>KO</esito>
                    </paaVerificaRPTRisposta>
                </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoVerificaRPT response
        And check originalFaultCode field exists in nodoVerificaRPT response
        And replace wrongFaultCode content with PAA_SOAPACTION content
        And check value $nodoVerificaRPTResponse.originalFaultCode is not equal to value $wrongFaultCode
        
@runnable
    Scenario: Execute nodoAttivaRPT (Phase 2)
        Given the Execute nodoVerificaRPT (Phase 1) scenario executed successfully
        And initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoAttivaRPT>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <codiceContestoPagamento>$nodoVerificaRPT.codiceContestoPagamento</codiceContestoPagamento>
                    <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
                    <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
                    <codificaInfrastrutturaPSP>$nodoVerificaRPT.codificaInfrastrutturaPSP</codificaInfrastrutturaPSP>
                    <codiceIdRPT>
                        <qrc:QrCode>
                            <qrc:CF>#creditor_institution_code#</qrc:CF>
                            <qrc:CodStazPA>02</qrc:CodStazPA>
                            <qrc:AuxDigit>0</qrc:AuxDigit>
                            <qrc:CodIUV>$1iuv</qrc:CodIUV>
                        </qrc:QrCode>
                    </codiceIdRPT>
                    <datiPagamentoPSP>
                        <importoSingoloVersamento>10.00</importoSingoloVersamento>
                        <!--Optional:-->
                        <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
                        <!--Optional:-->
                        <bicAppoggio>CCRTIT5TXXX</bicAppoggio>
                        <!--Optional:-->
                        <soggettoVersante>
                        <pag:identificativoUnivocoVersante>
                            <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
                            <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
                        </pag:identificativoUnivocoVersante>
                        <pag:anagraficaVersante>Franco Rossi</pag:anagraficaVersante>
                        <!--Optional:-->
                        <pag:indirizzoVersante>viale Monza</pag:indirizzoVersante>
                        <!--Optional:-->
                        <pag:civicoVersante>1</pag:civicoVersante>
                        <!--Optional:-->
                        <pag:capVersante>20125</pag:capVersante>
                        <!--Optional:-->
                        <pag:localitaVersante>Milano</pag:localitaVersante>
                        <!--Optional:-->
                        <pag:provinciaVersante>MI</pag:provinciaVersante>
                        <!--Optional:-->
                        <pag:nazioneVersante>IT</pag:nazioneVersante>
                        <!--Optional:-->
                        <pag:e-mailVersante>mail@mail.it</pag:e-mailVersante>
                        </soggettoVersante>
                        <!--Optional:-->
                        <ibanAddebito>IT96R0123454321000000012346</ibanAddebito>
                        <!--Optional:-->
                        <bicAddebito>CCRTIT2TXXX</bicAddebito>
                        <!--Optional:-->
                        <soggettoPagatore>
                        <pag:identificativoUnivocoPagatore>
                            <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
                            <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
                        </pag:identificativoUnivocoPagatore>
                        <pag:anagraficaPagatore>Franco Rossi</pag:anagraficaPagatore>
                        <!--Optional:-->
                        <pag:indirizzoPagatore>viale Monza</pag:indirizzoPagatore>
                        <!--Optional:-->
                        <pag:civicoPagatore>1</pag:civicoPagatore>
                        <!--Optional:-->
                        <pag:capPagatore>20125</pag:capPagatore>
                        <!--Optional:-->
                        <pag:localitaPagatore>Milano</pag:localitaPagatore>
                        <!--Optional:-->
                        <pag:provinciaPagatore>MI</pag:provinciaPagatore>
                        <!--Optional:-->
                        <pag:nazionePagatore>IT</pag:nazionePagatore>
                        <!--Optional:-->
                        <pag:e-mailPagatore>mail@mail.it</pag:e-mailPagatore>
                        </soggettoPagatore>
                    </datiPagamentoPSP>
                </ws:nodoAttivaRPT>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <fault>
            <faultCode>PAA_SEMANTICA_EXTRAXSD</faultCode>
            <faultString>errore semantico PA</faultString>
            <id>#creditor_institution_code#</id>
            <description>Errore semantico emesso dalla PA</description>
            </fault>
            <esito>KO</esito>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoAttivaRPT response
        And check originalFaultCode field exists in nodoAttivaRPT response
        And check id is #creditor_institution_code# of nodoAttivaRPT response
        And update through the query param_update_in of the table INTERMEDIARI_PSP the parameter FAULT_BEAN_ESTESO with N, with where condition OBJ_ID and where value ('16646') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds