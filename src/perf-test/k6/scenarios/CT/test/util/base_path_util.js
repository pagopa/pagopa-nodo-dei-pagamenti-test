import http from 'k6/http';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from 'k6/data';

export function getBasePath(baseUrl, primitive) {
	const primitiveMapping = {
		"verificaBollettino": "/node-for-psp/v1",
		"verifyPaymentNotice": "/node-for-psp/v1",
		"activatePaymentNotice": "/node-for-psp/v1",
		"sendPaymentOutcome": "/node-for-psp/v1",
		"activateIOPayment": "/node-for-io/v1",
		"nodoVerificaRPT": "/nodo-per-psp/v1",
		"nodoAttivaRPT": "/nodo-per-psp/v1",
		"nodoInviaFlussoRendicontazione": "/nodo-per-psp/v1",
		"nodoChiediElencoFlussiRendicontazione": "/nodo-per-pa/v1",
		"nodoChiediFlussoRendicontazione": "/nodo-per-pa/v1",
		"demandPaymentNotice": "/nodo-per-psp/v1",
		"nodoChiediCatalogoServizi": "/nodo-per-psp-richiesta-avvisi/v1",
		"nodoChiediCatalogoServiziV2": "/nodo-per-psp/v1",
		"nodoChiediCopiaRT": "/nodo-per-pa/v1",
		"nodoChiediInformativaPA": "/nodo-per-psp/v1",
		"nodoChiediListaPendentiRPT": "/nodo-per-pa/v1",
		"nodoChiediNumeroAvviso": "/nodo-per-psp-richiesta-avvisi/v1",
		"nodoChiediStatoRPT": "/nodo-per-pa/v1",
		"nodoChiediTemplateInformativaPSP": "/nodo-per-psp/v1",
		"nodoInviaCarrelloRPT": "/nodo-per-pa/v1",
		"nodoInviaRPT": "/nodo-per-pa/v1",
		"nodoInviaRT": "/nodo-per-psp/v1",
		"nodoPAChiediInformativaPA": "/nodo-per-pa/v1",

		"nodoPerPMv1": "/nodo-per-pm/v1",
		"nodoPerPMv2": "/nodo-per-pm/v2",
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
