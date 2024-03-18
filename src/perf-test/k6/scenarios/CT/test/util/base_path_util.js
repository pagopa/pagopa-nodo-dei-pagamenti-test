import http from 'k6/http';
import papaparse from './papaparse.js';
import { SharedArray } from 'k6/data';

export function getBasePath(baseUrl, primitive) {
	var primitiveMapping;

	if (baseUrl.includes("nodo-p-prf") || baseUrl.includes("localhost") || baseUrl.includes("pagoPA_PERF_loadB_Oracle_azure")) {
		primitiveMapping = {
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

			"nodoPerPMv1": "",
			"nodoPerPMv2": ""
		}
	}
	else {
		primitiveMapping = {
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
			"checkPosition": "/checkPosition",
			"closePaymentV2": "/v2/closepayment",

			"nodoPerPMv1": "/nodo-per-pm/v1",
			"nodoPerPMv2": "/nodo-per-pm/v2"
		}
	}
	if (baseUrl.includes("nodo-dei-pagamenti-")) {
		return baseUrl + primitiveMapping[primitive];
	}
	return baseUrl + primitiveMapping[primitive]
}


export function getHeaders(headers) {
	if ("SUBSCRIPTION_KEY" in __ENV && __ENV.SUBSCRIPTION_KEY != "") {
		headers["Ocp-Apim-Subscription-Key"] = __ENV.SUBSCRIPTION_KEY;
	}
	return headers;
}
