import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";
export const nodoChiediElencoFlussiRendicontazione_Trend = new Trend('nodoChiediElencoFlussiRendicontazione');
export const All_Trend = new Trend('ALL');

function getBody(idPsp, idInt, idStation, idPa) {

	return `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediElencoFlussiRendicontazione>
                    <identificativoIntermediarioPA>${idInt}</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>${idStation}</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>${idPa}</identificativoDominio>
                    <identificativoPSP>${idPsp}</identificativoPSP>
                </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>`;
}

export function nodoChiediElencoFlussiRendicontazione(baseUrl, idPsp, idInt, idStation, idPa) {

	const pathToCall = getBasePath(baseUrl, "nodoChiediElencoFlussiRendicontazione")
	let body = getBody(idPsp, idInt, idStation, idPa);
	
	let res = http.post(pathToCall, body,
		{
			headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediElencoFlussiRendicontazione' }),
			tags: { nodoChiediElencoFlussiRendicontazione: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediElencoFlussiRendicontazione" }
		}
	);
	nodoChiediElencoFlussiRendicontazione_Trend.add(res.timings.duration);
	All_Trend.add(res.timings.duration);

	console.debug("nodoChiediElencoFlussiRendicontazione");
	console.debug(JSON.stringify(res));
	


	check(res, {
		'nodoChiediElencoFlussiRendicontazione:over_sla300': (r) => r.timings.duration > 300,
	},
		{ nodoChiediElencoFlussiRendicontazione: 'over_sla300', ALL: 'over_sla300' }
	);

	check(res, {
		'nodoChiediElencoFlussiRendicontazione:over_sla400': (r) => r.timings.duration > 400,
	},
		{ nodoChiediElencoFlussiRendicontazione: 'over_sla400', ALL: 'over_sla400' }
	);

	check(res, {
		'nodoChiediElencoFlussiRendicontazione:over_sla500': (r) => r.timings.duration > 500,
	},
		{ nodoChiediElencoFlussiRendicontazione: 'over_sla500', ALL: 'over_sla500' }
	);

	check(res, {
		'nodoChiediElencoFlussiRendicontazione:over_sla600': (r) => r.timings.duration > 600,
	},
		{ nodoChiediElencoFlussiRendicontazione: 'over_sla600', ALL: 'over_sla600' }
	);

	check(res, {
		'nodoChiediElencoFlussiRendicontazione:over_sla800': (r) => r.timings.duration > 800,
	},
		{ nodoChiediElencoFlussiRendicontazione: 'over_sla800', ALL: 'over_sla800' }
	);

	check(res, {
		'nodoChiediElencoFlussiRendicontazione:over_sla1000': (r) => r.timings.duration > 1000,
	},
		{ nodoChiediElencoFlussiRendicontazione: 'over_sla1000', ALL: 'over_sla1000' }
	);


	let fault = '';

	try {
		let doc = parseHTML(res.body);
		let script = doc.find('fault');
		fault = script.text();
	} catch (error) { }



	check(
		res,
		{
			'nodoChiediElencoFlussiRendicontazione:ok_rate': (r) => fault == '',
		},
		{ nodoChiediElencoFlussiRendicontazione: 'ok_rate', ALL: 'ok_rate' }
	);

	if (check(
		res,
		{
			'nodoChiediElencoFlussiRendicontazione:ko_rate': (r) => fault != '',
		},
		{ nodoChiediElencoFlussiRendicontazione: 'ko_rate', ALL: 'ko_rate' }
	)) {
		fail(`response with fault: [${fault}]`);
	}

	return res;
}
