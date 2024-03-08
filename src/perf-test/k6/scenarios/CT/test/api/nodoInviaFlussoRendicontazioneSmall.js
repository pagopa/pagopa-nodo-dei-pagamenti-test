import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";
import * as common from '../../../CommonScript.js';
import * as util from '../util/k6utils.js';
import encoding from 'k6/encoding';

export const nodoInviaFlussoRendicontazioneSmall_Trend = new Trend('nodoInviaFlussoRendicontazioneSmall');
export const All_Trend = new Trend('ALL');

function getBody(idPSP, idChannel, idInt, idPA) {
	
	const currentDate = new Date();

	const year = currentDate.getFullYear();
	const month = String(currentDate.getMonth() + 1).padStart(2, '0'); // Month (1-12)
	const day = String(currentDate.getDate()).padStart(2, '0'); // Day of month (1-31)
	const hours = String(currentDate.getHours()).padStart(2, '0'); // hours (0-23)
	const minutes = String(currentDate.getMinutes()).padStart(2, '0'); // Mins (0-59)
	const seconds = String(currentDate.getSeconds()).padStart(2, '0'); // Sec (0-59)
	const milliseconds = String(currentDate.getMilliseconds()).padStart(3, '0'); // Millis (0-999)
	const data = `${year}-${month}-${day}`;
	const dataora = `${year}-${month}-${day}T${hours}:${minutes}:${seconds}`;
	const formattedDateTime = `${year}-${month}-${day}T${hours}:${minutes}:${seconds}.${milliseconds}`;
	const intnum = util.randomIntBetween(0,1000);
	const idFlusso = `${year}-${month}-${day}${idPSP}-${intnum}`;
	const XMLRendi = getxmlRendicontazione(idFlusso, dataora, data)
	return `<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	<soap:Body>
		<ns5:nodoInviaFlussoRendicontazione xmlns:ns2="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:ns3="http://PuntoAccessoPSP.spcoop.gov.it/QrCode" xmlns:ns4="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:ns5="http://ws.pagamenti.telematici.gov/">
			<identificativoPSP>${idPSP}</identificativoPSP>
			<identificativoIntermediarioPSP>${idInt}</identificativoIntermediarioPSP>
			<identificativoCanale>${idChannel}</identificativoCanale>
			<password>pwdpwdpwd</password>
			<identificativoDominio>${idPA}</identificativoDominio>
			<identificativoFlusso>${idFlusso}</identificativoFlusso>
			<dataOraFlusso>${formattedDateTime}</dataOraFlusso>
            <xmlRendicontazione>${XMLRendi}</xmlRendicontazione>
        </ns5:nodoInviaFlussoRendicontazione>
    </soap:Body>
</soap:Envelope>`;
}

function getxmlRendicontazione(idFlusso, dataora, data ) {
	let xmlDecoded = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<FlussoRiversamento xmlns="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
    <versioneOggetto>1.0</versioneOggetto>
    <identificativoFlusso>${idFlusso}</identificativoFlusso>
    <dataOraFlusso>${dataora}</dataOraFlusso>
    <identificativoUnivocoRegolamento>Bonifico SEPA-03268-9999999999</identificativoUnivocoRegolamento>
    <dataRegolamento>${data}</dataRegolamento>
    <istitutoMittente>
        <identificativoUnivocoMittente>
            <tipoIdentificativoUnivoco>B</tipoIdentificativoUnivoco>
            <codiceIdentificativoUnivoco>SELBIT2B</codiceIdentificativoUnivoco>
        </identificativoUnivocoMittente>
        <denominazioneMittente>Banca Sella</denominazioneMittente>
    </istitutoMittente>
    <istitutoRicevente>
        <identificativoUnivocoRicevente>
            <tipoIdentificativoUnivoco>G</tipoIdentificativoUnivoco>
            <codiceIdentificativoUnivoco>99999999999</codiceIdentificativoUnivoco>
        </identificativoUnivocoRicevente>
    </istitutoRicevente>
    <numeroTotalePagamenti>1</numeroTotalePagamenti>
    <importoTotalePagamenti>999.00</importoTotalePagamenti>
    <datiSingoliPagamenti>
        <identificativoUnivocoVersamento>123456789112345</identificativoUnivocoVersamento>
        <identificativoUnivocoRiscossione>1730326800010819867</identificativoUnivocoRiscossione>
        <indiceDatiSingoloPagamento>1</indiceDatiSingoloPagamento>
        <singoloImportoPagato>999.00</singoloImportoPagato>
        <codiceEsitoSingoloPagamento>9</codiceEsitoSingoloPagamento>
        <dataEsitoSingoloPagamento>${data}</dataEsitoSingoloPagamento>
    </datiSingoliPagamenti>
</FlussoRiversamento>`

	return encoding.b64encode(xmlDecoded);
}

export function nodoInviaFlussoRendicontazioneSmall(baseUrl, idPSP, idChannel, idInt, idPA) {

	const pathToCall = getBasePath(baseUrl, "nodoInviaFlussoRendicontazione")
	let body = getBody(idPSP, idChannel, idInt, idPA);
	let res = http.post(pathToCall, body,
		{
			headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoInviaFlussoRendicontazione' }),
			tags: { activatePaymentNotice: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoInviaFlussoRendicontazioneSmall" }
		}
	);
	console.debug(`nodoInviaFlussoRendicontazioneSmall params req: PSP [${idPSP}] idChannel [${idChannel}], idInt [${idInt}]` )
	console.debug("nodoInviaFlussoRendicontazioneSmall body RES");
	console.debug(JSON.stringify(res.body));
	nodoInviaFlussoRendicontazioneSmall_Trend.add(res.timings.duration);
	All_Trend.add(res.timings.duration);


	check(res, {
		'nodoInviaFlussoRendicontazioneSmall:over_sla300': (r) => r.timings.duration > 300,
	},
		{ nodoInviaFlussoRendicontazioneSmall: 'over_sla300', ALL: 'over_sla300' }
	);

	check(res, {
		'nodoInviaFlussoRendicontazioneSmall:over_sla400': (r) => r.timings.duration > 400,
	},
		{ nodoInviaFlussoRendicontazioneSmall: 'over_sla400', ALL: 'over_sla400' }
	);

	check(res, {
		'nodoInviaFlussoRendicontazioneSmall:over_sla500': (r) => r.timings.duration > 500,
	},
		{ nodoInviaFlussoRendicontazioneSmall: 'over_sla500', ALL: 'over_sla500' }
	);

	check(res, {
		'nodoInviaFlussoRendicontazioneSmall:over_sla600': (r) => r.timings.duration > 600,
	},
		{ nodoInviaFlussoRendicontazioneSmall: 'over_sla600', ALL: 'over_sla600' }
	);

	check(res, {
		'nodoInviaFlussoRendicontazioneSmall:over_sla800': (r) => r.timings.duration > 800,
	},
		{ nodoInviaFlussoRendicontazioneSmall: 'over_sla800', ALL: 'over_sla800' }
	);

	check(res, {
		'nodoInviaFlussoRendicontazioneSmall:over_sla1000': (r) => r.timings.duration > 1000,
	},
		{ nodoInviaFlussoRendicontazioneSmall: 'over_sla1000', ALL: 'over_sla1000' }
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
			'nodoInviaFlussoRendicontazioneSmall:ok_rate': (r) => outcome == 'OK',
		},
		{ nodoInviaFlussoRendicontazioneSmall: 'ok_rate', ALL: 'ok_rate' }
	);

	if (check(
		res,
		{
			'nodoInviaFlussoRendicontazioneSmall:ko_rate': (r) => outcome != 'OK',
		},
		{ nodoInviaFlussoRendicontazioneSmall: 'ko_rate', ALL: 'ko_rate' }
	)) {
		fail("outcome != OK: " + outcome);
	}

	return res;
}
