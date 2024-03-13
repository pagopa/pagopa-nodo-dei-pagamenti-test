import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";

export const inoltraEsitoPagamentoCarta_Trend = new Trend('inoltraEsitoPagamentoCarta');
export const All_Trend = new Trend('ALL');


export function rptReqBody(psp, intpsp, chpsp_c, paymentToken){


return `
{"idPagamento":"${paymentToken}",
"RRN":15465081,
"identificativoPsp":"${psp}",
"tipoVersamento":"CP",
"identificativoIntermediario":"${intpsp}",
"identificativoCanale":"${chpsp_c}",
"importoTotalePagato":1.00,
"timestampOperazione":"2021-07-09T17:06:03.100+01:00",
"codiceAutorizzativo":"123456",
"esitoTransazioneCarta":"00"}
`
};

export function inoltraEsitoPagamentoCarta(baseUrl,rndAnagPsp,paymentToken, fieldToAssert,valueToAssert, importoTotale,rrn) {
	
 console.debug("inoltraEsitoPagamentoCarta importoTotale "+ importoTotale + " type "+ typeof importoTotale)
 let body=
 	`{
		\"idPagamento\":\"${paymentToken}\", 
		\"RRN\":${rrn}, 
		\"identificativoPsp\":\"${rndAnagPsp.PSP}\",
		\"tipoVersamento\":\"CP\",
		\"identificativoIntermediario\":\"${rndAnagPsp.INTPSP}\",
		\"identificativoCanale\":\"${rndAnagPsp.CHPSP_C}\",
		\"importoTotalePagato\":${importoTotale},
		\"timestampOperazione\":\"2021-07-09T17:06:03.100+01:00\",
		\"codiceAutorizzativo\":\"123456\",
		\"esitoTransazioneCarta\":\"00\"
	}`;

 const res = http.post(
    getBasePath(baseUrl, "nodoPerPMv1")+'/inoltroEsito/carta',
    body,
    //JSON.stringify(rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken)),
    { headers: getHeaders({ 'Content-Type': 'application/json'/*, 'Host': 'api.prf.platform.pagopa.it'*/  }) ,
	tags: { inoltraEsitoPagamentoCarta: 'http_req_duration', ALL: 'http_req_duration', primitiva: "inoltroEsito/carta"}
	}
  );
  
  console.debug("inoltraEsitoPagamentoCarta RES");
  console.debug(JSON.stringify(res));

  inoltraEsitoPagamentoCarta_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla300': (r) => r.timings.duration >300,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla300' , ALL: 'over_sla300'}
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla400': (r) => r.timings.duration >400,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla400', ALL: 'over_sla400' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla500 ': (r) => r.timings.duration >500,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla500' , ALL: 'over_sla500'}
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla600': (r) => r.timings.duration >600,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla800': (r) => r.timings.duration >800,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla1000': (r) => r.timings.duration >1000,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla1000', ALL: 'over_sla1000' }
   );


   let outcome='';
   try{
	if(valueToAssert != '408'){
		let bodyJson = JSON.parse(res.body);
   		outcome= bodyJson[fieldToAssert];
	}
	else{
		console.debug("res status is "+res.status)
		outcome = res.status;
	}
	
   }catch(error){}

  /*console.debug("inoltraEsitoPagamento="+res.body);
  if(outcome=='KO'){
  console.debug("inoltraEsitoPagamento REQuest----------------"+JSON.stringify(rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken))); 
  console.debug("inoltraEsitoPagamento RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
    
	 'inoltraEsitoPagamentoCarta:ok_rate': (r) => outcome == valueToAssert,
    },
    { inoltraEsitoPagamentoCarta: 'ok_rate' , ALL: 'ok_rate'}
	);
 
  if(check(
    res,
    {
     
	  'inoltraEsitoPagamentoCarta:ko_rate': (r) => outcome != valueToAssert,
    },
    { inoltraEsitoPagamentoCarta: 'ko_rate', ALL: 'ko_rate' }
  )){
	fail("outcome != "+ valueToAssert + ": "+outcome);
	}
  
  return res;
   
}

