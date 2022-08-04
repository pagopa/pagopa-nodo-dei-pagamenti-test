package eu.sia.nft.interceptor;

import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.interceptor.AbstractSoapInterceptor;
import org.apache.cxf.binding.soap.interceptor.CheckFaultInterceptor;
import org.apache.cxf.interceptor.ServiceInvokerInterceptor;
import org.apache.cxf.jaxws.interceptors.HolderInInterceptor;
import org.apache.cxf.jaxws.interceptors.HolderOutInterceptor;
import org.apache.cxf.phase.Phase;

public class InvokeInterceptor extends AbstractSoapInterceptor {

	public InvokeInterceptor() {
		super(Phase.INVOKE);
		addBefore(ServiceInvokerInterceptor.class.getName());
	}
	

	@Override
	public void handleMessage(SoapMessage message) {
		message.getExchange().put("InvokeTime", System.currentTimeMillis());
	}

}