package eu.sia.nft.interceptor;

import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.interceptor.AbstractSoapInterceptor;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.interceptor.OutgoingChainInterceptor;
import org.apache.cxf.interceptor.ServiceInvokerInterceptor;
import org.apache.cxf.message.Message;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;

public class PostInvokeInterceptor extends AbstractSoapInterceptor {

	public PostInvokeInterceptor() {
		super(Phase.INVOKE);
		addAfter(ServiceInvokerInterceptor.class.getName());
	}

	@Override
	public void handleMessage(SoapMessage message) throws Fault {
		message.getExchange().put("PostInvokeTime", System.currentTimeMillis());
	}

}