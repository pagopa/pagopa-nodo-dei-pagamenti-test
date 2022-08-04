package eu.sia.nft.impl;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import rt.gov.telematici.pagamenti.ws.EsitoPaaInviaRT;
import rt.gov.telematici.pagamenti.ws.PaaInviaRT;
import rt.gov.telematici.pagamenti.ws.PaaInviaRTRisposta;
import rt.gov.telematici.pagamenti.ws.TipoInviaEsitoStornoRisposta;
import rt.gov.telematici.pagamenti.ws.TipoInviaRichiestaRevocaRisposta;
import rt.gov.telematici.pagamenti.ws.ppthead.IntestazionePPT;
import rt.spcoop.nodopagamentispc.servizi.pagamentitelematicirt.PagamentiTelematiciRT;

public class PagamentiTelematiciRT_I implements PagamentiTelematiciRT {
	final Logger logger = LogManager.getLogger(PagamentiTelematiciRT_I.class);
	PaaInviaRTRisposta paaInviaRTRisposta;
	EsitoPaaInviaRT esitoPaaInviaRT;
	Data d;

	public PagamentiTelematiciRT_I() {
		logger.info("Starting");
		d = MainPA.d;
		paaInviaRTRisposta = new PaaInviaRTRisposta();
		esitoPaaInviaRT = new EsitoPaaInviaRT();
	}

	@Override
	public PaaInviaRTRisposta paaInviaRT(PaaInviaRT bodyrichiesta, IntestazionePPT header) {
		paaInviaRTRisposta = new PaaInviaRTRisposta();
		esitoPaaInviaRT = new EsitoPaaInviaRT();
		esitoPaaInviaRT.setEsito("OK");
		paaInviaRTRisposta.setPaaInviaRTRisposta(esitoPaaInviaRT);
		logger.info("InviaRT -> " + header.getIdentificativoUnivocoVersamento() + "-" + header.getIdentificativoDominio());
		return paaInviaRTRisposta;
	}

	@Override
	public TipoInviaRichiestaRevocaRisposta paaInviaRichiestaRevoca(String identificativoDominio, String identificativoUnivocoVersamento, String codiceContestoPagamento, byte[] rr) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TipoInviaEsitoStornoRisposta paaInviaEsitoStorno(String identificativoIntermediarioPA, String identificativoStazioneIntermediarioPA, String identificativoDominio,
			String identificativoUnivocoVersamento, String codiceContestoPagamento, byte[] er) {
		// TODO Auto-generated method stub
		return null;
	}

}
