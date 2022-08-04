package eu.sia.nft.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import generazioneAvvisi.spcoop.nodopagamentispc.servizi.richiestaavvisi.GenerazioneAvvisi;
import generazioneAvvisi.ws.CtDatiPagamentoPA;
import generazioneAvvisi.ws.CtEsitoChiediNumeroAvviso;
import generazioneAvvisi.ws.CtNumeroAvviso;
import generazioneAvvisi.ws.PaaChiediNumeroAvviso;
import generazioneAvvisi.ws.PaaChiediNumeroAvvisoRisposta;
import generazioneAvvisi.ws.ppthead.IntestazionePPT;

public class GenerazioneAvvisi_I implements GenerazioneAvvisi {
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

}
