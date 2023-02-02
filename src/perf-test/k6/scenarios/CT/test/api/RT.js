import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";


export const RT_Trend = new Trend('RT');
export const All_Trend = new Trend('ALL');

export function rtReqBody(psp, intpsp, chpsp_c, pa, iuv, rtEncoded){

return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
	<soapenv:Header/>
	<soapenv:Body>
		<ws:nodoInviaRT>
			<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
			<identificativoCanale>${chpsp_c}</identificativoCanale>
			<password>pwdpwdpwd</password>
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
		 getBasePath(baseUrl, "nodoInviaRT"),
    rtReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, rndAnagPa.PA, iuv, rtEncoded),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoInviaRT' }) ,
	tags: { RT: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("RT RES");
  console.debug(res);


   RT_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);

   check(res, {
 	'RT:over_sla300': (r) => r.timings.duration >300,
   },
   { RT: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'RT:over_sla400': (r) => r.timings.duration >400,
   },
   { RT: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'RT:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RT: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'RT:over_sla600': (r) => r.timings.duration >600,
   },
   { RT: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'RT:over_sla800': (r) => r.timings.duration >800,
   },
   { RT: 'over_sla800' , ALL:'over_sla800'}
   );
   
   check(res, {
 	'RT:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RT: 'over_sla1000', ALL:'over_sla1000' }
   );


    let  outcome='';
    try{
    let doc = parseHTML(res.body);
    let script = doc.find('esito');
    outcome = script.text();
    }catch(error){}


    
   check(
    res,
    {
    
	 'RT:ok_rate': (r) => outcome == 'OK',
    },
    { RT: 'ok_rate', ALL:'ok_rate' }
	);
 
  if(check(
    res,
    {
     
	 'RT:ko_rate': (r) => outcome !== 'OK',
    },
    { RT: 'ko_rate', ALL:'ko_rate' }
  )){
	fail("outcome != ok: "+outcome);
	}
  
  return res;
   
}

