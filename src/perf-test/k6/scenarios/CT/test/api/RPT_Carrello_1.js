import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';

export function rptReqBody(psp, intpsp, chpsp_c, pa, intpa, stazpa, iuvs, rptEncoded){

return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
	<soapenv:Header>
		<ppt:intestazioneCarrelloPPT>
			<identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
			<identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
			<identificativoCarrello>${iuvs[0]}</identificativoCarrello>
		</ppt:intestazioneCarrelloPPT>
	</soapenv:Header>
	<soapenv:Body>
		<ws:nodoInviaCarrelloRPT>
			<password>pwdpwdpwd</password>
			<identificativoPSP>${psp}</identificativoPSP>
			<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
			<identificativoCanale>${chpsp_c}</identificativoCanale>
			<listaRPT>
				<elementoListaRPT>
					<identificativoDominio>${pa}</identificativoDominio>
					<identificativoUnivocoVersamento>${iuvs[0]}</identificativoUnivocoVersamento>
					<codiceContestoPagamento>PERFORMANCE</codiceContestoPagamento>
					<rpt>${rptEncoded}</rpt>
				</elementoListaRPT>
			</listaRPT>
		</ws:nodoInviaCarrelloRPT>
	</soapenv:Body>
</soapenv:Envelope>
`


};


export function RPT_Carrello_1(baseUrl,rndAnagPsp,rndAnagPa,iuvs) {
 
  
 let rptEncoded = rptUtil.getRptCEncoded(rndAnagPa.PA, rndAnagPa.STAZPA, iuvs[0]);
  
 const res = http.post(
    baseUrl+'?soapAction=nodoInviaCarrelloRPT',
    rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuvs, rptEncoded),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { RPT_Carrello_1: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'RPT_Carrello_1:over_sla300': (r) => r.timings.duration >300,
   },
   { RPT_Carrello_1: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'RPT_Carrello_1:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT_Carrello_1: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'RPT_Carrello_1:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT_Carrello_1: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'RPT_Carrello_1:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT_Carrello_1: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'RPT_Carrello_1:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT_Carrello_1: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'RPT_Carrello_1:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT_Carrello_1: 'over_sla1000', ALL:'over_sla1000' }
   );

  let outcome='';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('esitoComplessivoOperazione');
  outcome = script.text();
  }catch(error){}
  
  /*if(outcome=='KO'){
  console.log("rptCarrello1 REQuest----------------"+rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuvs, rptEncoded)); 
  console.log("rptCarrello1 RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
    
	  'RPT_Carrello_1:ok_rate': (r) => outcome == 'OK',
    },
    { RPT_Carrello_1: 'ok_rate' , ALL:'ok_rate'}
	);
 
  check(
    res,
    {
     
	  'RPT_Carrello_1:ko_rate': (r) => outcome !== 'OK',
    },
    { RPT_Carrello_1: 'ko_rate', ALL:'ko_rate' }
  );
  
  return res;
   
}

