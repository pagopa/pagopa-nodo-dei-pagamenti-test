import http from 'k6/http';
import { check } from 'k6';

 
export function pay_PP_bye(baseUrl, RED_Path) {
 

 const res = http.get(
    baseUrl+RED_Path,
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: {pay_PP_bye: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  
  check(res, {
 	'pay_PP_bye:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_PP_bye: 'over_sla300' }
   );
   
   check(res, {
 	'pay_PP_bye:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_PP_bye: 'over_sla400' }
   );
   
   check(res, {
 	'pay_PP_bye:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_PP_bye: 'over_sla500' }
   );
   
   check(res, {
 	'pay_PP_bye:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_PP_bye: 'over_sla600' }
   );
   
   check(res, {
 	'pay_PP_bye:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_PP_bye: 'over_sla800' }
   );
   
   check(res, {
 	'pay_PP_bye:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_PP_bye: 'over_sla1000' }
   );
  
  
   let esitoTrEdt = 'NA';
   if (RED_Path!=="NA"){
   esitoTrEdt = RED_Path.substr(RED_Path.indexOf("outcome=")+8);
   }
   	 
   check(
    res,
    {
    
	 'pay_PP_bye:ok_rate': (r) =>  esitoTrEdt == '0',
    },
    { pay_PP_bye: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'pay_PP_bye:ko_rate': (r) => esitoTrEdt !== '0',
    },
    { pay_PP_bye: 'ko_rate' }
  );
    
  return res;
   
}

