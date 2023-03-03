package eu.sia.nft.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;

import eu.sia.nodopa.merged.paaNodoNM4.CtDatiPagamentoPA;
import eu.sia.nodopa.merged.paaNodoNM4.CtEsitoChiediNumeroAvviso;
import eu.sia.nodopa.merged.paaNodoNM4.CtNumeroAvviso;
import eu.sia.nodopa.merged.paaNodoNM4.CtPaymentOptionDescriptionPA;
import eu.sia.nodopa.merged.paaNodoNM4.CtPaymentOptionsDescriptionListPA;
import eu.sia.nodopa.merged.paaNodoNM4.CtQrCode;
import eu.sia.nodopa.merged.paaNodoNM4.GenerazioneAvvisiMerged;
import eu.sia.nodopa.merged.paaNodoNM4.IntestazionePPT;
import eu.sia.nodopa.merged.paaNodoNM4.PaDemandPaymentNoticeRequest;
import eu.sia.nodopa.merged.paaNodoNM4.PaDemandPaymentNoticeResponse;
import eu.sia.nodopa.merged.paaNodoNM4.PaaChiediNumeroAvviso;
import eu.sia.nodopa.merged.paaNodoNM4.PaaChiediNumeroAvvisoRisposta;
import eu.sia.nodopa.merged.paaNodoNM4.StAmountOption;
import eu.sia.nodopa.merged.paaNodoNM4.StOutcome;

public class GenerazioneAvvisi_I implements GenerazioneAvvisiMerged {
	final Logger logger = LogManager.getLogger(GenerazioneAvvisi_I.class);
	Data d;
	PaaChiediNumeroAvvisoRisposta CNA_Response;

	public GenerazioneAvvisi_I() {
		logger.info("Starting");
		d = MainPA.d;
		CNA_Response = new PaaChiediNumeroAvvisoRisposta();

	}

	@Override
	public PaaChiediNumeroAvvisoRisposta paaChiediNumeroAvviso(PaaChiediNumeroAvviso bodyrichiesta, IntestazionePPT header) {
		CtEsitoChiediNumeroAvviso esito = new CtEsitoChiediNumeroAvviso();
		esito.setEsito("OK");
		CtNumeroAvviso numeroA = new CtNumeroAvviso();
		numeroA.setAuxDigit("1");
		numeroA.setIUV("12345678904567890");
		esito.setNumeroAvviso(numeroA);
		CtDatiPagamentoPA datiPagamento = new CtDatiPagamentoPA();
		datiPagamento.setIbanAccredito("IT00R0000000000000000000000");
		datiPagamento.setImportoSingoloVersamento(new BigDecimal(3).setScale(2, RoundingMode.HALF_EVEN));
		datiPagamento.setCausaleVersamento("Stress Test");
		esito.setDatiPagamentoPA(datiPagamento);
		CNA_Response.setPaaChiediNumeroAvvisoRisposta(esito);
		logger.info("CNA -> " + bodyrichiesta.getIdentificativoPSP() + "-" + header.getIdentificativoDominio());
		return CNA_Response;
	}

	@Override
	public PaDemandPaymentNoticeResponse paDemandPaymentNotice(PaDemandPaymentNoticeRequest requestBody) {
		PaDemandPaymentNoticeResponse res = new PaDemandPaymentNoticeResponse();
		res.setOutcome(StOutcome.OK);
		CtQrCode qrC = new CtQrCode();
		qrC.setFiscalCode(requestBody.getIdPA());
		qrC.setNoticeNumber(getRandomNotNum());
		res.setQrCode(qrC);
		res.setPaymentDescription("PerfTest");
		res.setFiscalCodePA(requestBody.getIdPA());
		res.setCompanyName("italpetrolcemetermotessilfarmometalchimica");
		res.setOfficeName("Ufficio impiegati scomparsi");
		CtPaymentOptionsDescriptionListPA list = new CtPaymentOptionsDescriptionListPA();
		CtPaymentOptionDescriptionPA objList = new CtPaymentOptionDescriptionPA();
		objList.setAmount(new BigDecimal(1).setScale(2, RoundingMode.HALF_EVEN));
		objList.setOptions(StAmountOption.EQ);
		list.setPaymentOptionDescription(objList);
		res.setPaymentList(list);
		return res;
	}

	String getRandomNotNum() {
		return "311" + RandomStringUtils.randomNumeric(15);
	}
}
