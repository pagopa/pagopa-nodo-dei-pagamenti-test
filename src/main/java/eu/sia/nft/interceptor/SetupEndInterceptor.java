package eu.sia.nft.interceptor;

import java.util.concurrent.ExecutorService;

import javax.xml.namespace.QName;

import org.apache.cxf.message.Message;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.workers.SendToQueue;
import merged.pagopa.pagopa_api.pa.pafornode.IntestazionePPT;

public class SetupEndInterceptor extends AbstractPhaseInterceptor<Message> {

	private ExecutorService executors;
	private static final Logger logger = LogManager.getLogger(SetupEndInterceptor.class);

	public SetupEndInterceptor(ExecutorService executorService) {
		super(Phase.SETUP_ENDING);
		this.executors = executorService;
	}

	@Override
	public void handleMessage(Message message) {
		// GESTIONE SECONDA ATTIVA PER TOKEN SCADUTO
		if (message.getExchange().getInMessage().getContent(java.util.List.class).get(0).toString()
				.startsWith("merged.pagopa.pagopa_api.pa.pafornode.merged.ws.PaaAttiva")) {
			IntestazionePPT intestazionePPT = (IntestazionePPT) message.getExchange().getInMessage()
					.getContent(java.util.List.class).get(1);
			logger.trace("IntestazionePPT is: " + intestazionePPT);
			// se nullo ritorno, non mi interessa
			if (intestazionePPT == null)
				return;
			String action = ((QName) message.get(Message.WSDL_OPERATION)).toString();
			logger.trace("Action is: " + action);
			// send su coda delle info che servono
			String ccp = intestazionePPT.getCodiceContestoPagamento();
			if (ccp.indexOf("-v2") > -1) {
				// stringa da salvare
				String tmp_ts = intestazionePPT.getIdentificativoDominio() + ","
						+ intestazionePPT.getIdentificativoIntermediarioPA() + ","
						+ intestazionePPT.getIdentificativoStazioneIntermediarioPA() + ","
						+ intestazionePPT.getCodiceContestoPagamento() + ","
						+ intestazionePPT.getIdentificativoUnivocoVersamento();
				executors.submit(new SendToQueue(tmp_ts));
			}
		}
	}
}
