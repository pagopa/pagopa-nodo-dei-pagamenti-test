import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";

export const RPT_Semplice_Trend = new Trend('RPT_Semplice');
export const All_Trend = new Trend('ALL');

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
		 getBasePath(baseUrl, "nodoInviaRPT"),
    rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, rptEncoded),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoInviaRPT', 'x-forwarded-for':'10.6.189.192' }) ,
	tags: { RPT_Semplice: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );

  console.debug("RPT (semplice) RES");
  console.log(JSON.stringify(res));

   RPT_Semplice_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);

	check(res, {
 	'RPT_Semplice:over_sla300': (r) => r.timings.duration >300,
   },
   { RPT_Semplice: 'over_sla300', ALL:'over_sla300' }
   );

   check(res, {
 	'RPT_Semplice:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT_Semplice: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT_Semplice: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT_Semplice: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT_Semplice: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'RPT_Semplice:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT_Semplice: 'over_sla1000' , ALL:'over_sla1000'}
   );

  let outcome='';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  outcome = script.text();
  }catch(error){}
  
  /*if(outcome=='KO'){
  console.debug("rptSemplice REQuest----------------"+rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, rptEncoded)); 
  console.debug("rptSemplice RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
     
	  'RPT_Semplice:ok_rate': (r) => outcome == 'OK',
    },
    { RPT_Semplice: 'ok_rate' , ALL:'ok_rate'}
	);
 
  if(check(
    res,
    {
      
	  'RPT_Semplice:ko_rate': (r) => outcome !== 'OK',
    },
    { RPT_Semplice: 'ko_rate', ALL:'ko_rate' }
  )){
	fail("outcome != ok: "+outcome);
	}
  
  return res;
   
}

