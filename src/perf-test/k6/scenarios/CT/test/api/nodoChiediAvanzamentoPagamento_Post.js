import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";


export const nodoChiediAvanzamentoPagamento_Post_Trend = new Trend('nodoChiediAvanzamentoPagamento_Post');
export const All_Trend = new Trend('ALL');


export function nodoChiediAvanzamentoPagamento_Post(baseUrl,paymentToken) {

  const pathToCall = getBasePath(baseUrl, "nodoPerPMv1")+'/avanzamentoPagamento?idPagamento='
 let res=http.get(pathToCall+paymentToken,
    { headers: getHeaders({ 'Content-Type': 'application/json' }) ,
	tags: { nodoChiediAvanzamentoPagamento_Post: 'http_req_duration' , ALL: 'http_req_duration', name: pathToCall+"<idPagamento>", primitiva: "avanzamentoPagamento"}
	}
  );
  console.debug("nodoChiediAvanzamentoPagamento_Post RES");
  console.debug(JSON.stringify(res));
  nodoChiediAvanzamentoPagamento_Post_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);


   check(res, {
 	'nodoChiediAvanzamentoPagamento_Post:over_sla300': (r) => r.timings.duration >300,
   },
   { nodoChiediAvanzamentoPagamento_Post: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Post:over_sla400': (r) => r.timings.duration >400,
   },
   { nodoChiediAvanzamentoPagamento_Post: 'over_sla400', ALL: 'over_sla400' }
   );
      
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Post:over_sla500': (r) => r.timings.duration >500,
   },
   { nodoChiediAvanzamentoPagamento_Post: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Post:over_sla600': (r) => r.timings.duration >600,
   },
   { nodoChiediAvanzamentoPagamento_Post: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Post:over_sla800': (r) => r.timings.duration >800,
   },
   { nodoChiediAvanzamentoPagamento_Post: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'nodoChiediAvanzamentoPagamento_Post:over_sla1000': (r) => r.timings.duration >1000,
   },
   { nodoChiediAvanzamentoPagamento_Post: 'over_sla1000', ALL: 'over_sla1000' }
   );


  let outcome='';
  try{
  outcome= JSON.parse(res.body)["esito"];
  }catch(error){}


  
   check(
    res,
    {
      'nodoChiediAvanzamentoPagamento_Post:ok_rate': (r) => outcome == 'OK',
    },
    { nodoChiediAvanzamentoPagamento_Post: 'ok_rate', ALL: 'ok_rate' }
	);
	
	if(check(
    res,
    {
     'nodoChiediAvanzamentoPagamento_Post:ko_rate': (r) => outcome !== 'OK',
    },
    { nodoChiediAvanzamentoPagamento_Post: 'ko_rate', ALL: 'ko_rate' }
  )){
	fail("outcome != ok: "+outcome);
	}
   
     return res;
}
