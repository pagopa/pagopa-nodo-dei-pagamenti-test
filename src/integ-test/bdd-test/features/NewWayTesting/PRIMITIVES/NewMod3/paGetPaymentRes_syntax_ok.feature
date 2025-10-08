Feature: Syntax checks for paGetPaymentRes - OK 1385

	Background:
		Given systems up


	@ALL @PRIMITIVE @NM3 @NM3PAGPRSSNTOK @NM3PAGPRSSNTOK_1
	Scenario Outline: Check paGetPayment response with missing optional fields
		Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
			| idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
			| #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
		And from body with datatable vertical paGetPayment_full initial XML paGetPayment
			| outcome                     | OK                          |
			| creditorReferenceId         | 02$iuv                      |
			| paymentAmount               | 10.00                       |
			| dueDate                     | 2021-12-31                  |
			| description                 | description                 |
			| entityUniqueIdentifierType  | G                           |
			| entityUniqueIdentifierValue | 77777777777                 |
			| fullName                    | Massimo Benvegnù            |
			| transferAmount              | 10.00                       |
			| fiscalCodePA                | #creditor_institution_code# |
			| IBAN                        | IT45R0760103200000000001016 |
			| remittanceInformation       | testPaGetPayment            |
			| transferCategory            | paGetPaymentTest            |
		And <elem> with <tagvalue> in paGetPayment
		And EC replies to nodo-dei-pagamenti with the paGetPayment
		When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
		Then check outcome is OK of activatePaymentNotice response
		Examples:
			| elem                | tagvalue | soapUI test  |
			| soapenv:Header      | None     | SIN_PGPR_01  |
			| retentionDate       | None     | SIN_PGPR_26  |
			| lastPayment         | None     | SIN_PGPR_29  |
			| companyName         | None     | SIN_PGPR_38  |
			| officeName          | None     | SIN_PGPR_41  |
			| streetName          | None     | SIN_PGPR_59  |
			| civicNumber         | None     | SIN_PGPR_62  |
			| postalCode          | None     | SIN_PGPR_65  |
			| city                | None     | SIN_PGPR_68  |
			| stateProvinceRegion | None     | SIN_PGPR_71  |
			| country             | None     | SIN_PGPR_74  |
			| e-mail              | None     | SIN_PGPR_78  |
			| metadata            | None     | SIN_PGPR_115 |