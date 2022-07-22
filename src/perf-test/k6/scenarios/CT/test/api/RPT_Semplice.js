import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';

export function rptReqBody(psp, intpsp, chpsp, pa, intpa, stazpa, iuv, rptEncoded){


return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
	<soapenv:Header>
		<ppt:intestazionePPT>
			<identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
			<identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
			<identificativoDominio>${pa}</identificativoDominio>
			<identificativoUnivocoVersamento>${iuv}</identificativoUnivocoVersamento>
			<codiceContestoPagamento>PERFORMANCE</codiceContestoPagamento>
		</ppt:intestazionePPT>
	</soapenv:Header>
	<soapenv:Body>
		<ws:nodoInviaRPT>
			<password>pwdpwdpwd</password>
			<identificativoPSP>${psp}</identificativoPSP>
			<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
			<identificativoCanale>${chpsp}</identificativoCanale>
			<tipoFirma/>
			<rpt>${rptEncoded}</rpt>
		</ws:nodoInviaRPT>
	</soapenv:Body>
</soapenv:Envelope>
`
};

export function RPT(baseUrl,rndAnagPsp,rndAnagPa,iuv) {
 
  
 let rptEncoded = rptUtil.getRptEncoded(rndAnagPa.PA, rndAnagPa.STAZPA, iuv, "PERFORMANCE");
 
 const res = http.post(
    baseUrl+'?soapAction=nodoInviaRPT',
    rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, rptEncoded),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { RPT_Semplice: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
     
   check(res, {
 	'RPT_Semplice:over_sla300': (r) => r.timings.duration >300,
   },
   { RPT_Semplice: 'over_sla300' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT_Semplice: 'over_sla400' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT_Semplice: 'over_sla500' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT_Semplice: 'over_sla600' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT_Semplice: 'over_sla800' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT_Semplice: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  const outcome = script.text();
  
  /*if(outcome=='KO'){
  console.log("rptSemplice REQuest----------------"+rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, rptEncoded)); 
  console.log("rptSemplice RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
     
	  'RPT_Semplice:ok_rate': (r) => outcome == 'OK',
    },
    { RPT_Semplice: 'ok_rate' }
	);
 
  check(
    res,
    {
      
	  'RPT_Semplice:ko_rate': (r) => outcome !== 'OK',
    },
    { RPT_Semplice: 'ko_rate' }
  );
  
  return res;
   
}

