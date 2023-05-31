Feature: revision checks for sendPaymentOutcomeV2

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
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
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>$activatePaymentNoticeV2.amount</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>#broker_AGID#</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>#canale_AGID_02#</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: nodoInviaRPT
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>11</pay_i:civicoVersante>
            <pay_i:capVersante>00186</pay_i:capVersante>
            <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
            <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
            <pay_i:capPagatore>00186</pay_i:capPagatore>
            <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
            <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>$activatePaymentNoticeV2.amount</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeV2Response.paymentToken</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>$activatePaymentNoticeV2.amount</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$activatePaymentNoticeV2Response.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_02#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    Scenario: closePaymentV2
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "10793459"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: sendPaymentOutcomeV2
        Given initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            </paymentTokens>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>postal</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # SEM_SPO_7.1
    @test @independent 
    Scenario: SEM_SPO_7.1
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    # SEM_SPO_21
    @test @dependentread @lazy 
    Scenario: SEM_SPO_21
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

    # SEM_SPO_23

    Scenario: SEM_SPO_23 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test @independent 
    Scenario: SEM_SPO_23 (part 2)
        Given the SEM_SPO_23 (part 1) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response

    # SEM_SPO_23.1

    Scenario: SEM_SPO_23.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test @independent 
    Scenario: SEM_SPO_23.1 (part 2)
        Given the SEM_SPO_23.1 (part 1) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response

    # SEM_SPO_28
    @test @independent 
    Scenario: SEM_SPO_28
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And outcome with KO in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome KO non accettabile of sendPaymentOutcomeV2 response

    # SEM_SPO_29
    @test @independent 
    Scenario: SEM_SPO_29
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And fee with 3.00 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response

    # SEM_SPO_31
    @test @dependentwrite 
    Scenario: SEM_SPO_31
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 311011451292109621 under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        And updates through the query update_noticeidrandom of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 002$iuv under macro NewMod1 on db nodo_online
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO of sendPaymentOutcomeV2 response

    # SEM_SPO_32
    @test @dependentwrite 
    Scenario: SEM_SPO_32
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response

    # SEM_SPO_33
    @test @dependentwrite 
    Scenario: SEM_SPO_33
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_ACCEPTED under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    # SEM_SPO_33.1
    @test @dependentread 
    Scenario: SEM_SPO_33.1
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_UNKNOWN under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 0 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1

    # SEM_SPO_35.1
    @test @dependentwrite 
    Scenario: SEM_SPO_35.1
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_STATUS_SNAPSHOT the parameter ACTIVATION_PENDING with Y under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.2
    @test @dependentwrite 
    Scenario: SEM_SPO_35.2
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYING under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Payment sconosciuto of sendPaymentOutcomeV2 response

    # SEM_SPO_35.4
    @test @dependentwrite 
    Scenario: SEM_SPO_35.4
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SENT under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Payment sconosciuto of sendPaymentOutcomeV2 response

    # SEM_SPO_35.5
    @test @dependentwrite 
    Scenario: SEM_SPO_35.5
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SEND_ERROR under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Payment sconosciuto of sendPaymentOutcomeV2 response

    # SEM_SPO_35.6
    @test @dependentwrite 
    Scenario: SEM_SPO_35.6
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_REFUSED under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Payment sconosciuto of sendPaymentOutcomeV2 response

    # SEM_SPO_36
    @test @dependentwrite 
    Scenario: SEM_SPO_36
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

    # SEM_SPO_36.1
    @test @dependentwrite 
    Scenario: SEM_SPO_36.1
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And updates through the query update_notice_number_from_iuv of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response