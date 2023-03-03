package eu.sia.nft.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Random;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeConstants;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtEntityUniqueIdentifier;
import merged.pagopa.pagopa_api.pa.pafornode.CtMapEntry;
import merged.pagopa.pagopa_api.pa.pafornode.CtMetadata;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentOptionDescriptionPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentOptionsDescriptionListPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtPaymentPAV2;
import merged.pagopa.pagopa_api.pa.pafornode.CtSubject;
import merged.pagopa.pagopa_api.pa.pafornode.CtTransferListPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtTransferListPAV2;
import merged.pagopa.pagopa_api.pa.pafornode.CtTransferPA;
import merged.pagopa.pagopa_api.pa.pafornode.CtTransferPAV2;
import merged.pagopa.pagopa_api.pa.pafornode.EsitoAttivaRPT;
import merged.pagopa.pagopa_api.pa.pafornode.EsitoVerificaRPT;
import merged.pagopa.pagopa_api.pa.pafornode.IntestazionePPT;
import merged.pagopa.pagopa_api.pa.pafornode.PaDemandPaymentNoticeRequest;
import merged.pagopa.pagopa_api.pa.pafornode.PaDemandPaymentNoticeResponse;
import merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentReq;
import merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentRes;
import merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentV2Request;
import merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentV2Response;
import merged.pagopa.pagopa_api.pa.pafornode.PaSendRTReq;
import merged.pagopa.pagopa_api.pa.pafornode.PaSendRTRes;
import merged.pagopa.pagopa_api.pa.pafornode.PaSendRTV2Request;
import merged.pagopa.pagopa_api.pa.pafornode.PaSendRTV2Response;
import merged.pagopa.pagopa_api.pa.pafornode.PaVerifyPaymentNoticeReq;
import merged.pagopa.pagopa_api.pa.pafornode.PaVerifyPaymentNoticeRes;
import merged.pagopa.pagopa_api.pa.pafornode.PaaAttivaRPT;
import merged.pagopa.pagopa_api.pa.pafornode.PaaAttivaRPTRisposta;
import merged.pagopa.pagopa_api.pa.pafornode.PaaTipoDatiPagamentoPA;
import merged.pagopa.pagopa_api.pa.pafornode.PaaVerificaRPT;
import merged.pagopa.pagopa_api.pa.pafornode.PaaVerificaRPTRisposta;
import merged.pagopa.pagopa_api.pa.pafornode.StAmountOption;
import merged.pagopa.pagopa_api.pa.pafornode.StEntityUniqueIdentifierType;
import merged.pagopa.pagopa_api.pa.pafornode.StOutcome;

public class MergedPagamentiTelematiciCCP_I implements merged.pagopa.pagopa_api.pa.pafornode.PaForNode {
	final Logger logger = LogManager.getLogger(MergedPagamentiTelematiciCCP_I.class);
	Data d;

	// Specifico Activate
	CtSubject deb;
	Random rnd;
	ArrayList<String> PA_List;

	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

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
		list.setPaymentOptionDescription(objList);
		paVerifyPaymentNoticeRes.setPaymentList(list);
		paVerifyPaymentNoticeRes.setPaymentDescription("Megaditta");
		paVerifyPaymentNoticeRes.setFiscalCodePA(requestBody.getIdPA());
		paVerifyPaymentNoticeRes.setCompanyName("italpetrolcemetermotessilfarmometalchimica");
		logger.info("paVerifyPaymentNotice -> " + requestBody.getQrCode().getNoticeNumber());
		return paVerifyPaymentNoticeRes;
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
		logger.info("VerificaRPT -> " + header.getIdentificativoUnivocoVersamento() + "-"
				+ bodyrichiesta.getIdentificativoPSP() + "-" + header.getIdentificativoDominio());
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
		logger.info("AttivaRPT -> " + header.getIdentificativoUnivocoVersamento() + "-"
				+ bodyrichiesta.getIdentificativoPSP() + "-" + header.getIdentificativoDominio());
		return attivaResponse;
	}

	@Override
	public PaDemandPaymentNoticeResponse paDemandPaymentNotice(PaDemandPaymentNoticeRequest requestBody) {
		PaDemandPaymentNoticeResponse res = new PaDemandPaymentNoticeResponse();
//		res.setOutcome(StOutcome.OK);
//		CtQrCode qrC = new CtQrCode();
//		qrC.setFiscalCode(requestBody.getIdPA());
//		qrC.setNoticeNumber(getRandomNotNum());
//		res.setQrCode(qrC);
//		res.setPaymentDescription("PerfTest");
//		res.setFiscalCodePA(requestBody.getIdPA());
//		res.setCompanyName("italpetrolcemetermotessilfarmometalchimica");
//		res.setOfficeName("Ufficio impiegati scomparsi");
//		CtPaymentOptionsDescriptionListPA list = new CtPaymentOptionsDescriptionListPA();
//		CtPaymentOptionDescriptionPA objList = new CtPaymentOptionDescriptionPA();
//		objList.setAmount(new BigDecimal(1).setScale(2, RoundingMode.HALF_EVEN));
//		objList.setOptions(StAmountOption.EQ);
//		list.setPaymentOptionDescription(objList);
//		res.setPaymentList(list);
		return res;
	}

	String getRandomNotNum() {
		return "311" + RandomStringUtils.randomNumeric(15);
	}

	@Override
	public PaSendRTV2Response paSendRTV2(PaSendRTV2Request requestBody) {
		PaSendRTV2Response paSendRTRes = new PaSendRTV2Response();
		paSendRTRes.setOutcome(StOutcome.OK);
		logger.info("paSendRTV2 -> " + requestBody.getReceipt().getReceiptId());
		return paSendRTRes;
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

	@Override
	public PaGetPaymentV2Response paGetPaymentV2(PaGetPaymentV2Request requestBody) {
		try {
			PaGetPaymentV2Response res = new PaGetPaymentV2Response();
			// check sui transfer
			int totAmout;
			try {
				totAmout = Integer.valueOf(requestBody.getPaymentNote().split("_")[0]);
			} catch (NumberFormatException n) {
				totAmout = 1;
			}
			// check metadati
			boolean meta = false;
			try {
				if (requestBody.getPaymentNote().split("_")[1].toLowerCase().matches("m")) {
					meta = true;
				}
			} catch (NullPointerException n) {
				meta = false;
				logger.warn("Tag metadata not found in payment note");
			}
			res.setOutcome(StOutcome.OK);
			CtPaymentPAV2 data = new CtPaymentPAV2();
			data.setCreditorReferenceId(requestBody.getQrCode().getNoticeNumber().substring(1));
			data.setPaymentAmount(new BigDecimal(totAmout).setScale(2, RoundingMode.HALF_EVEN));
			GregorianCalendar cal = new GregorianCalendar();
			XMLGregorianCalendar xmlDate;
			try {
				xmlDate = DatatypeFactory.newInstance().newXMLGregorianCalendarDate(cal.get(Calendar.YEAR),
						cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH), DatatypeConstants.FIELD_UNDEFINED);
			} catch (DatatypeConfigurationException e) {
				logger.error("Errore in generazione data");
				xmlDate = null;
			}
			data.setDueDate(xmlDate);
			CtSubject deb = new CtSubject();
			deb.setFullName("Stress Test");
			CtEntityUniqueIdentifier ui = new CtEntityUniqueIdentifier();
			ui.setEntityUniqueIdentifierType(StEntityUniqueIdentifierType.G);
			ui.setEntityUniqueIdentifierValue("44444444444");
			deb.setUniqueIdentifier(ui);
			data.setDebtor(deb);
			data.setDescription("Perf Test");

			// transferList
			CtTransferListPAV2 ctTransferListPA = new CtTransferListPAV2();
			for (int i = 1; i <= totAmout; i++) {
				CtTransferPAV2 ctTransferPA = new CtTransferPAV2();
				ctTransferPA.setIdTransfer(i);
				ctTransferPA.setTransferAmount(new BigDecimal(1).setScale(2, RoundingMode.HALF_EVEN));
				if (i == 1)
					ctTransferPA.setFiscalCodePA(requestBody.getQrCode().getFiscalCode());
				else
					ctTransferPA.setFiscalCodePA(getRandomPA(requestBody.getQrCode().getFiscalCode()));
				ctTransferPA.setIBAN("IT00R0000000000000000000000");
				ctTransferPA.setRemittanceInformation("remittanceInformation");
				ctTransferPA.setTransferCategory("Categoria");
				if (meta) {
					CtMetadata mDataTr = new CtMetadata();
					CtMapEntry mETr = new CtMapEntry();
					mETr.setKey("kTrA");
					mETr.setValue("vTrA");
					mDataTr.getMapEntry().add(mETr);
					mETr = new CtMapEntry();
					mETr.setKey("kTrB");
					mETr.setValue("vTrB");
					mDataTr.getMapEntry().add(mETr);
					ctTransferPA.setMetadata(mDataTr);
				}
				ctTransferListPA.getTransfer().add(ctTransferPA);
			}
			data.setTransferList(ctTransferListPA);

			// metadata
			if (meta) {
				CtMetadata mData = new CtMetadata();
				CtMapEntry mE = new CtMapEntry();
				mE.setKey("kA");
				mE.setValue("vA");
				mData.getMapEntry().add(mE);
				mE = new CtMapEntry();
				mE.setKey("kB");
				mE.setValue("vB");
				mData.getMapEntry().add(mE);
				data.setMetadata(mData);
			}

			res.setData(data);
			logger.info("paGetPaymentV2 -> " + requestBody.getQrCode().getNoticeNumber());
			return res;
		} catch (Exception e) {
			logger.error("Eccezione in MergedPagamentiTelematiciCCP_I: " + e.getMessage(), e);
			throw e;
		}
	}

}
