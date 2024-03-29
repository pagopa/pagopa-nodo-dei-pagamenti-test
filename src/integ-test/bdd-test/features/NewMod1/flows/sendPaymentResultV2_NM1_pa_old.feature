Feature: flow tests for sendPaymentResultV2

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
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

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
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
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

    Scenario: closePaymentV2 request
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: pspNotifyPayment timeout response
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <delay>10000</delay>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: pspNotifyPayment malformata response
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <outcome>OO</outcome>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: pspNotifyPayment KO response
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>CANALE_SEMANTICA</faultCode>
            <faultString>Errore semantico dal psp</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>Errore dal psp</description>
            </fault>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: pspNotifyPayment irraggiungibile response
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <irraggiungibile/>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: sendPaymentOutcome request
        Given initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
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
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # FLUSSO_SPR_01_IO_OLD

    Scenario: FLUSSO_SPR_01_IO_OLD (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # RPT
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoPSP of the record at column PSP of the table RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoIntermediarioPSP of the record at column INTERMEDIARIOPSP of the table RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PO of the record at column TIPO_VERSAMENTO of the table RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column DUE_DATE of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column INSERTED_BY of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column UPDATED_BY of the table POSITION_ACTIVATE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_SERVICE
        And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column INSERTED_BY of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column UPDATED_BY of the table POSITION_SERVICE retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_PLAN
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column INSERTED_BY of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT_PLAN retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoDominio of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_TRANSFER
        And checks the value NotNone of the record at column ID of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoDominio of the record at column PA_FISCAL_CODE_SECONDARY of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value IT45R0760103200000000001016 of the record at column IBAN of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column REMITTANCE_INFORMATION of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column TRANSFER_CATEGORY of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column TRANSFER_IDENTIFIER of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value Y of the record at column VALID of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value activatePaymentNoticeV2 of the record at column INSERTED_BY of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value nodoInviaRPT of the record at column UPDATED_BY of the table POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 4 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
    @test @dependentread @lazy 
    Scenario: FLUSSO_SPR_01_IO_OLD (part 2)
        Given the FLUSSO_SPR_01_IO_OLD (part 1) scenario executed successfully
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paInviaRt triggered after 5 seconds
        Then check outcome is OK of sendPaymentOutcome response
        And verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoDominio of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value 2 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_VERSAMENTI
        And checks the value NotNone of the record at column RT_VERSAMENTI.ID of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column PROGRESSIVO of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column IMPORTO_RT of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value ESEGUITO of the record at column RT_VERSAMENTI.ESITO of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column CAUSALE_VERSAMENTO of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column COMMISSIONE_APPLICATE_PSP of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_VERSAMENTI.INSERTED_TIMESTAMP of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_VERSAMENTI.UPDATED_TIMESTAMP of the table RT_VERSAMENTI JOIN RT ON RT_VERSAMENTI.FK_RT=RT.ID retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column METADATA of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoDominio of the record at column IDENT_DOMINIO of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column IUV of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_TRANSFER
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_TRANSFER of the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_TRANSFER JOIN POSITION_TRANSFER ON POSITION_TRANSFER.ID=POSITION_RECEIPT_TRANSFER.FK_POSITION_TRANSFER retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoDominio of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoDominio of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

    # T_SPR_V2_15
    @test @dependentread @lazy 
    Scenario: T_SPR_V2_15
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 4 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activatev2 on db re under macro NewMod1

    # T_SPR_V2_16

    Scenario: T_SPR_V2_16 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the pspNotifyPayment timeout response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
    @test @dependentread @lazy 
    Scenario: T_SPR_V2_16 (part 2)
        Given the T_SPR_V2_16 (part 1) scenario executed successfully
        And wait 12 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paInviaRt triggered after 5 seconds
        Then check outcome is OK of sendPaymentOutcome response
        And verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 7 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

    # T_SPR_V2_17

    Scenario: T_SPR_V2_17 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the pspNotifyPayment malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
    @test @dependentread @lazy 
    Scenario: T_SPR_V2_17 (part 2)
        Given the T_SPR_V2_17 (part 1) scenario executed successfully
        And wait 10 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paInviaRt triggered after 5 seconds
        Then check outcome is OK of sendPaymentOutcome response
        And verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 7 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

    # T_SPR_V2_18
    @test @dependentread @lazy 
    Scenario: T_SPR_V2_18
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the pspNotifyPayment KO response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        And job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activatePaymentNoticeV2Response.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

    # T_SPR_V2_19
    @test @dependentread @lazy 
    Scenario: T_SPR_V2_19
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the pspNotifyPayment irraggiungibile response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        And job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activatePaymentNoticeV2Response.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

    # T_SPR_V2_20

    Scenario: T_SPR_V2_20 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the pspNotifyPayment malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
    @test @dependentread @dependentwrite @lazy 
    Scenario: T_SPR_V2_20 (part 2)
        Given the T_SPR_V2_20 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 0 seconds
        And job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        And verify the HTTP status code of paInviaRt response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activatePaymentNoticeV2Response.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

    # T_SPR_V2_21

    Scenario: T_SPR_V2_21 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the activatePaymentNoticeV2 scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        And the pspNotifyPayment malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
    @test @dependentread @dependentwrite @lazy 
    Scenario: T_SPR_V2_21 (part 2)
        Given the T_SPR_V2_21 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        And job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        And verify the HTTP status code of paInviaRt response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activatePaymentNoticeV2Response.paymentToken
        And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
        And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

# i seguenti test sono commentati perché risultano essere validi soltanto in DEV, dove è presente il mock PM, al quale si può richiedere una response particolare della sendPaymentResult-v2 tramite manipolazione del transactionId nella closePayment-v2,
# mentre risultano essere out of scope in SIT, dove è presente il PM al quale non si può richiedere una response particolare per la sendPaymentResult-v2

# # T_SPR_V2_23

# Scenario: T_SPR_V2_23 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#
#     And the nodoInviaRPT scenario executed successfully
#
#     And the closePaymentV2 request scenario executed successfully
#     And transactionId with resSPR_2KO_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response

# Scenario: T_SPR_V2_23 (part 2)
#     Given the T_SPR_V2_23 (part 1) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcome request scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
#     And job paInviaRt triggered after 5 seconds
#     Then check outcome is OK of sendPaymentOutcome response
#     And verify the HTTP status code of paInviaRt response is 200
# @test
# Scenario: T_SPR_V2_23 (part 3)
#     Given the T_SPR_V2_23 (part 2) scenario executed successfully
#     When job positionRetrySendPaymentResult triggered after 65 seconds
#     Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
#     And wait 15 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_RETRY_SENDPAYMENTRESULT
#     # And verify 0 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

#     # STATI_RPT
#     And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

#     # STATI_RPT_SNAPSHOT
#     And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
#     And checking value $XML_RE.description is equal to value TPAY
#     And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
#     And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

# # T_SPR_V2_24

# Scenario: T_SPR_V2_24 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#
#     And the nodoInviaRPT scenario executed successfully
#
#     And the closePaymentV2 request scenario executed successfully
#     And transactionId with resSPR_400_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response

# Scenario: T_SPR_V2_24 (part 2)
#     Given the T_SPR_V2_24 (part 1) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcome request scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
#     And job paInviaRt triggered after 5 seconds
#     Then check outcome is OK of sendPaymentOutcome response
#     And verify the HTTP status code of paInviaRt response is 200
# @test
# Scenario: T_SPR_V2_24 (part 3)
#     Given the T_SPR_V2_24 (part 2) scenario executed successfully
#     When job positionRetrySendPaymentResult triggered after 65 seconds
#     Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
#     And wait 15 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_RETRY_SENDPAYMENTRESULT
#     And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value resSPR_400_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value $sessionToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

#     # STATI_RPT
#     And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

#     # STATI_RPT_SNAPSHOT
#     And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
#     And checking value $XML_RE.description is equal to value TPAY
#     And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
#     And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

# # T_SPR_V2_25

# Scenario: T_SPR_V2_25 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#
#     And the nodoInviaRPT scenario executed successfully
#
#     And the closePaymentV2 request scenario executed successfully
#     And transactionId with resSPR_404_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response

# Scenario: T_SPR_V2_25 (part 2)
#     Given the T_SPR_V2_25 (part 1) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcome request scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
#     And job paInviaRt triggered after 5 seconds
#     Then check outcome is OK of sendPaymentOutcome response
#     And verify the HTTP status code of paInviaRt response is 200
# @test
# Scenario: T_SPR_V2_25 (part 3)
#     Given the T_SPR_V2_25 (part 2) scenario executed successfully
#     When job positionRetrySendPaymentResult triggered after 65 seconds
#     Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
#     And wait 15 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_RETRY_SENDPAYMENTRESULT
#     And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value resSPR_404_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value $sessionToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

#     # STATI_RPT
#     And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

#     # STATI_RPT_SNAPSHOT
#     And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
#     And checking value $XML_RE.description is equal to value TPAY
#     And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
#     And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

# # T_SPR_V2_26

# Scenario: T_SPR_V2_26 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#
#     And the nodoInviaRPT scenario executed successfully
#
#     And the closePaymentV2 request scenario executed successfully
#     And transactionId with resSPR_408_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response

# Scenario: T_SPR_V2_26 (part 2)
#     Given the T_SPR_V2_26 (part 1) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcome request scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
#     And job paInviaRt triggered after 5 seconds
#     Then check outcome is OK of sendPaymentOutcome response
#     And verify the HTTP status code of paInviaRt response is 200
# @test
# Scenario: T_SPR_V2_26 (part 3)
#     Given the T_SPR_V2_26 (part 2) scenario executed successfully
#     When job positionRetrySendPaymentResult triggered after 65 seconds
#     Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
#     And wait 15 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_RETRY_SENDPAYMENTRESULT
#     And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value resSPR_408_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value $sessionToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

#     # STATI_RPT
#     And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

#     # STATI_RPT_SNAPSHOT
#     And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
#     And checking value $XML_RE.description is equal to value TPAY
#     And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
#     And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

# # T_SPR_V2_27

# Scenario: T_SPR_V2_27 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#
#     And the nodoInviaRPT scenario executed successfully
#
#     And the closePaymentV2 request scenario executed successfully
#     And transactionId with resSPR_422_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response

# Scenario: T_SPR_V2_27 (part 2)
#     Given the T_SPR_V2_27 (part 1) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcome request scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
#     And job paInviaRt triggered after 5 seconds
#     Then check outcome is OK of sendPaymentOutcome response
#     And verify the HTTP status code of paInviaRt response is 200
# @test
# Scenario: T_SPR_V2_27 (part 3)
#     Given the T_SPR_V2_27 (part 2) scenario executed successfully
#     When job positionRetrySendPaymentResult triggered after 65 seconds
#     Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
#     And wait 15 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_RETRY_SENDPAYMENTRESULT
#     And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value resSPR_422_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value $sessionToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

#     # STATI_RPT
#     And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

#     # STATI_RPT_SNAPSHOT
#     And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
#     And checking value $XML_RE.description is equal to value TPAY
#     And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
#     And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E

# # T_SPR_V2_28

# Scenario: T_SPR_V2_28 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#
#     And the nodoInviaRPT scenario executed successfully
#
#     And the closePaymentV2 request scenario executed successfully
#     And transactionId with resSPR_400_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response

# Scenario: T_SPR_V2_28 (part 2)
#     Given the T_SPR_V2_28 (part 1) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcome request scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
#     And job paInviaRt triggered after 5 seconds
#     Then check outcome is OK of sendPaymentOutcome response
#     And verify the HTTP status code of paInviaRt response is 200
# @test
# Scenario: T_SPR_V2_28 (part 3)
#     Given the T_SPR_V2_28 (part 2) scenario executed successfully
#     When job positionRetrySendPaymentResult triggered after 65 seconds
#     Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
#     And wait 15 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_number_from_iuv on db nodo_online under macro NewMod1

#     # POSITION_RETRY_SENDPAYMENTRESULT
#     And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value resSPR_400_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value $sessionToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

#     # STATI_RPT
#     And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

#     # STATI_RPT_SNAPSHOT
#     And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
#     And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
#     And checking value $XML_RE.description is equal to value TPAY
#     And checking value $XML_RE.fiscalCode is equal to value $nodoInviaRPT.identificativoDominio
#     And checking value $XML_RE.debtor is equal to value RCCGLD09P09H501E