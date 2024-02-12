import http from 'k6/http';
import papaparse from './papaparse.js';
import { SharedArray } from 'k6/data';

export function getBasePath(baseUrl, primitive) {
	const primitiveMapping = {
		"verificaBollettino": "/webservices/input",
		"verifyPaymentNotice": "/webservices/input",
		"activatePaymentNotice": "/webservices/input",
		"activatePaymentNoticeV2": "/webservices/input",
		"sendPaymentOutcome": "/webservices/input",
		"sendPaymentOutcomeV2": "/webservices/input",
		"activateIOPayment": "/webservices/input",
		"nodoVerificaRPT": "/webservices/input",
		"nodoAttivaRPT": "/webservices/input",
		"nodoInviaFlussoRendicontazione": "/webservices/input",
		"nodoChiediElencoFlussiRendicontazione": "/webservices/input",
		"nodoChiediFlussoRendicontazione": "/webservices/input",
		"demandPaymentNotice": "/webservices/input",
		"nodoChiediCatalogoServizi": "/webservices/input",
		"nodoChiediCatalogoServiziV2": "/webservices/input",
		"nodoChiediCopiaRT": "/webservices/input",
		"nodoChiediInformativaPA": "/webservices/input",
		"nodoChiediListaPendentiRPT": "/webservices/input",
		"nodoChiediNumeroAvviso": "/webservices/input",
		"nodoChiediStatoRPT": "/webservices/input",
		"nodoChiediTemplateInformativaPSP": "/webservices/input",
		"nodoInviaCarrelloRPT": "/webservices/input",
		"nodoInviaRPT": "/webservices/input",
		"nodoInviaRT": "/webservices/input",
		"nodoPAChiediInformativaPA": "/webservices/input",
		"checkPosition": "/checkPosition",
		"closePaymentV2": "/v2/closepayment",

		"nodoPerPMv1": "/webservices/input",
		"nodoPerPMv2": "/webservices/input"
	}
	if(baseUrl.includes("nodo-dei-pagamenti-")){
		return baseUrl;
	}
	return baseUrl + primitiveMapping[primitive]
}


export function getHeaders(headers) {
	if ("SUBSCRIPTION_KEY" in __ENV && __ENV.SUBSCRIPTION_KEY != "")  {
		headers["Ocp-Apim-Subscription-Key"] = __ENV.SUBSCRIPTION_KEY;
	}
	return headers;
}
