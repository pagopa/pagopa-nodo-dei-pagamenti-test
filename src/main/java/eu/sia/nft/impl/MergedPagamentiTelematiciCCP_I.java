package eu.sia.nft.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Random;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import co.elastic.apm.api.ElasticApm;
import co.elastic.apm.api.Transaction;
import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtEntityUniqueIdentifier;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentOptionDescriptionPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentOptionsDescriptionListPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtSubject;
import merged.pagopa.pagopa_api.pa.pafornode.CtTransferListPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtTransferPA;
import merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentReq;
import merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentRes;
import merged.pagopa.pagopa_api.pa.pafornode.PaSendRTReq;
import merged.pagopa.pagopa_api.pa.pafornode.PaSendRTRes;
import merged.pagopa.pagopa_api.pa.pafornode.PaVerifyPaymentNoticeReq;
import merged.pagopa.pagopa_api.pa.pafornode.PaVerifyPaymentNoticeRes;
import merged.pagopa.pagopa_api.pa.pafornode.StAmountOption;
import merged.pagopa.pagopa_api.pa.pafornode.StEntityUniqueIdentifierType;
import merged.pagopa.pagopa_api.pa.pafornode.StOutcome;
import merged.ws.EsitoAttivaRPT;
import merged.ws.EsitoVerificaRPT;
import merged.ws.PaaAttivaRPT;
import merged.ws.PaaAttivaRPTRisposta;
import merged.ws.PaaTipoDatiPagamentoPA;
import merged.ws.PaaVerificaRPT;
import merged.ws.PaaVerificaRPTRisposta;
import merged.ws.ppthead.IntestazionePPT;
import pagopa.pagopa_api.pa.pafornode_wsdl.MergedPortType;

public class MergedPagamentiTelematiciCCP_I implements MergedPortType {
	final Logger logger = LogManager.getLogger(MergedPagamentiTelematiciCCP_I.class);
	Data d;

	// Specifico Activate
	CtSubject deb;
	Random rnd;
	ArrayList<String> PA_List;

	public MergedPagamentiTelematiciCCP_I() {
		logger.info("Starting");
		d = MainPA.d;

		// Specifico Activate
		PA_List = new ArrayList<String>(d.getPAList());
		rnd = new Random();
		deb = new CtSubject();
		CtEntityUniqueIdentifier id = new CtEntityUniqueIdentifier();
		id.setEntityUniqueIdentifierType(StEntityUniqueIdentifierType.F);
		id.setEntityUniqueIdentifierValue("fiscalCode");
		deb.setUniqueIdentifier(id);
		deb.setFullName("Stress");
		deb.setStreetName("NFT");
		deb.setCivicNumber("4");
		deb.setPostalCode("12345");
		deb.setCity("bububu");
		deb.setStateProvinceRegion("Ovunque");
		deb.setCountry("IT");
		deb.setEMail("mail@mail.it");

	}

	@Override
	public PaSendRTRes paSendRT(PaSendRTReq requestBody) {
		PaSendRTRes paSendRTRes = new PaSendRTRes();
		paSendRTRes.setOutcome(StOutcome.OK);
		logger.info("paSendRT -> " + requestBody.getReceipt().getReceiptId());
		return paSendRTRes;
	}

	@Override
	public PaVerifyPaymentNoticeRes paVerifyPaymentNotice(PaVerifyPaymentNoticeReq requestBody) {
		PaVerifyPaymentNoticeRes paVerifyPaymentNoticeRes = new PaVerifyPaymentNoticeRes();
		paVerifyPaymentNoticeRes.setOutcome(StOutcome.OK);
		CtPaymentOptionsDescriptionListPA list = new CtPaymentOptionsDescriptionListPA();
		CtPaymentOptionDescriptionPA objList = new CtPaymentOptionDescriptionPA();
		objList.setAmount(new BigDecimal(1).setScale(2, RoundingMode.HALF_EVEN));
		objList.setOptions(StAmountOption.EQ);
		objList.setAllCCP(true);
		list.getPaymentOptionDescription().add(objList);
		paVerifyPaymentNoticeRes.setPaymentList(list);
		paVerifyPaymentNoticeRes.setPaymentDescription("Megaditta");
		paVerifyPaymentNoticeRes.setFiscalCodePA(requestBody.getIdPA());
		paVerifyPaymentNoticeRes.setCompanyName("italpetrolcemetermotessilfarmometalchimica");
		logger.info("paVerifyPaymentNotice -> " + requestBody.getQrCode().getNoticeNumber());
		return paVerifyPaymentNoticeRes;
	}

	@Override
	public PaGetPaymentRes paGetPayment(PaGetPaymentReq requestBody) {
		PaGetPaymentRes paGetPaymentRes = new PaGetPaymentRes();
		paGetPaymentRes.setOutcome(StOutcome.OK);
		CtPaymentPA dat = new CtPaymentPA();
		dat.setCreditorReferenceId(requestBody.getQrCode().getNoticeNumber().substring(1));

		// check sui transfer
		int totAmout;
		try {
			totAmout = Integer.valueOf(requestBody.getPaymentNote());
		} catch (NumberFormatException n) {
			totAmout = 1;
		}
		dat.setPaymentAmount(new BigDecimal(totAmout).setScale(2, RoundingMode.HALF_EVEN));
		dat.setDueDate(requestBody.getDueDate());
		dat.setDescription("NFT Stress Test");
		// debtor
		dat.setDebtor(deb);

		// transferList
		CtTransferListPA ctTransferListPA = new CtTransferListPA();
		for (int i = 1; i <= totAmout; i++) {
			CtTransferPA ctTransferPA = new CtTransferPA();
			ctTransferPA.setIdTransfer(i);
			ctTransferPA.setTransferAmount(new BigDecimal(1).setScale(2, RoundingMode.HALF_EVEN));
			if (i == 1)
				ctTransferPA.setFiscalCodePA(requestBody.getQrCode().getFiscalCode());
			else
				ctTransferPA.setFiscalCodePA(getRandomPA(requestBody.getQrCode().getFiscalCode()));
			ctTransferPA.setIBAN("IT00R0000000000000000000000");
			ctTransferPA.setRemittanceInformation("remittanceInformation");
			ctTransferPA.setTransferCategory("Categoria");
			ctTransferListPA.getTransfer().add(ctTransferPA);
		}
		dat.setTransferList(ctTransferListPA);

		paGetPaymentRes.setData(dat);
		logger.info("paGetPayment -> " + requestBody.getQrCode().getNoticeNumber());
		return paGetPaymentRes;
	}

	String getRandomPA(String actual) {
		String tmp;
		while (actual.matches(tmp = PA_List.get(rnd.nextInt(PA_List.size())))) {
		}
		return tmp;
	}

	@Override
	public PaaVerificaRPTRisposta paaVerificaRPT(PaaVerificaRPT bodyrichiesta, IntestazionePPT header) {
		PaaVerificaRPTRisposta verificaResponse = new PaaVerificaRPTRisposta();
		EsitoVerificaRPT esito = new EsitoVerificaRPT();
		esito.setEsito("OK");

		PaaTipoDatiPagamentoPA value = new PaaTipoDatiPagamentoPA();
		value.setCausaleVersamento("Stress Test");
		value.setIbanAccredito("IT00R0000000000000000000000");
		value.setImportoSingoloVersamento(new BigDecimal(3).setScale(2, RoundingMode.HALF_EVEN));
		esito.setDatiPagamentoPA(value);
		verificaResponse.setPaaVerificaRPTRisposta(esito);
		logger.info("VerificaRPT -> " + header.getIdentificativoUnivocoVersamento() + "-" + bodyrichiesta.getIdentificativoPSP() + "-" + header.getIdentificativoDominio());
		return verificaResponse;
	}

	@Override
	public PaaAttivaRPTRisposta paaAttivaRPT(PaaAttivaRPT bodyrichiesta, IntestazionePPT header) {
		PaaAttivaRPTRisposta attivaResponse = new PaaAttivaRPTRisposta();
		EsitoAttivaRPT esito = new EsitoAttivaRPT();
		PaaTipoDatiPagamentoPA value = new PaaTipoDatiPagamentoPA();
		value.setCausaleVersamento("Stress Test");
		value.setIbanAccredito("IT00R0000000000000000000000");
		value.setImportoSingoloVersamento(new BigDecimal(3).setScale(2, RoundingMode.HALF_EVEN));
		esito.setDatiPagamentoPA(value);
		esito.setEsito("OK");
		attivaResponse.setPaaAttivaRPTRisposta(esito);
		logger.info("AttivaRPT -> " + header.getIdentificativoUnivocoVersamento() + "-" + bodyrichiesta.getIdentificativoPSP() + "-" + header.getIdentificativoDominio());
		return attivaResponse;
	}

}
