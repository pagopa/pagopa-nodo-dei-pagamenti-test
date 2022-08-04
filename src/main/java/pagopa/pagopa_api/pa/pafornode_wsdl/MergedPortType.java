package pagopa.pagopa_api.pa.pafornode_wsdl;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.ws.Action;

/**
 * This class was generated by Apache CXF 3.4.4 2021-07-05T17:41:14.597+02:00
 * Generated source version: 3.4.4
 *
 */
@WebService(targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.wsdl", name = "mergedPortType")
@XmlSeeAlso({ merged.pagopa.pagopa_api.pa.pafornode.ObjectFactory.class, merged.ws.ppthead.ObjectFactory.class,
		merged.ws.ObjectFactory.class, merged.digitpa.schemas._2011.pagamenti.ObjectFactory.class })
@SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
public interface MergedPortType {

	@WebMethod(action = "paaVerificaRPT")
	@Action(input = "http://ws.pagamenti.telematici.gov/PPT/paaVerificaRPTRichiesta", output = "http://ws.pagamenti.telematici.gov/PPT/paaVerificaRPTRisposta")
	@WebResult(name = "paaVerificaRPTRisposta", targetNamespace = "http://ws.pagamenti.telematici.gov/", partName = "bodyrisposta")
	public merged.ws.PaaVerificaRPTRisposta paaVerificaRPT(

			@WebParam(partName = "bodyrichiesta", name = "paaVerificaRPT", targetNamespace = "http://ws.pagamenti.telematici.gov/") merged.ws.PaaVerificaRPT bodyrichiesta,
			@WebParam(partName = "header", name = "intestazionePPT", targetNamespace = "http://ws.pagamenti.telematici.gov/ppthead", header = true) merged.ws.ppthead.IntestazionePPT header);

	@WebMethod(action = "paSendRT")
	@Action(input = "http://pagopa-api.pagopa.gov.it/service/pa/paForNode/paSendRTReq", output = "http://pagopa-api.pagopa.gov.it/service/pa/paForNode/paSendRTRes")
	@WebResult(name = "paSendRTRes", targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", partName = "responseBody")
	public merged.pagopa.pagopa_api.pa.pafornode.PaSendRTRes paSendRT(

			@WebParam(partName = "requestBody", name = "paSendRTReq", targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd") merged.pagopa.pagopa_api.pa.pafornode.PaSendRTReq requestBody);

	@WebMethod(action = "paVerifyPaymentNotice")
	@Action(input = "http://pagopa-api.pagopa.gov.it/service/pa/paForNode/paVerifyPaymentNoticeReq", output = "http://pagopa-api.pagopa.gov.it/service/pa/paForNode/paVerifyPaymentNoticeRes")
	@WebResult(name = "paVerifyPaymentNoticeRes", targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", partName = "responseBody")
	public merged.pagopa.pagopa_api.pa.pafornode.PaVerifyPaymentNoticeRes paVerifyPaymentNotice(

			@WebParam(partName = "requestBody", name = "paVerifyPaymentNoticeReq", targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd") merged.pagopa.pagopa_api.pa.pafornode.PaVerifyPaymentNoticeReq requestBody);

	@WebMethod(action = "paaAttivaRPT")
	@Action(input = "http://ws.pagamenti.telematici.gov/PPT/paaAttivaRPTRichiesta", output = "http://ws.pagamenti.telematici.gov/PPT/paaAttivaRPTRisposta")
	@WebResult(name = "paaAttivaRPTRisposta", targetNamespace = "http://ws.pagamenti.telematici.gov/", partName = "bodyrisposta")
	public merged.ws.PaaAttivaRPTRisposta paaAttivaRPT(

			@WebParam(partName = "bodyrichiesta", name = "paaAttivaRPT", targetNamespace = "http://ws.pagamenti.telematici.gov/") merged.ws.PaaAttivaRPT bodyrichiesta,
			@WebParam(partName = "header", name = "intestazionePPT", targetNamespace = "http://ws.pagamenti.telematici.gov/ppthead", header = true) merged.ws.ppthead.IntestazionePPT header);

	@WebMethod(action = "paGetPayment")
	@Action(input = "http://pagopa-api.pagopa.gov.it/service/pa/paForNode/paGetPaymentReq", output = "http://pagopa-api.pagopa.gov.it/service/pa/paForNode/paGetPaymentRes")
	@WebResult(name = "paGetPaymentRes", targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd", partName = "responseBody")
	public merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentRes paGetPayment(

			@WebParam(partName = "requestBody", name = "paGetPaymentReq", targetNamespace = "http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd") merged.pagopa.pagopa_api.pa.pafornode.PaGetPaymentReq requestBody);
}
