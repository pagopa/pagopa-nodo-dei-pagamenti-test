package eu.sia.nft.services;

import javax.xml.ws.Endpoint;
import org.apache.cxf.jaxws.EndpointImpl;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import eu.sia.nft.impl.PagamentiTelematiciRT_I;
import eu.sia.nft.interceptor.InInterceptor;
import eu.sia.nft.interceptor.InvokeInterceptor;
import eu.sia.nft.interceptor.PostInvokeInterceptor;
import eu.sia.nft.interceptor.SendInterceptor;

public class PagamentiTelematiciRT_S {
	Data d;

	public PagamentiTelematiciRT_S() {
		d = MainPA.d;
	}

	public void init() {
		String urlEndPoint = d.getP().getProperty("address") + "/PagamentiTelematiciRT";
		PagamentiTelematiciRT_I impl = new PagamentiTelematiciRT_I();
		EndpointImpl ep = (EndpointImpl) Endpoint.publish(urlEndPoint, impl);
		ep.getInInterceptors().add(new InInterceptor());
		ep.getInInterceptors().add(new InvokeInterceptor());
		ep.getInInterceptors().add(new PostInvokeInterceptor());
		ep.getOutInterceptors().add(new SendInterceptor());
		ep.getOutFaultInterceptors().add(new SendInterceptor());
	}
}
