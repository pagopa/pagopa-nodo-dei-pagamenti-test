import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';

export function rptReqBody(pa, intpa, stazpa, iuv, rptEncoded, ccp){


return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
	<soapenv:Header>
		<ppt:intestazionePPT>
			<identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
			<identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
			<identificativoDominio>${pa}</identificativoDominio>
			<identificativoUnivocoVersamento>${iuv}</identificativoUnivocoVersamento>
			<codiceContestoPagamento>${ccp}</codiceContestoPagamento>
		</ppt:intestazionePPT>
	</soapenv:Header>
	<soapenv:Body>
		<ws:nodoInviaRPT>
			<password>password</password>
			<identificativoPSP>AGID_01</identificativoPSP>
			<identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
			<identificativoCanale>97735020584_02</identificativoCanale>
			<tipoFirma/>
			<rpt>${rptEncoded}</rpt>
		</ws:nodoInviaRPT>
	</soapenv:Body>
</soapenv:Envelope>
`
};

export function RPT(baseUrl,rndAnagPa,iuv,ccp) {
 
  
 let rptEncoded = rptUtil.getRptEncoded(rndAnagPa.PA, rndAnagPa.STAZPA, iuv, ccp);
 
 const res = http.post(
    baseUrl+'?soapAction=nodoInviaRPT',
    rptReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, rptEncoded, ccp),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { RPT: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
     
   check(res, {
 	'RPT:over_sla300': (r) => r.timings.duration >300,
   },
   { RPT: 'over_sla300' }
   );
   
   check(res, {
 	'RPT:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT: 'over_sla400' }
   );
   
   check(res, {
 	'RPT:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT: 'over_sla500' }
   );
   
   check(res, {
 	'RPT:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT: 'over_sla600' }
   );
   
   check(res, {
 	'RPT:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT: 'over_sla800' }
   );
   
   check(res, {
 	'RPT:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  const outcome = script.text();
    
   check(
    res,
    {
     
	 'RPT:ok_rate': (r) => outcome == 'OK',
    },
    { RPT: 'ok_rate' }
	);
 
  check(
    res,
    {
      
	 'RPT:ko_rate': (r) => outcome !== 'OK',
    },
    { RPT: 'ko_rate' }
  );
  
  return res;
   
}

