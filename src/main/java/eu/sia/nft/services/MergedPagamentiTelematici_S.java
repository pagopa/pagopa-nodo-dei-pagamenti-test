package eu.sia.nft.services;

import java.util.concurrent.Executors;

import javax.xml.ws.Endpoint;

import org.apache.cxf.jaxws.EndpointImpl;

import eu.sia.nft.Data;
import eu.sia.nft.MainPA;
import eu.sia.nft.impl.MergedPagamentiTelematiciCCP_I;
import eu.sia.nft.interceptor.InInterceptor;
import eu.sia.nft.interceptor.InvokeInterceptor;
import eu.sia.nft.interceptor.PostInvokeInterceptor;
import eu.sia.nft.interceptor.SendInterceptor;
import eu.sia.nft.interceptor.SetupEndInterceptor;

public class MergedPagamentiTelematici_S {
	Data d;

	public MergedPagamentiTelematici_S() {
		d = MainPA.d;
	}

	public void init() {
		String urlEndPoint = d.getP().getProperty("address") + "/PagamentiTelematiciCCP";
		MergedPagamentiTelematiciCCP_I impl = new MergedPagamentiTelematiciCCP_I();
		EndpointImpl ep = (EndpointImpl) Endpoint.publish(urlEndPoint, impl);
		ep.getInInterceptors().add(new InInterceptor());
		ep.getInInterceptors().add(new InvokeInterceptor());
		ep.getInInterceptors().add(new PostInvokeInterceptor());
		ep.getOutInterceptors().add(new SendInterceptor());
		ep.getOutFaultInterceptors().add(new SendInterceptor());

		// abilitazione per gestione rpt2 a token scaduto
		if (d.getP().getProperty("enableRPTv2", "false").matches("true")) {
			ep.getOutInterceptors().add(new SetupEndInterceptor(Executors.newFixedThreadPool(Integer.valueOf(d.getP().getProperty("OutInterceptorTSPool", "100")))));
		}
	}

}
