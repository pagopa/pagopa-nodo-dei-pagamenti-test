package eu.sia.nft.interceptor;

import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.interceptor.AbstractSoapInterceptor;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.phase.Phase;

import co.elastic.apm.api.ElasticApm;
import co.elastic.apm.api.Transaction;

public class InInterceptor extends AbstractSoapInterceptor {

	public InInterceptor() {
		super(Phase.RECEIVE);
	}

	@Override
	public void handleMessage(SoapMessage message) throws Fault {
		message.getExchange().put("InTime", System.currentTimeMillis());

	}

}