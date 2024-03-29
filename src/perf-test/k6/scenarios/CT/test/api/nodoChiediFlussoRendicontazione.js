import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";
export const nodoChiediFlussoRendicontazione_Trend = new Trend('nodoChiediFlussoRendicontazione');
export const All_Trend = new Trend('ALL');

function getBody(idInt, idStation, idFlusso) {

	return `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediFlussoRendicontazione>
                    <identificativoIntermediarioPA>${idInt}</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>${idStation}</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoFlusso>${idFlusso}</identificativoFlusso>
                </ws:nodoChiediFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>`;
}

export function nodoChiediFlussoRendicontazione(baseUrl, idInt, idStation, idPa, idFlusso) {

	const pathToCall = getBasePath(baseUrl, "nodoChiediFlussoRendicontazione")
	let body = getBody(idInt, idStation, idPa, idFlusso);
	
	let res = http.post(pathToCall, body,
		{
			headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediFlussoRendicontazione' }),
			tags: { nodoChiediFlussoRendicontazione: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediFlussoRendicontazione" }
		}
	);
	nodoChiediFlussoRendicontazione_Trend.add(res.timings.duration);
	All_Trend.add(res.timings.duration);

	console.debug("nodoChiediFlussoRendicontazione");
	console.debug(JSON.stringify(res));
	


	check(res, {
		'nodoChiediFlussoRendicontazione:over_sla300': (r) => r.timings.duration > 300,
	},
		{ nodoChiediFlussoRendicontazione: 'over_sla300', ALL: 'over_sla300' }
	);

	check(res, {
		'nodoChiediFlussoRendicontazione:over_sla400': (r) => r.timings.duration > 400,
	},
		{ nodoChiediFlussoRendicontazione: 'over_sla400', ALL: 'over_sla400' }
	);

	check(res, {
		'nodoChiediFlussoRendicontazione:over_sla500': (r) => r.timings.duration > 500,
	},
		{ nodoChiediFlussoRendicontazione: 'over_sla500', ALL: 'over_sla500' }
	);

	check(res, {
		'nodoChiediFlussoRendicontazione:over_sla600': (r) => r.timings.duration > 600,
	},
		{ nodoChiediFlussoRendicontazione: 'over_sla600', ALL: 'over_sla600' }
	);

	check(res, {
		'nodoChiediFlussoRendicontazione:over_sla800': (r) => r.timings.duration > 800,
	},
		{ nodoChiediFlussoRendicontazione: 'over_sla800', ALL: 'over_sla800' }
	);

	check(res, {
		'nodoChiediFlussoRendicontazione:over_sla1000': (r) => r.timings.duration > 1000,
	},
		{ nodoChiediFlussoRendicontazione: 'over_sla1000', ALL: 'over_sla1000' }
	);


	let outcome = '';

	try {
		let doc = parseHTML(res.body);
		let script = doc.find('esito');
		outcome = script.text();
	} catch (error) { }



	check(
		res,
		{
			'nodoChiediFlussoRendicontazione:ok_rate': (r) => outcome == 'OK',
		},
		{ nodoChiediFlussoRendicontazione: 'ok_rate', ALL: 'ok_rate' }
	);

	if (check(
		res,
		{
			'nodoChiediFlussoRendicontazione:ko_rate': (r) => outcome != 'OK',
		},
		{ nodoChiediFlussoRendicontazione: 'ko_rate', ALL: 'ko_rate' }
	)) {
		fail("outcome != OK: " + outcome);
	}

	return res;
}
