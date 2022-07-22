import http from 'k6/http';
import { check } from 'k6';



export function B_Check(baseUrl, idTr) {
 
 
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v3/webview/checkout/check?id='+idTr+'&_='+Date.now(),
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { B_Check: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'B_Check:over_sla300': (r) => r.timings.duration >300,
   },
   { B_Check: 'over_sla300' }
   );
   
   check(res, {
 	'B_Check:over_sla400': (r) => r.timings.duration >400,
   },
   { B_Check: 'over_sla400' }
   );
   
   check(res, {
 	'B_Check:over_sla500 ': (r) => r.timings.duration >500,
   },
   { B_Check: 'over_sla500' }
   );
   
   check(res, {
 	'B_Check:over_sla600': (r) => r.timings.duration >600,
   },
   { B_Check: 'over_sla600' }
   );
   
   check(res, {
 	'B_Check:over_sla800': (r) => r.timings.duration >800,
   },
   { B_Check: 'over_sla800' }
   );
   
   check(res, {
 	'B_Check:over_sla1000': (r) => r.timings.duration >1000,
   },
   { B_Check: 'over_sla1000' }
   );
  
  
   let statusTr = res['statusMessage'];
   	 
   check(
    res,
    {
    
	 'B_Check:ok_rate': (r) =>  statusTr !== undefined,
    },
    { B_Check: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'B_Check:ko_rate': (r) => statusTr == undefined,
    },
    { B_Check: 'ko_rate' }
  );
    
  return res;
   
}

