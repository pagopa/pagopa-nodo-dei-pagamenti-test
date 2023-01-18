import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import * as rptUtil from '../util/rpt.js';

export function rptReqBody (pa, intpa, stazpa, iuvs, rptEncodeds){

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
			<identificativoPSP>AGID_01</identificativoPSP>
			<identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
			<identificativoCanale>97735020584_03</identificativoCanale>
			<listaRPT>
				<elementoListaRPT>
					<identificativoDominio>${pa}</identificativoDominio>
					<identificativoUnivocoVersamento>${iuvs[0]}</identificativoUnivocoVersamento>
					<codiceContestoPagamento>PERFORMANCE</codiceContestoPagamento>
					<rpt>${rptEncodeds[0]}</rpt>
				</elementoListaRPT>
				<elementoListaRPT>
					<identificativoDominio>${pa}</identificativoDominio>
					<identificativoUnivocoVersamento>${iuvs[1]}</identificativoUnivocoVersamento>
					<codiceContestoPagamento>PERFORMANCE</codiceContestoPagamento>
					<rpt>${rptEncodeds[1]}</rpt>
				</elementoListaRPT>
			</listaRPT>
		</ws:nodoInviaCarrelloRPT>
	</soapenv:Body>
</soapenv:Envelope>
`
/*<identificativoPSP>AGID_01</identificativoPSP>
			<identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
			<identificativoCanale>97735020584_02</identificativoCanale>*/

};


export function RPT_Carrello_2(baseUrl,rndAnagPa,iuvs) {
 
  
 let rptEncodeds  =[];
 
 for(var i=0; i< iuvs.length;i++){
	
 let rptEncoded = rptUtil.getRptCEncoded(rndAnagPa.PA, rndAnagPa.STAZPA, iuvs[i]);
 rptEncodeds.push(rptEncoded);
 }
  
 const res = http.post(
    baseUrl+'?soapAction=nodoInviaCarrelloRPT',
    rptReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuvs, rptEncodeds),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { RPT_Carrello_2: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'RPT_Carrello_2:over_sla300': (r) => r.timings.duration >300,
   },
   { RPT_Carrello_2: 'over_sla300' }
   );
   
   check(res, {
 	'RPT_Carrello_2:over_sla400': (r) => r.timings.duration >400,
   },
   { RPT_Carrello_2: 'over_sla400' }
   );
   
   check(res, {
 	'RPT_Carrello_2:over_sla500 ': (r) => r.timings.duration >500,
   },
   { RPT_Carrello_2: 'over_sla500' }
   );
   
   check(res, {
 	'RPT_Carrello_2:over_sla600': (r) => r.timings.duration >600,
   },
   { RPT_Carrello_2: 'over_sla600' }
   );
   
   check(res, {
 	'RPT_Carrello_2:over_sla800': (r) => r.timings.duration >800,
   },
   { RPT_Carrello_2: 'over_sla800' }
   );
   
   check(res, {
 	'RPT_Carrello_2:over_sla1000': (r) => r.timings.duration >1000,
   },
   { RPT_Carrello_2: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('esitoComplessivoOperazione');
  const outcome = script.text();
  
  if(outcome=='KO'){
  console.log("rptCarrello2 REQuest----------------"+rptReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuvs, rptEncodeds)); 
  console.log("rptCarrello2 RESPONSE----------------"+res.body);
  }
    
   check(
    res,
    {
    
	  'RPT_Carrello_2:ok_rate': (r) => outcome == 'OK',
    },
    { RPT_Carrello_2: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	  'RPT_Carrello_2:ko_rate': (r) => outcome !== 'OK',
    },
    { RPT_Carrello_2: 'ko_rate' }
  );
  
  return res;
   
}

