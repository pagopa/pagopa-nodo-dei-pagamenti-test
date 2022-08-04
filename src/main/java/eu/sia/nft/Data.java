package eu.sia.nft;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Properties;

import javax.jms.Connection;
import javax.jms.DeliveryMode;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MessageConsumer;
import javax.jms.MessageProducer;
import javax.jms.Queue;
import javax.jms.Session;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.activemq.command.ActiveMQTextMessage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Data {
	Properties p;
	final Logger logger = LogManager.getLogger(Data.class);
	ArrayList<String> PAList;

	// connection
	String amqUser, amqPwd, amqUri, queueWr, statWr;
	ActiveMQConnectionFactory connectionFactory;
	Connection connection;
	Session session;
	MessageProducer producer;
	MessageConsumer consumer;
	Destination destination;

	String rptDecoded;

	public Data(String[] args) {
		p = new Properties();
		loadCmdLine(args);
		loadPA();
		if (getP().getProperty("enableRPTv2", "false").matches("true")) {
			loadConfFileV2();
			rptDecoded = loadRprDecoded();
			logger.debug("Build amq worker");
			buildAMQProducer();
		}

	}

	private void loadConfFileV2() {
		FileInputStream input = null;
		String fileName = null;
		try {
			fileName = getP().getProperty("loadConfFileV2", "TS_Config.conf");
			input = new FileInputStream(fileName);
			// load a properties file
			p.load(input);
			logger.debug("RPT TS - Configuration file loaded");
		} catch (IOException ex) {
			logger.error("Unable to load configuration file " + fileName + ", exiting ...", ex);
			System.exit(0);
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					logger.error("Enable to close file " + fileName, e);
				}
			}
		}
	}

	String loadRprDecoded() {
		try {
			BufferedReader br = Files.newBufferedReader(Paths.get("rpt.xml"));
			// read line by line
			String line, rt = "";
			while ((line = br.readLine()) != null) {
				rt += line;
			}
			logger.trace("RT Decoded: " + rt);
			return rt;
		} catch (FileNotFoundException e) {
			logger.error("File not fouund ", e);
			return null;
		} catch (IOException e) {
			logger.error("ERROR", e);
			return null;
		}
	}

	void loadPA() {
		PAList = new ArrayList<String>();
		String line;
		BufferedReader in;
		try {
			in = new BufferedReader(new FileReader("PA_List.dat"));
			while ((line = in.readLine()) != null) {
				if (line.isEmpty())
					break;
				PAList.add(line);
			}
			in.close();
			logger.info("Number of PA loaded: " + PAList.size());
			if (PAList.size() == 0) {
				logger.warn("No PA defined, exiting ...");
				System.exit(0);
			}
		} catch (FileNotFoundException e) {
			logger.error(e.getMessage(), e);
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		}
	}

	private void loadCmdLine(String[] args) {
		for (String v : args) {
			String lab = v.split("=")[0];
			if (!lab.startsWith("--")) {
				logger.error("Arg not valid --> " + lab);
				System.exit(0);
			} else {
				lab = lab.substring(2);
				String val = v.split("=")[1];
				p.setProperty(lab, val);
				logger.debug("P: " + lab + "=" + val);
			}
		}
	}

	void buildAMQProducer() {
		amqUser = getP().getProperty("amqUsr");
		amqPwd = getP().getProperty("amqPwd");
		amqUri = getP().getProperty("amqUri");
		queueWr = getP().getProperty("queueRpt");
		statWr = getP().getProperty("queueStat");
		try {
			connectionFactory = new ActiveMQConnectionFactory(amqUser, amqPwd, amqUri);
			connection = connectionFactory.createConnection();
			connection.start();
			logger.debug("Connection started");
			session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
			logger.debug("Session started");
			destination = session.createQueue(queueWr);
			logger.debug("Destination created");
			producer = session.createProducer(destination);
			producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);
			logger.debug("producer created");
		} catch (JMSException e) {
			logger.error("JMS Error", e);
		}
	}

	public synchronized Session getSession() {
		return session;
	}
	
	public MessageConsumer getNewConsumer() {
		try {
			Queue destinationRd = session.createQueue(queueWr);
			return session.createConsumer(destinationRd);
		} catch (JMSException e) {
			return null;
		}
	}
	
	public MessageProducer getNewStatProducer() {
		try {
			Queue destinationStat = session.createQueue(statWr);
			return session.createProducer(destinationStat);
		} catch (JMSException e) {
			return null;
		}
	}

	public synchronized MessageProducer getProducer() {
		return producer;
	}

	public synchronized ArrayList<String> getPAList() {
		return PAList;
	}

	public synchronized Properties getP() {
		return p;
	}

	public synchronized String getRptDecoded() {
		return rptDecoded;
	}
}
