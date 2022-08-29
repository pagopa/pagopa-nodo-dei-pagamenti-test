import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';
import { Trend } from 'k6/metrics';


export const RPT_Semplice_N3_Trend = new Trend('RPT_Semplice_N3');
export const All_Trend = new Trend('ALL');

export function rptSempliceN3ReqBody(pa, intpa, stazpa, paymentToken, creditorReferenceId, rptEncoded){


return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
	<soapenv:Header>
		<ppt:intestazionePPT>
			<identificativoIntermediarioPA>${pa}</identificativoIntermediarioPA>
			<identificativoStazioneIntermediarioPA>${pa}</identificativoStazioneIntermediarioPA>
			<identificativoDominio>${pa}</identificativoDominio>
			<identificativoUnivocoVersamento>${creditorReferenceId}</identificativoUnivocoVersamento>
			<codiceContestoPagamento>${paymentToken}</codiceContestoPagamento>
		</ppt:intestazionePPT>
	</soapenv:Header>
	<soapenv:Body>
		<ws:nodoInviaRPT>
			<password>pwdpwdpwd</password>
                                                 <identificativoPSP>40000000001</identificativoPSP>
                                                 <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                                                 <identificativoCanale>40000000001_01</identificativoCanale>
			<tipoFirma/>
			<rpt>${rptEncoded}</rpt>
		</ws:nodoInviaRPT>
	</soapenv:Body>
</soapenv:Envelope>
`
/*  <identificativoPSP>15376371009</identificativoPSP>
                                                 <identificativoIntermediarioPSP>15376371009</identificativoIntermediarioPSP>
                                                 <identificativoCanale>15376371009_01</identificativoCanale>
			<tipoFirma/>
			*/
};

export function RPT_Semplice_N3(baseUrl,rndAnagPaNew,paymentToken, creditorReferenceId) {
 
  //console.log("paymToken="+paymentToken); 
  //console.log("creditorReferenceId="+creditorReferenceId); 
  let rptEncoded = rptUtil.getRptEncoded(rndAnagPaNew.PA, rndAnagPaNew.STAZPA, creditorReferenceId, paymentToken);
  
 const res = http.post(
    baseUrl+'?soapAction=nodoInviaRPT',
    rptSempliceN3ReqBody(rndAnagPaNew.PA, rndAnagPaNew.INTPA, rndAnagPaNew.STAZPA,paymentToken, creditorReferenceId, rptEncoded),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { RPT_Semplice_N3: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   RPT_Semplice_N3_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);

   check(res, {
 	':over_sla300': (r) => r.timings.duration >300,
   },
   { RPT_Semplice_N3: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'RPT_Semplice_N3:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT_Semplice_N3: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'RPT_Semplice_N3:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT_Semplice_N3: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'RPT_Semplice_N3:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT_Semplice_N3: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'RPT_Semplice_N3:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT_Semplice_N3: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'RPT_Semplice_N3:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT_Semplice_N3: 'over_sla1000', ALL:'over_sla1000' }
   );



  let outcome='';
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('esito');
  outcome = script.text();
  }catch(error){}


  if(outcome=='KO'){
 // console.log("RPTSempliceN3 REQuest----------------"+ rptSempliceN3ReqBody(rndAnagPaNew.PA, rndAnagPaNew.INTPA, rndAnagPaNew.STAZPA,paymentToken, creditorReferenceId, rptEncoded));
 // console.log("RPTSempliceN3 RESPONSE----------------"+res.body);
  }
   
   check(
    res,
    {
     
	  'RPT_Semplice_N3:ok_rate': (r) => outcome == 'OK',
    },
    { RPT_Semplice_N3: 'ok_rate', ALL:'ok_rate' }
	);
 
  check(
    res,
    {
     
	  'RPT_Semplice_N3:ko_rate': (r) => outcome !== 'OK',
    },
    { RPT_Semplice_N3: 'ko_rate', ALL:'ko_rate' }
  );
  
  return res;
   
}

