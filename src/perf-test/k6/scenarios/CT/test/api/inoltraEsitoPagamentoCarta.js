import http from 'k6/http';
import { check } from 'k6';


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

export function inoltraEsitoPagamentoCarta(baseUrl,rndAnagPsp,paymentToken) {
 
  
 const res = http.post(
    baseUrl+'/inoltroEsito/carta',
    JSON.stringify(rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken)),
    { headers: { 'Content-Type': 'application/json', 'Host': 'api.dev.platform.pagopa.it'  } ,
	tags: { inoltraEsitoPagamentoCarta: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla300': (r) => r.timings.duration >300,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla300' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla400': (r) => r.timings.duration >400,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla400' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla500 ': (r) => r.timings.duration >500,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla500' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla600': (r) => r.timings.duration >600,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla600' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla800': (r) => r.timings.duration >800,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla800' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoCarta:over_sla1000': (r) => r.timings.duration >1000,
   },
   { inoltraEsitoPagamentoCarta: 'over_sla1000' }
   );
   
   const outcome= res["esito"];
  
  console.log("inoltraEsitoPagamento="+res.body);
  if(outcome=='KO'){
  console.log("inoltraEsitoPagamento REQuest----------------"+JSON.stringify(rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken))); 
  console.log("inoltraEsitoPagamento RESPONSE----------------"+res.body);
  }
    
   check(
    res,
    {
    
	  'inoltraEsitoPagamentoCarta:ok_rate': (r) => outcome == 'OK',
    },
    { inoltraEsitoPagamentoCarta: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	  'inoltraEsitoPagamentoCarta:ko_rate': (r) => outcome !== 'OK',
    },
    { inoltraEsitoPagamentoCarta: 'ko_rate' }
  );
  
  return res;
   
}

