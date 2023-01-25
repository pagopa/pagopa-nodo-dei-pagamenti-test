import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";

export const RPT_Trend = new Trend('RPT');
export const All_Trend = new Trend('ALL');

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
			<password>pwdpwdpwd</password>
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
    getBasePath(baseUrl, "nodoInviaRPT"),
    rptReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, rptEncoded, ccp),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoInviaRPT' }) ,
	tags: { RPT: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("RPT RES");
  console.debug(res);

   RPT_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);

   check(res, {
 	'RPT:over_sla300': (r) => r.timings.duration >300,
   },
   { RPT: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'RPT:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'RPT:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'RPT:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'RPT:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'RPT:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT: 'over_sla1000', ALL:'over_sla1000' }
   );



    let outcome='';
    let paymentToken='';
    let result={};
    result.paymentToken=paymentToken;
    try{
    let doc = parseHTML(res.body);
    let script = doc.find('esito');
    outcome = script.text();
    script = doc.find('url');
    let token = script.text();
    paymentToken = token.split('=')[1];
    result.paymentToken=paymentToken;
    }catch(error){}



    
   check(
    res,
    {
     
	 'RPT:ok_rate': (r) => outcome == 'OK' && result.paymentToken != undefined && result.paymentToken !== '',
    },
    { RPT: 'ok_rate' , ALL:'ok_rate'}
	);
  
  if(check(
    res,
    {
      
	 'RPT:ko_rate': (r) => outcome != 'OK' || result.paymentToken == undefined || result.paymentToken === '',
    },
    { RPT: 'ko_rate', ALL:'ko_rate' }
  )){
	fail("result.paymentToken undefined or empty: "+result.paymentToken + " or outcome != ok");
	}
  
  return result;
   
}

