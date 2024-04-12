Feature: flow checks for verificaBollettino - EC old [TF_POSTE_02] 1349

    Background:
        Given systems up
        


    # verificaBollettinoReq phase
    Scenario: Execute verificaBollettino request
        Given initial XML paaVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
            <paaVerificaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>1.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200#ccPoste#</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>44444444444_05</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>paaVerificaRPT</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
            <pag:capBeneficiario>jyr</pag:capBeneficiario>
            <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>of8</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/019551233153100/TXT/</causaleVersamento>
            </datiPagamentoPA>
            </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        And initial XML verificaBollettino
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:verificaBollettinoReq>
                    <idPSP>#psp#</idPSP>
                    <idBrokerPSP>#psp#</idBrokerPSP>
                    <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                    <password>pwdpwdpwd</password>
                    <ccPost>#ccPoste#</ccPost>
                    <noticeNumber>#notice_number_old#</noticeNumber>
                </nod:verificaBollettinoReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And wait 5 seconds for expiration
        And checks the value #creditor_institution_code# of the record at column PA_FISCAL_CODE of the table VERIFICA_BOLLETTINO retrived by the query verifica_bollettino on db nodo_online under macro NewMod3


    # activatePaymentNoticeReq phase
    @runnable
    Scenario: Execute activatePaymentNotice request
        Given the Execute verificaBollettino request scenario executed successfully
        And initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                        <importoSingoloVersamento>10.00</importoSingoloVersamento>
                        <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
                        <enteBeneficiario>
                            <pag:identificativoUnivocoBeneficiario>
                            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
                            <pag:codiceIdentificativoUnivoco>#creditor_institution_code#</pag:codiceIdentificativoUnivoco>
                            </pag:identificativoUnivocoBeneficiario>
                            <pag:denominazioneBeneficiario>Pa Gabri</pag:denominazioneBeneficiario>
                        </enteBeneficiario>
                        <credenzialiPagatore>tizio caio</credenzialiPagatore>
                        <causaleVersamento>830903868663590</causaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        And initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
                <nod:activatePaymentNoticeReq>
                    <idPSP>#psp#</idPSP>
                    <idBrokerPSP>#psp#</idBrokerPSP>
                    <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
                    <password>pwdpwdpwd</password>
                    <qrCode>
                        <fiscalCode>#creditor_institution_code#</fiscalCode>
                        <noticeNumber>$verificaBollettino.noticeNumber</noticeNumber>
                    </qrCode>
                    <amount>10.00</amount>
                </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And checks the value IT45R0760103200000000001016 of the record at column IBAN of the table POSITION_TRANSFER retrived by the query position_transfer on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query position_payment on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3

