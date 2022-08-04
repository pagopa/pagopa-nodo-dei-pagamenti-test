package eu.sia.nft;

import java.util.ArrayList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.services.GenerazioneAvvisi_S;
import eu.sia.nft.services.MergedPagamentiTelematici_S;
import eu.sia.nft.services.PagamentiTelematiciRT_S;
import eu.sia.nft.workers.ClientRPT_TokenScad;

public class MainPA {
	private static final Logger logger = LogManager.getLogger(MainPA.class);
	public static Data d;

	public static void main(String[] args) {
		logger.info("Starting");
		d = new Data(args);

		logger.debug("Init Services");
		new GenerazioneAvvisi_S().init();
		new PagamentiTelematiciRT_S().init();
		new MergedPagamentiTelematici_S().init();

		if (d.getP().getProperty("enableRPTv2", "false").matches("true")) {
			try {
				logger.debug("Creating " + d.getP().getProperty("rptWorkerNumber", "1") + " RPT Client. EP: " + d.getP().getProperty("rptEndPoint"));
				ArrayList<ClientRPT_TokenScad> clList = new ArrayList<ClientRPT_TokenScad>();
				for (int i = 0; i < Integer.valueOf(d.getP().getProperty("rptWorkerNumber", "1")); i++) {
					clList.add(new ClientRPT_TokenScad(i));
				}
				for (ClientRPT_TokenScad c : clList) {
					c.start();
				}
			} catch (NullPointerException n) {
				logger.error("Invalid configuration", n);
				System.exit(0);
			}

		}

	}
}
