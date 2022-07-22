import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";


export function nodoChiediAvanzamentoPagamento_Pre(baseUrl,paymentToken) {
 
 let res=http.get(baseUrl+'/avanzamentoPagamento?idPagamento='+paymentToken,
    { headers: { 'Content-Type': 'application/json' } ,
	tags: { nodoChiediAvanzamentoPagamento_Pre: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Pre:over_sla300': (r) => r.timings.duration >300,
   },
   { nodoChiediAvanzamentoPagamento_Pre: 'over_sla300' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Pre:over_sla400': (r) => r.timings.duration >400,
   },
   { nodoChiediAvanzamentoPagamento_Pre: 'over_sla400' }
   );
      
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Pre:over_sla500': (r) => r.timings.duration >500,
   },
   { nodoChiediAvanzamentoPagamento_Pre: 'over_sla500' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Pre:over_sla600': (r) => r.timings.duration >600,
   },
   { nodoChiediAvanzamentoPagamento_Pre: 'over_sla600' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Pre:over_sla800': (r) => r.timings.duration >800,
   },
   { nodoChiediAvanzamentoPagamento_Pre: 'over_sla800' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Pre:over_sla1000': (r) => r.timings.duration >1000,
   },
   { nodoChiediAvanzamentoPagamento_Pre: 'over_sla1000' }
   );
   
  
  const outcome= res["esito"];
  
   check(
    res,
    {
      'nodoChiediAvanzamentoPagamento_Pre:ok_rate': (r) => outcome == 'ACK_UNKNOWN',
    },
    { nodoChiediAvanzamentoPagamento_Pre: 'ok_rate' }
	);
	
	 check(
    res,
    {
      'nodoChiediAvanzamentoPagamento_Pre:ko_rate': (r) => outcome !== 'ACK_UNKNOWN',
    },
    { nodoChiediAvanzamentoPagamento_Pre: 'ko_rate' }
  );
   
     return res;
}