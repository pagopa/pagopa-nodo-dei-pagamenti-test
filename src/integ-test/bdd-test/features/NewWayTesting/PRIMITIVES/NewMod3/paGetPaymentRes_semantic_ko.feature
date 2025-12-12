Feature:  semantic checks for paGetPaymentRes - KO 1382

	Background:
		Given systems up


	@ALL @PRIMITIVE @NM3 @NM3PAGPRSSEMKO @NM3PAGPRSSEMKO_1
	#fiscalCodePA and IBAN check: fiscalCodePA and IBAN not in db, fiscalCodePA with field ENABLED = N, IBAN not associated to fiscalCodePa in NODO4_CFG.INFORMATIVE_CONTO_ACCREDITO_DETAIL table
	Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on non-existent or disabled body element value
		Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
			| idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
			| #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
		And from body with datatable vertical paGetPayment_full initial XML paGetPayment
			| outcome                     | OK                          |
			| creditorReferenceId         | $iuv                        |
			| paymentAmount               | 10.00                       |
			| dueDate                     | 2021-12-31                  |
			| description                 | pagamentoTest               |
			| entityUniqueIdentifierType  | G                           |
			| entityUniqueIdentifierValue | 77777777777                 |
			| fullName                    | Massimo Benvegnù            |
			| transferAmount              | 10.00                       |
			| fiscalCodePA                | 77777777777                 |
			| IBAN                        | IT45R0760103200000000001016 |
			| remittanceInformation       | testPaGetPayment            |
			| transferCategory            | paGetPaymentTest            |
		And <tag> with <tag_value> in paGetPayment
		And EC replies to nodo-dei-pagamenti with the paGetPayment
		When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
		Then check outcome is KO of activatePaymentNotice response
		And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
		Examples:
			| tag          | tag_value                   | soapUI test |
			| fiscalCodePA | 10000000000                 | SEM_PGPR_03 |
			| fiscalCodePA | 11111122222                 | SEM_PGPR_04 |
			| IBAN         | IT45R0760103200000000001015 | SEM_PGPR_05 |
			| IBAN         | IT45R0760103200666666666666 | SEM_PGPR_06 |