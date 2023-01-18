import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";


export function nodoNotificaAnnullamento(baseUrl,paymentToken) {
 
 let res=http.get(baseUrl+'/notificaAnnullamento?idPagamento='+paymentToken,
    { headers: { 'Content-Type': 'application/json' } ,
	tags: { nodoNotificaAnnullamento: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'nodoNotificaAnnullamento:over_sla300': (r) => r.timings.duration >300,
   },
   { nodoNotificaAnnullamento: 'over_sla300' }
   );
   
   check(res, {
 	'nodoNotificaAnnullamento:over_sla400': (r) => r.timings.duration >400,
   },
   { nodoNotificaAnnullamento: 'over_sla400' }
   );
      
   check(res, {
 	'nodoNotificaAnnullamento:over_sla500': (r) => r.timings.duration >500,
   },
   { nodoNotificaAnnullamento: 'over_sla500' }
   );
   
   check(res, {
 	'nodoNotificaAnnullamento:over_sla600': (r) => r.timings.duration >600,
   },
   { nodoNotificaAnnullamento: 'over_sla600' }
   );
   
   check(res, {
 	'nodoNotificaAnnullamento:over_sla800': (r) => r.timings.duration >800,
   },
   { nodoNotificaAnnullamento: 'over_sla800' }
   );
   
   check(res, {
 	'nodoNotificaAnnullamento:over_sla1000': (r) => r.timings.duration >1000,
   },
   { nodoNotificaAnnullamento: 'over_sla1000' }
   );
   
  /*const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();*/
  
  const outcome= res["esito"];
  
   check(
    res,
    {
      //'nodoNotificaAnnullamento:ok_rate': (r) => r.status == 200,
	  'nodoNotificaAnnullamento:ok_rate': (r) => outcome == 'OK',
    },
    { nodoNotificaAnnullamento: 'ok_rate' }
	);
	
	 check(
    res,
    {
      //'nodoNotificaAnnullamento:ko_rate': (r) => r.status !== 200,
	  'nodoNotificaAnnullamento:ko_rate': (r) => outcome !== 'OK',
    },
    { nodoNotificaAnnullamento: 'ko_rate' }
  );
   
     return res;
}