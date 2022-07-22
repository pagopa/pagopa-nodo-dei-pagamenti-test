import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';

export function rtReqBody(psp, intpsp, chpsp_c, pa, iuv, rtEncoded){

return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
	<soapenv:Header/>
	<soapenv:Body>
		<ws:nodoInviaRT>
			<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
			<identificativoCanale>${chpsp_c}</identificativoCanale>
			<password>password</password>
			<identificativoPSP>${psp}</identificativoPSP>
			<identificativoDominio>${pa}</identificativoDominio>
			<identificativoUnivocoVersamento>${iuv}</identificativoUnivocoVersamento>
			<codiceContestoPagamento>PERFORMANCE</codiceContestoPagamento>
			<tipoFirma/>
			<forzaControlloSegno>1</forzaControlloSegno>
			<rt>${rtEncoded}</rt>
		</ws:nodoInviaRT>
	</soapenv:Body>
</soapenv:Envelope>
`


};


export function RT(baseUrl,rndAnagPsp,rndAnagPa,iuv) {
 
  
 let rtEncoded = rptUtil.getRtEncoded(rndAnagPa.PA, iuv);
  
 const res = http.post(
    baseUrl+'?soapAction=nodoInviaRT',
    rtReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, rndAnagPa.PA, iuv, rtEncoded),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { RT: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'RT:over_sla300': (r) => r.timings.duration >300,
   },
   { RT: 'over_sla300' }
   );
   
   check(res, {
 	'RT:over_sla400': (r) => r.timings.duration >400,
   },
   { RT: 'over_sla400' }
   );
   
   check(res, {
 	'RT:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RT: 'over_sla500' }
   );
   
   check(res, {
 	'RT:over_sla600': (r) => r.timings.duration >600,
   },
   { RT: 'over_sla600' }
   );
   
   check(res, {
 	'RT:over_sla800': (r) => r.timings.duration >800,
   },
   { RT: 'over_sla800' }
   );
   
   check(res, {
 	'RT:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RT: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  const outcome = script.text();
    
   check(
    res,
    {
    
	 'RT:ok_rate': (r) => outcome == 'OK',
    },
    { RT: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'RT:ko_rate': (r) => outcome !== 'OK',
    },
    { RT: 'ko_rate' }
  );
  
  return res;
   
}

