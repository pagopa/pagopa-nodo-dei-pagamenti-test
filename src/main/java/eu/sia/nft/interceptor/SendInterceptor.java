package eu.sia.nft.interceptor;

import java.util.List;
import java.util.Map;

import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.interceptor.AbstractSoapInterceptor;
import org.apache.cxf.headers.Header;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.message.Message;
import org.apache.cxf.phase.Phase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import co.elastic.apm.api.ElasticApm;
import co.elastic.apm.api.Span;
import co.elastic.apm.api.Transaction;

public class SendInterceptor extends AbstractSoapInterceptor {
	private static final Logger logger = LogManager.getLogger(SendInterceptor.class);
	public SendInterceptor() {
		super(Phase.SEND_ENDING);
	}

	@Override
	public void handleMessage(SoapMessage message) throws Fault {
		message.getExchange().put("OutTime", System.currentTimeMillis());
	
		// transaction apm
		Transaction transaction = ElasticApm.startTransaction();
		transaction.setType(Transaction.TYPE_REQUEST);
		transaction.setStartTimestamp((Long) message.getExchange().get("InTime") * 1000);
		transaction.setName(message.getExchange().getBindingOperationInfo().getOperationInfo().getName().toString().split("}")[1]);

		Span spanWS = transaction.startSpan("Engine",null,null).setStartTimestamp((Long) message.getExchange().get("InvokeTime") * 1000).setName("WSEngine");
		spanWS.end((Long) message.getExchange().get("PostInvokeTime") * 1000);

		transaction.end((Long) message.getExchange().get("OutTime") * 1000);

		logger.info("OP: " + message.getExchange().getBindingOperationInfo().getOperationInfo().getName() + "->"
				+ ((Long) message.getExchange().get("OutTime") - (Long) message.getExchange().get("InTime")));
	}

}