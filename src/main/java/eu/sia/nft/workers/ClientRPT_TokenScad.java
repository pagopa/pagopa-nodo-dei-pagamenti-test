package eu.sia.nft.workers;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.jms.JMSException;
import javax.jms.MessageConsumer;
import javax.jms.MessageNotWriteableException;
import javax.jms.MessageProducer;
import javax.xml.ws.WebServiceException;

import org.apache.activemq.command.ActiveMQTextMessage;
import org.apache.cxf.configuration.jsse.TLSClientParameters;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.frontend.ClientProxy;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;
import org.apache.cxf.transport.http.HTTPConduit;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import eu.sia.nft.RptModel;
import nodo.gov.telematici.pagamenti.ws.NodoInviaRPT;
import nodo.gov.telematici.pagamenti.ws.NodoInviaRPTRisposta;
import nodo.gov.telematici.pagamenti.ws.ppthead.IntestazionePPT;
import nodo.it.gov.spcoop.nodopagamentispc.servizi.pagamentitelematicirpt.PagamentiTelematiciRPT;

public class ClientRPT_TokenScad extends Thread {
	Data d;
	final Logger logger;
	MessageConsumer consumer;
	MessageProducer prodStat;
	String statMsg;
	ActiveMQTextMessage wrMessage;
	RptModel rpt;
	PagamentiTelematiciRPT client;
	String rptDecoded;
	DateFormat date = new SimpleDateFormat("YYYY-MM-dd");
	DateFormat dateTimeiuv = new SimpleDateFormat("YYYYMMddHHmmssSSS");
	DateFormat dateTime = new SimpleDateFormat("YYYY-MM-dd'T'HH:mm:ss'Z'");
	DateFormat time = new SimpleDateFormat("HH:mm:ss.SSS");

	String esito, fDesc, fCode, httpRespCode, label;
	Long startTS, lat;
	final int id;

	public ClientRPT_TokenScad(int idx) {
		id = idx;
		logger = LogManager.getLogger(ClientRPT_TokenScad.class + "_" + id);
		logger.debug("Starting");
		d = MainPA.d;
		consumer = d.getNewConsumer();
		prodStat = d.getNewStatProducer();
		build();

		label = "RPT_2_TS";
	}

	void build() {
		JaxWsProxyFactoryBean factory = new JaxWsProxyFactoryBean();
		factory.setServiceClass(PagamentiTelematiciRPT.class);
		factory.setAddress(d.getP().getProperty("rptEndPoint"));
		client = (PagamentiTelematiciRPT) factory.create();
		logger.debug("Created client: " + d.getP().getProperty("rptEndPoint"));
		Client cl = ClientProxy.getClient(client);
		HTTPConduit http = (HTTPConduit) cl.getConduit();
		final TLSClientParameters tlsCP = new TLSClientParameters();
		tlsCP.setDisableCNCheck(true);
		http.setTlsClientParameters(tlsCP);
		http.getClient().setConnectionTimeout(60000L);
		http.getClient().setReceiveTimeout(60000L);
		rptDecoded = d.getRptDecoded();
	}

	@Override
	public void run() {
		logger.info("Started");
		while (true) {
			try {
				ActiveMQTextMessage message = (ActiveMQTextMessage) consumer.receive();
				logger.debug("RPT_Listen: " + message.getText());
				rpt = new RptModel(message.getText());
				sendRpt(rpt);
			} catch (JMSException e) {
				logger.error("ERROR", e);
			}
		}
	}

	void sendRpt(RptModel dat) {
		Long t = System.currentTimeMillis();
		NodoInviaRPT body = new NodoInviaRPT();
		body.setPassword("password");
		// dati speciali per caso vecchia PA
		body.setIdentificativoCanale("15376371009_01");
		body.setIdentificativoIntermediarioPSP("15376371009");
		body.setIdentificativoPSP("15376371009");
		body.setRpt(String.format(rptDecoded, rpt.getDominio(), rpt.getStazPa(), dateTime.format(t), date.format(t), rpt.getIuv(), rpt.getCcp()).getBytes());
		IntestazionePPT header = new IntestazionePPT();
		header.setIdentificativoDominio(rpt.getDominio());
		header.setIdentificativoIntermediarioPA(rpt.getIntPa());
		header.setIdentificativoStazioneIntermediarioPA(rpt.getStazPa());
		header.setIdentificativoUnivocoVersamento(rpt.getIuv());
		header.setCodiceContestoPagamento(rpt.getCcp());
		NodoInviaRPTRisposta resp;
		try {
			startTS = System.currentTimeMillis();
			resp = client.nodoInviaRPT(body, header);
			lat = System.currentTimeMillis() - startTS;
			esito = resp.getEsito();
			if (esito.matches("OK"))
				httpRespCode = "200";
			else
				httpRespCode = "no200";
			try {
				fDesc = resp.getFault().getDescription();
			} catch (NullPointerException n) {
				fDesc = "";
			}
			try {
				fCode = resp.getFault().getFaultCode();
			} catch (NullPointerException n) {
				fCode = "";
			}
			logger.debug("RPT Resp: " + esito);
		} catch (WebServiceException e) {
			lat = System.currentTimeMillis() - startTS;
			esito = "KO";
			fDesc = e.getMessage();
			fCode = "NET";
			httpRespCode = "KO";
			logger.error("RPT Resp: " + "ERR," + e.getCause(), e);
		} finally {
			try {
				wrMessage = new ActiveMQTextMessage();
				statMsg = startTS + "," + esito + "," + fCode + "," + fDesc + "," + lat + "," + label + "," + httpRespCode + "," + rpt.getCcp();
				logger.debug(statMsg);
				wrMessage.setText(statMsg);
				prodStat.send(wrMessage);
			} catch (JMSException e) {
				logger.error("Unable to sent stat message", e);
			}
		}

	}
}
