package eu.sia.nft.workers;

import javax.jms.JMSException;

import org.apache.activemq.command.ActiveMQTextMessage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;

public class SendToQueue implements Runnable {
	String message;
	Data d;
	private static final Logger logger = LogManager.getLogger(SendToQueue.class);
	ActiveMQTextMessage wrMessage;

	public SendToQueue(String message) {
		this.message = message;
		d = MainPA.d;
	}

	@Override
	public void run() {
		logger.debug("SendToQueue message is: " + message);
		try {
			wrMessage = new ActiveMQTextMessage();
			wrMessage.setText(message);
			d.getProducer().send(wrMessage);
		} catch (JMSException e) {
			logger.error("AMQ ERROR", e);
		}
	}

}
