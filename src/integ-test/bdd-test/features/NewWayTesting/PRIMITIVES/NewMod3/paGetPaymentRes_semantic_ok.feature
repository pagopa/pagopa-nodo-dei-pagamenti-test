Feature: Semantic checks for paGetPaymentRes - OK 1383

	Background:
		Given systems up


	@ALL @PRIMITIVE @NM3 @NM3PAGPRSSEMOK @NM3PAGPRSSEMOK_1
	Scenario Outline: Check outcome OK on amount or fiscalCodePA of paGetPaymentRes different from paGetPaymentReq
		Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
			| idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
			| #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
		And from body with datatable vertical paGetPayment_full initial XML paGetPayment
			| outcome                     | OK                          |
			| creditorReferenceId         | 02$iuv                      |
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
		And <elem> with <tagvalue> in paGetPayment
		And <elem1> with <tagvalue> in paGetPayment
		And EC replies to nodo-dei-pagamenti with the paGetPayment
		When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
		Then check outcome is OK of activatePaymentNotice response
		Examples:
			| elem          | elem1          | tagvalue    | soapUI test |
			| paymentAmount | transferAmount | 8.00        | SEM_PGPR_01 |
			| fiscalCodePA  | -              | 44444444444 | SEM_PGPR_02 |